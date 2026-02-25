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


/*public class List: UIScrollView {
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
    public func content(content: (UIView) -> UIView) -> Self {
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
}*/

/*public class List: UIScrollView {
    private var customRefreshControl: UIRefreshControl?
    private var refreshAction: (() -> Void)?
    private let pullThreshold: CGFloat = 60   // bebas mau 50–80
    private var allowRefreshText = true

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
        self.delegate = self
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
            customRefreshControl?.attributedTitle = NSAttributedString(
                string: "Refreshing...",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                    .foregroundColor: UIColor.gray
                ]
            )
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }

        return self
    }

    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.customRefreshControl?.endRefreshing()

            // Hilangkan title
            self?.customRefreshControl?.attributedTitle = nil

            // Kunci supaya text tidak muncul lagi
            self?.allowRefreshText = false
        }
    }

    @objc private func handleRefresh() {
        customRefreshControl?.attributedTitle = NSAttributedString(
            string: "Loading...",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.gray
            ]
        )
        
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

extension List {
    private struct AssociatedKeys {
        static var loadMoreAction: UInt8 = 0
        static var isLoadingMore: UInt8 = 1
        static var loadMoreIndicator: UInt8 = 2
        static var loadMoreThreshold: UInt8 = 3
        static var loadMoreContainer: UInt8 = 4
    }

    // Store load more action closure
    private var loadMoreAction: ((@escaping () -> Void) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreAction) as? (@escaping () -> Void) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Track if currently loading more data
    private var isLoadingMore: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isLoadingMore) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isLoadingMore, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Loading indicator for load more
    private var loadMoreIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Distance from bottom to trigger load more (default: 100)
    private var loadMoreThreshold: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.loadMoreThreshold) as? CGFloat) ?? 100
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreThreshold, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Container view for load more indicator
    private var loadMoreContainer: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreContainer) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreContainer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Public API

    /// Adds infinite scroll functionality to the List
    /// - Parameters:
    ///   - threshold: Distance from bottom (in points) to trigger loading. Default is 100.
    ///   - action: Closure called when more data should be loaded. Must call completion when done.
    /// - Returns: Self for method chaining
    @discardableResult
    public func infiniteScroll(threshold: CGFloat = 100, action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.loadMoreAction = action
        self.loadMoreThreshold = threshold

        // Setup load more indicator if not already created
        if loadMoreIndicator == nil {
            setupLoadMoreIndicator()
        }

        // Set delegate to self to detect scrolling
        if delegate == nil {
            delegate = self
        }

        return self
    }

    /// Call this method to programmatically end loading state
    public func endLoadingMore() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.isLoadingMore = false
            self.loadMoreIndicator?.stopAnimating()
            self.loadMoreContainer?.isHidden = true

            // Remove bottom inset that was added for the indicator
            let currentInsets = self.contentInset
            self.contentInset = UIEdgeInsets(
                top: currentInsets.top,
                left: currentInsets.left,
                bottom: max(0, currentInsets.bottom - 40), // Remove the indicator height
                right: currentInsets.right
            )
        }
    }

    /// Get the load more indicator view (internal use)
    internal func getLoadMoreIndicator() -> UIActivityIndicatorView? {
        return loadMoreIndicator
    }

    /// Get the load more container view (internal use)
    internal func getLoadMoreContainer() -> UIView? {
        return loadMoreContainer
    }

    // MARK: - Private Methods

    private func setupLoadMoreIndicator() {
        // Create full-width container view (like a list item)
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isHidden = true // Start hidden

        addSubview(containerView)

        // Create spinner indicator
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(indicator)

        // Position container at bottom of content - full width like list items
        // This makes it appear as the last item in the list
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Center spinner indicator in the container
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: containerView.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        self.loadMoreContainer = containerView
        self.loadMoreIndicator = indicator
    }

    private func triggerLoadMore() {
        guard !isLoadingMore, let action = loadMoreAction else { return }

        isLoadingMore = true

        // Add bottom inset to make space for the indicator
        let currentInsets = contentInset
        contentInset = UIEdgeInsets(
            top: currentInsets.top,
            left: currentInsets.left,
            bottom: currentInsets.bottom,
            right: currentInsets.right
        )

        loadMoreContainer?.isHidden = false
        loadMoreIndicator?.startAnimating()

        // Call the load more action with completion handler
        action { [weak self] in
            self?.endLoadingMore()
        }
    }
}

extension List: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        if offsetY >= 0 {
            allowRefreshText = true
        }
        // ==========================
        //  PULL TO REFRESH TEXT
        // ==========================
        if let rc = customRefreshControl, !rc.isRefreshing, allowRefreshText {

            if offsetY < -pullThreshold {
                rc.attributedTitle = NSAttributedString(
                    string: "Release to refresh",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                        .foregroundColor: UIColor.gray
                    ]
                )
            } else if offsetY < -20 {
                rc.attributedTitle = NSAttributedString(
                    string: "Pull to refresh",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 12),
                        .foregroundColor: UIColor.gray
                    ]
                )
            }
        }
        // ==========================
        //  LOAD MORE (PUNYA KODE LU)
        // ==========================
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > 0 && offsetY > contentHeight - scrollViewHeight - loadMoreThreshold {
            triggerLoadMore()
        }
    }
}*/

//
//  ListView.swift
//  Virtualized List (Merged version - full file)
//
import UIKit
import ObjectiveC.runtime

public class List: UIScrollView {
    // MARK: - Basic
    private var customRefreshControl: UIRefreshControl?
    private var refreshAction: (() -> Void)?

    // MARK: - Virtualized List Internal Storage (Step 1)
    private var virtualItems: [Any] = []
    private var virtualBuilder: ((Int, Any) -> UIView)?
    private var virtualTopSpacer: UIView?
    private var virtualBottomSpacer: UIView?
    private var virtualContainer: UIView?
    private var reusePool: [UIView] = []
    private var visibleMap: [Int: UIView] = [:]
    private var virtualItemHeights: [Int: CGFloat] = [:]
    private var virtualPrefixHeights: [CGFloat] = []
    private var virtualContainerOffsetY: CGFloat = 0
    private var virtualEstimatedRowHeight: CGFloat = 60
    private var virtualBottomSpacerHeightConstraint: NSLayoutConstraint?
    private var prefetchBuffer: Int = 3

    // MARK: - Initializer
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
        resetVirtualMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Configure Content

    /// Configure the list content
    /// Usage: listView.configure { container in ... }
    @discardableResult
    public func content(content: (UIView) -> UIView) -> Self {
        // If switching from virtual mode → reset
        resetVirtualMode()

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

    // MARK: - Virtualized Entry Point (Step 2)
    /// Call this to enable virtualized rendering for an items array.
    /// The builder returns a UIView for each index.
    public func virtualized<Item>(
        items: [Item],
        estimatedRowHeight: CGFloat = 60,
        builder: @escaping (Int, Item) -> UIView
    ) {
        // Reset any previous virtual state
        resetVirtualMode()

        // Save input for later use
        self.virtualEstimatedRowHeight = estimatedRowHeight
        self.virtualItems = items
        self.virtualBuilder = { index, anyItem in
            guard let typedItem = anyItem as? Item else { return UIView() }
            return builder(index, typedItem)
        }

        // Create spacer views
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        let container = UIView()

        addSubview(topSpacer)
        addSubview(container)
        addSubview(bottomSpacer)

        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false

        // create & keep bottom height constraint for future updates
        let bottomHeightConstraint = bottomSpacer.heightAnchor.constraint(equalToConstant: CGFloat(items.count) * estimatedRowHeight)
        bottomHeightConstraint.priority = .required
        bottomHeightConstraint.isActive = true
        self.virtualBottomSpacerHeightConstraint = bottomHeightConstraint

        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            // topSpacer height stays 0 initially

            container.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            // container bottom is top of bottom spacer (set below via constraint)

            bottomSpacer.topAnchor.constraint(equalTo: container.bottomAnchor),
            bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Save references
        self.virtualTopSpacer = topSpacer
        self.virtualBottomSpacer = bottomSpacer
        self.virtualContainer = container

        // Init prefix heights with estimated height
        virtualPrefixHeights = Array(repeating: 0, count: items.count + 1)
        for i in 1...items.count {
            virtualPrefixHeights[i] = virtualPrefixHeights[i - 1] + estimatedRowHeight
        }

        // Clear previous state
        self.visibleMap.removeAll()
        self.reusePool.removeAll()
        self.virtualItemHeights.removeAll()

        // Set delegate so scrollViewDidScroll triggers virtual update & infinite scroll
        if delegate == nil {
            delegate = self
        }

        // Force layout to calculate frames
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Reset Virtual Mode (Step 10)
    private func resetVirtualMode() {
        // remove all visible views
        for (_, v) in visibleMap {
            v.removeFromSuperview()
        }
        visibleMap.removeAll()

        // clear pool
        reusePool.removeAll()

        // remove containers
        virtualTopSpacer?.removeFromSuperview()
        virtualBottomSpacer?.removeFromSuperview()
        virtualContainer?.removeFromSuperview()

        virtualTopSpacer = nil
        virtualBottomSpacer = nil
        virtualContainer = nil

        // clear data
        virtualItems.removeAll()
        virtualItemHeights.removeAll()
        virtualPrefixHeights.removeAll()
        virtualBottomSpacerHeightConstraint = nil
        virtualContainerOffsetY = 0
    }

    // MARK: - Measure helpers (Step 5)
    private func measureHeight(of view: UIView, width: CGFloat) -> CGFloat {
        // Ensure proper width for auto-layout
        view.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.priority = .required
        widthConstraint.isActive = true

        // Fit size
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        widthConstraint.isActive = false
        return max(1, height)
    }

    // MARK: - Offset helper (Step 6)
    private func offsetForIndex(_ index: Int) -> CGFloat {
        if index < virtualPrefixHeights.count {
            return virtualPrefixHeights[index]
        }
        return virtualPrefixHeights.last ?? 0
    }

    // MARK: - Virtual Rendering Engine (Step 3, 5, 6, 7, 8 combined)
    private func updateVisibleItems() {
        guard let topSpacer = virtualTopSpacer,
              let bottomSpacer = virtualBottomSpacer,
              let container = virtualContainer,
              !virtualItems.isEmpty else {
            return
        }

        let totalItems = virtualItems.count
        // estimated height fallback
        let estimatedHeight = virtualEstimatedRowHeight

        // compute total content height (from prefix or estimate)
        let totalHeight = virtualPrefixHeights.last ?? CGFloat(totalItems) * estimatedHeight
        // ensure bottom spacer constraint updated
        if let bottomConstraint = virtualBottomSpacerHeightConstraint {
            if bottomConstraint.constant != totalHeight {
                bottomConstraint.constant = totalHeight
            }
        } else {
            // try to set by searching constraint
            virtualBottomSpacer?.constraints.first { $0.firstAttribute == .height }?.constant = totalHeight
        }

        // visible range with prefetch
        let scrollTop = contentOffset.y
        let scrollBottom = scrollTop + frame.height

        // get raw start/end by estimated height to avoid heavy math when prefix unknown
        // but we will clamp with prefix anyway
        let rawStart = Int(floor(scrollTop / max(1, estimatedHeight)))
        let rawEnd = Int(floor(scrollBottom / max(1, estimatedHeight)))

        var visibleStart = max(0, rawStart - prefetchBuffer)
        var visibleEnd = min(totalItems - 1, rawEnd + prefetchBuffer)

        // If prefix sums are present, refine start/end using binary search on prefix
        if virtualPrefixHeights.count == totalItems + 1 {
            // binary search to find the true start
            let startIndex = binarySearchPrefix(prefix: virtualPrefixHeights, value: scrollTop)
            let endIndex = binarySearchPrefix(prefix: virtualPrefixHeights, value: scrollBottom)
            visibleStart = max(0, startIndex - prefetchBuffer)
            visibleEnd = min(totalItems - 1, endIndex + prefetchBuffer)
        }

        // Remove items no longer visible
        for (index, view) in visibleMap {
            if index < visibleStart || index > visibleEnd {
                reusePool.append(view)
                view.removeFromSuperview()
                visibleMap.removeValue(forKey: index)
            }
        }

        // Compute container offset (position container to start of visible region)
        let containerOffset = offsetForIndex(visibleStart)
        virtualContainerOffsetY = containerOffset
        // position container relative to the List
        container.frame = CGRect(x: 0, y: containerOffset, width: frame.width, height: totalHeight - containerOffset)

        // Add visible items
        for index in visibleStart...visibleEnd {
            if visibleMap[index] == nil {
                let data = virtualItems[index]
                let viewFromPool = reusePool.popLast()
                let view = viewFromPool ?? virtualBuilder?(index, data) ?? UIView()
                // ensure view has correct width before measuring
                view.translatesAutoresizingMaskIntoConstraints = false

                // add as subview
                container.addSubview(view)

                // measure height (cached if available)
                let realHeight: CGFloat
                if let saved = virtualItemHeights[index] {
                    realHeight = saved
                } else {
                    // temporarily set width and measure
                    realHeight = measureHeight(of: view, width: frame.width)
                    virtualItemHeights[index] = realHeight

                    // update prefix heights from this index onward (Step 6)
                    let oldHeight = virtualEstimatedRowHeight
                    let heightDiff = realHeight - oldHeight
                    if heightDiff != 0 {
                        // ensure prefix has correct size
                        if virtualPrefixHeights.count != totalItems + 1 {
                            // re-init prefix if corrupted
                            virtualPrefixHeights = Array(repeating: 0, count: totalItems + 1)
                            for i in 1...totalItems {
                                virtualPrefixHeights[i] = virtualPrefixHeights[i - 1] + virtualEstimatedRowHeight
                            }
                        }
                        for i in (index + 1)..<virtualPrefixHeights.count {
                            virtualPrefixHeights[i] += heightDiff
                        }
                    }
                }

                // compute y inside container
                let itemOffsetGlobal = offsetForIndex(index)
                let yInContainer = itemOffsetGlobal - virtualContainerOffsetY

                view.frame = CGRect(
                    x: 0,
                    y: yInContainer,
                    width: frame.width,
                    height: realHeight
                )

                visibleMap[index] = view
            } else {
                // update frame in case width changed (e.g. rotation)
                if let view = visibleMap[index] {
                    let realHeight = virtualItemHeights[index] ?? virtualEstimatedRowHeight
                    let itemOffsetGlobal = offsetForIndex(index)
                    let yInContainer = itemOffsetGlobal - virtualContainerOffsetY
                    view.frame = CGRect(
                        x: 0,
                        y: yInContainer,
                        width: frame.width,
                        height: realHeight
                    )
                }
            }
        }
    }

    // binary search helper to find index for given y in prefix array
    private func binarySearchPrefix(prefix: [CGFloat], value: CGFloat) -> Int {
        var low = 0
        var high = prefix.count - 1
        var best = 0
        while low <= high {
            let mid = (low + high) / 2
            let midVal = prefix[mid]
            if midVal == value {
                return mid
            } else if midVal < value {
                best = mid
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        return max(0, best)
    }

    // MARK: - Refresh Virtual Layout on Size Change (Step 9)
    private func refreshVirtualLayout() {
        guard virtualContainer != nil else { return }

        let width = frame.width
        guard width > 0 else { return }

        // remeasure visible heights
        for (index, view) in visibleMap {
            let realHeight = measureHeight(of: view, width: width)
            let old = virtualItemHeights[index] ?? virtualEstimatedRowHeight
            if realHeight != old {
                let diff = realHeight - old
                virtualItemHeights[index] = realHeight
                // update prefix from index+1 onward
                if virtualPrefixHeights.count == virtualItems.count + 1 {
                    for i in (index + 1)..<virtualPrefixHeights.count {
                        virtualPrefixHeights[i] += diff
                    }
                }
            }
        }

        // rebuild prefix if missing
        if virtualPrefixHeights.count != virtualItems.count + 1 {
            var prefix: [CGFloat] = [0]
            prefix.reserveCapacity(virtualItems.count + 1)
            for i in 0..<virtualItems.count {
                let h = virtualItemHeights[i] ?? virtualEstimatedRowHeight
                prefix.append(prefix.last! + h)
            }
            virtualPrefixHeights = prefix
        }

        // update total height
        let totalHeight = virtualPrefixHeights.last ?? CGFloat(virtualItems.count) * virtualEstimatedRowHeight
        virtualBottomSpacerHeightConstraint?.constant = totalHeight

        setNeedsLayout()
    }

    // MARK: - Scroll Handling for Virtualized Mode (Step 4)
    private func handleVirtualScroll() {
        if virtualContainer != nil {
            updateVisibleItems()
        }
    }

    // MARK: - Override layoutSubviews (calls refresh & update)
    public override func layoutSubviews() {
        super.layoutSubviews()

        // refresh layout on width change / size change
        if virtualContainer != nil {
            refreshVirtualLayout()
        }

        updateVisibleItems()
    }
}

// MARK: - Infinite Scroll Extension (existing + integrated)
extension List {
    private struct AssociatedKeys {
        static var loadMoreAction: UInt8 = 0
        static var isLoadingMore: UInt8 = 1
        static var loadMoreIndicator: UInt8 = 2
        static var loadMoreThreshold: UInt8 = 3
        static var loadMoreContainer: UInt8 = 4
    }

    // Store load more action closure
    private var loadMoreAction: ((@escaping () -> Void) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreAction) as? (@escaping () -> Void) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Track if currently loading more data
    private var isLoadingMore: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isLoadingMore) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isLoadingMore, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Loading indicator for load more
    private var loadMoreIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Distance from bottom to trigger load more (default: 100)
    private var loadMoreThreshold: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.loadMoreThreshold) as? CGFloat) ?? 100
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreThreshold, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Container view for load more indicator
    private var loadMoreContainer: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadMoreContainer) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadMoreContainer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Public API

    /// Adds infinite scroll functionality to the List
    /// - Parameters:
    ///   - threshold: Distance from bottom (in points) to trigger loading. Default is 100.
    ///   - action: Closure called when more data should be loaded. Must call completion when done.
    /// - Returns: Self for method chaining
    @discardableResult
    public func infiniteScroll(threshold: CGFloat = 100, action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.loadMoreAction = action
        self.loadMoreThreshold = threshold

        // Setup load more indicator if not already created
        if loadMoreIndicator == nil {
            setupLoadMoreIndicator()
        }

        // Set delegate to self to detect scrolling
        if delegate == nil {
            delegate = self
        }

        return self
    }

    /// Call this method to programmatically end loading state
    public func endLoadingMore() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.isLoadingMore = false
            self.loadMoreIndicator?.stopAnimating()
            self.loadMoreContainer?.isHidden = true

            // Remove bottom inset that was added for the indicator
            let currentInsets = self.contentInset
            self.contentInset = UIEdgeInsets(
                top: currentInsets.top,
                left: currentInsets.left,
                bottom: max(0, currentInsets.bottom - 40), // Remove the indicator height
                right: currentInsets.right
            )
        }
    }

    /// Get the load more indicator view (internal use)
    internal func getLoadMoreIndicator() -> UIActivityIndicatorView? {
        return loadMoreIndicator
    }

    /// Get the load more container view (internal use)
    internal func getLoadMoreContainer() -> UIView? {
        return loadMoreContainer
    }

    // MARK: - Private Methods

    private func setupLoadMoreIndicator() {
        // Create full-width container view (like a list item)
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isHidden = true // Start hidden

        addSubview(containerView)

        // Create spinner indicator
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(indicator)

        // Position container at bottom of content - full width like list items
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Center spinner indicator in the container
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        self.loadMoreContainer = containerView
        self.loadMoreIndicator = indicator
    }

    private func triggerLoadMore() {
        guard !isLoadingMore, let action = loadMoreAction else { return }

        isLoadingMore = true

        loadMoreContainer?.isHidden = false
        loadMoreIndicator?.startAnimating()

        // Call the load more action with completion handler
        action { [weak self] in
            self?.endLoadingMore()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension List: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        // Check if user has scrolled near the bottom
        if offsetY > 0 && offsetY > contentHeight - scrollViewHeight - loadMoreThreshold {
            triggerLoadMore()
        }

        // NEW: update virtual list
        handleVirtualScroll()
    }
}




















/*
import UIKit

/// ListView: SwiftUI-style List using UITableView
/// Features now:
/// - Builder-based row creation
/// - Automatic height
/// - Refreshable
/// - onDelete
/// - swipeActions
/// - onMove (reorder)
/// - DiffableDataSource support (smooth animated reloads)

public final class ListViews: UIView {
    
    // MARK: - Internal Cell Wrapper
    private final class HostingCell: UITableViewCell {
        static let id = "ListView.HostingCell"
        private var hosted: UIView?
        private var activeConstraints: [NSLayoutConstraint] = []
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            hosted?.removeFromSuperview()
            hosted = nil
            NSLayoutConstraint.deactivate(activeConstraints)
            activeConstraints.removeAll()
            contentView.clipsToBounds = false
        }
        
        func host(_ view: UIView) {
            if hosted === view { return }
            hosted?.removeFromSuperview()
            hosted = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            
            activeConstraints = [
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
            NSLayoutConstraint.activate(activeConstraints)
        }
    }
    
    // MARK: - UI
    public private(set) var tableView: UITableView!
    
    // MARK: - Data
    private enum Section { case main }
    private var diffable: UITableViewDiffableDataSource<Section, AnyHashable>?
    private var rawItems: [AnyHashable] = []
    private var builder: ((AnyHashable) -> UIView)?
    
    // storage untuk versi non-Hashable
    private var storedItems: [Any] = []
    private var stableIDs: [AnyHashable] = []
    
    // MARK: - Callbacks
    private var refreshAction: ((@escaping () -> Void) -> Void)?
    private var deleteAction: ((IndexSet) -> Void)?
    private var moveAction: ((Int, Int) -> Void)?
    private var leadingSwipe: ((AnyHashable) -> [UIContextualAction])?
    private var trailingSwipe: ((AnyHashable) -> [UIContextualAction])?
    
    // MARK: BackgroundColor
    private var rowBackgroundColor: UIColor?
    private var rowBackgroundView: UIView?
    private var rowBackgroundForIndex: ((Int) -> UIColor)?
    
    // MARK: - Selection Callbacks
    private var onSelectItem: ((AnyHashable) -> Void)?
    private var onSelectIndex: ((Int) -> Void)?
    private var onSelectItemIndex: ((AnyHashable, Int) -> Void)?

    // Deselect
    private var onDeselectIndex: ((Int) -> Void)?

    // Highlight
    private var onHighlightIndex: ((Int) -> Void)?
    private var onUnhighlightIndex: ((Int) -> Void)?
    
    // MARK: - Refreshable (compatible version)
    private var refreshActionCompletion: ((@escaping () -> Void) -> Void)?
    private var refreshActionSimple: (() -> Void)?
    
    // MARK: - Init
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero)
        setup(style: style)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(style: .plain)
    }
    
    private func setup(style: UITableView.Style) {
        tableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        setupDiffable()
    }
    
    // MARK: - Diffable
    private func setupDiffable() {
        diffable = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView) {
            tableView, indexPath, itemIdentifier -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath) as? HostingCell else {
                return UITableViewCell()
            }
            if let b = self.builder {
                let v = b(itemIdentifier)
                cell.host(v)
            }
            return cell
        }
    }
    
    private func applySnapshot(animated: Bool = true) {
        var snap = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snap.appendSections([.main])
        snap.appendItems(rawItems, toSection: .main)
        diffable?.apply(snap, animatingDifferences: animated)
    }
    
    // MARK: - UIViewBuilder
    @resultBuilder
    public struct UIViewBuilder {
        public static func buildBlock(_ components: UIView...) -> UIView {
            if components.count == 1 { return components[0] }
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 4
            components.forEach { stack.addArrangedSubview($0) }
            return stack
        }
    }
    
    public func Text(_ string: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = string
        lbl.font = .systemFont(ofSize: 17)
        return lbl
    }
    
    // MARK: - Internal duplicate-safe config
    // Helper untuk mapping Hashable ID ↔ original Item
    private func makeBuilder<Item>(
        raw: [AnyHashable],
        stored: [Item],
        _ builder: @escaping (Item) -> UIView
    ) -> (AnyHashable) -> UIView {
        return { any in
            if let idx = raw.firstIndex(of: any) {
                return builder(stored[idx])
            }
            return UIView()
        }
    }
    
    @discardableResult
    private func configureDuplicateSafe<Item: Hashable>(
        _ items: [Item],
        builder: @escaping (Item) -> UIView
    ) -> Self {
        
        let unique = Set(items)
        
        if unique.count != items.count {
            // kalau stable IDs belum cukup → generate sekali saja
            if stableIDs.count != items.count {
                stableIDs = items.enumerated().map { idx, _ in AnyHashable("IDX-\(idx)") }
            }
            
            rawItems = stableIDs
            
            self.builder = makeBuilder(raw: rawItems, stored: items, builder)
        } else {
            // ID aman langsung pakai item
            rawItems = items.map { $0 as AnyHashable }
            self.builder = { any in builder(any as! Item) }
        }
        
        // keep a copy of original items for id-based mapping (non-hashable flows)
        self.storedItems = items.map { $0 }
        applySnapshot()
        return self
    }
    
    // MARK: - Initializers (SwiftUI-style)
    
    /// SwiftUI-style init: ListView($binding) { item in ... }
    public convenience init<Item: Hashable>(
        _ binding: SBinding<[Item]>,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) {
        self.init()
        
        // load initial using duplicate-safe
        self.configureDuplicateSafe(binding.wrappedValue, builder: builder)
        
        // auto-update when binding changes
        binding.didSet = { [weak self] newItems in
            self?.configureDuplicateSafe(newItems, builder: builder)
        }
    }
    
    /// SwiftUI-style init: ListViews($binding, id: ...) { item in ... }
    public convenience init<Item>(
        _ binding: SBinding<[Item]>,
        id: @escaping (Item) -> AnyHashable,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) {
        self.init()
        
        // initial load
        self.configure(binding.wrappedValue, id: id, builder: builder)
        
        // auto-update on binding changes
        binding.didSet = { [weak self] newItems in
            guard let self = self else { return }
            self.rawItems = newItems.map { id($0) }
            self.storedItems = newItems
            self.applySnapshot()
        }
    }
    
    /// SwiftUI-style init: ListView { ... }
    /// This supports static content (no items array)
    public convenience init(@UIViewBuilder content: () -> UIView) {
        self.init()
        
        let built = content()
        
        // Jika builder menghasilkan UIStackView → multiple rows
        if let stack = built as? UIStackView {
            let views = stack.arrangedSubviews
            self.storedItems = views
            self.rawItems = views.enumerated().map { idx, _ in idx as AnyHashable }
            self.builder = { any in
                guard let index = any as? Int else { return UIView() }
                return views[index]
            }
        } else {
            // Hanya 1 row
            self.storedItems = [built]
            self.rawItems = [0]
            self.builder = { _ in built }
        }
        
        applySnapshot()
    }
    
    /// SwiftUI-style init: ListView(items) { item in ... }
    public convenience init<Item: Hashable>(
        _ items: [Item],
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) {
        self.init()
        self.configureDuplicateSafe(items, builder: builder)
    }
    
    /// SwiftUI-style init for non-Hashable with ID
    public convenience init<Item>(
        _ items: [Item],
        id: @escaping (Item) -> AnyHashable,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) {
        self.init()
        self.configure(items, id: id, builder: builder)
    }
    
    // MARK: - Public API
    
    // MARK: - configure with SBinding<[Item]> + id (non-Hashable support)
    @discardableResult
    public func configure<Item>(
        _ binding: SBinding<[Item]>,
        id: @escaping (Item) -> AnyHashable,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) -> Self {
        // initial load
        self.configure(binding.wrappedValue, id: id, builder: builder)
        
        binding.didSet = { [weak self] newItems in
            self?.rawItems = newItems.map { id($0) }
            self?.storedItems = newItems
            self?.applySnapshot()
        }
        
        return self
    }
    
    // MARK: - configure with SBinding<[Item]>
    @discardableResult
    public func configure<Item: Hashable>(
        _ binding: SBinding<[Item]>,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) -> Self {
        // initial load
        self.configureDuplicateSafe(binding.wrappedValue, builder: builder)
        
        // auto-update when binding changes
        binding.didSet = { [weak self] newItems in
            self?.configureDuplicateSafe(newItems, builder: builder)
        }
        
        return self
    }
    
    // MARK: - Overload: configure with id (Item tidak perlu Hashable)
    @discardableResult
    public func configure<Item>(
        _ items: [Item],
        id: @escaping (Item) -> AnyHashable,
        @UIViewBuilder builder: @escaping (Item) -> UIView
    ) -> Self {
        rawItems = items.map { id($0) }
        self.builder = { any in
            // mapping balik ke Item (karena rawItems disimpan sebagai AnyHashable ID)
            // Untuk builder, kita tidak simpan Item secara langsung, jadi builder harus memanggil ulang dari array items
            // solusinya: kita simpan array items secara paralel
            if let index = self.rawItems.firstIndex(of: any) {
                let original = self.storedItems[index] as! Item
                return builder(original)
            }
            return UIView()
        }
        self.storedItems = items.map { $0 }
        applySnapshot()
        return self
    }
    
    
    @discardableResult
    public func configure<Item: Hashable>(_ items: [Item], @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        // Detect duplicates
        let unique = Set(items)
        
        if unique.count != items.count {
            // Use index-based unique IDs
            rawItems = items.enumerated().map { idx, item in
                AnyHashable("\(idx)-\(item.hashValue)")
            }
            
            // For index-based IDs, map back to original items
            self.builder = { any in
                if let index = self.rawItems.firstIndex(of: any) {
                    return builder(items[index])
                }
                return UIView()
            }
        } else {
            // Safe to use item directly as identifier
            rawItems = items.map { $0 as AnyHashable }
            self.builder = { any in builder(any as! Item) }
        }
        
        self.storedItems = items.map { $0 }
        applySnapshot()
        return self
    }
    
    @discardableResult
    public func configureLegacy<Item: Hashable>(_ items: [Item], builder: @escaping (Item) -> UIView) -> Self {
        rawItems = items.map { $0 as AnyHashable }
        self.builder = { any in builder(any as! Item) }
        applySnapshot()
        return self
    }
    
    @discardableResult
    public func updateItems<Item: Hashable>(_ items: [Item]) -> Self {
        self.configureDuplicateSafe(items) { item in
            self.builder?(item) ?? UIView()
        }
    }
    
    /*@discardableResult
    public func refreshable(_ action: @escaping (@escaping () -> Void) -> Void) -> Self {
        refreshAction = action
        if tableView.refreshControl == nil {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(runRefresh), for: .valueChanged)
            tableView.refreshControl = rc
        }
        return self
    }*/
    @objc private func runRefresh() {
        refreshAction? { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @discardableResult
    public func onDelete(_ action: @escaping (IndexSet) -> Void) -> Self {
        deleteAction = action
        return self
    }
    
    @discardableResult
    public func onMove(_ action: @escaping (Int, Int) -> Void) -> Self {
        moveAction = action
        tableView.isEditing = true
        return self
    }
    
    @discardableResult
    public func leadingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        leadingSwipe = make
        return self
    }
    
    @discardableResult
    public func trailingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        trailingSwipe = make
        return self
    }
}

// MARK: - UITableView Delegate
extension ListViews: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rawItems.count }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // handled by diffable
        return tableView.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath)
    }
    
    // Delete
    public func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction?(IndexSet(integer: indexPath.row))
        }
    }
    
    // Move
    public func tableView(_ tableView: UITableView,
                          moveRowAt sourceIndexPath: IndexPath,
                          to destinationIndexPath: IndexPath) {
        moveAction?(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    // Leading swipe
    public func tableView(_ tableView: UITableView,
                          leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let f = leadingSwipe else { return nil }
        let item = rawItems[indexPath.row]
        let actions = f(item)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    // Trailing swipe
    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let f = trailingSwipe else { return nil }
        let item = rawItems[indexPath.row]
        let actions = f(item)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let any = rawItems[indexPath.row]

        onSelectItem?(any)
        onSelectIndex?(indexPath.row)
        onSelectItemIndex?(any, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView,
                          didDeselectRowAt indexPath: IndexPath) {
        onDeselectIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView,
                          didHighlightRowAt indexPath: IndexPath) {
        onHighlightIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView,
                          didUnhighlightRowAt indexPath: IndexPath) {
        onUnhighlightIndex?(indexPath.row)
    }
}




public enum OIListStyle {
    case plain
    case grouped
    case insetGrouped
    case inset
    case card
}

extension ListViews {
    @discardableResult
    public func listStyle(_ style: OIListStyle) -> Self {
        
        switch style {
            
        case .plain:
            tableView.separatorInset = .zero
            tableView.separatorStyle = .singleLine
            tableView.backgroundColor = .systemBackground
            
        case .grouped:
            tableView = wrapNewTable(style: .grouped)
            
        case .insetGrouped:
            tableView = wrapNewTable(style: .insetGrouped)
            
        case .inset:
            tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
        case .card:
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        
        return self
    }

    private func wrapNewTable(style: UITableView.Style) -> UITableView {
        // create new table with requested style
        let newTable = UITableView(frame: .zero, style: style)
        newTable.translatesAutoresizingMaskIntoConstraints = false

        // copy visible config from old table
        newTable.rowHeight = tableView.rowHeight
        newTable.estimatedRowHeight = tableView.estimatedRowHeight
        newTable.separatorStyle = tableView.separatorStyle
        newTable.separatorInset = tableView.separatorInset
        newTable.allowsSelection = tableView.allowsSelection
        newTable.allowsMultipleSelectionDuringEditing = tableView.allowsMultipleSelectionDuringEditing

        // register hosting cell
        newTable.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)

        // replace view in hierarchy
        tableView.removeFromSuperview()
        tableView = newTable
        addSubview(newTable)

        NSLayoutConstraint.activate([
            newTable.topAnchor.constraint(equalTo: topAnchor),
            newTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            newTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            newTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // restore refreshControl if any
        // (note: refreshControl is a weak-ish attachment to the table view; reassign it)
        if let rc = tableView.refreshControl {
            newTable.refreshControl = rc
        }

        // set delegate/datasource
        newTable.delegate = self

        // recreate diffable data source bound to the new table
        // (we call setupDiffable which creates a new UITableViewDiffableDataSource using current tableView)
        setupDiffable()

        // re-apply the current snapshot without animation (style switch shouldn't animate)
        applySnapshot(animated: false)

        return newTable
    }
}

extension ListViews {
    public func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {

        // PRIORITAS: background per-index
        if let provider = rowBackgroundForIndex {
            let color = provider(indexPath.row)
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
            return
        }

        // GLOBAL background color
        if let color = rowBackgroundColor {
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
        }

        // GLOBAL background view
        if let bgView = rowBackgroundView {
            let v = type(of: bgView).init(frame: bgView.frame)
            v.translatesAutoresizingMaskIntoConstraints = false
            cell.backgroundView = v
        }
    }
}


public enum OISeparatorVisibility {
    case visible
    case hidden
}

extension ListViews {
    @discardableResult
    public func separator(_ visibility: OISeparatorVisibility) -> Self {
        switch visibility {
        case .visible:
            tableView.separatorStyle = .singleLine
        case .hidden:
            tableView.separatorStyle = .none
        }
        return self
    }

    @discardableResult
    public func separatorInset(_ inset: UIEdgeInsets) -> Self {
        tableView.separatorInset = inset
        return self
    }

    @discardableResult
    public func separatorPadding(_ left: CGFloat, _ right: CGFloat = 0) -> Self {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        return self
    }
}

extension ListViews {
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        tableView.contentInset = insets
        return self
    }
    
    @discardableResult
    public func paddingHorizontal(_ value: CGFloat) -> Self {
        tableView.contentInset.left = value
        tableView.contentInset.right = value
        return self
    }

    @discardableResult
    public func paddingVertical(_ value: CGFloat) -> Self {
        tableView.contentInset.top = value
        tableView.contentInset.bottom = value
        return self
    }

    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        tableView.contentInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return self
    }
}

extension ListViews {
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        tableView.backgroundColor = color
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func backgroundView(_ view: UIView) -> Self {
        tableView.backgroundView = view
        return self
    }
}

extension ListViews {
    @discardableResult
    public func listRowBackground(_ color: UIColor) -> Self {
        self.rowBackgroundColor = color
        self.rowBackgroundView = nil
        tableView.reloadData()
        return self
    }
    
    @discardableResult
    public func listRowBackground(_ view: UIView) -> Self {
        self.rowBackgroundView = view
        self.rowBackgroundColor = nil
        tableView.reloadData()
        return self
    }
    
    @discardableResult
    public func listRowBackground(alternate colorA: UIColor, and colorB: UIColor) -> Self {
        self.rowBackgroundForIndex = { index in
            index % 2 == 0 ? colorA : colorB
        }
        tableView.reloadData()
        return self
    }
}

extension ListViews {
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable) -> Void) -> Self {
        self.onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
    
    @discardableResult
    public func onSelectIndex(_ action: @escaping (Int) -> Void) -> Self {
        self.onSelectIndex = action
        tableView.allowsSelection = true
        return self
    }
    
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        self.onSelectItemIndex = action
        tableView.allowsSelection = true
        return self
    }
    
    @discardableResult
    public func onDeselect(_ action: @escaping (Int) -> Void) -> Self {
        self.onDeselectIndex = action
        return self
    }
    
    @discardableResult
    public func onHighlight(_ action: @escaping (Int) -> Void) -> Self {
        self.onHighlightIndex = action
        return self
    }
    
    @discardableResult
    public func onUnhighlight(_ action: @escaping (Int) -> Void) -> Self {
        self.onUnhighlightIndex = action
        return self
    }
    
    @discardableResult
    public func onRowTapGesture(_ action: @escaping (AnyHashable) -> Void) -> Self {
        self.onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
}

extension ListViews {
    @discardableResult
    public func refreshable(_ action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.refreshActionCompletion = action
        self.refreshActionSimple = nil
        ensureRefreshControl()
        return self
    }
    
    @discardableResult
    public func refreshable(_ action: @escaping () -> Void) -> Self {
        self.refreshActionSimple = action
        self.refreshActionCompletion = nil
        ensureRefreshControl()
        return self
    }
    
    private func ensureRefreshControl() {
        if tableView.refreshControl == nil {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(runRefreshControl), for: .valueChanged)
            tableView.refreshControl = rc
        }
    }
    
    @objc private func runRefreshControl() {
        // old-style completion handler
        if let completionAction = refreshActionCompletion {
            completionAction { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
            return
        }
        
        // simple closure
        if let simple = refreshActionSimple {
            DispatchQueue.global().async { [weak self] in
                simple()
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            return
}
        
        tableView.refreshControl?.endRefreshing()
    }
}*/







/*
// 1️⃣ MARK: HAMPIR FIX 1
// Xcode-Style Formatted Version (No Code Changes)
// — Cleaned indentation, spacing, and grouping

import UIKit

// MARK: - ListViews
public final class ListViews: UIView {
    
    // MARK: Internal Cell Wrapper
    private final class HostingCell: UITableViewCell {
        static let id = "ListView.HostingCell"
        
        private var hosted: UIView?
        private var activeConstraints: [NSLayoutConstraint] = []
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            hosted?.removeFromSuperview()
            hosted = nil
            NSLayoutConstraint.deactivate(activeConstraints)
            activeConstraints.removeAll()
            contentView.clipsToBounds = true
            layoutIfNeeded()
        }
        
        func host(_ view: UIView) {
            if hosted === view { return }
            hosted?.removeFromSuperview()
            hosted = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            
            activeConstraints = [
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
            NSLayoutConstraint.activate(activeConstraints)
        }
    }
    
    // MARK: UI
    public private(set) var tableView: UITableView!
    
    // MARK: Data
    // MARK: Data
    private enum Section { case main }

    // ⬇️ Tambahin di dalam ListViews (sebelum/di dekat diffable)
    private final class DataSource: UITableViewDiffableDataSource<Section, AnyHashable> {
        weak var owner: ListViews?
        
        override func tableView(_ tableView: UITableView,
                                canMoveRowAt indexPath: IndexPath) -> Bool {
            // Hanya bisa di-drag kalau ada onMove yang diset
            return owner?.moveAction != nil
        }
        
        override func tableView(_ tableView: UITableView,
                                moveRowAt sourceIndexPath: IndexPath,
                                to destinationIndexPath: IndexPath) {
            owner?.moveAction?(sourceIndexPath.row, destinationIndexPath.row)
        }
    }

    private var diffable: DataSource?

    private var rawItems: [AnyHashable] = []
    private var builder: ((AnyHashable) -> UIView)?
    private var storedItems: [Any] = []
    private var stableIDs: [AnyHashable] = []
    
    // MARK: Callbacks
    //private var deleteAction: ((IndexSet) -> Void)?
    private var moveAction: ((Int, Int) -> Void)?
    private var leadingSwipe: ((AnyHashable) -> [UIContextualAction])?
    private var trailingSwipe: ((AnyHashable) -> [UIContextualAction])?
    
    // MARK: Background
    private var rowBackgroundColor: UIColor?
    private var rowBackgroundView: UIView?
    private var rowBackgroundForIndex: ((Int) -> UIColor)?
    
    // MARK: Selection
    private var onSelectItem: ((AnyHashable) -> Void)?
    private var onSelectIndex: ((Int) -> Void)?
    private var onSelectItemIndex: ((AnyHashable, Int) -> Void)?
    private var onDeselectIndex: ((Int) -> Void)?
    private var onHighlightIndex: ((Int) -> Void)?
    private var onUnhighlightIndex: ((Int) -> Void)?
    
    // MARK: Refreshable
    private var refreshActionCompletion: ((@escaping () -> Void) -> Void)?
    private var refreshActionSimple: (() -> Void)?
    
    // MARK: Scroll
    private var isScrollDisabled: Bool = false
    
    private var rowInsets: UIEdgeInsets?
    
    // MARK: Appear
    private var onRowAppear: ((Int) -> Void)?
    private var onItemAppear: ((AnyHashable) -> Void)?
    private var onItemIndexAppear: ((AnyHashable, Int) -> Void)?
    
    private var onRowDisappear: ((Int) -> Void)?
    private var onItemDisappear: ((AnyHashable) -> Void)?
    private var onItemIndexDisappear: ((AnyHashable, Int) -> Void)?
    
    // MARK: ignoresSafeArea
    private var ignoresSafeAreaEdges: OIEdges = .all
    
    // MARK: Paging state
    private var currentPageValue: Int = 1
    private var perPageValue: Int = 10
    private var totalPagesValue: Int = 1
    private var isTotalPagesSet: Bool = false
    
    public var currentPage: Int { currentPageValue }          // public read-only
    public var perPage: Int { perPageValue }                 // public read-only
    public var totalPages: Int { totalPagesValue }           // public read-only
    private var onTotalDataChanged: ((Int) -> Void)?
    
    public var hasMorePages: Bool {
        if !isTotalPagesSet {
            // MODE B: unlimited loadMore
            return true
        }
        return currentPageValue < totalPagesValue
    }
    
    // MARK: - Reach bottom (load more)
    private var onReachBottomAction: (() -> Void)?
    private var reachThreshold: CGFloat = 300.0 // jarak dari bottom untuk trigger
    private var isLoadingMore: Bool = false     // debounce flag
    private var loadMoreSpinner: UIActivityIndicatorView?
    
    // MARK: On Delete
    private var deleteAction: ((IndexSet) -> Void)?
    private var deleteSide: OISwipeSide = .right
    private var deleteTitle: String = "Delete"
    private var deleteSystemImage: String?
    private var deleteFullSwipe: Bool = true
    
    // MARK: Empty State
    private var emptyStateView: UIView?
    
    // MARK: Init
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero)
        setup(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(style: .plain)
    }
    
    private func setup(style: UITableView.Style) {
        tableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        setupDiffable()
    }
    
    private func setupDiffable() {
        let ds = DataSource(tableView: tableView) { [weak self] table, indexPath, identifier in
            guard let cell = table.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath) as? HostingCell else {
                return UITableViewCell()
            }
            guard let build = self?.builder else { return cell }
            let v = build(identifier)
            cell.host(v)
            return cell
        }
        ds.owner = self
        diffable = ds
    }
    
    private func applySnapshot(animated: Bool = true) {
        DispatchQueue.main.async {
            var snap = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snap.appendSections([.main])
            snap.appendItems(self.rawItems)
            self.diffable?.apply(snap, animatingDifferences: animated)
            
            // reset loading flags
            self.isLoadingMore = false
            self.updatePagingStateAfterItemsChange()
            
            // hide footer spinner
            self.hideLoadMoreSpinner()
            // total data
            self.onTotalDataChanged?(self.storedItems.count)
            // ⬅️ PENTING: update empty state setiap kali data berubah
            self.updateEmptyStateVisibility()
        }
    }
    
    // MARK: UIViewBuilder
    @resultBuilder
    public struct UIViewBuilder {
        public static func buildBlock(_ components: UIView...) -> UIView {
            if components.count == 1 { return components[0] }
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 4
            components.forEach { stack.addArrangedSubview($0) }
            return stack
        }
    }
    
    public func Text(_ string: String) -> UILabel {
        let label = UILabel()
        label.text = string
        label.font = .systemFont(ofSize: 17)
        return label
    }
    
    // MARK: Duplicate-Safe Mapping
    private func makeBuilder<Item>(raw: [AnyHashable], stored: [Item], _ builder: @escaping (Item) -> UIView) -> (AnyHashable) -> UIView {
        { any in
            if let idx = raw.firstIndex(of: any) {
                return builder(stored[idx])
            }
            return UIView()
        }
    }
    
    @discardableResult
    private func configureDuplicateSafe<Item: Hashable>(_ items: [Item], builder: @escaping (Item) -> UIView) -> Self {
        let unique = Set(items)
        if unique.count != items.count {
            // always regenerate stable IDs to keep mapping aligned
            stableIDs = items.indices.map { AnyHashable("IDX-\($0)") }
            rawItems = stableIDs
            self.builder = makeBuilder(raw: rawItems, stored: items, builder)
        } else {
            rawItems = items.map { $0 as AnyHashable }
            self.builder = { any in
                guard let typed = any as? Item else { return UIView() }
                return builder(typed)
            }
        }
        
        storedItems = items
        applySnapshot()
        updatePagingStateAfterItemsChange()
        return self
    }
    
    // MARK: Initializers
    public convenience init<Item: Hashable>(_ binding: SBinding<[Item]>, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configureDuplicateSafe(binding.wrappedValue, builder: builder)
        
        binding.didSet = { [weak self] newItems in
            self?.configureDuplicateSafe(newItems, builder: builder)
        }
    }
    
    public convenience init<Item>(_ binding: SBinding<[Item]>, id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configure(binding.wrappedValue, id: id, builder: builder)
        
        binding.didSet = { [weak self] newItems in
            self?.rawItems = newItems.map(id)
            self?.storedItems = newItems
            self?.applySnapshot()
        }
    }
    
    public convenience init(@UIViewBuilder content: @escaping () -> UIView) {
        self.init()
        
        // hanya 1 item (1 row)
        rawItems = [AnyHashable(0)]
        storedItems = []
        
        // builder bikin view baru setiap cell tampil
        builder = { _ in
            return content()
        }
        
        applySnapshot()
    }
    
    /*public convenience init(@UIViewBuilder content: () -> UIView) {
     self.init()
     
     let built = content()
     
     if let stack = built as? UIStackView {
     let views = stack.arrangedSubviews
     storedItems = views
     rawItems = views.indices.map { AnyHashable($0) }
     builder = { any in views[any as! Int] }
     } else {
     storedItems = [built]
     rawItems = [0]
     builder = { _ in built }
     }
     
     applySnapshot()
     }*/
    
    public convenience init<Item: Hashable>(_ items: [Item], @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configureDuplicateSafe(items, builder: builder)
    }
    
    public convenience init<Item>(_ items: [Item], id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configure(items, id: id, builder: builder)
    }
    
    // MARK: Configure
    @discardableResult
    public func configure<Item>(_ binding: SBinding<[Item]>, id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        configure(binding.wrappedValue, id: id, builder: builder)
        binding.didSet = { [weak self] newItems in
            self?.rawItems = newItems.map(id)
            self?.storedItems = newItems
            self?.applySnapshot()
        }
        return self
    }
    
    @discardableResult
    public func configure<Item: Hashable>(_ binding: SBinding<[Item]>, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        configureDuplicateSafe(binding.wrappedValue, builder: builder)
        binding.didSet = { [weak self] items in
            self?.configureDuplicateSafe(items, builder: builder)
        }
        return self
    }
    
    @discardableResult
    public func configure<Item>(_ items: [Item], id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        rawItems = items.map(id)
        self.builder = { any in
            if let index = self.rawItems.firstIndex(of: any) {
                return builder(self.storedItems[index] as! Item)
            }
            return UIView()
        }
        storedItems = items
        applySnapshot()
        updatePagingStateAfterItemsChange()
        return self
    }
    
    @discardableResult
    public func configure<Item: Hashable>(_ items: [Item], @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        let unique = Set(items)
        
        if unique.count != items.count {
            rawItems = items.enumerated().map { AnyHashable("\($0.offset)-\($0.element.hashValue)") }
            self.builder = { any in
                if let index = self.rawItems.firstIndex(of: any) {
                    return builder(items[index])
                }
                return UIView()
            }
        } else {
            rawItems = items.map { $0 as AnyHashable }
            self.builder = { any in
                if let item = any as? Item {
                    return builder(item)
                }
                return UIView() // or assertionFailure("Type mismatch")
            }
        }
        
        storedItems = items
        applySnapshot()
        updatePagingStateAfterItemsChange()
        return self
    }
    
    @discardableResult
    public func configureLegacy<Item: Hashable>(_ items: [Item], builder: @escaping (Item) -> UIView) -> Self {
        rawItems = items
        self.builder = { any in
            if let item = any as? Item {
                return builder(item)
            }
            return UIView() // or assertionFailure("Type mismatch")
        }
        applySnapshot()
        return self
    }
    
    @discardableResult
    public func updateItems<Item: Hashable>(_ items: [Item]) -> Self {
        configureDuplicateSafe(items) { self.builder?($0) ?? UIView() }
    }
    
    @discardableResult
    public func onDelete(_ action: @escaping (IndexSet) -> Void) -> Self {
        deleteAction = action
        return self
    }
    
    @discardableResult
    public func onMove(_ action: @escaping (Int, Int) -> Void) -> Self {
        moveAction = action
        tableView.isEditing = true
        return self
    }
    
    @discardableResult
    public func onMove(
        _ binding: SBinding<Bool>,
        _ action: @escaping (Int, Int) -> Void
    ) -> Self {

        // simpan closure
        self.moveAction = action

        // apply state awal
        tableView.isEditing = binding.wrappedValue

        // listen perubahan binding
        binding.didSet = { [weak self] newValue in
            self?.tableView.isEditing = newValue
        }

        return self
    }
    
    @discardableResult
    public func leadingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        leadingSwipe = make
        return self
    }
    
    @discardableResult
    public func trailingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        trailingSwipe = make
        return self
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        if let rc = tableView.refreshControl {
            rc.removeTarget(self, action: #selector(runRefreshControl), for: .valueChanged)
        }
        tableView.refreshControl = nil
        diffable = nil
        
        loadMoreSpinner?.stopAnimating()
        loadMoreSpinner = nil
        
        // clear closure properties
        refreshActionCompletion = nil
        refreshActionSimple = nil
        deleteAction = nil
        moveAction = nil
        leadingSwipe = nil
        trailingSwipe = nil
        onSelectItem = nil
        onSelectIndex = nil
        onSelectItemIndex = nil
        onDeselectIndex = nil
        onHighlightIndex = nil
        onUnhighlightIndex = nil
        onReachBottomAction = nil
        onTotalDataChanged = nil
        onRowAppear = nil
        onItemAppear = nil
        onItemIndexAppear = nil
        onRowDisappear = nil
        onItemDisappear = nil
        onItemIndexDisappear = nil
    }
}

// MARK: - UITableView Delegate
extension ListViews: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rawItems.count }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction?(IndexSet(integer: indexPath.row))
        }
    }
    
    /*public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveAction?(sourceIndexPath.row, destinationIndexPath.row)
    }*/
    
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let item = rawItems[indexPath.row]
        
        // CUSTOM swipe > Delete default
        if let custom = trailingSwipe {
            return UISwipeActionsConfiguration(actions: custom(item))
        }
        
        // Delete di sisi kanan?
        if deleteSide == .right, let deleteButton = makeDeleteAction(forRow: indexPath.row) {
            let config = UISwipeActionsConfiguration(actions: [deleteButton])
            config.performsFirstActionWithFullSwipe = deleteFullSwipe
            return config
        }
        
        return nil
    }
    
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let item = rawItems[indexPath.row]
        
        if let custom = leadingSwipe {
            return UISwipeActionsConfiguration(actions: custom(item))
        }
        
        if deleteSide == .left, let deleteButton = makeDeleteAction(forRow: indexPath.row) {
            let config = UISwipeActionsConfiguration(actions: [deleteButton])
            config.performsFirstActionWithFullSwipe = deleteFullSwipe
            return config
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let any = rawItems[indexPath.row]
        onSelectItem?(any)
        onSelectIndex?(indexPath.row)
        onSelectItemIndex?(any, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselectIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        onHighlightIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        onUnhighlightIndex?(indexPath.row)
    }
}

// MARK: - Styles
public enum OIListStyle { case plain, grouped, insetGrouped, inset, card }

extension ListViews {
    @discardableResult
    public func listStyle(_ style: OIListStyle) -> Self {
        switch style {
        case .plain:
            tableView.separatorInset = .zero
            tableView.separatorStyle = .singleLine
            tableView.backgroundColor = .systemBackground
        case .grouped:
            tableView = wrapNewTable(style: .grouped)
        case .insetGrouped:
            tableView = wrapNewTable(style: .insetGrouped)
        case .inset:
            tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .card:
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        return self
    }
    
    private func wrapNewTable(style: UITableView.Style) -> UITableView {
        let newTable = UITableView(frame: .zero, style: style)
        newTable.translatesAutoresizingMaskIntoConstraints = false
        
        newTable.rowHeight = tableView.rowHeight
        newTable.estimatedRowHeight = tableView.estimatedRowHeight
        newTable.separatorStyle = tableView.separatorStyle
        newTable.separatorInset = tableView.separatorInset
        newTable.allowsSelection = tableView.allowsSelection
        newTable.allowsMultipleSelectionDuringEditing = tableView.allowsMultipleSelectionDuringEditing
        
        newTable.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)
        
        tableView.removeFromSuperview()
        tableView = newTable
        addSubview(newTable)
        
        NSLayoutConstraint.activate([
            newTable.topAnchor.constraint(equalTo: topAnchor),
            newTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            newTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            newTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let rc = tableView.refreshControl {
            newTable.refreshControl = rc
        }
        
        newTable.delegate = self
        //newTable.dataSource = self
        setupDiffable()
        applySnapshot(animated: false)
        return newTable
    }
}

// MARK: - Background & Separator Settings
extension ListViews {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let item = rawItems[index]
        
        // Appear: index
        onRowAppear?(index)
        
        // Appear: item
        onItemAppear?(item)
        
        // Appear: item + index
        onItemIndexAppear?(item, index)
        
        if let inset = rowInsets {
            cell.contentView.layoutMargins = inset
            cell.separatorInset = inset
        }
        
        if let provider = rowBackgroundForIndex {
            let color = provider(indexPath.row)
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
            return
        }
        if let color = rowBackgroundColor {
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
        }
        if let bgView = rowBackgroundView {
            let v = type(of: bgView).init(frame: bgView.frame)
            v.translatesAutoresizingMaskIntoConstraints = false
            cell.backgroundView = v
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          didEndDisplaying cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        
        // Pastikan index masih valid (diffable bisa ubah state)
        guard rawItems.indices.contains(index) else {
            onRowDisappear?(index)
            return
        }
        
        let item = rawItems[index]
        
        // Disappear: index
        onRowDisappear?(index)
        
        // Disappear: item
        onItemDisappear?(item)
        
        // Disappear: item + index
        onItemIndexDisappear?(item, index)
    }
    
}

public enum OISeparatorVisibility { case visible, hidden }

extension ListViews {
    @discardableResult
    public func separator(_ visibility: OISeparatorVisibility) -> Self {
        tableView.separatorStyle = visibility == .visible ? .singleLine : .none
        return self
    }
    @discardableResult
    public func separatorInset(_ inset: UIEdgeInsets) -> Self {
        tableView.separatorInset = inset
        return self
    }
    @discardableResult
    public func separatorPadding(_ left: CGFloat, _ right: CGFloat = 0) -> Self {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        return self
    }
}

// MARK: - Padding
extension ListViews {
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        tableView.contentInset = insets
        return self
    }
    @discardableResult
    public func paddingHorizontal(_ value: CGFloat) -> Self {
        tableView.contentInset.left = value
        tableView.contentInset.right = value
        return self
    }
    @discardableResult
    public func paddingVertical(_ value: CGFloat) -> Self {
        tableView.contentInset.top = value
        tableView.contentInset.bottom = value
        return self
    }
    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        tableView.contentInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return self
    }
}

// MARK: - Background
extension ListViews {
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        tableView.backgroundColor = color
        self.backgroundColor = color
        return self
    }
    @discardableResult
    public func backgroundView(_ view: UIView) -> Self {
        tableView.backgroundView = view
        return self
    }
}

// MARK: - Row Background
extension ListViews {
    @discardableResult
    public func listRowBackground(_ color: UIColor) -> Self {
        rowBackgroundColor = color
        rowBackgroundView = nil
        tableView.reloadData()
        return self
    }
    @discardableResult
    public func listRowBackground(_ view: UIView) -> Self {
        rowBackgroundView = view
        rowBackgroundColor = nil
        tableView.reloadData()
        return self
    }
    @discardableResult
    public func listRowBackground(alternate colorA: UIColor, and colorB: UIColor) -> Self {
        rowBackgroundForIndex = { $0 % 2 == 0 ? colorA : colorB }
        tableView.reloadData()
        return self
    }
}

// MARK: - Selection
extension ListViews {
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onSelectIndex(_ action: @escaping (Int) -> Void) -> Self {
        onSelectIndex = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onSelectItemIndex = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onDeselect(_ action: @escaping (Int) -> Void) -> Self {
        onDeselectIndex = action
        return self
    }
    @discardableResult
    public func onHighlight(_ action: @escaping (Int) -> Void) -> Self {
        onHighlightIndex = action
        return self
    }
    @discardableResult
    public func onUnhighlight(_ action: @escaping (Int) -> Void) -> Self {
        onUnhighlightIndex = action
        return self
    }
    @discardableResult
    public func onRowTapGesture(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
}

// MARK: - Refreshable
extension ListViews {
    @discardableResult
    public func refreshable(_ action: @escaping (@escaping () -> Void) -> Void) -> Self {
        refreshActionCompletion = action
        refreshActionSimple = nil
        ensureRefreshControl()
        return self
    }
    @discardableResult
    public func refreshable(_ action: @escaping () -> Void) -> Self {
        refreshActionSimple = action
        refreshActionCompletion = nil
        ensureRefreshControl()
        return self
    }
    private func ensureRefreshControl() {
        if tableView.refreshControl == nil {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(runRefreshControl), for: .valueChanged)
            tableView.refreshControl = rc
        }
    }
    @objc private func runRefreshControl() {
        if let completionAction = refreshActionCompletion {
            completionAction { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
            return
        }
        if let simple = refreshActionSimple {
            DispatchQueue.global().async { [weak self] in
                simple()
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            return
        }
        tableView.refreshControl?.endRefreshing()
    }
}

extension ListViews {
    @discardableResult
    public func scrollEnabled(_ enabled: Bool) -> Self {
        tableView.isScrollEnabled = enabled
        return self
    }
}

// MARK: - Row Insets
extension ListViews {
    @discardableResult
    public func listRowInsets(_ insets: UIEdgeInsets) -> Self {
        rowInsets = insets
        tableView.reloadData()
        return self
    }
    
    @discardableResult
    public func listRowInsets(_ insets: UIEdgeInsets?) -> Self {
        rowInsets = insets
        tableView.reloadData()
        return self
    }
}

// MARK: - Keyboard Dismiss
extension ListViews {
    @discardableResult
    public func keyboardDismiss(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        tableView.keyboardDismissMode = mode
        return self
    }
    
    @discardableResult
    public func dismissKeyboardOnDrag() -> Self {
        tableView.keyboardDismissMode = .onDrag
        return self
    }
}

// MARK: - Appear
extension ListViews {
    @discardableResult
    public func onAppear(_ action: @escaping (Int) -> Void) -> Self {
        onRowAppear = action
        return self
    }
    
    @discardableResult
    public func onAppear(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onItemAppear = action
        return self
    }
    
    @discardableResult
    public func onAppear(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onItemIndexAppear = action
        return self
    }
}

// MARK: - Disappear
extension ListViews {
    @discardableResult
    public func onDisappear(_ action: @escaping (Int) -> Void) -> Self {
        onRowDisappear = action
        return self
    }
    
    @discardableResult
    public func onDisappear(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onItemDisappear = action
        return self
    }
    
    @discardableResult
    public func onDisappear(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onItemIndexDisappear = action
        return self
    }
}

// MARK: - Safe Area
public enum OIEdges {
    case all, top, bottom, horizontal, vertical
}

extension ListViews {
    @discardableResult
    public func ignoresSafeArea(_ edges: OIEdges = .all) -> Self {
        ignoresSafeAreaEdges = edges
        tableView.contentInsetAdjustmentBehavior = .never
        return self
    }
}

// MARK: Indicator
extension ListViews {
    @discardableResult
    public func showsVerticalIndicator(_ show: Bool) -> Self {
        tableView.showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    public func showsHorizontalIndicator(_ show: Bool) -> Self {
        tableView.showsHorizontalScrollIndicator = show
        return self
    }
}

// MARK: - Header Footer
extension ListViews {
    @discardableResult
    public func headerSpacing(_ height: CGFloat) -> Self {
        let spacer = UIView()
        spacer.frame.size.height = height
        tableView.tableHeaderView = spacer
        return self
    }
    
    @discardableResult
    public func footerSpacing(_ height: CGFloat) -> Self {
        let spacer = UIView()
        spacer.frame.size.height = height
        tableView.tableFooterView = spacer
        return self
    }
}

// MARK: - Paging state
extension ListViews {
    @discardableResult
    public func currentPage(_ page: Int) -> Self {
        // pastikan page minimal 1
        currentPageValue = max(1, page)
        return self
    }
    
    @discardableResult
    public func perPage(_ perPage: Int) -> Self {
        // minimal 1 item per page
        perPageValue = max(1, perPage)
        return self
    }
    
    @discardableResult
    public func totalPages(_ pages: Int) -> Self {
        totalPagesValue = max(1, pages)
        isTotalPagesSet = true
        return self
    }
    
    @discardableResult
    public func resetPaging(toPage page: Int = 1) -> Self {
        currentPageValue = max(1, page)
        return self
    }
    
    @discardableResult
    public func totalData(_ action: @escaping (Int) -> Void) -> Self {
        self.onTotalDataChanged = action
        // initial fire
        action(storedItems.count)
        return self
    }
}

// MARK: - Reach bottom API
extension ListViews {
    /// Set closure to call when user scrolls near bottom
    @discardableResult
    public func onReachBottom(reachThreshold: CGFloat = 300,
                              _ action: @escaping () -> Void) -> Self {
        self.reachThreshold = max(0, reachThreshold)
        self.onReachBottomAction = action
        return self
    }
    
    /// Call this when your load-more operation is finished (e.g. after network completes and items updated).
    public func endReachLoading() {
        DispatchQueue.main.async {
            self.isLoadingMore = false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let action = onReachBottomAction else { return }
        
        // block saat pull-to-refresh
        let offsetY = scrollView.contentOffset.y
        let topInset = scrollView.adjustedContentInset.top
        if tableView.isDragging && offsetY < -topInset { return }
        if tableView.refreshControl?.isRefreshing == true { return }
        
        // block saat sudah loading atau tidak ada page
        if isLoadingMore { return }
        if !hasMorePages { return }
        
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.bounds.height
        
        // <<< SOLUSI PENTING >>>
        // kalau item masih sedikit dan belum bisa scroll → auto loadMore sekali
        if contentHeight <= frameHeight {
            isLoadingMore = true
            showLoadMoreSpinner()
            DispatchQueue.main.async { action() }
            return
        }
        
        if offsetY + frameHeight + reachThreshold >= contentHeight {
            isLoadingMore = true
            showLoadMoreSpinner()
            DispatchQueue.main.async { action() }
        }
    }
    
    // MARK: - Paging helpers (auto update)
    private func updatePagingStateAfterItemsChange() {
        DispatchQueue.main.async {
            // stop loading more when items changed
            self.isLoadingMore = false
            
            // recompute current page from storedItems.count and perPageValue
            let count = self.storedItems.count
            guard self.perPageValue > 0 else {
                self.currentPageValue = 1
                return
            }
            // page = ceil(count / perPage)
            let page = max(1, Int(ceil(Double(count) / Double(self.perPageValue))))
            self.currentPageValue = page
        }
    }
}

// MARK: - Load More Spinner
extension ListViews {
    private func showLoadMoreSpinner() {
        if loadMoreSpinner == nil {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
            spinner.hidesWhenStopped = true
            
            loadMoreSpinner = spinner
        }
        
        tableView.tableFooterView = loadMoreSpinner
    }
    
    private func hideLoadMoreSpinner() {
        tableView.tableFooterView = nil
    }
}

// MARK: OnDelete
public enum OISwipeSide {
    case left
    case right
}

extension ListViews {
    @discardableResult
    public func onDelete(
        _ side: OISwipeSide = .right,
        title: String = "Delete",
        systemImage: String? = nil,
        fullSwipe: Bool = true,
        _ action: @escaping (IndexSet) -> Void
    ) -> Self {

        self.deleteSide = side
        self.deleteTitle = title
        self.deleteSystemImage = systemImage
        self.deleteFullSwipe = fullSwipe
        self.deleteAction = action
        
        return self
    }
    
    private func makeDeleteAction(forRow row: Int) -> UIContextualAction? {
        guard let deleteAction = deleteAction else { return nil }
        
        let action = UIContextualAction(style: .destructive, title: deleteTitle) { [weak self] _, _, done in
            guard let self = self else { return }
            self.handleDelete(at: row, deleteAction: deleteAction)
            done(true)
        }
        
        // Tambah icon kalau ada
        if let imageName = deleteSystemImage {
            action.image = UIImage(systemName: imageName)
        }
        
        return action
    }
    
    private func handleDelete(at row: Int, deleteAction: @escaping (IndexSet) -> Void) {
        // Pastikan index masih valid
        guard rawItems.indices.contains(row) else { return }
        deleteAction(IndexSet(integer: row))
    }
}

extension ListViews {
    @discardableResult
    public func searchable<Item>(
        _ query: SBinding<String>,
        source: SBinding<[Item]>,
        resetOnEmpty: Bool = true,
        matches: @escaping (Item, String) -> Bool
    ) -> Self {

        // simpan data full
        var originalItems = source.wrappedValue
        var isInternalUpdate = false

        // simpan didSet lama supaya binding ListViews gak ketimpa
        let oldSourceDidSet = source.didSet
        let oldQueryDidSet = query.didSet

        func applyFilter() {
            let text = query.wrappedValue
                .trimmingCharacters(in: .whitespacesAndNewlines)

            isInternalUpdate = true
            defer { isInternalUpdate = false }

            // kalau query kosong
            if text.isEmpty {
                if resetOnEmpty {
                    // balikin ke data full
                    source.wrappedValue = originalItems
                }
                // kalau resetOnEmpty = false → gak ngapa2in
                return
            }
            
            // kalau ada query → filter dari originalItems
            source.wrappedValue = originalItems.filter { item in
                matches(item, text)
            }
        }

        // kalau data asli (source) berubah dari luar (API, paging, dsb)
        source.didSet = { newValue in
            // tetap panggil didSet lama (ListViews masih auto-refresh)
            oldSourceDidSet?(newValue)

            // kalau perubahan bukan dari filter internal
            if !isInternalUpdate {
                originalItems = newValue
                applyFilter()
            }
        }

        // kalau query berubah ($searchText berubah)
        query.didSet = { newValue in
            // kalau ada listener lain di query, tetap dipanggil
            oldQueryDidSet?(newValue)
            applyFilter()
        }

        // initial
        applyFilter()

        return self
    }
}

extension ListViews {
    @discardableResult
    public func emptyState(@UIViewBuilder _ builder: () -> UIView) -> Self {
        // buang yang lama kalau ada
        emptyStateView?.removeFromSuperview()

        let view = builder()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        bringSubviewToFront(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])

        emptyStateView = view
        updateEmptyStateVisibility()

        return self
    }

    private func updateEmptyStateVisibility() {
        // kosong → tampil, ada data → sembunyikan
        emptyStateView?.isHidden = !rawItems.isEmpty
    }
}*/

// 2️⃣ MARK: HAMPIR FIX 2
// Xcode-Style Formatted Version (No Code Changes)
// — Cleaned indentation, spacing, and grouping

import UIKit

// MARK: - ListViews
public final class ListViews: UIView {
    
    // MARK: Internal Cell Wrapper
    private final class HostingCell: UITableViewCell {
        static let id = "ListView.HostingCell"
        
        private var hosted: UIView?
        private var activeConstraints: [NSLayoutConstraint] = []
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            hosted?.removeFromSuperview()
            hosted = nil
            NSLayoutConstraint.deactivate(activeConstraints)
            activeConstraints.removeAll()
            contentView.clipsToBounds = true
            layoutIfNeeded()
        }
        
        func host(_ view: UIView) {
            if hosted === view { return }
            hosted?.removeFromSuperview()
            hosted = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            
            activeConstraints = [
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
            NSLayoutConstraint.activate(activeConstraints)
        }
    }
    
    // MARK: UI
    public private(set) var tableView: UITableView!
    
    // MARK: Data
    // MARK: Data
    private enum Section { case main }

    // ⬇️ Tambahin di dalam ListViews (sebelum/di dekat diffable)
    private final class DataSource: UITableViewDiffableDataSource<Section, AnyHashable> {
        weak var owner: ListViews?
        
        override func tableView(_ tableView: UITableView,
                                canMoveRowAt indexPath: IndexPath) -> Bool {
            // Hanya bisa di-drag kalau ada onMove yang diset
            return owner?.moveAction != nil
        }
        
        override func tableView(_ tableView: UITableView,
                                moveRowAt sourceIndexPath: IndexPath,
                                to destinationIndexPath: IndexPath) {
            owner?.moveAction?(sourceIndexPath.row, destinationIndexPath.row)
        }
    }

    private var diffable: DataSource?

    private var rawItems: [AnyHashable] = []
    private var builder: ((AnyHashable) -> UIView)?
    private var storedItems: [Any] = []
    private var stableIDs: [AnyHashable] = []
    
    // MARK: Callbacks
    //private var deleteAction: ((IndexSet) -> Void)?
    private var moveAction: ((Int, Int) -> Void)?
    private var leadingSwipe: ((AnyHashable) -> [UIContextualAction])?
    private var trailingSwipe: ((AnyHashable) -> [UIContextualAction])?
    
    // MARK: Background
    private var rowBackgroundColor: UIColor?
    private var rowBackgroundView: UIView?
    private var rowBackgroundForIndex: ((Int) -> UIColor)?
    
    // MARK: Selection
    private var onSelectItem: ((AnyHashable) -> Void)?
    private var onSelectIndex: ((Int) -> Void)?
    private var onSelectItemIndex: ((AnyHashable, Int) -> Void)?
    private var onDeselectIndex: ((Int) -> Void)?
    private var onHighlightIndex: ((Int) -> Void)?
    private var onUnhighlightIndex: ((Int) -> Void)?
    
    // MARK: Refreshable
    private var refreshActionCompletion: ((@escaping () -> Void) -> Void)?
    private var refreshActionSimple: (() -> Void)?
    
    // MARK: Scroll
    private var isScrollDisabled: Bool = false
    private var hasUserScrolled = false
    private var rowInsets: UIEdgeInsets?
    
    // MARK: Appear
    private var onRowAppear: ((Int) -> Void)?
    private var onItemAppear: ((AnyHashable) -> Void)?
    private var onItemIndexAppear: ((AnyHashable, Int) -> Void)?
    
    private var onRowDisappear: ((Int) -> Void)?
    private var onItemDisappear: ((AnyHashable) -> Void)?
    private var onItemIndexDisappear: ((AnyHashable, Int) -> Void)?
    
    // MARK: ignoresSafeArea
    private var ignoresSafeAreaEdges: OIEdges = .all
    
    // MARK: Paging state
    private var currentPageValue: Int = 1
    private var perPageValue: Int = 10
    private var totalPagesValue: Int = 1
    private var isTotalPagesSet: Bool = false
    
    public var currentPage: Int { currentPageValue }          // public read-only
    public var perPage: Int { perPageValue }                 // public read-only
    public var totalPages: Int { totalPagesValue }           // public read-only
    private var onTotalDataChanged: ((Int) -> Void)?
    
    public var hasMorePages: Bool {
        if !isTotalPagesSet {
            // MODE B: unlimited loadMore
            return true
        }
        return currentPageValue < totalPagesValue
    }
    
    // MARK: - Reach bottom (load more)
    private var onReachBottomAction: (() -> Void)?
    private var reachThreshold: CGFloat = 300.0 // jarak dari bottom untuk trigger
    private var isLoadingMore: Bool = false     // debounce flag
    private var loadMoreSpinner: UIActivityIndicatorView?
    
    // MARK: On Delete
    private var deleteAction: ((IndexSet) -> Void)?
    private var deleteSide: OISwipeSide = .right
    private var deleteTitle: String = "Delete"
    private var deleteSystemImage: String?
    private var deleteFullSwipe: Bool = true
    
    // MARK: Empty State
    private var emptyStateView: UIView?
    
    // MARK: Init
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero)
        setup(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(style: .plain)
    }
    
    private func setup(style: UITableView.Style) {
        tableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        setupDiffable()
    }
    
    private func setupDiffable() {
        let ds = DataSource(tableView: tableView) { [weak self] table, indexPath, identifier in
            guard let cell = table.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath) as? HostingCell else {
                return UITableViewCell()
            }
            guard let build = self?.builder else { return cell }
            let v = build(identifier)
            cell.host(v)
            return cell
        }
        ds.owner = self
        diffable = ds
    }
    
    private func applySnapshot(animated: Bool = true) {
        DispatchQueue.main.async {
            var snap = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snap.appendSections([.main])
            snap.appendItems(self.rawItems)
            self.diffable?.apply(snap, animatingDifferences: animated)
            
            // reset loading flags
            self.isLoadingMore = false
            self.updatePagingStateAfterItemsChange()
            
            // hide footer spinner
            self.hideLoadMoreSpinner()
            // total data
            self.onTotalDataChanged?(self.storedItems.count)
            // ⬅️ PENTING: update empty state setiap kali data berubah
            self.updateEmptyStateVisibility()
        }
    }
    
    // MARK: UIViewBuilder
    @resultBuilder
    public struct UIViewBuilder {
        public static func buildBlock(_ components: UIView...) -> UIView {
            if components.count == 1 { return components[0] }
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 4
            components.forEach { stack.addArrangedSubview($0) }
            return stack
        }
    }
    
    public func Text(_ string: String) -> UILabel {
        let label = UILabel()
        label.text = string
        label.font = .systemFont(ofSize: 17)
        return label
    }
    
    // MARK: Duplicate-Safe Mapping
    private func makeBuilder<Item>(raw: [AnyHashable], stored: [Item], _ builder: @escaping (Item) -> UIView) -> (AnyHashable) -> UIView {
        { any in
            if let idx = raw.firstIndex(of: any) {
                return builder(stored[idx])
            }
            return UIView()
        }
    }
    
    // MARK: Initializers
    public convenience init<Item: Hashable>(_ binding: SBinding<[Item]>, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configureDuplicateSafe(binding.wrappedValue, builder: builder)
        
        binding.didSet = { [weak self] newItems in
            self?.configureDuplicateSafe(newItems, builder: builder)
        }
    }
    
    public convenience init<Item>(_ binding: SBinding<[Item]>, id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configure(binding.wrappedValue, id: id, builder: builder)
        
        binding.didSet = { [weak self] newItems in
            self?.rawItems = newItems.map(id)
            self?.storedItems = newItems
            self?.applySnapshot()
        }
    }
    
    public convenience init(@UIViewBuilder content: @escaping () -> UIView) {
        self.init()
        
        // hanya 1 item (1 row)
        rawItems = [AnyHashable(0)]
        storedItems = []
        
        // builder bikin view baru setiap cell tampil
        builder = { _ in
            return content()
        }
        
        applySnapshot()
    }
    
    /*public convenience init(@UIViewBuilder content: () -> UIView) {
     self.init()
     
     let built = content()
     
     if let stack = built as? UIStackView {
     let views = stack.arrangedSubviews
     storedItems = views
     rawItems = views.indices.map { AnyHashable($0) }
     builder = { any in views[any as! Int] }
     } else {
     storedItems = [built]
     rawItems = [0]
     builder = { _ in built }
     }
     
     applySnapshot()
     }*/
    
    public convenience init<Item: Hashable>(_ items: [Item], @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configureDuplicateSafe(items, builder: builder)
    }
    
    public convenience init<Item>(_ items: [Item], id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) {
        self.init()
        configure(items, id: id, builder: builder)
    }
    
    // MARK: Configure
    @discardableResult
    public func configure<Item>(_ binding: SBinding<[Item]>, id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        configure(binding.wrappedValue, id: id, builder: builder)
        binding.didSet = { [weak self] newItems in
            self?.rawItems = newItems.map(id)
            self?.storedItems = newItems
            self?.applySnapshot()
        }
        return self
    }
    
    @discardableResult
    public func configure<Item: Hashable>(_ binding: SBinding<[Item]>, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        configureDuplicateSafe(binding.wrappedValue, builder: builder)
        binding.didSet = { [weak self] items in
            self?.configureDuplicateSafe(items, builder: builder)
        }
        return self
    }
    
    @discardableResult
    public func configure<Item>(_ items: [Item], id: @escaping (Item) -> AnyHashable, @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        rawItems = items.map(id)
        self.builder = { any in
            if let index = self.rawItems.firstIndex(of: any) {
                return builder(self.storedItems[index] as! Item)
            }
            return UIView()
        }
        storedItems = items
        applySnapshot()
        updatePagingStateAfterItemsChange()
        return self
    }
    
    @discardableResult
    public func configure<Item: Hashable>(_ items: [Item], @UIViewBuilder builder: @escaping (Item) -> UIView) -> Self {
        let unique = Set(items)
        
        if unique.count != items.count {
            rawItems = items.enumerated().map { AnyHashable("\($0.offset)-\($0.element.hashValue)") }
            self.builder = { any in
                if let index = self.rawItems.firstIndex(of: any) {
                    return builder(items[index])
                }
                return UIView()
            }
        } else {
            rawItems = items.map { $0 as AnyHashable }
            self.builder = { any in
                if let item = any as? Item {
                    return builder(item)
                }
                return UIView() // or assertionFailure("Type mismatch")
            }
        }
        
        storedItems = items
        applySnapshot()
        updatePagingStateAfterItemsChange()
        return self
    }
    
    @discardableResult
    public func configureLegacy<Item: Hashable>(_ items: [Item], builder: @escaping (Item) -> UIView) -> Self {
        rawItems = items
        self.builder = { any in
            if let item = any as? Item {
                return builder(item)
            }
            return UIView() // or assertionFailure("Type mismatch")
        }
        applySnapshot()
        return self
    }
    
    @discardableResult
    public func updateItems<Item: Hashable>(_ items: [Item]) -> Self {
        configureDuplicateSafe(items) { self.builder?($0) ?? UIView() }
    }
    
    @discardableResult
    public func onDelete(_ action: @escaping (IndexSet) -> Void) -> Self {
        deleteAction = action
        return self
    }
    
    @discardableResult
    public func onMove(_ action: @escaping (Int, Int) -> Void) -> Self {
        moveAction = action
        tableView.isEditing = true
        return self
    }
    
    @discardableResult
    public func onMove(
        _ binding: SBinding<Bool>,
        _ action: @escaping (Int, Int) -> Void
    ) -> Self {

        // simpan closure
        self.moveAction = action

        // apply state awal
        tableView.isEditing = binding.wrappedValue

        // listen perubahan binding
        binding.didSet = { [weak self] newValue in
            self?.tableView.isEditing = newValue
        }

        return self
    }
    
    @discardableResult
    public func leadingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        leadingSwipe = make
        return self
    }
    
    @discardableResult
    public func trailingSwipeActions(_ make: @escaping (AnyHashable) -> [UIContextualAction]) -> Self {
        trailingSwipe = make
        return self
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        if let rc = tableView.refreshControl {
            rc.removeTarget(self, action: #selector(runRefreshControl), for: .valueChanged)
        }
        tableView.refreshControl = nil
        diffable = nil
        
        loadMoreSpinner?.stopAnimating()
        loadMoreSpinner = nil
        
        // clear closure properties
        refreshActionCompletion = nil
        refreshActionSimple = nil
        deleteAction = nil
        moveAction = nil
        leadingSwipe = nil
        trailingSwipe = nil
        onSelectItem = nil
        onSelectIndex = nil
        onSelectItemIndex = nil
        onDeselectIndex = nil
        onHighlightIndex = nil
        onUnhighlightIndex = nil
        onReachBottomAction = nil
        onTotalDataChanged = nil
        onRowAppear = nil
        onItemAppear = nil
        onItemIndexAppear = nil
        onRowDisappear = nil
        onItemDisappear = nil
        onItemIndexDisappear = nil
    }
}

// MARK: - UITableView Delegate
extension ListViews: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rawItems.count }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: HostingCell.id, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction?(IndexSet(integer: indexPath.row))
        }
    }
    
    /*public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveAction?(sourceIndexPath.row, destinationIndexPath.row)
    }*/
    
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let item = rawItems[indexPath.row]
        
        // CUSTOM swipe > Delete default
        if let custom = trailingSwipe {
            return UISwipeActionsConfiguration(actions: custom(item))
        }
        
        // Delete di sisi kanan?
        if deleteSide == .right, let deleteButton = makeDeleteAction(forRow: indexPath.row) {
            let config = UISwipeActionsConfiguration(actions: [deleteButton])
            config.performsFirstActionWithFullSwipe = deleteFullSwipe
            return config
        }
        
        return nil
    }
    
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let item = rawItems[indexPath.row]
        
        if let custom = leadingSwipe {
            return UISwipeActionsConfiguration(actions: custom(item))
        }
        
        if deleteSide == .left, let deleteButton = makeDeleteAction(forRow: indexPath.row) {
            let config = UISwipeActionsConfiguration(actions: [deleteButton])
            config.performsFirstActionWithFullSwipe = deleteFullSwipe
            return config
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let any = rawItems[indexPath.row]
        onSelectItem?(any)
        onSelectIndex?(indexPath.row)
        onSelectItemIndex?(any, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeselectIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        onHighlightIndex?(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        onUnhighlightIndex?(indexPath.row)
    }
}

// MARK: - Styles
public enum OIListStyle { case plain, grouped, insetGrouped, inset, card }

extension ListViews {
    @discardableResult
    public func listStyle(_ style: OIListStyle) -> Self {
        switch style {
        case .plain:
            tableView.separatorInset = .zero
            tableView.separatorStyle = .singleLine
            tableView.backgroundColor = .systemBackground
        case .grouped:
            tableView = wrapNewTable(style: .grouped)
        case .insetGrouped:
            tableView = wrapNewTable(style: .insetGrouped)
        case .inset:
            tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .card:
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        return self
    }
    
    private func wrapNewTable(style: UITableView.Style) -> UITableView {
        let newTable = UITableView(frame: .zero, style: style)
        newTable.translatesAutoresizingMaskIntoConstraints = false
        
        newTable.rowHeight = tableView.rowHeight
        newTable.estimatedRowHeight = tableView.estimatedRowHeight
        newTable.separatorStyle = tableView.separatorStyle
        newTable.separatorInset = tableView.separatorInset
        newTable.allowsSelection = tableView.allowsSelection
        newTable.allowsMultipleSelectionDuringEditing = tableView.allowsMultipleSelectionDuringEditing
        
        newTable.register(HostingCell.self, forCellReuseIdentifier: HostingCell.id)
        
        tableView.removeFromSuperview()
        tableView = newTable
        addSubview(newTable)
        
        NSLayoutConstraint.activate([
            newTable.topAnchor.constraint(equalTo: topAnchor),
            newTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            newTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            newTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let rc = tableView.refreshControl {
            newTable.refreshControl = rc
        }
        
        newTable.delegate = self
        //newTable.dataSource = self
        setupDiffable()
        applySnapshot(animated: false)
        return newTable
    }
}

// MARK: - Background & Separator Settings
extension ListViews {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let item = rawItems[index]
        
        // Appear: index
        onRowAppear?(index)
        
        // Appear: item
        onItemAppear?(item)
        
        // Appear: item + index
        onItemIndexAppear?(item, index)
        
        if let inset = rowInsets {
            cell.contentView.layoutMargins = inset
            cell.separatorInset = inset
        }
        
        if let provider = rowBackgroundForIndex {
            let color = provider(indexPath.row)
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
            return
        }
        if let color = rowBackgroundColor {
            cell.contentView.backgroundColor = color
            cell.backgroundColor = color
        }
        if let bgView = rowBackgroundView {
            let v = type(of: bgView).init(frame: bgView.frame)
            v.translatesAutoresizingMaskIntoConstraints = false
            cell.backgroundView = v
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          didEndDisplaying cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        
        // Pastikan index masih valid (diffable bisa ubah state)
        guard rawItems.indices.contains(index) else {
            onRowDisappear?(index)
            return
        }
        
        let item = rawItems[index]
        
        // Disappear: index
        onRowDisappear?(index)
        
        // Disappear: item
        onItemDisappear?(item)
        
        // Disappear: item + index
        onItemIndexDisappear?(item, index)
    }
    
}

public enum OISeparatorVisibility { case visible, hidden }

extension ListViews {
    @discardableResult
    public func separator(_ visibility: OISeparatorVisibility) -> Self {
        tableView.separatorStyle = visibility == .visible ? .singleLine : .none
        return self
    }
    @discardableResult
    public func separatorInset(_ inset: UIEdgeInsets) -> Self {
        tableView.separatorInset = inset
        return self
    }
    @discardableResult
    public func separatorPadding(_ left: CGFloat, _ right: CGFloat = 0) -> Self {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        return self
    }
}

// MARK: - Padding
extension ListViews {
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        tableView.contentInset = insets
        return self
    }
    @discardableResult
    public func paddingHorizontal(_ value: CGFloat) -> Self {
        tableView.contentInset.left = value
        tableView.contentInset.right = value
        return self
    }
    @discardableResult
    public func paddingVertical(_ value: CGFloat) -> Self {
        tableView.contentInset.top = value
        tableView.contentInset.bottom = value
        return self
    }
    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        tableView.contentInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return self
    }
}

// MARK: - Background
extension ListViews {
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        tableView.backgroundColor = color
        self.backgroundColor = color
        return self
    }
    @discardableResult
    public func backgroundView(_ view: UIView) -> Self {
        tableView.backgroundView = view
        return self
    }
}

// MARK: - Row Background
extension ListViews {
    @discardableResult
    public func listRowBackground(_ color: UIColor) -> Self {
        rowBackgroundColor = color
        rowBackgroundView = nil
        tableView.reloadData()
        return self
    }
    @discardableResult
    public func listRowBackground(_ view: UIView) -> Self {
        rowBackgroundView = view
        rowBackgroundColor = nil
        tableView.reloadData()
        return self
    }
    @discardableResult
    public func listRowBackground(alternate colorA: UIColor, and colorB: UIColor) -> Self {
        rowBackgroundForIndex = { $0 % 2 == 0 ? colorA : colorB }
        tableView.reloadData()
        return self
    }
}

// MARK: - Selection
extension ListViews {
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onSelectIndex(_ action: @escaping (Int) -> Void) -> Self {
        onSelectIndex = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onSelect(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onSelectItemIndex = action
        tableView.allowsSelection = true
        return self
    }
    @discardableResult
    public func onDeselect(_ action: @escaping (Int) -> Void) -> Self {
        onDeselectIndex = action
        return self
    }
    @discardableResult
    public func onHighlight(_ action: @escaping (Int) -> Void) -> Self {
        onHighlightIndex = action
        return self
    }
    @discardableResult
    public func onUnhighlight(_ action: @escaping (Int) -> Void) -> Self {
        onUnhighlightIndex = action
        return self
    }
    @discardableResult
    public func onRowTapGesture(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onSelectItem = action
        tableView.allowsSelection = true
        return self
    }
}

// MARK: - Refreshable
extension ListViews {
    @discardableResult
    public func refreshable(_ action: @escaping (@escaping () -> Void) -> Void) -> Self {
        refreshActionCompletion = action
        refreshActionSimple = nil
        ensureRefreshControl()
        return self
    }
    @discardableResult
    public func refreshable(_ action: @escaping () -> Void) -> Self {
        refreshActionSimple = action
        refreshActionCompletion = nil
        ensureRefreshControl()
        return self
    }
    private func ensureRefreshControl() {
        if tableView.refreshControl == nil {
            let rc = UIRefreshControl()
            rc.addTarget(self, action: #selector(runRefreshControl), for: .valueChanged)
            tableView.refreshControl = rc
        }
    }
    @objc private func runRefreshControl() {
        if let completionAction = refreshActionCompletion {
            completionAction { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
            return
        }
        if let simple = refreshActionSimple {
            DispatchQueue.global().async { [weak self] in
                simple()
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            return
        }
        tableView.refreshControl?.endRefreshing()
    }
}

extension ListViews {
    @discardableResult
    public func scrollEnabled(_ enabled: Bool) -> Self {
        tableView.isScrollEnabled = enabled
        return self
    }
}

// MARK: - Row Insets
extension ListViews {
    @discardableResult
    public func listRowInsets(_ insets: UIEdgeInsets) -> Self {
        rowInsets = insets
        tableView.reloadData()
        return self
    }
    
    @discardableResult
    public func listRowInsets(_ insets: UIEdgeInsets?) -> Self {
        rowInsets = insets
        tableView.reloadData()
        return self
    }
}

// MARK: - Keyboard Dismiss
extension ListViews {
    @discardableResult
    public func keyboardDismiss(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        tableView.keyboardDismissMode = mode
        return self
    }
    
    @discardableResult
    public func dismissKeyboardOnDrag() -> Self {
        tableView.keyboardDismissMode = .onDrag
        return self
    }
}

// MARK: - Appear
extension ListViews {
    @discardableResult
    public func onAppear(_ action: @escaping (Int) -> Void) -> Self {
        onRowAppear = action
        return self
    }
    
    @discardableResult
    public func onAppear(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onItemAppear = action
        return self
    }
    
    @discardableResult
    public func onAppear(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onItemIndexAppear = action
        return self
    }
}

// MARK: - Disappear
extension ListViews {
    @discardableResult
    public func onDisappear(_ action: @escaping (Int) -> Void) -> Self {
        onRowDisappear = action
        return self
    }
    
    @discardableResult
    public func onDisappear(_ action: @escaping (AnyHashable) -> Void) -> Self {
        onItemDisappear = action
        return self
    }
    
    @discardableResult
    public func onDisappear(_ action: @escaping (AnyHashable, Int) -> Void) -> Self {
        onItemIndexDisappear = action
        return self
    }
}

// MARK: - Safe Area
public enum OIEdges {
    case all, top, bottom, horizontal, vertical
}

extension ListViews {
    @discardableResult
    public func ignoresSafeArea(_ edges: OIEdges = .all) -> Self {
        ignoresSafeAreaEdges = edges
        tableView.contentInsetAdjustmentBehavior = .never
        return self
    }
}

// MARK: Indicator
extension ListViews {
    @discardableResult
    public func showsVerticalIndicator(_ show: Bool) -> Self {
        tableView.showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    public func showsHorizontalIndicator(_ show: Bool) -> Self {
        tableView.showsHorizontalScrollIndicator = show
        return self
    }
}

// MARK: - Header Footer
extension ListViews {
    @discardableResult
    public func headerSpacing(_ height: CGFloat) -> Self {
        let spacer = UIView()
        spacer.frame.size.height = height
        tableView.tableHeaderView = spacer
        return self
    }
    
    @discardableResult
    public func footerSpacing(_ height: CGFloat) -> Self {
        let spacer = UIView()
        spacer.frame.size.height = height
        tableView.tableFooterView = spacer
        return self
    }
}

// MARK: - Paging state
extension ListViews {
    @discardableResult
    public func currentPage(_ page: Int) -> Self {
        // pastikan page minimal 1
        currentPageValue = max(1, page)
        return self
    }
    
    @discardableResult
    public func perPage(_ perPage: Int) -> Self {
        // minimal 1 item per page
        perPageValue = max(1, perPage)
        return self
    }
    
    @discardableResult
    public func totalPages(_ pages: Int) -> Self {
        totalPagesValue = max(1, pages)
        isTotalPagesSet = true
        return self
    }
    
    @discardableResult
    public func resetPaging(toPage page: Int = 1) -> Self {
        currentPageValue = max(1, page)
        return self
    }
    
    @discardableResult
    public func totalData(_ action: @escaping (Int) -> Void) -> Self {
        self.onTotalDataChanged = action
        // initial fire
        action(storedItems.count)
        return self
    }
}

// MARK: - Reach bottom API
extension ListViews {
    /// Set closure to call when user scrolls near bottom
    @discardableResult
    public func onReachBottom(reachThreshold: CGFloat = 300,
                              _ action: @escaping () -> Void) -> Self {
        self.reachThreshold = max(0, reachThreshold)
        self.onReachBottomAction = action
        return self
    }
    
    /// Call this when your load-more operation is finished (e.g. after network completes and items updated).
    public func endReachLoading() {
        DispatchQueue.main.async {
            self.isLoadingMore = false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard hasUserScrolled else { return }
        guard let action = onReachBottomAction else { return }
        
        // block saat pull-to-refresh
        let offsetY = scrollView.contentOffset.y
        let topInset = scrollView.adjustedContentInset.top
        if tableView.isDragging && offsetY < -topInset { return }
        if tableView.refreshControl?.isRefreshing == true { return }
        
        // block saat sudah loading atau tidak ada page
        if isLoadingMore { return }
        if !hasMorePages { return }
        
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.bounds.height
        
        // <<< SOLUSI PENTING >>>
        // kalau item masih sedikit dan belum bisa scroll → auto loadMore sekali
        if contentHeight <= frameHeight {
            isLoadingMore = true
            showLoadMoreSpinner()
            DispatchQueue.main.async { action() }
            return
        }
        
        if offsetY + frameHeight + reachThreshold >= contentHeight {
            isLoadingMore = true
            showLoadMoreSpinner()
            DispatchQueue.main.async { action() }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hasUserScrolled = true
    }
    
    // MARK: - Paging helpers (auto update)
    private func updatePagingStateAfterItemsChange() {
        DispatchQueue.main.async {
            // stop loading more when items changed
            self.isLoadingMore = false
            
            // recompute current page from storedItems.count and perPageValue
            let count = self.storedItems.count
            guard self.perPageValue > 0 else {
                self.currentPageValue = 1
                return
            }
            // page = ceil(count / perPage)
            let page = max(1, Int(ceil(Double(count) / Double(self.perPageValue))))
            self.currentPageValue = page
        }
    }
}

// MARK: - Load More Spinner
extension ListViews {
    private func showLoadMoreSpinner() {
        if loadMoreSpinner == nil {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
            spinner.hidesWhenStopped = true
            
            loadMoreSpinner = spinner
        }
        
        tableView.tableFooterView = loadMoreSpinner
    }
    
    private func hideLoadMoreSpinner() {
        tableView.tableFooterView = nil
    }
}

// MARK: OnDelete
public enum OISwipeSide {
    case left
    case right
}

extension ListViews {
    @discardableResult
    public func onDelete(
        _ side: OISwipeSide = .right,
        title: String = "Delete",
        systemImage: String? = nil,
        fullSwipe: Bool = true,
        _ action: @escaping (IndexSet) -> Void
    ) -> Self {

        self.deleteSide = side
        self.deleteTitle = title
        self.deleteSystemImage = systemImage
        self.deleteFullSwipe = fullSwipe
        self.deleteAction = action
        
        return self
    }
    
    private func makeDeleteAction(forRow row: Int) -> UIContextualAction? {
        guard let deleteAction = deleteAction else { return nil }
        
        let action = UIContextualAction(style: .destructive, title: deleteTitle) { [weak self] _, _, done in
            guard let self = self else { return }
            self.handleDelete(at: row, deleteAction: deleteAction)
            done(true)
        }
        
        // Tambah icon kalau ada
        if let imageName = deleteSystemImage {
            action.image = UIImage(systemName: imageName)
        }
        
        return action
    }
    
    private func handleDelete(at row: Int, deleteAction: @escaping (IndexSet) -> Void) {
        // Pastikan index masih valid
        guard rawItems.indices.contains(row) else { return }
        deleteAction(IndexSet(integer: row))
    }
}

extension ListViews {
    @discardableResult
    public func searchable<Item>(
        _ query: SBinding<String>,
        source: SBinding<[Item]>,
        resetOnEmpty: Bool = true,
        matches: @escaping (Item, String) -> Bool
    ) -> Self {

        // simpan data full
        var originalItems = source.wrappedValue
        var isInternalUpdate = false

        // simpan didSet lama supaya binding ListViews gak ketimpa
        let oldSourceDidSet = source.didSet
        let oldQueryDidSet = query.didSet

        func applyFilter() {
            let text = query.wrappedValue
                .trimmingCharacters(in: .whitespacesAndNewlines)

            isInternalUpdate = true
            defer { isInternalUpdate = false }

            // kalau query kosong
            if text.isEmpty {
                if resetOnEmpty {
                    // balikin ke data full
                    source.wrappedValue = originalItems
                }
                // kalau resetOnEmpty = false → gak ngapa2in
                return
            }
            
            // kalau ada query → filter dari originalItems
            source.wrappedValue = originalItems.filter { item in
                matches(item, text)
            }
        }

        // kalau data asli (source) berubah dari luar (API, paging, dsb)
        source.didSet = { newValue in
            // tetap panggil didSet lama (ListViews masih auto-refresh)
            oldSourceDidSet?(newValue)

            // kalau perubahan bukan dari filter internal
            if !isInternalUpdate {
                originalItems = newValue
                applyFilter()
            }
        }

        // kalau query berubah ($searchText berubah)
        query.didSet = { newValue in
            // kalau ada listener lain di query, tetap dipanggil
            oldQueryDidSet?(newValue)
            applyFilter()
        }

        // initial
        applyFilter()

        return self
    }
}

extension ListViews {
    @discardableResult
    public func emptyState(@UIViewBuilder _ builder: () -> UIView) -> Self {
        // buang yang lama kalau ada
        emptyStateView?.removeFromSuperview()

        let view = builder()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        bringSubviewToFront(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])

        emptyStateView = view
        updateEmptyStateVisibility()

        return self
    }

    private func updateEmptyStateVisibility() {
        // kosong → tampil, ada data → sembunyikan
        emptyStateView?.isHidden = !rawItems.isEmpty
    }
}

extension ListViews {
    private func setItems(
        raw: [AnyHashable],
        stored: [Any],
        builder: @escaping (AnyHashable) -> UIView,
        animated: Bool = true
    ) {
        self.rawItems = raw
        self.storedItems = stored
        self.builder = builder
        applySnapshot(animated: animated)
    }
    
    @discardableResult
    private func configureDuplicateSafe<Item: Hashable>(
        _ items: [Item],
        builder build: @escaping (Item) -> UIView
    ) -> Self {

        if Set(items).count != items.count {
            let ids = items.indices.map { AnyHashable("IDX-\($0)") }

            setItems(
                raw: ids,
                stored: items,
                builder: makeBuilder(raw: ids, stored: items, build)
            )
        } else {
            setItems(
                raw: items.map { $0 as AnyHashable },
                stored: items,
                builder: { any in
                    guard let item = any as? Item else { return UIView() }
                    return build(item)
                }
            )
        }

        return self
    }
}
