//
//  Circle.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit

public class CircleView: UIView {
    public var fillColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    private var overlayView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.masksToBounds = true
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        layer.masksToBounds = true
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(fillColor.cgColor)
        context.fillEllipse(in: rect)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2.0

        // Update the overlay's frame if it exists
        overlayView?.frame = bounds
    }
}

public extension CircleView {
    @discardableResult
    func frame(width: CGFloat, height: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func overlay(_ overlay: (UIView) -> Void) -> Self {
        let overlayView = UIView()
        overlay(overlayView)
        
        addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return self
    }
    
    @discardableResult
    func fill(_ color: UIColor) -> CircleView {
        fillColor = color
        return self
    }
    
    @discardableResult
    func shadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
        return self
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    @discardableResult
    func stroke(_ color: UIColor? = .black, style: StrokeStyle) -> CircleView {
        let borderStyle = BorderStyle(style)
        layer.borderColor = color?.cgColor
        layer.borderWidth = style.lineWidth
        
        if let shapeLayer = layer as? CAShapeLayer {
            shapeLayer.lineDashPattern = borderStyle.lineDashPattern
            shapeLayer.lineCap = borderStyle.lineCap
            shapeLayer.lineJoin = borderStyle.lineJoin
        }
        
        return self
    }
}

public struct StrokeStyle {
    public var lineWidth: CGFloat = 1.0
    public var lineDashPattern: [NSNumber]? = nil
    public var lineCap: CAShapeLayerLineCap = .butt
    public var lineJoin: CAShapeLayerLineJoin = .miter

    public init(_ builder: (inout StrokeStyle) -> Void) {
        builder(&self)
    }
}

public struct BorderStyle {
    let lineWidth: CGFloat
    let lineDashPattern: [NSNumber]?
    let lineCap: CAShapeLayerLineCap
    let lineJoin: CAShapeLayerLineJoin

    public init(_ style: StrokeStyle) {
        self.lineWidth = style.lineWidth
        self.lineDashPattern = style.lineDashPattern
        self.lineCap = style.lineCap
        self.lineJoin = style.lineJoin
    }
}

