//
//  DynamicNestedListViewController.swift
//  OISwift
//
//  Created for demonstrating dynamic data updates in nested lists
//

import UIKit

// MARK: - Dynamic Data Models

class DynamicCategory: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var icon: String
    var items: [DynamicItem]
    var createdAt: Date

    init(name: String, icon: String, items: [DynamicItem] = []) {
        self.name = name
        self.icon = icon
        self.items = items
        self.createdAt = Date()
    }

    static func == (lhs: DynamicCategory, rhs: DynamicCategory) -> Bool {
        lhs.id == rhs.id
    }
}

class DynamicItem: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }

    static func == (lhs: DynamicItem, rhs: DynamicItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - DynamicNestedListViewController

class DynamicNestedListViewController: UIViewController {

    // Dynamic data that will be updated
    var categories: [DynamicCategory] = [
        DynamicCategory(name: "Work Tasks", icon: "briefcase.fill", items: [
            DynamicItem(title: "Review code"),
            DynamicItem(title: "Write documentation")
        ]),
        DynamicCategory(name: "Personal", icon: "person.fill", items: [
            DynamicItem(title: "Buy groceries"),
            DynamicItem(title: "Call dentist")
        ])
    ]

    // Reference to the main container view for rebuilding
    private var mainContainerView: UIView?
    private var scrollView: UIView?

    // Text fields for input
    private var categoryNameField: UITextField?
    private var itemTitleField: UITextField?
    private var selectedCategoryIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        buildView()
    }

    // Rebuild the entire view with updated data
    private func buildView() {
        // Remove existing view
        mainContainerView?.removeFromSuperview()

        // Build new view
        let mainStack = view.VStack {
            self.createDynamicNestedList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Dynamic Nested List")
        mainStack.navigationBarTitleDisplayMode(.always)

        mainContainerView = mainStack
    }

    // Refresh the view after data changes
    private func refreshView() {
        buildView()
    }
}

// MARK: - Main View Creation

extension DynamicNestedListViewController {

    private func createDynamicNestedList() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 16) {
                // Header
                Text().text("📊 Dynamic Nested List").font(18, weight: .bold)

                // Info box
                self.createInfoBox()

                // Statistics
                self.createStatisticsBox()

                // Add Category Section
                self.createAddCategorySection()

                // Add Item Section
                self.createAddItemSection()

                // Categories List
                self.createCategoriesList()
            }
        }
        return listView
    }

    private func createInfoBox() -> UIView {
        let box = View().VStack(spacing: 8, alignment: .leading, distribution: .fill) {
            View().HStack(spacing: 8, alignment: .center) {
                Image().image(systemName: "info.circle.fill").foregroundColor(.systemBlue).frame(width: 20, height: 20).scaledToFit()
                Text().text("Live Data Updates").font(14, weight: .bold)
            }

            Text().text("• Add new categories (parents)").font(12, weight: .regular)
            Text().text("• Add new items to categories (children)").font(12, weight: .regular)
            Text().text("• Delete categories or items").font(12, weight: .regular)
            Text().text("• Toggle item completion").font(12, weight: .regular)
        }
        box.padding(12)
        box.background(UIColor.systemBlue.withAlphaComponent(0.1))
        box.cornerRadius(8)

        return box
    }

    private func createStatisticsBox() -> UIView {
        let totalCategories = categories.count
        let totalItems = categories.reduce(0) { $0 + $1.items.count }
        let completedItems = categories.flatMap { $0.items }.filter { $0.isCompleted }.count

        let box = View().HStack(spacing: 12, alignment: .center, distribution: .fillEqually) {
            // Categories stat
            View().VStack(spacing: 4, alignment: .center, distribution: .fillEqually) {
                Text().text("\(totalCategories)").font(20, weight: .bold).foregroundColor(.systemBlue)
                Text().text("Categories").font(10, weight: .regular).foregroundColor(.systemGray)
            }
            .padding(8)
            .background(UIColor.systemBlue.withAlphaComponent(0.1))
            .cornerRadius(6)

            // Items stat
            View().VStack(spacing: 4, alignment: .center, distribution: .fillEqually) {
                Text().text("\(totalItems)").font(20, weight: .bold).foregroundColor(.systemGreen)
                Text().text("Items").font(10, weight: .regular).foregroundColor(.systemGray)
            }
            .padding(8)
            .background(UIColor.systemGreen.withAlphaComponent(0.1))
            .cornerRadius(6)

            // Completed stat
            View().VStack(spacing: 4, alignment: .center, distribution: .fillEqually) {
                Text().text("\(completedItems)").font(20, weight: .bold).foregroundColor(.systemOrange)
                Text().text("Completed").font(10, weight: .regular).foregroundColor(.systemGray)
            }
            .padding(8)
            .background(UIColor.systemOrange.withAlphaComponent(0.1))
            .cornerRadius(6)
        }

        return box
    }
}

// MARK: - Add Category Section

extension DynamicNestedListViewController {

    private func createAddCategorySection() -> UIView {
        let section = View().VStack(spacing: 10) {
            // Section header
            View().HStack(spacing: 8, alignment: .center) {
                Image().image(systemName: "plus.circle.fill").foregroundColor(.systemPurple).frame(width: 20, height: 20).scaledToFit()
                Text().text("Add New Category (Parent)").font(15, weight: .semibold)
            }

            // Input row
            View().HStack(spacing: 8, alignment: .center) {
                // Text field
                self.createCategoryTextField()

                // Add button
                Button().content {
                    self.addNewCategory()
                } setup: { button in
                    button.title("Add")
                        .background(.systemPurple)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .height(40)
                        .width(70)
                }
            }
        }
        section.padding(12)
        section.background(UIColor.systemPurple.withAlphaComponent(0.05))
        section.cornerRadius(10)

        return section
    }

    private func createCategoryTextField() -> UIView {
        let inputField = TextField()
            .placeholder("Enter category name...")
            .padding(10)
            .height(40)
            .cornerRadius(6)
            .background(UIColor.white)
            .stroke(UIColor.systemGray4, lineWidth: 1)

        // Store reference - TextField IS a UITextField subclass
        self.categoryNameField = inputField

        return inputField
    }

    private func addNewCategory() {
        guard let name = categoryNameField?.text, !name.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please enter a category name")
            return
        }

        // Add new category to data
        let icons = ["folder.fill", "star.fill", "heart.fill", "flag.fill", "bookmark.fill"]
        let randomIcon = icons.randomElement() ?? "folder.fill"

        let newCategory = DynamicCategory(name: name, icon: randomIcon, items: [])
        categories.append(newCategory)

        // Clear input
        categoryNameField?.text = ""

        // Refresh view
        refreshView()

        // Show success
        print("✅ Added new category: \(name)")
        print("📊 Total categories: \(categories.count)")
    }
}

// MARK: - Add Item Section

extension DynamicNestedListViewController {

    private func createAddItemSection() -> UIView {
        let section = View().VStack(spacing: 10) {
            // Section header
            View().HStack(spacing: 8, alignment: .center) {
                Image().image(systemName: "plus.square.fill").foregroundColor(.systemGreen).frame(width: 20, height: 20).scaledToFit()
                Text().text("Add New Item (Child)").font(15, weight: .semibold)
            }

            // Category selector
            self.createCategorySelector()

            // Input row
            View().HStack(spacing: 8, alignment: .center) {
                // Text field
                self.createItemTextField()

                // Add button
                Button().content {
                    self.addNewItem()
                } setup: { button in
                    button.title("Add")
                        .background(.systemGreen)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .height(40)
                        .width(70)
                }
            }
        }
        section.padding(12)
        section.background(UIColor.systemGreen.withAlphaComponent(0.05))
        section.cornerRadius(10)

        return section
    }

    private func createCategorySelector() -> UIView {
        let stackView = View().HStack(spacing: 8, alignment: .center) {
            Text().text("Add to:").font(12, weight: .medium).foregroundColor(.systemGray)
        }

        // Manually add category selector buttons
        for (index, _) in categories.enumerated() {
            let button = createCategorySelectorButton(index: index)
            if let hstack = stackView as? UIStackView {
                hstack.addArrangedSubview(button)
            }
        }

        return stackView
    }

    private func createCategorySelectorButton(index: Int) -> UIView {
        let category = categories[index]
        let isSelected = index == selectedCategoryIndex

        let button = Button().content {
            self.selectedCategoryIndex = index
            self.refreshView()
        } setup: { btn in
            btn.title(category.name)
                .background(isSelected ? .systemGreen : .systemGray5)
                .foregroundColor(isSelected ? .white : .systemGray)
                .cornerRadius(5)
                .height(30)
                .font(size: 11, weight: .medium)
        }

        return button
    }

    private func createItemTextField() -> UIView {
        let inputField = TextField()
            .placeholder("Enter item title...")
            .padding(10)
            .height(40)
            .cornerRadius(6)
            .background(UIColor.white)
            .stroke(UIColor.systemGray4, lineWidth: 1)

        // Store reference - TextField IS a UITextField subclass
        self.itemTitleField = inputField

        return inputField
    }

    private func addNewItem() {
        guard selectedCategoryIndex < categories.count else {
            showAlert(title: "Error", message: "Please select a category first")
            return
        }

        guard let title = itemTitleField?.text, !title.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please enter an item title")
            return
        }

        // Add new item to selected category
        let newItem = DynamicItem(title: title, isCompleted: false)
        categories[selectedCategoryIndex].items.append(newItem)

        // Clear input
        itemTitleField?.text = ""

        // Refresh view
        refreshView()

        // Show success
        let categoryName = categories[selectedCategoryIndex].name
        print("✅ Added new item '\(title)' to category '\(categoryName)'")
        print("📊 Category '\(categoryName)' now has \(categories[selectedCategoryIndex].items.count) items")
    }
}

// MARK: - Categories List

extension DynamicNestedListViewController {

    private func createCategoriesList() -> UIView {
        let headerView = View().HStack(spacing: 8, alignment: .center) {
            Text().text("📂 Categories & Items").font(16, weight: .bold)
            Spacer()
            Text().text("\(categories.count) total").font(12, weight: .regular).foregroundColor(.systemGray)
        }

        let container = View().VStack(spacing: 12) {
            headerView
        }

        // Manually add categories
        if let stackView = container as? UIStackView {
            for (index, _) in categories.enumerated() {
                let categoryView = createCategoryItem(index: index)
                stackView.addArrangedSubview(categoryView)
            }

            // Add empty state if needed
            if categories.isEmpty {
                stackView.addArrangedSubview(createEmptyState())
            }
        }

        return container
    }

    private func createCategoryItem(index: Int) -> UIView {
        let category = categories[index]

        let headerView = View().HStack(spacing: 12, alignment: .center) {
            Image().image(systemName: category.icon).foregroundColor(.systemIndigo).frame(width: 24, height: 24).scaledToFit()

            View().VStack(spacing: 2, alignment: .leading, distribution: .fillEqually) {
                Text().text(category.name).font(15, weight: .bold)
                Text().text("\(category.items.count) items • Created \(self.timeAgo(from: category.createdAt))").font(11, weight: .regular).foregroundColor(.systemGray)
            }

            Spacer()

            // Delete button
            Button().content {
                self.deleteCategory(at: index)
            } setup: { btn in
                btn.title("🗑")
                    .background(.systemRed.withAlphaComponent(0.1))
                    .cornerRadius(5)
                    .width(35)
                    .height(35)
            }
        }
        headerView.padding(12)
        headerView.background(UIColor.systemIndigo.withAlphaComponent(0.1))
        headerView.cornerRadius(8)

        // Create content views manually
        var contentViews: [UIView] = []

        if category.items.isEmpty {
            contentViews.append(createCategoryEmptyState())
        } else {
            for itemIndex in category.items.indices {
                contentViews.append(createItemCell(categoryIndex: index, itemIndex: itemIndex))
            }
        }

        // Build collapsible item with manual content
        let contentStack = View().VStack(spacing: 6) {}
        if let stackView = contentStack as? UIStackView {
            contentViews.forEach { stackView.addArrangedSubview($0) }
        }

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: true,
            spacing: 6,
            onToggle: { expanded in
                print("Category '\(category.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            contentStack
        }

        return collapsibleItem
    }

    private func createItemCell(categoryIndex: Int, itemIndex: Int) -> UIView {
        let item = categories[categoryIndex].items[itemIndex]

        let cell = View().HStack(spacing: 10, alignment: .center) {
            // Checkbox
            Button().content {
                self.toggleItemCompletion(categoryIndex: categoryIndex, itemIndex: itemIndex)
            } setup: { btn in
                btn.title(item.isCompleted ? "✓" : "○")
                    .background(item.isCompleted ? .systemGreen : .systemGray5)
                    .foregroundColor(item.isCompleted ? .white : .systemGray)
                    .cornerRadius(15)
                    .width(30)
                    .height(30)
                    .font(size: 14, weight: .bold)
            }

            // Item info
            View().VStack(spacing: 2, alignment: .leading, distribution: .fillEqually) {
                Text().text(item.title).font(14, weight: item.isCompleted ? .regular : .medium).foregroundColor(item.isCompleted ? .systemGray : .label)
                Text().text("Added \(self.timeAgo(from: item.createdAt))").font(10, weight: .regular).foregroundColor(.systemGray2)
            }

            Spacer()

            // Delete button
            Button().content {
                self.deleteItem(categoryIndex: categoryIndex, itemIndex: itemIndex)
            } setup: { btn in
                btn.title("✕")
                    .background(.systemRed.withAlphaComponent(0.1))
                    .foregroundColor(.systemRed)
                    .cornerRadius(5)
                    .width(30)
                    .height(30)
                    .font(size: 12, weight: .bold)
            }
        }
        cell.padding(10)
        cell.background(UIColor.white)
        cell.cornerRadius(6)
        cell.stroke(UIColor.systemGray5, lineWidth: 1)

        return cell
    }

    private func createEmptyState() -> UIView {
        let empty = View().VStack(spacing: 8, alignment: .center, distribution: .fillEqually) {
            Text().text("📭").font(40, weight: .regular)
            Text().text("No categories yet").font(14, weight: .semibold).foregroundColor(.systemGray)
            Text().text("Add your first category above").font(12, weight: .regular).foregroundColor(.systemGray2)
        }
        empty.padding(30)
        empty.background(UIColor.systemGray6)
        empty.cornerRadius(10)

        return empty
    }

    private func createCategoryEmptyState() -> UIView {
        let empty = View().VStack(spacing: 6, alignment: .center, distribution: .fillEqually) {
            Text().text("No items yet").font(12, weight: .medium).foregroundColor(.systemGray)
            Text().text("Add an item above").font(10, weight: .regular).foregroundColor(.systemGray2)
        }
        empty.padding(16)
        empty.background(UIColor.systemGray6.withAlphaComponent(0.5))
        empty.cornerRadius(6)

        return empty
    }
}

// MARK: - Data Manipulation

extension DynamicNestedListViewController {

    private func deleteCategory(at index: Int) {
        let categoryName = categories[index].name

        categories.remove(at: index)

        // Update selected index if needed
        if selectedCategoryIndex >= categories.count {
            selectedCategoryIndex = max(0, categories.count - 1)
        }

        refreshView()

        print("🗑 Deleted category: \(categoryName)")
        print("📊 Remaining categories: \(categories.count)")
    }

    private func deleteItem(categoryIndex: Int, itemIndex: Int) {
        let itemTitle = categories[categoryIndex].items[itemIndex].title
        let categoryName = categories[categoryIndex].name

        categories[categoryIndex].items.remove(at: itemIndex)

        refreshView()

        print("🗑 Deleted item '\(itemTitle)' from category '\(categoryName)'")
        print("📊 Category '\(categoryName)' now has \(categories[categoryIndex].items.count) items")
    }

    private func toggleItemCompletion(categoryIndex: Int, itemIndex: Int) {
        categories[categoryIndex].items[itemIndex].isCompleted.toggle()

        let item = categories[categoryIndex].items[itemIndex]
        let categoryName = categories[categoryIndex].name

        refreshView()

        print("✓ Toggled '\(item.title)' in '\(categoryName)': \(item.isCompleted ? "completed" : "incomplete")")
    }
}

// MARK: - Helper Methods

extension DynamicNestedListViewController {

    private func timeAgo(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)

        if seconds < 60 {
            return "just now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(seconds / 86400)
            return "\(days)d ago"
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
