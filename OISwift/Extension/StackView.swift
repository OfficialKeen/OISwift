//
//  StackView.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

import UIKit

/*@MainActor
open class ListView<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var content: (Data.Element) -> Content

    public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        super.init(frame: .zero)
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let scrollView = UIScrollView()
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        for item in data {
            let view = content(item)
            stackView.addArrangedSubview(view)
        }
        
        // Setup constraints for stackView inside scrollView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensures the stack view width matches the scroll view width
        ])
        
        // Add the scrollView to the current view
        self.addSubview(scrollView)

        // Setup constraints for scrollView within the current view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}*/

/*@MainActor
open class ForEach<Range: Sequence, Content: UIView>: UIView where Range.Element: Hashable {
    private var range: Range
    private var content: (Range.Element) -> Content

    public init(_ range: Range, content: @escaping (Range.Element) -> Content) {
        self.range = range
        self.content = content
        super.init(frame: .zero)
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for item in range {
            let view = content(item)
            stackView.addArrangedSubview(view)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}*/

/*@MainActor
open class ForEach<Data, Content: UIView>: UIView {
    private var data: [Data]
    private var content: (Data) -> Content

    public init(_ data: [Data], content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
        super.init(frame: .zero)
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for item in data {
            let view = content(item)
            stackView.addArrangedSubview(view)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}*/

import UIKit

@resultBuilder
public struct UIStackViewBuilder {
    public static func buildBlock(_ components: UIView?...) -> [UIView] {
        return components.compactMap { $0 }
    }
}

public enum VStackModifyAlignment {
    case centerXY
    case topLeading
    case topCenter
    case topTrailing
    case bottomLeading
    case bottomCenter
    case bottomTrailing
    case blank
}

extension UIView {
    @discardableResult
    public func VStack(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return stackView
    }
    
    // MARK: VStack
    @discardableResult
    public func VStack(centerXY: Bool = false, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if centerXY {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        return stackView
    }
    

    @discardableResult
    public func VStack(spacing: CGFloat = 0, isModifyAlignment: Bool = false, modifyAlignment: VStackModifyAlignment = .blank, alignment: UIStackView.Alignment = .leading, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the stackView based on modifyLocation
        if isModifyAlignment {
            switch modifyAlignment {
            case .centerXY:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .topLeading:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
                ])
            case .topCenter:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
                ])
            case .topTrailing:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .bottomLeading:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            case .bottomCenter:
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
                ])
            case .bottomTrailing:
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .blank:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        return stackView
    }
    // MARK: HStack
    @discardableResult
    public func HStack(spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, centered: Bool = false, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        if centered {
            // Center horizontally
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        } else {
            // Fill horizontally
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }

        // Fill vertically
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        return stackView
    }
    
    @discardableResult
    func HStack(spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return stackView
    }
    
    @discardableResult
    func HStack(centerXY: Bool = false, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if centerXY {
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        return stackView
    }
    
    @discardableResult
    public func HStack(spacing: CGFloat = 0, isModifyAlignment: Bool = false, modifyAlignment: VStackModifyAlignment = .blank, alignment: UIStackView.Alignment = .leading, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the stackView based on modifyLocation
        if isModifyAlignment {
            switch modifyAlignment {
            case .centerXY:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                    
                ])
            case .topLeading:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
                ])
            case .topCenter:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
                ])
            case .topTrailing:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .bottomLeading:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            case .bottomCenter:
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
                ])
            case .bottomTrailing:
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .blank:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        return stackView
    }
    // MARK: ZStack
    @discardableResult
    public func ZStack(@UIStackViewBuilder content: (_ containerView: UIView) -> [UIView]) -> UIView {
        let overlayContainer = UIView()
        overlayContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayContainer)
        
        NSLayoutConstraint.activate([
            overlayContainer.topAnchor.constraint(equalTo: topAnchor),
            overlayContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let views = content(overlayContainer)
        for view in views {
            overlayContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        return overlayContainer
    }
    
    @discardableResult
    public func ZStack(@UIStackViewBuilder content: () -> [UIView]) -> UIView {
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let views = content()
        for view in views {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        return container
    }
}

public enum CenteredOption {
    case none, centerX, centerY, centerXY
}

extension UIView {
    @discardableResult
    public func VStack(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        centered: CenteredOption = .none,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIStackView {
        let views = content()
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        
        // Adjust stackView constraints or layout if needed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        switch centered {
        case .none:
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        case .centerX:
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        case .centerY:
            NSLayoutConstraint.activate([
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        case .centerXY:
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        return stackView
    }
    
    @discardableResult
    public func HStack(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        centered: CenteredOption = .none,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIStackView {
        let views = content()
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        switch centered {
        case .none:
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: topAnchor),
                stack.leadingAnchor.constraint(equalTo: leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        case .centerX:
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                stack.topAnchor.constraint(equalTo: topAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        case .centerY:
            NSLayoutConstraint.activate([
                stack.centerYAnchor.constraint(equalTo: centerYAnchor),
                stack.leadingAnchor.constraint(equalTo: leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        case .centerXY:
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        return stack
    }
}
