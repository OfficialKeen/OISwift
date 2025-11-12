//
//  CollapsibleItem.swift
//  OISwift
//
//  Created for nested ForEach expand/collapse functionality
//

import UIKit

/// A collapsible container for nested content, useful for ForEach within ForEach scenarios
/// Allows individual list items to expand/collapse their children
open class CollapsibleItem: UIView {
    private let stackView = UIStackView()
    private let headerContainer = UIView()
    private let chevronImageView = UIImageView()
    private var headerView: UIView
    private var contentViews: [UIView]
    private var contentContainer = UIView()
    private var contentStackView = UIStackView()

    // Collapse state
    private var isExpanded: Bool = true
    private var onToggle: ((Bool) -> Void)?

    // Styling
    private var headerBackgroundColor: UIColor?
    private var contentBackgroundColor: UIColor?
    private var spacing: CGFloat

    /// Initializer for CollapsibleItem
    /// - Parameters:
    ///   - header: The header view to display (tappable to toggle)
    ///   - isExpanded: Initial expansion state (default: true)
    ///   - spacing: Spacing between content items (default: 8)
    ///   - headerBackgroundColor: Optional background color for header
    ///   - contentBackgroundColor: Optional background color for content area
    ///   - onToggle: Callback when toggle state changes
    ///   - content: Builder for child views
    public init(
        header: UIView,
        isExpanded: Bool = true,
        spacing: CGFloat = 8,
        headerBackgroundColor: UIColor? = nil,
        contentBackgroundColor: UIColor? = nil,
        onToggle: ((Bool) -> Void)? = nil,
        @UIStackViewBuilder content: () -> [UIView]
    ) {
        self.headerView = header
        self.contentViews = content()
        self.isExpanded = isExpanded
        self.spacing = spacing
        self.headerBackgroundColor = headerBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self.onToggle = onToggle
        super.init(frame: .zero)

        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Setup header container
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Apply header background color if provided
        if let bgColor = headerBackgroundColor {
            headerContainer.backgroundColor = bgColor
        }

        // Add header view to container
        headerContainer.addSubview(headerView)

        // Setup chevron
        setupChevron()

        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCollapse))
        headerContainer.addGestureRecognizer(tapGesture)
        headerContainer.isUserInteractionEnabled = true

        // Constraints for header
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            headerView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8)
        ])

        stackView.addArrangedSubview(headerContainer)

        // Setup content container
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = spacing
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        // Apply content background color if provided
        if let bgColor = contentBackgroundColor {
            contentContainer.backgroundColor = bgColor
        }

        // Add content views to content stack
        for view in contentViews {
            contentStackView.addArrangedSubview(view)
        }

        contentContainer.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16), // Indent children
            contentStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])

        stackView.addArrangedSubview(contentContainer)

        addSubview(stackView)

        // Constraints for main stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // Set initial state
        if !isExpanded {
            contentContainer.isHidden = true
            contentContainer.alpha = 0.0
        }
    }

    private func setupChevron() {
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -8),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        // Set initial rotation
        if !isExpanded {
            chevronImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }

    @objc private func toggleCollapse() {
        isExpanded.toggle()

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            // Rotate chevron
            if self.isExpanded {
                self.chevronImageView.transform = .identity
            } else {
                self.chevronImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            }

            // Show/hide content
            self.contentContainer.isHidden = !self.isExpanded
            self.contentContainer.alpha = self.isExpanded ? 1.0 : 0.0

            // Force layout update
            self.layoutIfNeeded()

            // Update parent view layout
            self.superview?.layoutIfNeeded()
        }

        // Call callback
        onToggle?(isExpanded)
    }

    // Public methods for programmatic control
    public func expand(animated: Bool = true) {
        guard !isExpanded else { return }
        if animated {
            toggleCollapse()
        } else {
            isExpanded = true
            contentContainer.isHidden = false
            contentContainer.alpha = 1.0
            chevronImageView.transform = .identity
        }
    }

    public func collapse(animated: Bool = true) {
        guard isExpanded else { return }
        if animated {
            toggleCollapse()
        } else {
            isExpanded = false
            contentContainer.isHidden = true
            contentContainer.alpha = 0.0
            chevronImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }

    // Get current state
    public func isCurrentlyExpanded() -> Bool {
        return isExpanded
    }
}
