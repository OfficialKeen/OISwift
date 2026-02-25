//
//  InfiniteScrollViewController.swift
//  OISwift
//
//  Created by keenoi on 12/11/25.
//

import UIKit

struct Item {
    let id: Int
    let title: String
    let subtitle: String
}

class InfiniteScrollViewController: UIViewController {

    // Use regular array, we'll rebuild view manually
    private var items: [Item] = []
    private var currentPage = 0
    private let itemsPerPage = 10

    // Keep reference to main container for rebuilding
    private var mainContainer: UIView?

    // Keep reference to the List (scroll view) to restore position
    internal var listView = List()

    // Store scroll position before rebuild
    private var savedScrollOffset: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load initial data
        loadInitialData()

        // Setup view
        buildView()
    }

    // MARK: - Data Loading

    /// Load initial batch of items
    private func loadInitialData() {
        items = generateItems(page: currentPage)
        currentPage += 1
    }

    /// Refresh data from the beginning
    /// - Parameter completion: Called when refresh is complete
    private func refreshData(completion: @escaping () -> Void) {
        debugPrint("DEBUG: Starting refresh")

        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else {
                completion()
                return
            }

            // Reset to first page
            self.currentPage = 0
            let newItems = self.generateItems(page: self.currentPage)

            // Update on main thread
            DispatchQueue.main.async {
                self.items = newItems
                self.currentPage = 1
                debugPrint("DEBUG: Refreshed data, Total items: \(self.items.count)")

                // Rebuild the view to show refreshed items
                self.buildView()

                // Scroll to top
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.listView.setContentOffset(.zero, animated: true)
                }

                completion()
            }
        }
    }

    /// Simulate loading more items from API
    /// - Parameter completion: Called when loading is complete
    private func loadMoreItems(completion: @escaping () -> Void) {
        // Save current scroll position before loading
        savedScrollOffset = listView.contentOffset
        debugPrint("DEBUG: Saved scroll position: \(savedScrollOffset.y)")

        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else {
                completion()
                return
            }

            // Generate new items
            let newItems = self.generateItems(page: self.currentPage)

            // Update on main thread
            DispatchQueue.main.async {
                self.items.append(contentsOf: newItems)
                self.currentPage += 1
                debugPrint("DEBUG: Loaded page \(self.currentPage), Total items: \(self.items.count)")

                // Rebuild the view to show new items
                self.buildView()

                // Restore scroll position after a brief delay to allow layout
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.listView.setContentOffset(self.savedScrollOffset, animated: false)
                    debugPrint("DEBUG: Restored scroll position: \(self.savedScrollOffset.y)")
                }

                completion()
            }
        }
    }

    /// Generate sample items for a given page
    /// - Parameter page: Page number
    /// - Returns: Array of items
    private func generateItems(page: Int) -> [Item] {
        let startIndex = page * itemsPerPage
        return (0..<itemsPerPage).map { index in
            let id = startIndex + index
            return Item(
                id: id,
                title: "Item #\(id + 1)",
                subtitle: "This is item number \(id + 1) on page \(page + 1)"
            )
        }
    }

    // MARK: - View Building

    /// Rebuild the entire view with current data
    private func buildView() {
        // Remove existing view
        mainContainer?.removeFromSuperview()

        // Build new view with current data
        let container = contentView()
        mainContainer = container
    }
}

// MARK: - View Setup

extension InfiniteScrollViewController {
    fileprivate func contentView() -> UIView {
        return view.VStack(spacing: 10) {
            // Header info
            View().VStack(spacing: 0) {
                Text()
                    .text("Scroll to bottom to load more")
                    .font(14, weight: .medium)
                    .foregroundColor(0x666666)
                    .alignment(.center)
            }
            .padding(8)
            .background(0xF0F0F0)
            .cornerRadius(8)
            
            View().VStack(spacing: 0) {
                TextField()
                    .text("Scroll to ")
                    .font(14, weight: .medium)
                    .foregroundColor(0x666666)
            }
            .padding(8)
            .background(0xF0F0F0)
            .cornerRadius(8)

            // Item count indicator
            View().VStack(spacing: 0) {
                Text()
                    .text("Loaded: \(items.count) items")
                    .font(12, weight: .medium)
                    .foregroundColor(0x999999)
                    .alignment(.center)
            }
            .padding(4)
            
            listView.content { container in
                container.VStack(spacing: 8) {
                    // Iterate through items
                    ForEach(self.items) { item in
                        self.createItemView(item: item)
                    }
                }
            }
            .refreshable { [weak self] completion in
                // Called when user pulls to refresh
                debugPrint("DEBUG: Pull to refresh triggered")
                self?.refreshData(completion: completion)
            }
            .infiniteScroll(threshold: 100) { [weak self] (completion: @escaping () -> Void) in
                // Called when user scrolls near bottom
                debugPrint("DEBUG: Load more triggered")
                self?.loadMoreItems(completion: completion)
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Infinite Scroll Demo")
    }

    /// Create view for individual item using VStack/HStack DSL
    /// - Parameter item: The item to display
    /// - Returns: Configured UIView
    private func createItemView(item: Item) -> UIView {
        // Create subtitle with multiline support
        let subtitleLabel = Text()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        subtitleLabel.numberOfLines = 0

        return View().HStack(spacing: 12, alignment: .center) {
            // Icon
            Image()
                .image(systemName: "doc.text.fill")
                .foregroundColor(0x007AFF)
                .frame(width: 40, height: 40)
                .scaledToFit()

            // Text content
            View().VStack(spacing: 4, alignment: .leading, distribution: .fill) {
                Text()
                    .text(item.title)
                    .font(16, weight: .semibold)
                    .foregroundColor(0x333333)

                subtitleLabel
            }

            Spacer()
        }
        .padding(12)
        .background(0xF8F9FA)
        .cornerRadius(8)
        .stroke(0xE0E0E0, lineWidth: 1)
    }
}
