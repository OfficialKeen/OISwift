//
//  DraggableListViewController.swift
//  OISwift
//
//  Created for demonstrating drag and drop / sortable list functionality
//

import UIKit

// MARK: - Data Models

struct Task: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var priority: String
    var isCompleted: Bool = false
}

struct Project: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var tasks: [Task]
}

// MARK: - DraggableListViewController

class DraggableListViewController: UIViewController {

    // Sample data
    var simpleTasks = [
        Task(title: "Design mockups", priority: "High"),
        Task(title: "Write documentation", priority: "Medium"),
        Task(title: "Code review", priority: "High"),
        Task(title: "Update dependencies", priority: "Low"),
        Task(title: "Fix bug #123", priority: "Critical")
    ]

    var projects = [
        Project(name: "iOS App", tasks: [
            Task(title: "Implement login", priority: "High"),
            Task(title: "Add animations", priority: "Medium"),
            Task(title: "Test on devices", priority: "High")
        ]),
        Project(name: "Website", tasks: [
            Task(title: "Update homepage", priority: "Medium"),
            Task(title: "Fix navigation", priority: "Low")
        ]),
        Project(name: "API", tasks: [
            Task(title: "Add endpoint", priority: "Critical"),
            Task(title: "Write tests", priority: "High")
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Choose which example to display
        //example1_SimpleDraggableList()
        //example2_DraggableWithSections()
        //example3_NestedDraggableLists()
        //example4_DraggableWithCollapse()
        example5_TwoLevelDragging()
    }
}

// MARK: - Examples

extension DraggableListViewController {

    // EXAMPLE 1: Simple draggable list
    func example1_SimpleDraggableList() {
        let mainStack = view.VStack {
            self.createSimpleDraggableList()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Draggable List")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 2: Draggable list with sections
    func example2_DraggableWithSections() {
        let mainStack = view.VStack {
            self.createDraggableWithSections()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Draggable Sections")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 3: Nested draggable lists
    func example3_NestedDraggableLists() {
        let mainStack = view.VStack {
            self.createNestedDraggableLists()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Nested Draggable")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 4: Draggable with collapse
    func example4_DraggableWithCollapse() {
        let mainStack = view.VStack {
            self.createDraggableWithCollapse()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Drag + Collapse")
        mainStack.navigationBarTitleDisplayMode(.always)
    }

    // EXAMPLE 5: Two-level dragging (parents and children independently)
    func example5_TwoLevelDragging() {
        let mainStack = view.VStack {
            self.createTwoLevelDragging()
        }

        mainStack.padding(16)
        mainStack.background(.white)
        mainStack.navigationTitle("Two-Level Dragging")
        mainStack.navigationBarTitleDisplayMode(.always)
    }
}

// MARK: - Example 1: Simple Draggable List

extension DraggableListViewController {

    private func createSimpleDraggableList() -> UIView {
        let container = View().VStack(spacing: 10) {
            // Header
            Text().text("📋 Task List - Long press to drag").font(18, weight: .bold)

            // Instructions
            self.createInstructionBox(text: "Long press any task and drag to reorder")

            // Draggable container
            self.createSimpleDraggableContainer()
        }
        container.padding()
        return container
    }

    private func createSimpleDraggableContainer() -> UIView {
        let listContainer = DraggableListContainer(spacing: 8)

        // Set up callbacks
        listContainer.onReorder = { sourceIndex, destinationIndex in
            print("Task moved from \(sourceIndex) to \(destinationIndex)")
        }

        listContainer.onReorderComplete = { indices in
            print("Final order: \(indices)")
            // Update your data model here
            let reorderedTasks = indices.map { self.simpleTasks[$0] }
            self.simpleTasks = reorderedTasks
        }

        // Add tasks
        for (index, task) in simpleTasks.enumerated() {
            let taskView = createTaskCell(task: task, index: index)
            listContainer.addDraggableItem(content: taskView, showDragHandle: true)
        }

        return listContainer
    }

    private func createTaskCell(task: Task, index: Int) -> UIView {
        let cell = View().HStack(spacing: 12, alignment: .center) {
            // Priority indicator
            View().frame(width: 4, height: 40)
                .background(self.priorityColor(for: task.priority))
                .cornerRadius(2)

            // Task info
            View().VStack(spacing: 4, alignment: .leading, distribution: .fillEqually) {
                Text().text(task.title).font(15, weight: .semibold)
                Text().text("Priority: \(task.priority)").font(12, weight: .regular).foregroundColor(.systemGray)
            }

            Spacer()

            // Task number
            View().VStack(alignment: .center, distribution: .fillEqually) {
                Text().text("#\(index + 1)").font(12, weight: .medium).foregroundColor(.systemGray)
            }
            .frame(width: 30, height: 30)
            .background(UIColor.systemGray6)
            .cornerRadius(15)
        }

        cell.padding(12)
        cell.background(UIColor.white)
        cell.cornerRadius(8)
        cell.stroke(UIColor.systemGray5, lineWidth: 1)

        return cell
    }

    private func priorityColor(for priority: String) -> UIColor {
        switch priority {
        case "Critical": return .systemRed
        case "High": return .systemOrange
        case "Medium": return .systemYellow
        case "Low": return .systemGreen
        default: return .systemGray
        }
    }
}

// MARK: - Example 2: Draggable with Sections

extension DraggableListViewController {

    private func createDraggableWithSections() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 16) {
                // Header
                Text().text("📁 Projects with Draggable Tasks").font(18, weight: .bold)

                // Instructions
                self.createInstructionBox(text: "Each project has independently sortable tasks")

                // Sections
                ForEach(projects) { project in
                    self.createProjectSection(project: project)
                }
            }
        }
        return listView
    }

    private func createProjectSection(project: Project) -> UIView {
        let section = View().VStack(spacing: 8) {
            // Project header
            View().HStack(spacing: 10, alignment: .center) {
                Image().image(systemName: "folder.fill").foregroundColor(.systemBlue).frame(width: 24, height: 24).scaledToFit()
                Text().text(project.name).font(16, weight: .bold)
                Text().text("(\(project.tasks.count) tasks)").font(12, weight: .regular).foregroundColor(.systemGray)
            }
            .padding(12)
            .background(.systemBlue.withAlphaComponent(0.1))
            .cornerRadius(8)

            // Draggable tasks
            self.createProjectDraggableContainer(project: project)
        }
        section.padding(12)
        section.background(.systemGray6)
        section.cornerRadius(10)

        return section
    }

    private func createProjectDraggableContainer(project: Project) -> UIView {
        let listContainer = DraggableListContainer(spacing: 6)

        listContainer.onReorderComplete = { indices in
            print("Tasks reordered in \(project.name): \(indices)")
        }

        for (index, task) in project.tasks.enumerated() {
            let taskView = createSimpleTaskCell(task: task, index: index)
            listContainer.addDraggableItem(content: taskView, showDragHandle: true)
        }

        return listContainer
    }

    private func createSimpleTaskCell(task: Task, index: Int) -> UIView {
        let cell = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: "checkmark.circle").foregroundColor(.systemGreen).frame(width: 20, height: 20).scaledToFit()
            Text().text(task.title).font(14, weight: .medium)
        }
        cell.padding(10)
        cell.background(.white)
        cell.cornerRadius(6)

        return cell
    }
}

// MARK: - Example 3: Nested Draggable Lists

extension DraggableListViewController {

    private func createNestedDraggableLists() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 16) {
                // Header
                Text().text("🎯 Nested Draggable Lists").font(18, weight: .bold)

                // Instructions
                self.createInstructionBox(text: "Drag projects to reorder, or drag tasks within projects")

                // Draggable projects container
                self.createNestedProjectsContainer()
            }
        }
        return listView
    }

    private func createNestedProjectsContainer() -> UIView {
        let listContainer = DraggableListContainer(spacing: 12)

        listContainer.onReorderComplete = { indices in
            print("Projects reordered: \(indices)")
        }

        for (index, project) in projects.enumerated() {
            let projectView = createNestedProjectItem(project: project, index: index)
            listContainer.addDraggableItem(content: projectView, showDragHandle: true)
        }

        return listContainer
    }

    private func createNestedProjectItem(project: Project, index: Int) -> UIView {
        let container = View().VStack(spacing: 8) {
            // Project header
            View().HStack(spacing: 10, alignment: .center) {
                Image().image(systemName: "folder.fill").foregroundColor(.systemIndigo).frame(width: 24, height: 24).scaledToFit()
                Text().text(project.name).font(16, weight: .bold)
                Text().text("#\(index + 1)").font(12, weight: .regular).foregroundColor(.systemGray)
            }
            .padding(10)

            // Nested draggable tasks
            self.createProjectDraggableContainer(project: project)
        }
        container.padding(12)
        container.background(.systemIndigo.withAlphaComponent(0.1))
        container.cornerRadius(10)

        return container
    }
}

// MARK: - Example 4: Draggable with Collapse

extension DraggableListViewController {

    private func createDraggableWithCollapse() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 16) {
                // Header
                Text().text("🎨 Draggable + Collapsible").font(18, weight: .bold)

                // Instructions
                self.createInstructionBox(text: "Tap to collapse/expand, long press to drag")

                // Collapsible + draggable items
                self.createCollapsibleDraggableContainer()
            }
        }
        return listView
    }

    private func createCollapsibleDraggableContainer() -> UIView {
        let listContainer = DraggableListContainer(spacing: 10)

        listContainer.onReorderComplete = { indices in
            print("Projects reordered: \(indices)")
            // Reorder projects array
            let reorderedProjects = indices.map { self.projects[$0] }
            self.projects = reorderedProjects
        }

        for (index, project) in projects.enumerated() {
            let collapsibleView = createCollapsibleProjectItem(project: project, index: index)
            listContainer.addDraggableItem(content: collapsibleView, showDragHandle: true)
        }

        return listContainer
    }

    private func createCollapsibleProjectItem(project: Project, index: Int) -> UIView {
        let headerView = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: "folder.fill").foregroundColor(.systemPurple).frame(width: 24, height: 24).scaledToFit()
            Text().text(project.name).font(16, weight: .bold)
            Text().text("(\(project.tasks.count) tasks)").font(12, weight: .regular).foregroundColor(.systemGray)
        }
        headerView.padding(12)
        headerView.background(.systemPurple.withAlphaComponent(0.1))
        headerView.cornerRadius(8)

        let collapsibleItem = CollapsibleItem(
            header: headerView,
            isExpanded: false,
            spacing: 6,
            onToggle: { expanded in
                print("\(project.name) is now: \(expanded ? "expanded" : "collapsed")")
            }
        ) {
            // Create inner draggable list for tasks
            self.createInnerDraggableTaskList(project: project)
        }

        return collapsibleItem
    }

    private func createInnerDraggableTaskList(project: Project) -> UIView {
        let listContainer = DraggableListContainer(spacing: 6)

        listContainer.onReorderComplete = { indices in
            print("Tasks in \(project.name) reordered: \(indices)")
        }

        for (index, task) in project.tasks.enumerated() {
            let taskView = createCompactTaskCell(task: task, index: index)
            listContainer.addDraggableItem(content: taskView, showDragHandle: true)
        }

        return listContainer
    }

    private func createCompactTaskCell(task: Task, index: Int) -> UIView {
        let cell = View().HStack(spacing: 8, alignment: .center) {
            View().frame(width: 3, height: 30)
                .background(self.priorityColor(for: task.priority))
                .cornerRadius(1.5)

            Text().text(task.title).font(13, weight: .medium)
            Spacer()
            Text().text(task.priority).font(10, weight: .regular).foregroundColor(.systemGray)
        }
        cell.padding(8)
        cell.background(.white)
        cell.cornerRadius(5)

        return cell
    }
}

// MARK: - Example 5: Two-Level Dragging

extension DraggableListViewController {

    private func createTwoLevelDragging() -> UIView {
        let listView = List { view in
            view.VStack(spacing: 16) {
                // Header
                Text().text("🎯 Two-Level Dragging").font(18, weight: .bold)

                // Instructions
                self.createInstructionBox(text: "Drag projects to reorder them ↕️ AND drag tasks within each project to reorder them ↕️")

                // Status indicator
                self.createStatusBox()

                // Two-level draggable container
                self.createTwoLevelDraggableContainer()
            }
        }
        return listView
    }

    private func createStatusBox() -> UIView {
        let box = View().VStack(spacing: 6, alignment: .leading, distribution: .fill) {
            View().HStack(spacing: 8, alignment: .center) {
                View().frame(width: 20, height: 3)
                    .background(UIColor.systemBlue)
                    .cornerRadius(1.5)
                Text().text("Blue = Parent level (drag to reorder projects)").font(11, weight: .regular)
            }

            View().HStack(spacing: 8, alignment: .center) {
                View().frame(width: 20, height: 3)
                    .background(UIColor.systemGreen)
                    .cornerRadius(1.5)
                Text().text("Green = Child level (drag to reorder tasks)").font(11, weight: .regular)
            }
        }
        box.padding(10)
        box.background(UIColor.systemGray6)
        box.cornerRadius(8)

        return box
    }

    private func createTwoLevelDraggableContainer() -> UIView {
        // Outer container for PARENT items (projects)
        let parentContainer = DraggableListContainer(spacing: 12)

        parentContainer.onReorder = { sourceIndex, destinationIndex in
            print("🔵 PARENT: Project moved from position \(sourceIndex) to \(destinationIndex)")
        }

        parentContainer.onReorderComplete = { indices in
            print("🔵 PARENT: Final project order: \(indices)")
            // Reorder projects array
            let reorderedProjects = indices.map { self.projects[$0] }
            self.projects = reorderedProjects
            print("🔵 PARENT: Projects reordered to: \(self.projects.map { $0.name })")
        }

        // Add each project as a draggable parent item
        for (index, project) in projects.enumerated() {
            let projectView = createTwoLevelProjectItem(project: project, projectIndex: index)
            parentContainer.addDraggableItem(content: projectView, showDragHandle: true)
        }

        return parentContainer
    }

    private func createTwoLevelProjectItem(project: Project, projectIndex: Int) -> UIView {
        let container = View().VStack(spacing: 0) {
            // Project header with BLUE indicator (parent level)
            View().HStack(spacing: 12, alignment: .center) {
                // Blue bar for parent level
                View().frame(width: 4, height: 50)
                    .background(UIColor.systemBlue)
                    .cornerRadius(2)

                Image().image(systemName: "folder.fill").foregroundColor(.systemBlue).frame(width: 24, height: 24).scaledToFit()

                View().VStack(spacing: 2, alignment: .leading, distribution: .fillEqually) {
                    Text().text(project.name).font(16, weight: .bold)
                    Text().text("\(project.tasks.count) tasks • Project #\(projectIndex + 1)").font(12, weight: .regular).foregroundColor(.systemGray)
                }

                Spacer()

                // Parent level indicator
                View().VStack(alignment: .center, distribution: .fillEqually) {
                    Text().text("PARENT").font(9, weight: .bold).foregroundColor(.white)
                }
                .padding(4)
                .background(UIColor.systemBlue)
                .cornerRadius(4)
            }
            .padding(12)
            .background(UIColor.systemBlue.withAlphaComponent(0.1))

            // Divider
            View().height(1)
                .background(UIColor.systemGray4)

            // INNER DRAGGABLE CONTAINER for CHILD items (tasks)
            self.createChildDraggableContainer(project: project, projectIndex: projectIndex)
        }
        container.background(UIColor.white)
        container.cornerRadius(10)
        container.stroke(UIColor.systemGray4, lineWidth: 1)

        return container
    }

    private func createChildDraggableContainer(project: Project, projectIndex: Int) -> UIView {
        // Inner container for CHILD items (tasks within this project)
        let childContainer = DraggableListContainer(spacing: 8)

        childContainer.onReorder = { sourceIndex, destinationIndex in
            print("  🟢 CHILD [\(project.name)]: Task moved from position \(sourceIndex) to \(destinationIndex)")
        }

        childContainer.onReorderComplete = { indices in
            print("  🟢 CHILD [\(project.name)]: Final task order: \(indices)")

            // Find the project in the array and update its tasks
            if let projectIdx = self.projects.firstIndex(where: { $0.id == project.id }) {
                let reorderedTasks = indices.map { self.projects[projectIdx].tasks[$0] }
                self.projects[projectIdx].tasks = reorderedTasks
                print("  🟢 CHILD [\(project.name)]: Tasks reordered to: \(reorderedTasks.map { $0.title })")
            }
        }

        // Add each task as a draggable child item
        for (taskIndex, task) in project.tasks.enumerated() {
            let taskView = createTwoLevelTaskCell(task: task, taskIndex: taskIndex, projectName: project.name)
            childContainer.addDraggableItem(content: taskView, showDragHandle: true)
        }

        // Wrap in padding container
        let paddingContainer = View().VStack {
            childContainer
        }
        paddingContainer.padding(12)
        paddingContainer.background(UIColor.systemGreen.withAlphaComponent(0.05))

        return paddingContainer
    }

    private func createTwoLevelTaskCell(task: Task, taskIndex: Int, projectName: String) -> UIView {
        let cell = View().HStack(spacing: 10, alignment: .center) {
            // Green bar for child level
            View().frame(width: 3, height: 40)
                .background(UIColor.systemGreen)
                .cornerRadius(1.5)

            // Task info
            View().VStack(spacing: 2, alignment: .leading, distribution: .fillEqually) {
                Text().text(task.title).font(14, weight: .semibold)
                Text().text("Priority: \(task.priority) • Task #\(taskIndex + 1)").font(11, weight: .regular).foregroundColor(.systemGray)
            }

            Spacer()

            // Child level indicator
            View().VStack(alignment: .center, distribution: .fillEqually) {
                Text().text("CHILD").font(8, weight: .bold).foregroundColor(.white)
            }
            .padding(3)
            .background(UIColor.systemGreen)
            .cornerRadius(3)
        }
        cell.padding(10)
        cell.background(UIColor.white)
        cell.cornerRadius(6)
        cell.stroke(UIColor.systemGreen.withAlphaComponent(0.3), lineWidth: 1)

        return cell
    }
}

// MARK: - Helper Views

extension DraggableListViewController {

    private func createInstructionBox(text: String) -> UIView {
        let box = View().HStack(spacing: 10, alignment: .center) {
            Image().image(systemName: "info.circle.fill").foregroundColor(.systemBlue).frame(width: 20, height: 20).scaledToFit()
            Text().text(text).font(13, weight: .regular).foregroundColor(.systemGray)
        }
        box.padding(12)
        box.background(.systemBlue.withAlphaComponent(0.05))
        box.cornerRadius(8)
        box.stroke(.systemBlue.withAlphaComponent(0.2), lineWidth: 1)

        return box
    }
}

