//
//  NavigationLink.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit


public class NavigationLinkView: UIView {

    public typealias Action = () -> Void

    private var action: Action?

    @discardableResult
    public func content(_ action: @escaping Action, setup block: () -> Void) -> NavigationLinkView {
        block()
        self.action = action

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)

        return self
    }
    
    @discardableResult
    public func content(_ action: @escaping Action, setup block: (UIView) -> Void) -> NavigationLinkView {
        block(self)
        self.action = action

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)

        return self
    }

    @objc private func viewTapped() {
        action?()
    }

    public func frame(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}


