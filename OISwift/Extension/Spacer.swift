//
//  Spacer.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit

public class Spacer: UIView {
    let minLength: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
        super.init(frame: .zero)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        setContentHuggingPriority(.defaultLow, for: .horizontal)

        if let minLength = minLength {
            self.widthAnchor.constraint(equalToConstant: minLength).isActive = true
            self.heightAnchor.constraint(equalToConstant: minLength).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
