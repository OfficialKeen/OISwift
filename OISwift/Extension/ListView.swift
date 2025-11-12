//
//  ListView.swift
//  OISwift
//
//  Created by keenoi on 04/11/24.
//

import UIKit

// Enum untuk mendefinisikan berbagai style yang didukung
/*public enum ListViewStyle {
    case plain
    case grouped
    case insetGrouped
}

// ListView class yang mendukung listStyle
@MainActor
open class ListView<Data, Content: UIView, Header: UIView, Footer: UIView>: UIView where Data: Collection {
    private var data: Data
    private var content: (Data.Element) -> Content
    private var header: (() -> Header?)?
    private var footer: (() -> Footer?)?
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

    // Closure untuk menambahkan object UI tambahan
    private var additionalUI: (() -> UIView)?

    public init(_ data: Data,
                axis: NSLayoutConstraint.Axis = .vertical,
                header: (() -> Header?)? = nil,
                footer: (() -> Footer?)? = nil,
                additionalUI: (() -> UIView)? = nil, // Parameter baru untuk object UI tambahan
                content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.header = header
        self.footer = footer
        self.additionalUI = additionalUI
        self.content = content
        super.init(frame: .zero)
        stackView.axis = axis
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Add header if exists
        if let headerView = header?() {
            stackView.addArrangedSubview(headerView)
        }
        
        // Add content
        for item in data {
            let view = content(item)
            stackView.addArrangedSubview(view)
        }

        // Add additional UI if exists
        if let additionalUIView = additionalUI?() {
            stackView.addArrangedSubview(additionalUIView)
        }

        // Add footer if exists
        if let footerView = footer?() {
            stackView.addArrangedSubview(footerView)
        }

        if stackView.axis == .horizontal {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }

        self.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    // Fungsi untuk menerapkan style pada ListView
    public func listStyle(_ style: ListViewStyle) -> Self {
        switch style {
        case .plain:
            stackView.spacing = 8
            stackView.backgroundColor = .clear
            scrollView.backgroundColor = .clear
        case .grouped:
            stackView.spacing = 16
            scrollView.backgroundColor = .systemGroupedBackground
        case .insetGrouped:
            stackView.spacing = 16
            scrollView.backgroundColor = .systemGroupedBackground
            scrollView.layer.cornerRadius = 10
            scrollView.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
            self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        return self
    }
}*/

/*@MainActor
open class ListView<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var content: (Data.Element) -> Content
    private let stackView = UIStackView()

    public init(_ data: Data, axis: NSLayoutConstraint.Axis = .vertical, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        super.init(frame: .zero)
        stackView.axis = axis
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let scrollView = UIScrollView()
        
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        for item in data {
            let view = content(item)
            stackView.addArrangedSubview(view)
        }
        
        if stackView.axis == .horizontal {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Ensure stackView height matches scrollView height
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensure stackView width matches scrollView width
            ])
        }
        
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}*/

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

/*import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let stackView = UIStackView()
    private var scrollView: UIScrollView?

    public init(_ data: Data, axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 8, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.contentBuilder = content
        super.init(frame: .zero)
        
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(stackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(stackView)
        }
        
        setupViews(axis: axis)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(axis: NSLayoutConstraint.Axis) {
        for item in data {
            let view = contentBuilder(item)
            stackView.addArrangedSubview(view)
        }

        if axis == .horizontal, let scrollView = scrollView {
            // Constraints untuk scrollView ketika horizontal
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                
                stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
        } else {
            // Constraints untuk stackView ketika vertical (tanpa scrollView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
}*/

/*public class List: UIScrollView {
    // Inisialisasi dengan closure sebagai parameter
    public init(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, content: (UIView) -> UIView) {
        super.init(frame: .zero)
        
        let contentView = content(UIView())
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.alwaysBounceVertical = true
        
        if showIndicatorScroll {
            self.showsVerticalScrollIndicator = true
            self.showsHorizontalScrollIndicator = true
        } else {
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
        }
        
        self.isPagingEnabled = isPaging
        
        if let multiplier = multiplier {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        }
        
        // Panggil observer untuk menangani notifikasi keyboard
        self.adjustForKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}*/

/*import UIKit

public class List: UIScrollView {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// : Refreshable
/*import UIKit

public class List: UIScrollView {
    // MARK: - Properties
    private let contentView: UIView
    private var refreshAction: (() -> Void)?
    private var refreshControlElement: UIRefreshControl?
    
    // MARK: - Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        self.contentView = content(UIView())
        super.init(frame: .zero)
        
        // Setup content view
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView properties
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        // Validate multiplier
        let validMultiplier = max(multiplier ?? 1.0, 0.1)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: validMultiplier)
        ])
        
        // Adjust for keyboard
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult
    public func refreshable(action: @escaping () -> Void) -> Self {
        self.refreshAction = action
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.addSubview(refreshControl) // Add refresh control to UIScrollView
        
        return self
    }
    
    @objc private func handleRefresh() {
        refreshAction?()
        refreshControl?.endRefreshing() // End refresh animation
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            print("Failed to get keyboard frame")
            return
        }
        let keyboardHeight = keyboardFrame.height
        
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = keyboardHeight
            self?.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = 0
            self?.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}*/
// : Refreshable End

// : Refreshable LoadMore
/*import UIKit

public class List: UIScrollView {
    // MARK: - Properties
    private let contentView: UIView
    private var refreshAction: (() -> Void)?
    private var loadMoreAction: (() -> Void)?
    private var isLoadingMore: Bool = false // Prevent multiple triggers
    private var lastContentOffset: CGFloat = 0 // Track scroll direction
    
    private var refreshControlElement: UIRefreshControl?
    
    // MARK: - Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        self.contentView = content(UIView())
        super.init(frame: .zero)
        
        // Setup content view
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView properties
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        // Validate multiplier
        let validMultiplier = max(multiplier ?? 1.0, 0.1)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: validMultiplier)
        ])
        
        // Adjust for keyboard
        setupKeyboardObservers()
        
        // Monitor scrolling
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult
    public func refreshable(action: @escaping () -> Void) -> Self {
        self.refreshAction = action
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.addSubview(refreshControl) // Add refresh control to UIScrollView
        
        return self
    }
    
    @objc private func handleRefresh() {
        refreshAction?()
        refreshControl?.endRefreshing() // End refresh animation
    }
    
    // MARK: - Load More Feature
    @discardableResult
    public func loadMore(action: @escaping () -> Void) -> Self {
        self.loadMoreAction = action
        return self
    }
    
    private func triggerLoadMore() {
        guard !isLoadingMore else { return } // Prevent multiple triggers
        isLoadingMore = true
        
        loadMoreAction?()
        
        // Simulate asynchronous data load completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoadingMore = false
        }
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            print("Failed to get keyboard frame")
            return
        }
        let keyboardHeight = keyboardFrame.height
        
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = keyboardHeight
            self?.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = 0
            self?.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIScrollViewDelegate
extension List: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Track initial content offset
        lastContentOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Detect scroll direction
        let isScrollingDown = offsetY > lastContentOffset
        
        // Update last content offset
        lastContentOffset = offsetY
        
        // Trigger load more only if scrolling down and not at the top
        if isScrollingDown && offsetY > contentHeight - scrollViewHeight - 100 {
            triggerLoadMore()
        }
    }
}*/
// : Refreshable LoadMore End

/*import UIKit

public class List: UIScrollView {
    // MARK: - Properties
    private let contentView: UIView
    private var refreshAction: (() -> Void)?
    private var loadMoreAction: (() -> Void)?
    private var isLoadingMore: Bool = false // Prevent multiple triggers
    private var lastContentOffset: CGFloat = 0 // Track scroll direction
    
    private var refreshControlElement: UIRefreshControl?
    private let loadMoreControl = UIActivityIndicatorView(style: .medium) // Load More Indicator
    
    // MARK: - Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        self.contentView = content(UIView())
        super.init(frame: .zero)
        
        // Setup content view
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView properties
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        // Validate multiplier
        let validMultiplier = max(multiplier ?? 1.0, 0.1)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: validMultiplier)
        ])
        
        // Add Load More Indicator
        addLoadMoreControl()
        
        // Adjust for keyboard
        setupKeyboardObservers()
        
        // Monitor scrolling
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult
    public func refreshable(action: @escaping () -> Void) -> Self {
        self.refreshAction = action
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.addSubview(refreshControl) // Add refresh control to UIScrollView
        
        return self
    }
    
    @objc private func handleRefresh() {
        refreshAction?()
        refreshControl?.endRefreshing() // End refresh animation
    }
    
    // MARK: - Load More Feature
    @discardableResult
    public func loadMore(action: @escaping () -> Void) -> Self {
        self.loadMoreAction = action
        return self
    }
    
    private func addLoadMoreControl() {
        loadMoreControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadMoreControl)
        
        NSLayoutConstraint.activate([
            loadMoreControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadMoreControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16) // Jarak lebih jauh dari item terakhir
        ])
    }
    
    private func triggerLoadMore() {
        guard !isLoadingMore else { return } // Prevent multiple triggers
        isLoadingMore = true
        
        // Start animating load more indicator
        loadMoreControl.startAnimating()
        
        loadMoreAction?()
        
        // Simulate asynchronous data load completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadMoreControl.stopAnimating()
            self.isLoadingMore = false
        }
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            print("Failed to get keyboard frame")
            return
        }
        let keyboardHeight = keyboardFrame.height
        
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = keyboardHeight
            self?.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.contentInset.bottom = 0
            self?.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIScrollViewDelegate
extension List: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Track initial content offset
        lastContentOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Detect scroll direction
        let isScrollingDown = offsetY > lastContentOffset
        
        // Update last content offset
        lastContentOffset = offsetY
        
        // Trigger load more only if scrolling down and not at the top
        if isScrollingDown && offsetY > contentHeight - scrollViewHeight - 100 {
            triggerLoadMore()
        }
    }
}*/

/*public class List: UIScrollView {
    // MARK: - Properties
    private let contentView: UIView
    private var refreshAction: ((@escaping () -> Void) -> Void)?
    private var loadMoreAction: ((@escaping () -> Void) -> Void)?
    private var isRefreshing: Bool = false
    private var isLoadingMore: Bool = false
    
    private let refreshContainer = UIView()
    private let refreshIndicator = UIActivityIndicatorView(style: .medium)
    
    private let loadMoreContainer = UIView()
    private let loadMoreIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        self.contentView = content(UIView())
        super.init(frame: .zero)
        
        // Setup content view
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        let validMultiplier = max(multiplier ?? 1.0, 0.1)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: validMultiplier)
        ])
        
        addRefreshContainer()
        addLoadMoreContainer()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult
    public func refreshable(action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.refreshAction = action
        return self
    }
    
    private func addRefreshContainer() {
        refreshContainer.translatesAutoresizingMaskIntoConstraints = false
        refreshContainer.isHidden = true
        addSubview(refreshContainer)
        
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
        refreshContainer.addSubview(refreshIndicator)
        
        NSLayoutConstraint.activate([
            refreshContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            refreshContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            refreshContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            refreshContainer.heightAnchor.constraint(equalToConstant: 50),
            
            refreshIndicator.centerXAnchor.constraint(equalTo: refreshContainer.centerXAnchor),
            refreshIndicator.centerYAnchor.constraint(equalTo: refreshContainer.centerYAnchor)
        ])
    }
    
    private func triggerRefresh() {
        guard !isRefreshing else { return }
        guard let refreshAction = refreshAction else {
            // Do nothing if no refresh action is set
            return
        }
        
        isRefreshing = true
        refreshContainer.isHidden = false
        refreshIndicator.startAnimating()
        
        // Call the refresh action and pass a completion handler
        refreshAction { [weak self] in
            self?.isRefreshing = false
            self?.refreshIndicator.stopAnimating()
            self?.refreshContainer.isHidden = true
        }
    }
    
    // MARK: - Load More Feature
    @discardableResult
    public func loadMore(action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.loadMoreAction = action
        return self
    }
    
    private func addLoadMoreContainer() {
        loadMoreContainer.translatesAutoresizingMaskIntoConstraints = false
        loadMoreContainer.isHidden = true
        addSubview(loadMoreContainer)
        
        loadMoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadMoreContainer.addSubview(loadMoreIndicator)
        
        NSLayoutConstraint.activate([
            loadMoreContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadMoreContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadMoreContainer.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            loadMoreContainer.heightAnchor.constraint(equalToConstant: 50),
            
            loadMoreIndicator.centerXAnchor.constraint(equalTo: loadMoreContainer.centerXAnchor),
            loadMoreIndicator.centerYAnchor.constraint(equalTo: loadMoreContainer.centerYAnchor)
        ])
    }
    
    private func triggerLoadMore() {
        guard !isLoadingMore else { return }
        guard let loadMoreAction = loadMoreAction else {
            // Do nothing if no loadMore action is set
            return
        }
        
        isLoadingMore = true
        loadMoreContainer.isHidden = false
        loadMoreIndicator.startAnimating()
        
        // Call the load more action and pass a completion handler
        loadMoreAction { [weak self] in
            self?.isLoadingMore = false
            self?.loadMoreIndicator.stopAnimating()
            self?.loadMoreContainer.isHidden = true
        }
    }
}

// MARK: - UIScrollViewDelegate
extension List: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY < -100 {
            triggerRefresh()
        }
        
        if offsetY > contentHeight - scrollViewHeight - 100 {
            triggerLoadMore()
        }
    }
}*/

/*public class List: UIScrollView {
    // MARK: - Properties
    private let contentView: UIView
    private var refreshAction: ((@escaping () -> Void) -> Void)?
    private var loadMoreAction: ((@escaping () -> Void) -> Void)?
    private var isRefreshing: Bool = false
    private var isLoadingMore: Bool = false
    
    private let refreshContainer = UIView()
    private let refreshIndicator = UIActivityIndicatorView(style: .medium)
    
    private let loadMoreContainer = UIView()
    private let loadMoreIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        content: (UIView) -> UIView
    ) {
        self.contentView = content(UIView())
        super.init(frame: .zero)
        
        // Setup content view
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        let validMultiplier = max(multiplier ?? 1.0, 0.1)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: validMultiplier)
        ])
        
        addRefreshContainer()
        addLoadMoreContainer()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult
    public func refreshable(action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.refreshAction = action
        return self
    }
    
    private func addRefreshContainer() {
        refreshContainer.translatesAutoresizingMaskIntoConstraints = false
        refreshContainer.isHidden = true
        addSubview(refreshContainer)
        
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
        refreshContainer.addSubview(refreshIndicator)
        
        NSLayoutConstraint.activate([
            refreshContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            refreshContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            refreshContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            refreshContainer.heightAnchor.constraint(equalToConstant: 50),
            
            refreshIndicator.centerXAnchor.constraint(equalTo: refreshContainer.centerXAnchor),
            refreshIndicator.centerYAnchor.constraint(equalTo: refreshContainer.centerYAnchor)
        ])
    }
    
    private func triggerRefresh() {
        guard !isRefreshing else { return }
        isRefreshing = true
        refreshContainer.isHidden = false
        refreshIndicator.startAnimating()
        
        // Call the refresh action and pass a completion handler
        refreshAction? { [weak self] in
            self?.isRefreshing = false
            self?.refreshIndicator.stopAnimating()
            self?.refreshContainer.isHidden = true
        }
    }
    
    // MARK: - Load More Feature
    @discardableResult
    public func loadMore(action: @escaping (@escaping () -> Void) -> Void) -> Self {
        self.loadMoreAction = action
        return self
    }
    
    private func addLoadMoreContainer() {
        loadMoreContainer.translatesAutoresizingMaskIntoConstraints = false
        loadMoreContainer.isHidden = true
        addSubview(loadMoreContainer)
        
        loadMoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadMoreContainer.addSubview(loadMoreIndicator)
        
        NSLayoutConstraint.activate([
            loadMoreContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadMoreContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadMoreContainer.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            loadMoreContainer.heightAnchor.constraint(equalToConstant: 50),
            
            loadMoreIndicator.centerXAnchor.constraint(equalTo: loadMoreContainer.centerXAnchor),
            loadMoreIndicator.centerYAnchor.constraint(equalTo: loadMoreContainer.centerYAnchor)
        ])
    }
    
    private func triggerLoadMore() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        loadMoreContainer.isHidden = false
        loadMoreIndicator.startAnimating()
        
        // Call the load more action and pass a completion handler
        loadMoreAction? { [weak self] in
            self?.isLoadingMore = false
            self?.loadMoreIndicator.stopAnimating()
            self?.loadMoreContainer.isHidden = true
        }
    }
}

// MARK: - UIScrollViewDelegate
extension List: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY < -100 {
            triggerRefresh()
        }
        
        if offsetY > contentHeight - scrollViewHeight - 100 {
            triggerLoadMore()
        }
    }
}*/

/// NEW 27 Nove

/*import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Ubah ukuran indikator refresh
        adjustRefreshControlIndicatorSize()

        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func adjustRefreshControlIndicatorSize() {
        // Menyesuaikan ukuran indikator yang terdapat di dalam UIRefreshControl
        guard let activityIndicator = customRefreshControl?.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else {
            return
        }
        
        // Menentukan ukuran baru untuk indikator
        let newSize: CGFloat = 20.0 // Ukuran baru yang lebih kecil (misalnya 20x20)
        
        // Mengubah frame indikator agar lebih kecil
        activityIndicator.transform = CGAffineTransform(scaleX: newSize / activityIndicator.frame.size.width, y: newSize / activityIndicator.frame.size.height)
        
        // Hapus animasi built-in jika perlu, biarkan kita kontrol animasi menggunakan `beginRefreshing()`
        customRefreshControl?.tintColor = .clear
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh
        refreshAction?()
        
        // Simulasikan reload data (hapus setelah selesai)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.customRefreshControl?.endRefreshing()
        }
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

/*import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Tambahkan custom indicator kecil dan hapus default indicator
        setupCustomIndicator()
        
        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func setupCustomIndicator() {
        // Hapus indikator default
        customRefreshControl?.subviews.forEach { $0.removeFromSuperview() }
        
        // Tambahkan indikator custom dengan ukuran lebih kecil
        let customIndicator = UIActivityIndicatorView(style: .medium)
        customIndicator.color = .gray // Bisa disesuaikan warnanya
        customIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        customRefreshControl?.addSubview(customIndicator)
        
        // Set posisi custom indicator di tengah-tengah
        NSLayoutConstraint.activate([
            customIndicator.centerXAnchor.constraint(equalTo: customRefreshControl!.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: customRefreshControl!.centerYAnchor)
        ])
        
        // Mulai animasi indikator custom
        customIndicator.startAnimating()
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh
        refreshAction?()
        
        // Simulasikan reload data (hapus setelah selesai)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.customRefreshControl?.endRefreshing()
        }
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

/*import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Ubah ukuran indikator refresh
        adjustRefreshControlIndicatorSize()

        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func adjustRefreshControlIndicatorSize() {
        // Menyesuaikan ukuran indikator yang terdapat di dalam UIRefreshControl
        guard let activityIndicator = customRefreshControl?.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else {
            return
        }
        
        // Menentukan ukuran baru untuk indikator
        let newSize: CGFloat = 20.0 // Ukuran baru yang lebih kecil (misalnya 20x20)
        
        // Mengubah frame indikator agar lebih kecil
        activityIndicator.transform = CGAffineTransform(scaleX: newSize / activityIndicator.frame.size.width, y: newSize / activityIndicator.frame.size.height)
        
        // Hapus animasi built-in jika perlu, biarkan kita kontrol animasi menggunakan `beginRefreshing()`
        customRefreshControl?.tintColor = .clear
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh
        refreshAction?()
        
        // Mulai simulasi pengambilan data dari API
        loadDataFromAPI { [weak self] success in
            DispatchQueue.main.async {
                // Setelah data selesai dimuat, hentikan animasi refresh
                self?.customRefreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Simulasi Pengambilan Data dari API
    private func loadDataFromAPI(completion: @escaping (Bool) -> Void) {
        // Simulasikan pengambilan data dari API atau cloud
        // Contoh delay untuk simulasi waktu pengambilan data
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { // Simulasi waktu pengambilan data selama 3 detik
            // Misalnya, data berhasil dimuat
            completion(true)
        }
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
    private var dataChanged = false

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Ubah ukuran indikator refresh
        adjustRefreshControlIndicatorSize()

        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func adjustRefreshControlIndicatorSize() {
        // Menyesuaikan ukuran indikator yang terdapat di dalam UIRefreshControl
        guard let activityIndicator = customRefreshControl?.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else {
            return
        }
        
        // Menentukan ukuran baru untuk indikator
        let newSize: CGFloat = 20.0 // Ukuran baru yang lebih kecil (misalnya 20x20)
        
        // Mengubah frame indikator agar lebih kecil
        activityIndicator.transform = CGAffineTransform(scaleX: newSize / activityIndicator.frame.size.width, y: newSize / activityIndicator.frame.size.height)
        
        // Hapus animasi built-in jika perlu, biarkan kita kontrol animasi menggunakan `beginRefreshing()`
        customRefreshControl?.tintColor = .clear
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh (load data)
        refreshAction?()
        
        // Simulasikan reload data (hapus setelah selesai)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Delay 2 detik untuk simulasi
            // Setelah data dimuat, refresh tampilan
            self.customRefreshControl?.endRefreshing()
            self.dataChanged = true
            self.setNeedsLayout()  // Meminta layout untuk diperbarui
        }
    }
    
    // MARK: - Layout Update
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if dataChanged {
            // Jika ada perubahan data, paksa layout untuk diupdate
            self.layoutIfNeeded()
            dataChanged = false
        }
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

/*import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Tambahkan custom indicator kecil dan hapus default indicator
        setupCustomIndicator()
        
        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func setupCustomIndicator() {
        // Hapus indikator default
        customRefreshControl?.subviews.forEach { $0.removeFromSuperview() }
        
        // Tambahkan indikator custom dengan ukuran lebih kecil
        let customIndicator = UIActivityIndicatorView(style: .medium)
        customIndicator.color = .gray // Bisa disesuaikan warnanya
        customIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        customRefreshControl?.addSubview(customIndicator)
        
        // Set posisi custom indicator di tengah-tengah
        NSLayoutConstraint.activate([
            customIndicator.centerXAnchor.constraint(equalTo: customRefreshControl!.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: customRefreshControl!.centerYAnchor)
        ])
        
        // Mulai animasi indikator custom
        customIndicator.startAnimating()
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh
        refreshAction?()
        
        // Simulasikan reload data (hapus setelah selesai)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Setelah data dimuat, refresh tampilan
            self.customRefreshControl?.endRefreshing()
            
            // Memberitahu tampilan bahwa layout perlu diperbarui
            self.setNeedsLayout()  // Meminta layout untuk diperbarui
            self.layoutIfNeeded()  // Memaksa layout untuk segera diperbarui
            self.customRefreshControl?.endRefreshing()
        }
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


import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refreshable Feature
    @discardableResult // Membuat method ini dapat digunakan untuk chaining
    public func refreshable(action: @escaping () -> Void) -> Self {
        // Hanya buat refresh control jika belum ada
        if customRefreshControl == nil {
            customRefreshControl = UIRefreshControl()
            customRefreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            self.addSubview(customRefreshControl!)
        }
        
        // Tambahkan custom indicator kecil dan hapus default indicator
        setupCustomIndicator()
        
        // Simpan aksi refresh
        self.refreshAction = action
        
        return self // Mengembalikan self untuk mendukung chaining
    }
    
    private func setupCustomIndicator() {
        // Hapus indikator default
        customRefreshControl?.subviews.forEach { $0.removeFromSuperview() }
        
        // Tambahkan indikator custom dengan ukuran lebih kecil
        let customIndicator = UIActivityIndicatorView(style: .medium)
        customIndicator.color = .gray // Bisa disesuaikan warnanya
        customIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        customRefreshControl?.addSubview(customIndicator)
        
        // Set posisi custom indicator di tengah-tengah
        NSLayoutConstraint.activate([
            customIndicator.centerXAnchor.constraint(equalTo: customRefreshControl!.centerXAnchor),
            customIndicator.centerYAnchor.constraint(equalTo: customRefreshControl!.centerYAnchor)
        ])
        
        // Mulai animasi indikator custom
        customIndicator.startAnimating()
    }
    
    @objc private func handleRefresh() {
        // Mulai animasi refresh
        customRefreshControl?.beginRefreshing()
        
        // Jalankan aksi refresh
        refreshAction?()
        
        // Simulasikan reload data (hapus setelah selesai)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Setelah data dimuat, refresh tampilan
            self.customRefreshControl?.endRefreshing()
            
            // Memberitahu tampilan bahwa layout perlu diperbarui
            self.setNeedsLayout()  // Meminta layout untuk diperbarui
            self.layoutIfNeeded()  // Memaksa layout untuk segera diperbarui
            self.customRefreshControl?.endRefreshing()
        }
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
