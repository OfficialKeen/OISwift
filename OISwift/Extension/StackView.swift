//
//  StackView.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

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
    public func VStack(spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, @UIStackViewBuilder content: () -> [UIView]) -> UIStackView {
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

