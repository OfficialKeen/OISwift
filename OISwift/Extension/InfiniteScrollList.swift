//
//  InfiniteScrollList.swift
//  OISwift
//
//  Created by keenoi on 12/11/25.
//

import UIKit

// Extension to add infinite scroll (load more) functionality to List
extension List {
    private struct AssociatedKeys {
        static var loadMoreAction: UInt8 = 0
        static var isLoadingMore: UInt8 = 1
        static var loadMoreIndicator: UInt8 = 2
        static var loadMoreThreshold: UInt8 = 3
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
            self?.isLoadingMore = false
            self?.loadMoreIndicator?.stopAnimating()
            self?.loadMoreIndicator?.isHidden = true
        }
    }

    // MARK: - Private Methods

    private func setupLoadMoreIndicator() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false

        addSubview(indicator)

        // Position at bottom center
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])

        self.loadMoreIndicator = indicator
    }

    private func triggerLoadMore() {
        guard !isLoadingMore, let action = loadMoreAction else { return }

        isLoadingMore = true
        loadMoreIndicator?.isHidden = false
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
    }
}
