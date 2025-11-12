//
//  NestedListViewController.swift
//  OISwift
//
//  Created for demonstrating nested ForEach with collapsible functionality
//

import UIKit

// MARK: - Data Models

struct Company: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var departments: [Department]
}

struct Department: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var teams: [Team]
}

struct Team: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var members: [TeamMember]
}

struct TeamMember: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var role: String
}

struct Category: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var icon: String
    var subcategories: [Subcategory]
}

struct Subcategory: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var items: [String]
}

struct ItemWrapper: Identifiable, Equatable {
    var id = UUID()
    var name: String
}

// MARK: - NestedListViewController

class NestedListViewController: UIViewController {

    // Sample Data: Company Structure (3 levels deep)
    let companies = [
        Company(name: "Tech Corp", departments: [
            Department(name: "Engineering", teams: [
                Team(name: "iOS Team", members: [
                    TeamMember(name: "Alice", role: "Senior Developer"),
                    TeamMember(name: "Bob", role: "Developer"),
                    TeamMember(name: "Charlie", role: "Junior Developer")
                ]),
                Team(name: "Android Team", members: [
                    TeamMember(name: "David", role: "Lead Developer"),
                    TeamMember(name: "Eve", role: "Developer")
                ])
            ]),
            Department(name: "Design", teams: [
                Team(name: "UI/UX", members: [
                    TeamMember(name: "Frank", role: "UI Designer"),
                    TeamMember(name: "Grace", role: "UX Researcher")
                ])
            ])
        ]),
        Company(name: "Media Inc", departments: [
            Department(name: "Content", teams: [
                Team(name: "Video", members: [
                    TeamMember(name: "Henry", role: "Editor"),
                    TeamMember(name: "Ivy", role: "Producer")
                ]),
                Team(name: "Writing", members: [
                    TeamMember(name: "Jack", role: "Writer"),
                    TeamMember(name: "Kate", role: "Editor")
                ])
            ])
        ])
    ]

    // Sample Data: Category Structure (2 levels deep)
    let categories = [
        Category(name: "Electronics", icon: "laptopcomputer", subcategories: [
            Subcategory(name: "Computers", items: ["MacBook Pro", "iMac", "Mac Mini"]),
            Subcategory(name: "Phones", items: ["iPhone 16", "iPhone 16 Pro", "iPhone SE"]),
            Subcategory(name: "Tablets", items: ["iPad Pro", "iPad Air", "iPad Mini"])
        ]),
        Category(name: "Home & Garden", icon: "house.fill", subcategories: [
            Subcategory(name: "Furniture", items: ["Sofa", "Chair", "Table"]),
            Subcategory(name: "Decor", items: ["Lamp", "Rug", "Curtain"])
        ]),
        Category(name: "Sports", icon: "sportscourt.fill", subcategories: [
            Subcategory(name: "Outdoor", items: ["Soccer Ball", "Basketball", "Tennis Racket"]),
            Subcategory(name: "Fitness", items: ["Dumbbells", "Yoga Mat", "Resistance Bands"])
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Choose which example to display
        example1_ThreeLevelNesting()
        //example2_TwoLevelNesting()
        //example3_MixedNesting()
        //example4_AllExpanded()
    }
}

// MARK: - Examples

extension NestedListViewController {

    // EXAMPLE 1: Three-level nested ForEach (Company > Department > Team > Members)
    func example1_ThreeLevelNesting() {
        let mainStack = view.VStack {
            self.createThreeLevelList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("3-Level Nested Lists")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 2: Two-level nested ForEach (Category > Subcategory > Items)
    func example2_TwoLevelNesting() {
        let mainStack = view.VStack {
            self.createTwoLevelList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("2-Level Nested Lists")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 3: Mixed nesting with sections
    func example3_MixedNesting() {
        let mainStack = view.VStack {
            self.createMixedList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Mixed Nested Lists")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 4: All levels initially expanded
    func example4_AllExpanded() {
        let mainStack = view.VStack {
            self.createAllExpandedList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("All Expanded Lists")
        mainStack.navigationBarTitleDisplayMode(.always)
    }
}

// MARK: - Three-Level Nesting Implementation

extension NestedListViewController {

    private func createThreeLevelList() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 10) {
                Section(
                    header: Text().text("🏢 Company Structure").font(18, weight: .bold),
                    isCollapsible: true,
                    isExpanded: true
                ) {
                    ForEach(self.companies) { company in
                        self.createCompanyItem(company: company)
                    }
                }
            }
        }
        return listView
    }

    private func createCompanyItem(company: Company) -> UIView {
        let headerView = View().HStack(spacing: 12, alignment: .center) {
            Image().image(systemName: "building.2.fill").foregroundColor(.systemBlue).frame(width: 24, height: 24).scaledToFit()
            Text().text(company.name).font(16, weight: .bold)
            Text().text("(\(company.departments.count) depts)").font(12, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(12)
        headerView.background(.systemBlue.withAlphaComponent(0.1))
        headerView.cornerRadius(10)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 8,
            onToggle: { expanded in
                print("Company '\(company.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            ForEach(company.departments) { department in
                self.createDepartmentItem(department: department, companyName: company.name)
            }
        }
        return collapsibleItem
    }

    private func createDepartmentItem(department: Department, companyName: String) -> UIView {
        let headerView = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: "person.3.fill").foregroundColor(.systemPurple).frame(width: 22, height: 22).scaledToFit()
            Text().text(department.name).font(15, weight: .semibold)
            Text().text("(\(department.teams.count) teams)").font(11, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(10)
        headerView.background(.systemPurple.withAlphaComponent(0.1))
        headerView.cornerRadius(8)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 6,
            onToggle: { expanded in
                print("\(companyName) > '\(department.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            ForEach(department.teams) { team in
                self.createTeamItem(team: team, departmentName: department.name)
            }
        }
        return collapsibleItem
    }

    private func createTeamItem(team: Team, departmentName: String) -> UIView {
        let headerView = View().HStack(spacing: 8, alignment: .center) {
            Image().image(systemName: "person.2.fill").foregroundColor(.systemOrange).frame(width: 20, height: 20).scaledToFit()
            Text().text(team.name).font(14, weight: .semibold)
            Text().text("(\(team.members.count) members)").font(10, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(8)
        headerView.background(.systemOrange.withAlphaComponent(0.1))
        headerView.cornerRadius(6)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 4,
            onToggle: { expanded in
                print("\(departmentName) > '\(team.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            ForEach(team.members) { member in
                self.createMemberCell(member: member)
            }
        }
        return collapsibleItem
    }

    private func createMemberCell(member: TeamMember) -> UIView {
        let cell = View().HStack(spacing: 8, alignment: .center) {
            Image().image(systemName: "person.circle.fill").foregroundColor(.systemGreen).frame(width: 18, height: 18).scaledToFit()
            View().VStack(spacing: 2, alignment: .leading, distribution: .fillEqually) {
                Text().text(member.name).font(13, weight: .medium)
                Text().text(member.role).font(11, weight: .regular).foregroundColor(.systemGray)
            }
        }
        cell.padding(8)
        cell.background(UIColor.systemGreen.withAlphaComponent(0.05))
        cell.cornerRadius(5)
        return cell
    }
}

// MARK: - Two-Level Nesting Implementation

extension NestedListViewController {

    private func createTwoLevelList() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 10) {
                Section(
                    header: Text().text("📦 Product Categories").font(18, weight: .bold),
                    isCollapsible: true,
                    isExpanded: true
                ) {
                    ForEach(self.categories) { category in
                        self.createCategoryItem(category: category)
                    }
                }
            }
        }
        return listView
    }

    private func createCategoryItem(category: Category) -> UIView {
        let headerView = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: category.icon).foregroundColor(.systemIndigo).frame(width: 24, height: 24).scaledToFit()
            Text().text(category.name).font(16, weight: .bold)
            Text().text("(\(category.subcategories.count) subcategories)").font(12, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(12)
        headerView.background(.systemIndigo.withAlphaComponent(0.1))
        headerView.cornerRadius(10)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 6,
            onToggle: { expanded in
                print("Category '\(category.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            ForEach(category.subcategories) { subcategory in
                self.createSubcategoryItem(subcategory: subcategory)
            }
        }
        return collapsibleItem
    }

    private func createSubcategoryItem(subcategory: Subcategory) -> UIView {
        let headerView = View().HStack(spacing: 8, alignment: .center) {
            Image().image(systemName: "tag.fill").foregroundColor(.systemTeal).frame(width: 20, height: 20).scaledToFit()
            Text().text(subcategory.name).font(14, weight: .semibold)
            Text().text("(\(subcategory.items.count) items)").font(11, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(10)
        headerView.background(UIColor.systemTeal.withAlphaComponent(0.1))
        headerView.cornerRadius(8)

        // Wrap strings in ItemWrapper to make them Identifiable
        let wrappedItems = subcategory.items.map { ItemWrapper(name: $0) }

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 4,
            onToggle: { expanded in
                print("Subcategory '\(subcategory.name)' is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            ForEach(wrappedItems) { item in
                self.createItemCell(item: item.name)
            }
        }
        return collapsibleItem
    }

    private func createItemCell(item: String) -> UIView {
        let cell = View().HStack(spacing: 8, alignment: .center) {
            Image().image(systemName: "circle.fill").foregroundColor(.systemGray2).frame(width: 8, height: 8).scaledToFit()
            Text().text(item).font(13, weight: .regular)
        }
        cell.padding(8)
        cell.background(.systemGray6)
        cell.cornerRadius(5)
        return cell
    }
}

// MARK: - Mixed Nesting Implementation

extension NestedListViewController {

    private func createMixedList() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 12) {
                // Section 1: Collapsible with nested lists
                Section(
                    header: Text().text("🏢 Organizations").font(16, weight: .bold),
                    isCollapsible: true,
                    isExpanded: true
                ) {
                    ForEach(self.companies.prefix(1)) { company in
                        self.createCompanyItem(company: company)
                    }
                }

                // Section 2: Non-collapsible with nested lists
                Section(
                    header: Text().text("📦 Shopping").font(16, weight: .bold),
                    isCollapsible: false
                ) {
                    ForEach(self.categories.prefix(2)) { category in
                        self.createCategoryItem(category: category)
                    }
                }

                // Section 3: Collapsible starting collapsed
                Section(
                    header: Text().text("🎯 More Options").font(16, weight: .bold),
                    isCollapsible: true,
                    isExpanded: false
                ) {
                    ForEach(self.categories.suffix(1)) { category in
                        self.createCategoryItem(category: category)
                    }
                }
            }
        }
        return listView
    }
}

// MARK: - All Expanded Implementation

extension NestedListViewController {

    private func createAllExpandedList() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 10) {
                Section(
                    header: Text().text("📋 All Levels Expanded").font(18, weight: .bold),
                    isCollapsible: true,
                    isExpanded: true
                ) {
                    ForEach(self.companies.prefix(1)) { company in
                        self.createExpandedCompanyItem(company: company)
                    }
                }
            }
        }
        return listView
    }

    private func createExpandedCompanyItem(company: Company) -> UIView {
        let headerView = View().HStack(spacing: 12, alignment: .center) {
            Image().image(systemName: "building.2.fill").foregroundColor(.systemBlue).frame(width: 24, height: 24).scaledToFit()
            Text().text(company.name).font(16, weight: .bold)
        }
        headerView.padding(12)
        headerView.background(.systemBlue.withAlphaComponent(0.1))
        headerView.cornerRadius(10)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: true, // Expanded by default
            spacing: 8
        ) {
            ForEach(company.departments) { department in
                self.createExpandedDepartmentItem(department: department)
            }
        }
        return collapsibleItem
    }

    private func createExpandedDepartmentItem(department: Department) -> UIView {
        let headerView = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: "person.3.fill").foregroundColor(.systemPurple).frame(width: 22, height: 22).scaledToFit()
            Text().text(department.name).font(15, weight: .semibold)
        }
        headerView.padding(10)
        headerView.background(.systemPurple.withAlphaComponent(0.1))
        headerView.cornerRadius(8)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: true, // Expanded by default
            spacing: 6
        ) {
            ForEach(department.teams) { team in
                self.createExpandedTeamItem(team: team)
            }
        }
        return collapsibleItem
    }

    private func createExpandedTeamItem(team: Team) -> UIView {
        let headerView = View().HStack(spacing: 8, alignment: .center) {
            Image().image(systemName: "person.2.fill").foregroundColor(.systemOrange).frame(width: 20, height: 20).scaledToFit()
            Text().text(team.name).font(14, weight: .semibold)
        }
        headerView.padding(8)
        headerView.background(.systemOrange.withAlphaComponent(0.1))
        headerView.cornerRadius(6)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: true, // Expanded by default
            spacing: 4
        ) {
            ForEach(team.members) { member in
                self.createMemberCell(member: member)
            }
        }
        return collapsibleItem
    }
}
