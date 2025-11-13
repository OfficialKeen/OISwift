//
//  ListView.swift
//  OISwift
//
//  Created by keenoi on 04/11/24.
//

import UIKit

@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ views: UIView...) -> [UIView] {
        return views
    }
}

open class ListView<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data?
    private var contentBuilder: ((Data.Element) -> Content)?
    private let stackView = UIStackView()
    
    // Initializer untuk Array Data
    public init(_ data: Data, axis: NSLayoutConstraint.Axis = .vertical, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.contentBuilder = content
        super.init(frame: .zero)
        stackView.axis = axis
        setupDataViews()
    }
    
    // Initializer untuk Object UI Langsung menggunakan @ViewBuilder
    public init(axis: NSLayoutConstraint.Axis = .vertical, @ViewBuilder content: () -> [UIView]) {
        super.init(frame: .zero)
        stackView.axis = axis
        setupDirectViews(content())
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup untuk Array Data
    private func setupDataViews() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        if let data = data, let contentBuilder = contentBuilder {
            for item in data {
                let view = contentBuilder(item)
                stackView.addArrangedSubview(view)
            }
        }
        
        setupConstraints(scrollView: scrollView)
    }
    
    // Setup untuk Object UI Langsung
    private func setupDirectViews(_ views: [UIView]) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        setupConstraints(scrollView: scrollView)
    }
    
    // Mengatur constraint dasar untuk scrollView dan stackView
    private func setupConstraints(scrollView: UIScrollView) {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}


public class List: UIScrollView {
    private var customRefreshControl: UIRefreshControl?
    private var refreshAction: (() -> Void)?

    // Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        super.init(frame: .zero)

        // Setup content view
        let contentView = content(UIView())
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // ScrollView properties
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging

        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier ?? 1.0)
        ])

        // Adjust for keyboard
        setupKeyboardObservers()
    }

    // Convenience initializer for creating an empty List
    public convenience init() {
        self.init(content: { _ in UIView() })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Content

    /// Configure the list content
    /// Usage: listView.configure { container in ... }
    @discardableResult
    public func configure(content: (UIView) -> UIView) -> Self {
        // Get the load more container before removing subviews
        let loadMoreContainer = getLoadMoreContainer()

        // Store current delegate
        let currentDelegate = self.delegate

        // Remove all existing subviews except refresh control and load more container
        for subview in subviews {
            if subview !== customRefreshControl && subview !== loadMoreContainer {
                subview.removeFromSuperview()
            }
        }

        // Setup new content view
        let contentView = content(UIView())
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])

        // Bring load more container to front if it exists
        if let container = loadMoreContainer {
            bringSubviewToFront(container)
        }

        // Restore delegate if it was set (for infinite scroll)
        if currentDelegate != nil {
            self.delegate = currentDelegate
        }

        return self
    }

    // MARK: - Refreshable Feature

    /// Adds pull to refresh functionality to the List
    /// - Parameter action: Closure called when user pulls to refresh. Must call completion when done.
    /// - Returns: Self for method chaining
    @discardableResult
    public func refreshable(action: @escaping (@escaping () -> Void) -> Void) -> Self {
        // Store the action with completion handler
        self.refreshAction = {
            action { [weak self] in
                self?.endRefreshing()
            }
        }

        // Create refresh control if not already created
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }

        return self
    }

    /// Call this to programmatically end refreshing state
    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.customRefreshControl?.endRefreshing()
        }
    }

    @objc private func handleRefresh() {
        // Call the refresh action
        refreshAction?()
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        DispatchQueue.main.async {
            self.contentInset.bottom = keyboardHeight
            self.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            self.contentInset.bottom = 0
            self.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
