//
//  DraggableItem.swift
//  OISwift
//
//  Created for drag and drop / sortable list functionality
//

import UIKit

// MARK: - Drag State

public enum DragState {
    case idle
    case dragging
    case dropping
}

// MARK: - Draggable Item Delegate

public protocol DraggableItemDelegate: AnyObject {
    func draggableItemDidBeginDragging(_ item: DraggableItem, at index: Int)
    func draggableItemDidMove(_ item: DraggableItem, from sourceIndex: Int, to destinationIndex: Int)
    func draggableItemDidEndDragging(_ item: DraggableItem, at index: Int)
    func draggableItemShouldAllowDrag(_ item: DraggableItem, at index: Int) -> Bool
}

// Optional protocol methods
public extension DraggableItemDelegate {
    func draggableItemDidBeginDragging(_ item: DraggableItem, at index: Int) {}
    func draggableItemDidMove(_ item: DraggableItem, from sourceIndex: Int, to destinationIndex: Int) {}
    func draggableItemDidEndDragging(_ item: DraggableItem, at index: Int) {}
    func draggableItemShouldAllowDrag(_ item: DraggableItem, at index: Int) -> Bool { return true }
}

// MARK: - Draggable Item

open class DraggableItem: UIView {

    // Content
    private var contentView: UIView
    private let dragHandle: UIView
    private let dragHandleIcon: UIImageView

    // Drag state
    private(set) var dragState: DragState = .idle
    public var itemIndex: Int = 0
    public weak var delegate: DraggableItemDelegate?

    // Configuration
    public var isDraggingEnabled: Bool = true
    public var showDragHandle: Bool = true {
        didSet {
            dragHandle.isHidden = !showDragHandle
        }
    }

    // Visual feedback
    private var originalAlpha: CGFloat = 1.0
    private var dragOffset: CGPoint = .zero
    private var dragStartPoint: CGPoint = .zero

    // Haptics
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    /// Initializer for DraggableItem
    /// - Parameters:
    ///   - content: The content view to display
    ///   - index: The index of this item in the list
    ///   - showDragHandle: Whether to show the drag handle icon
    ///   - delegate: Delegate for drag events
    public init(
        content: UIView,
        index: Int = 0,
        showDragHandle: Bool = true,
        delegate: DraggableItemDelegate? = nil
    ) {
        self.contentView = content
        self.itemIndex = index
        self.showDragHandle = showDragHandle
        self.delegate = delegate

        // Create drag handle
        self.dragHandle = UIView()
        self.dragHandleIcon = UIImageView()

        super.init(frame: .zero)

        setupViews()
        setupGestures()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Setup drag handle
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        dragHandle.backgroundColor = .clear

        dragHandleIcon.image = UIImage(systemName: "line.3.horizontal")
        dragHandleIcon.tintColor = .systemGray2
        dragHandleIcon.contentMode = .scaleAspectFit
        dragHandleIcon.translatesAutoresizingMaskIntoConstraints = false

        dragHandle.addSubview(dragHandleIcon)
        dragHandle.isHidden = !showDragHandle

        // Setup content
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        addSubview(dragHandle)
        addSubview(contentView)

        // Constraints
        NSLayoutConstraint.activate([
            // Drag handle
            dragHandle.leadingAnchor.constraint(equalTo: leadingAnchor),
            dragHandle.topAnchor.constraint(equalTo: topAnchor),
            dragHandle.bottomAnchor.constraint(equalTo: bottomAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 40),

            // Drag handle icon
            dragHandleIcon.centerXAnchor.constraint(equalTo: dragHandle.centerXAnchor),
            dragHandleIcon.centerYAnchor.constraint(equalTo: dragHandle.centerYAnchor),
            dragHandleIcon.widthAnchor.constraint(equalToConstant: 20),
            dragHandleIcon.heightAnchor.constraint(equalToConstant: 20),

            // Content
            contentView.leadingAnchor.constraint(equalTo: dragHandle.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.3
        addGestureRecognizer(longPress)

        isUserInteractionEnabled = true
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard isDraggingEnabled else { return }
        guard delegate?.draggableItemShouldAllowDrag(self, at: itemIndex) ?? true else { return }

        switch gesture.state {
        case .began:
            beginDragging(at: gesture.location(in: superview))

        case .changed:
            updateDragging(at: gesture.location(in: superview))

        case .ended, .cancelled:
            endDragging()

        default:
            break
        }
    }

    private func beginDragging(at point: CGPoint) {
        dragState = .dragging
        dragStartPoint = point
        originalAlpha = alpha

        // Haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()

        // Visual feedback
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.7
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 5)
            self.layer.shadowRadius = 10
        }

        // Bring to front
        superview?.bringSubviewToFront(self)

        // Notify delegate
        delegate?.draggableItemDidBeginDragging(self, at: itemIndex)
    }

    private func updateDragging(at point: CGPoint) {
        guard dragState == .dragging else { return }

        // Calculate offset
        let offset = CGPoint(x: 0, y: point.y - dragStartPoint.y)

        // Update position
        transform = CGAffineTransform(translationX: 0, y: offset.y).scaledBy(x: 1.05, y: 1.05)

        // Check for reordering
        checkForReordering(at: point)
    }

    private func checkForReordering(at point: CGPoint) {
        guard let superview = superview else { return }

        // Find potential drop target
        for subview in superview.subviews {
            guard let draggableItem = subview as? DraggableItem,
                  draggableItem != self,
                  draggableItem.frame.contains(point) else { continue }

            let targetIndex = draggableItem.itemIndex

            // Notify delegate about potential move
            if itemIndex != targetIndex {
                delegate?.draggableItemDidMove(self, from: itemIndex, to: targetIndex)

                // Update indices
                let oldIndex = itemIndex
                itemIndex = targetIndex
                draggableItem.itemIndex = oldIndex

                // Animate reordering
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                    superview.layoutIfNeeded()
                }

                // Haptic feedback
                feedbackGenerator.impactOccurred()
            }

            break
        }
    }

    private func endDragging() {
        dragState = .dropping

        // Reset visual state
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
            self.transform = .identity
            self.alpha = self.originalAlpha
            self.layer.shadowOpacity = 0
        }) { _ in
            self.dragState = .idle
        }

        // Notify delegate
        delegate?.draggableItemDidEndDragging(self, at: itemIndex)
    }

    // Public methods
    public func updateIndex(_ index: Int) {
        itemIndex = index
    }

    public func setDraggingEnabled(_ enabled: Bool) {
        isDraggingEnabled = enabled
        dragHandle.alpha = enabled ? 1.0 : 0.3
    }
}

// MARK: - Draggable List Container

open class DraggableListContainer: UIView {

    private let stackView = UIStackView()
    private var draggableItems: [DraggableItem] = []

    // Configuration
    public var spacing: CGFloat = 8 {
        didSet {
            stackView.spacing = spacing
        }
    }

    // Callbacks
    public var onReorder: ((_ sourceIndex: Int, _ destinationIndex: Int) -> Void)?
    public var onReorderComplete: (([Int]) -> Void)?

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
        super.init(frame: .zero)
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func addDraggableItem(content: UIView, showDragHandle: Bool = true) {
        let index = draggableItems.count
        let draggableItem = DraggableItem(
            content: content,
            index: index,
            showDragHandle: showDragHandle,
            delegate: self
        )

        draggableItems.append(draggableItem)
        stackView.addArrangedSubview(draggableItem)
    }

    public func removeAllItems() {
        draggableItems.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    public func getCurrentOrder() -> [Int] {
        return draggableItems.map { $0.itemIndex }
    }

    private func reorderItems(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0,
              destinationIndex >= 0,
              sourceIndex < draggableItems.count,
              destinationIndex < draggableItems.count else { return }

        // Move item in array
        let item = draggableItems.remove(at: sourceIndex)
        draggableItems.insert(item, at: destinationIndex)

        // Move in stack view
        stackView.removeArrangedSubview(item)
        stackView.insertArrangedSubview(item, at: destinationIndex)

        // Update indices
        updateIndices()

        // Notify callback
        onReorder?(sourceIndex, destinationIndex)
    }

    private func updateIndices() {
        for (index, item) in draggableItems.enumerated() {
            item.updateIndex(index)
        }
    }
}

// MARK: - DraggableListContainer + DraggableItemDelegate

extension DraggableListContainer: DraggableItemDelegate {

    public func draggableItemDidBeginDragging(_ item: DraggableItem, at index: Int) {
        // Optional: Add container-level feedback
    }

    public func draggableItemDidMove(_ item: DraggableItem, from sourceIndex: Int, to destinationIndex: Int) {
        reorderItems(from: sourceIndex, to: destinationIndex)
    }

    public func draggableItemDidEndDragging(_ item: DraggableItem, at index: Int) {
        onReorderComplete?(getCurrentOrder())
    }
}
