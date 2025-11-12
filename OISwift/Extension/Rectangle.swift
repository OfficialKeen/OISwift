//
//  Rectangle.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit

public class Rectangle: UIView {
    
    init() {
        super.init(frame: .zero)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaults()
    }
    
    private func setupDefaults() {
        // Set default background color
        self.backgroundColor = UIColor.clear
    }
    
    public func fill(_ color: UIColor? = .clear) -> Rectangle {
        self.backgroundColor = color
        return self
    }
    
    public func frameRect(width: CGFloat, height: CGFloat) -> Rectangle {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
        return self
    }
    
    public func addCircle() -> Rectangle {
        let circleRadius = min(self.frame.width, self.frame.height) / 2.0
        let circle = CircleView(frame: CGRect(x: (self.frame.width - circleRadius * 2) / 2, y: (self.frame.height - circleRadius * 2) / 2, width: circleRadius * 2, height: circleRadius * 2))
        addSubview(circle)
        return self
    }
}


