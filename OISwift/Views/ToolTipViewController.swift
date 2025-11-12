//
//  ToolTipViewController.swift
//  OISwift
//
//  Created by keenoi on 16/08/25.
//

import UIKit

class ToolTipViewController: UIViewController {

    private weak var currentTooltip: TooltipView?
    
    var navLink = NavigationLinkView()
    var navLink2 = NavigationLinkView()
    var navLink3 = NavigationLinkView()
    var navLink4 = NavigationLinkView()
    var navLink5 = NavigationLinkView()
    var navLink6 = NavigationLinkView()
    var navLink7 = NavigationLinkView()
    var navLink8 = NavigationLinkView()
    var navLink9 = NavigationLinkView()
    
    @SBinding var addYears = "2025"
    
    private let button: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Tap me", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.VStack {
            Centered(.centerXY) {
                View().HStack {
                    navLink.content {
                        let tip = TooltipView(text: "Ini tooltip buatan sendiri 1",
                                              sourceView: self.navLink,
                                              orientation: .right)
                        tip.show(in: self.view)
                    } setup: {
                        navLink.VStack(alignment: .center) {
                            Text().text("Tap me 1").font(12, weight: .regular).foregroundColor(0x878787)
                        }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                    }
                    
                    navLink2.content {
                        let tip = TooltipView(text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri",
                                              sourceView: self.navLink2,
                                              orientation: .top)
                        tip.show(in: self.view)
                    } setup: {
                        navLink2.VStack(alignment: .center) {
                            Text().text("Tap me 2").font(12, weight: .regular).foregroundColor(0x878787)
                        }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                    }
                    
                    navLink3.content {
                        let tip = TooltipView(text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2",
                                              sourceView: self.navLink3,
                                              orientation: .bottom)
                        tip.show(in: self.view)
                    } setup: {
                        navLink3.VStack(alignment: .center) {
                            Text().text("Tap me 3").font(12, weight: .regular).foregroundColor(0x878787)
                        }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                    }
                    
                    navLink4.content {
                        let tip = TooltipView(text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2",
                                              sourceView: self.navLink4,
                                              orientation: .left)
                        tip.show(in: self.view)
                    } setup: {
                        navLink4.VStack(alignment: .center) {
                            Text().text("Tap me 4").font(12, weight: .regular).foregroundColor(0x878787)
                        }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                    }
                    
                    navLink5.content {
                        let tip = TooltipView(text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2",
                                              sourceView: self.navLink5,
                                              orientation: .bottom)
                        tip.show(in: self.view)
                    } setup: {
                        navLink5.VStack(alignment: .center) {
                            Text().text("Tap me 5").font(12, weight: .regular).foregroundColor(0x878787)
                        }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                    }
                }
            }
            
            View().HStack {
                navLink6.content {
                    let tip = TooltipView(text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2",
                                          sourceView: self.navLink6,
                                          orientation: .right)
                    tip.show(in: self.view)
                } setup: {
                    navLink6.VStack(alignment: .center) {
                        Text().text("Tap me 6").font(12, weight: .regular).foregroundColor(0x878787)
                    }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                }
                Spacer()
                navLink7.content {
                    TooltipView.show(
                        sourceView: self.navLink7,
                        orientation: .top,
                        in: self.view
                    ) {
                        View().HStack(spacing: 20) {
                            View().VStack(spacing: 10) {
                                Text().text("Keen").font(12).multilineTextAlignment(.left).foregroundColor(.black)
                                Text().text("Ini tooltip Ini tooltip buatan sendiri").font(10).multilineTextAlignment(.left).foregroundColor(.black)
                            }
                        }
                    }.background(.systemTeal, opacity: 0.4)
                    /*TooltipView.show(
                        text: "Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip \nIni tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2 Ini tooltip buatan sendiri 2",
                        sourceView: self.navLink7,          // view yang ditunjuk
                        orientation: .left,
                        in: self.view                  // view tempat tooltip muncul
                    )*/
                } setup: {
                    navLink7.VStack(alignment: .center) {
                        Text().text("Tap me 7").font(12, weight: .regular).foregroundColor(0x878787)
                    }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                }
            }
            
            View().HStack {
                navLink8.content {
                    let addYearsTemp = "Lahir Tahun" + " \(self.addYears)"
                    TooltipView.show(text: addYearsTemp,
                        sourceView: self.navLink8,
                        orientation: .top,
                        in: self.view
                    ).background(.white).shadow(color: 0x333333, radius: 4, opacity: 0.2, offset: CGSize(width: 0, height: 2)).foregroundColor(.black).font(12)
                } setup: {
                    navLink8.VStack(alignment: .center) {
                        Text().text("+").font(12, weight: .regular).foregroundColor(0x878787)
                    }.height(28).padding(.horizontal, 18).stroke(0x878787, lineWidth: 1).cornerRadius(14)
                }
                Spacer()
            }
            Spacer()
        }.padding(UIDevice.current.userInterfaceIdiom == .pad ? 144 : 16)
    }

    @objc private func handleTap() {
        
    }
}

import UIKit

final class TooltipView: UIView {

    // MARK: - Properties
    private let text: String
    private let sourceView: UIView
    private let orientation: Orientation
    private let arrowSize = CGSize(width: 14, height: 8)
    private var arrowColor: UIColor = UIColor(white: 0.15, alpha: 0.9)
    private let contentBuilder: (() -> UIView)?

    enum Orientation { case top, bottom, left, right }

    // MARK: - UI
    private let label = UILabel()
    private let arrowLayer = CAShapeLayer()

    // MARK: - Init lama (label teks)
    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top) {
        self.text           = text
        self.sourceView     = sourceView
        self.orientation    = orientation
        self.contentBuilder = nil
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Init baru (custom UIView)
    init(sourceView: UIView,
         orientation: Orientation = .top,
         contentBuilder: @escaping () -> UIView) {
        self.text            = ""
        self.sourceView      = sourceView
        self.orientation     = orientation
        self.contentBuilder  = contentBuilder
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Content
        if let innerView = contentBuilder?() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            innerView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(innerView)

            let maxRatio: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.25 : 0.8
            let maxW = UIScreen.main.bounds.width * maxRatio - 24
            NSLayoutConstraint.activate([
                innerView.topAnchor     .constraint(equalTo: container.topAnchor),
                innerView.bottomAnchor  .constraint(equalTo: container.bottomAnchor),
                innerView.leadingAnchor .constraint(equalTo: container.leadingAnchor),
                innerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                container.widthAnchor.constraint(lessThanOrEqualToConstant: maxW)
            ])

            addSubview(container)
            NSLayoutConstraint.activate([
                container.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                container.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(container)
        } else {
            label.textColor     = .white
            label.font          = .systemFont(ofSize: 12, weight: .regular)
            label.numberOfLines = 0
            label.text          = text
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                label.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(label)
        }

        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelf)))
        arrowLayer.fillColor = arrowColor.cgColor
        layer.addSublayer(arrowLayer)
    }

    // MARK: - Show
    func show(in container: UIView) {
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        container.addSubview(self)
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        let maxRatio: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.8
        let maxWidth = min(UIScreen.main.bounds.width * maxRatio,
                           container.bounds.width - 32)
        label.preferredMaxLayoutWidth = maxWidth
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        let sourceRect = sourceView.convert(sourceView.bounds, to: container)
        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - arrowSize.height
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + arrowSize.height
        case .left:
            x = sourceRect.minX - size.width - arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        case .right:
            x = sourceRect.maxX + arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        }

        x = max(16, min(x, container.bounds.width  - size.width  - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))
        frame.origin = CGPoint(x: x, y: y)

        drawArrow()

        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    // MARK: - Arrow (flexible)
    private func drawArrow() {
        guard let container = superview else { return }
        let sourceCenter = sourceView.convert(sourceView.bounds, to: container).center
        let arrowBase = convert(sourceCenter, from: container)

        let aw = arrowSize.width
        let ah = arrowSize.height
        let path = UIBezierPath()

        switch orientation {
        case .top:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.maxY))
            path.addLine(to: CGPoint(x: x, y: bounds.maxY + ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.maxY))
        case .bottom:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.minY))
            path.addLine(to: CGPoint(x: x, y: bounds.minY - ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.minY))
        case .left:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.maxX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.maxX + ah, y: y))
            path.addLine(to: CGPoint(x: bounds.maxX, y: y + aw/2))
        case .right:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.minX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.minX - ah, y: y))
            path.addLine(to: CGPoint(x: bounds.minX, y: y + aw/2))
        }
        path.close()
        arrowLayer.path = path.cgPath
    }

    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
    
    @discardableResult
    static func show(text: String,
                     sourceView: UIView,
                     orientation: Orientation = .top,
                     in container: UIView) -> TooltipView {
        let tip = TooltipView(text: text,
                              sourceView: sourceView,
                              orientation: orientation)
        tip.show(in: container)
        return tip
    }

    @discardableResult
    static func show(sourceView: UIView,
                     orientation: Orientation = .top,
                     in container: UIView,
                     contentBuilder: @escaping () -> UIView) -> TooltipView {
        let tip = TooltipView(sourceView: sourceView,
                              orientation: orientation,
                              contentBuilder: contentBuilder)
        tip.show(in: container)
        return tip
    }
}

extension TooltipView {
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        label.textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        label.textColor = color
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])

        label.font = UIFont(descriptor: fontDescriptor, size: size)
        return self
    }
    
    @discardableResult
    func background(_ color: UIColor) -> Self {
        backgroundColor = color
        
        arrowColor = color
        arrowLayer.fillColor = color.cgColor
        return self
    }
    
    @discardableResult
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        
        backgroundColor = color
        
        arrowColor = color
        arrowLayer.fillColor = color.cgColor
        return self
    }
    
    @discardableResult
    func background(_ color: UIColor, opacity: CGFloat = 1.0) -> Self {
        let final = color.withAlphaComponent(opacity)
        backgroundColor = final
        arrowLayer.fillColor = final.cgColor
        return self
    }
    
    @discardableResult
    func background(_ hex: UInt, opacity: CGFloat = 1.0) -> Self {
        let color = UIColor(hex: UInt32(hex)).withAlphaComponent(opacity)
        backgroundColor = color
        arrowLayer.fillColor = color.cgColor
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat = 10) -> Self {
        layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    public func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func shadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    public func shadow(color: UInt, radius: CGFloat, opacity: Float, offset: CGSize) -> Self {
        let hexColor = UIColor(hex: UInt32(color))
        layer.shadowColor = hexColor.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func arrowColor(_ color: UIColor) -> Self {
        arrowColor = color
        arrowLayer.fillColor = color.cgColor
        return self
    }
}

private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

/*
import UIKit

final class TooltipView: UIView {

    // MARK: - Properties
    private let text: String
    private let sourceView: UIView
    private let orientation: Orientation
    private let arrowSize = CGSize(width: 14, height: 8)
    private let contentBuilder: (() -> UIView)?

    enum Orientation { case top, bottom, left, right }

    // MARK: - UI
    private let label = UILabel()
    private let arrowLayer = CAShapeLayer()

    // MARK: - Init lama (label teks)
    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top) {
        self.text           = text
        self.sourceView     = sourceView
        self.orientation    = orientation
        self.contentBuilder = nil
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Init baru (custom UIView via closure)
    init(sourceView: UIView,
         orientation: Orientation = .top,
         contentBuilder: @escaping () -> UIView) {
        self.text            = ""
        self.sourceView      = sourceView
        self.orientation     = orientation
        self.contentBuilder  = contentBuilder
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Content
        if let innerView = contentBuilder?() {
            // pembungkus container
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            innerView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(innerView)

            // batas lebar 80 % layar
            //let maxW = UIScreen.main.bounds.width * 0.25 - 24
            let maxRatio: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.25 : 0.8
            let maxW = UIScreen.main.bounds.width * maxRatio - 24
            NSLayoutConstraint.activate([
                innerView.topAnchor     .constraint(equalTo: container.topAnchor),
                innerView.bottomAnchor  .constraint(equalTo: container.bottomAnchor),
                innerView.leadingAnchor .constraint(equalTo: container.leadingAnchor),
                innerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                container.widthAnchor.constraint(lessThanOrEqualToConstant: maxW)
            ])

            addSubview(container)
            NSLayoutConstraint.activate([
                container.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                container.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(container)
        } else {
            // fallback ke label lama
            label.textColor     = .white
            label.font          = .systemFont(ofSize: 14, weight: .medium)
            label.numberOfLines = 0
            label.text          = text
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                label.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(label)
        }

        // Shadow
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        // Tap to dismiss
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelf)))

        // Arrow layer
        arrowLayer.fillColor = backgroundColor?.cgColor
        layer.addSublayer(arrowLayer)
    }

    // MARK: - Show
    func show(in container: UIView) {
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        container.addSubview(self)
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        let maxWidth = min(container.bounds.width * 0.8,
                           container.bounds.width - 32)
        label.preferredMaxLayoutWidth = maxWidth
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        let sourceRect = sourceView.convert(sourceView.bounds, to: container)
        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - arrowSize.height
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + arrowSize.height
        case .left:
            x = sourceRect.minX - size.width - arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        case .right:
            x = sourceRect.maxX + arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        }

        x = max(16, min(x, container.bounds.width  - size.width  - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))
        frame.origin = CGPoint(x: x, y: y)

        drawArrow()

        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    // MARK: - Arrow (flexible)
    private func drawArrow() {
        guard let container = superview else { return }
        let sourceCenter = sourceView.convert(sourceView.bounds, to: container).center
        let arrowBase = convert(sourceCenter, from: container)

        let aw = arrowSize.width
        let ah = arrowSize.height
        let path = UIBezierPath()

        switch orientation {
        case .top:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.maxY))
            path.addLine(to: CGPoint(x: x, y: bounds.maxY + ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.maxY))
        case .bottom:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.minY))
            path.addLine(to: CGPoint(x: x, y: bounds.minY - ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.minY))
        case .left:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.maxX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.maxX + ah, y: y))
            path.addLine(to: CGPoint(x: bounds.maxX, y: y + aw/2))
        case .right:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.minX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.minX - ah, y: y))
            path.addLine(to: CGPoint(x: bounds.minX, y: y + aw/2))
        }
        path.close()
        arrowLayer.path = path.cgPath
    }

    // MARK: - Dismiss
    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
}

private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}*/

/*
import UIKit

final class TooltipView: UIView {

    // MARK: - Init
    private let text: String
    private let sourceView: UIView
    private let orientation: Orientation
    private let arrowSize = CGSize(width: 14, height: 8)
    private let contentBuilder: (() -> UIView)?   // 👈 tambahan

    enum Orientation {
        case top, bottom, left, right
    }

    // MARK: - UI
    private let label = UILabel()
    private let arrowLayer = CAShapeLayer()

    // MARK: - Init lama (label teks)
    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top) {
        self.text           = text
        self.sourceView     = sourceView
        self.orientation    = orientation
        self.contentBuilder = nil
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Init baru (custom UIView)
    init(sourceView: UIView,
         orientation: Orientation = .top,
        contentBuilder: @escaping () -> UIView) {
        self.text            = ""
        self.sourceView      = sourceView
        self.orientation     = orientation
        self.contentBuilder  = contentBuilder
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Content
        if let contentView = contentBuilder?() {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                contentView.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(contentView)
        } else {
            // fallback ke label lama
            label.textColor     = .white
            label.font          = .systemFont(ofSize: 14, weight: .medium)
            label.numberOfLines = 0
            label.text          = text
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
                label.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            bringSubviewToFront(label)
        }

        // Shadow
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        // Tap to dismiss
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelf)))

        // Configure arrow layer
        arrowLayer.fillColor = backgroundColor?.cgColor
        layer.addSublayer(arrowLayer)
    }

    // MARK: - Show
    func show(in container: UIView) {
        // 1. Hapus tooltip lama
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        // 2. Tambahkan ke container
        container.addSubview(self)
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        // 3. Hitung ukuran
        let maxWidth = min(container.bounds.width * 0.8,
                           container.bounds.width - 32)
        label.preferredMaxLayoutWidth = maxWidth
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        // 4. Posisi
        let sourceRect = sourceView.convert(sourceView.bounds, to: container)
        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - arrowSize.height
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + arrowSize.height
        case .left:
            x = sourceRect.minX - size.width - arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        case .right:
            x = sourceRect.maxX + arrowSize.height
            y = sourceRect.midY - size.height / 2
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        }

        x = max(16, min(x, container.bounds.width  - size.width  - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))
        frame.origin = CGPoint(x: x, y: y)

        // 5. Gambar panah
        drawArrow()

        // 6. Animasi masuk
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        // 7. Auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    // MARK: - Arrow (flexible)
    private func drawArrow() {
        guard let container = superview else { return }
        let sourceCenter = sourceView.convert(sourceView.bounds, to: container).center
        let arrowBase = convert(sourceCenter, from: container)

        let aw = arrowSize.width
        let ah = arrowSize.height
        let path = UIBezierPath()

        switch orientation {
        case .top:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.maxY))
            path.addLine(to: CGPoint(x: x, y: bounds.maxY + ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.maxY))
        case .bottom:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.minY))
            path.addLine(to: CGPoint(x: x, y: bounds.minY - ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.minY))
        case .left:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.maxX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.maxX + ah, y: y))
            path.addLine(to: CGPoint(x: bounds.maxX, y: y + aw/2))
        case .right:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.minX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.minX - ah, y: y))
            path.addLine(to: CGPoint(x: bounds.minX, y: y + aw/2))
        }
        path.close()
        arrowLayer.path = path.cgPath
    }

    // MARK: - Dismiss
    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
}

// MARK: - Helper
private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}*/

/*
import UIKit

final class TooltipView: UIView {

    // MARK: - Init
    private let text: String
    private let sourceView: UIView
    private let orientation: Orientation
    private let arrowSize = CGSize(width: 14, height: 8)

    enum Orientation {
        case top, bottom, left, right
    }

    // MARK: - UI
    private let label = UILabel()
    private let arrowLayer = CAShapeLayer()

    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top) {
        self.text        = text
        self.sourceView  = sourceView
        self.orientation = orientation
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false

        // Label
        label.textColor     = .white
        label.font          = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.text          = text
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor    .constraint(equalTo: topAnchor,    constant: 8),
            label.bottomAnchor .constraint(equalTo: bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        // Pastikan label paling depan
        bringSubviewToFront(label)

        // Shadow
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        // Tap to dismiss
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelf)))

        // Configure arrow layer
        arrowLayer.fillColor = backgroundColor?.cgColor
        layer.addSublayer(arrowLayer)
    }

    // MARK: - Show
    func show(in container: UIView) {
        // 1. Hapus tooltip lama
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        // 2. Tambahkan ke container
        container.addSubview(self)
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        // 3. Hitung ukuran
        let maxWidth = min(container.bounds.width * 0.8,
                           container.bounds.width - 32)
        label.preferredMaxLayoutWidth = maxWidth
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        // 4. Posisi
        let sourceRect = sourceView.convert(sourceView.bounds, to: container)
        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - arrowSize.height
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + arrowSize.height
        case .left:
            x = sourceRect.minX - size.width - arrowSize.height
            // biarkan panah sejajar vertikal dengan source-view
            y = sourceRect.midY - size.height / 2
            
            // namun pastikan Tooltip tidak keluar layar (clamping)
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
            
        case .right:
            x = sourceRect.maxX + arrowSize.height
            y = sourceRect.midY - size.height / 2
            
            let minY: CGFloat = 16
            let maxY: CGFloat = container.bounds.height - size.height - 16
            y = max(minY, min(y, maxY))
        }

        x = max(16, min(x, container.bounds.width  - size.width  - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))
        frame.origin = CGPoint(x: x, y: y)
        // 5. Gambar panah
        drawArrow()

        // 6. Animasi masuk
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        // 7. Auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    // MARK: - Arrow (flexible)
    private func drawArrow() {
        // 1. Titik tengah sourceView dalam koordinat TooltipView
        let container = superview!
        let sourceCenter = sourceView.convert(sourceView.bounds, to: container).center
        let arrowBase = convert(sourceCenter, from: container)
        
        // 2. Tentukan posisi panah (clamp agar tetap di dalam TooltipView)
        let aw = arrowSize.width
        let ah = arrowSize.height
        
        let path = UIBezierPath()
        switch orientation {
        case .top:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.maxY))
            path.addLine(to: CGPoint(x: x, y: bounds.maxY + ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.maxY))
        case .bottom:
            let x = max(aw/2, min(arrowBase.x, bounds.maxX - aw/2))
            path.move(to: CGPoint(x: x - aw/2, y: bounds.minY))
            path.addLine(to: CGPoint(x: x, y: bounds.minY - ah))
            path.addLine(to: CGPoint(x: x + aw/2, y: bounds.minY))
        case .left:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.maxX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.maxX + ah, y: y))
            path.addLine(to: CGPoint(x: bounds.maxX, y: y + aw/2))
        case .right:
            let y = max(aw/2, min(arrowBase.y, bounds.maxY - aw/2))
            path.move(to: CGPoint(x: bounds.minX, y: y - aw/2))
            path.addLine(to: CGPoint(x: bounds.minX - ah, y: y))
            path.addLine(to: CGPoint(x: bounds.minX, y: y + aw/2))
        }
        path.close()
        arrowLayer.path = path.cgPath
    }

    // MARK: - Dismiss
    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
}
// Helper
private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}*/
/*import UIKit

final class TooltipView: UIView {

    // MARK: - Init
    private let text: String
    private let sourceView: UIView   // view yang jadi “tembok” penempelan
    private let orientation: Orientation

    enum Orientation {
        case top, bottom, left, right
    }

    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top) {
        self.text       = text
        self.sourceView = sourceView
        self.orientation = orientation
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor          = .white
        lbl.font               = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines      = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false

        label.text = text
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        // shadow
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        // tap-to-dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        addGestureRecognizer(tap)
    }

    func show(in container: UIView) {
        // 1. Pastikan tooltip lama dihapus
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        // 2. Tambahkan ke superview dulu
        container.addSubview(self)

        // 3. Layout dulu supaya size valid
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        // 4. Hitung ukuran tooltip
        let maxWidth = min(container.bounds.width * 0.8,
                           container.bounds.width - 32)   // 16 pt padding kiri-kanan
        label.preferredMaxLayoutWidth = maxWidth          // <─ tambahkan ini
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        // 5. Hitung posisi berdasarkan sourceView
        let sourceRect = sourceView.convert(sourceView.bounds, to: container)

        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - 8
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + 8
        case .left:
            x = sourceRect.minX - size.width - 8
            y = sourceRect.midY - size.height / 2
        case .right:
            x = sourceRect.maxX + 8
            y = sourceRect.midY - size.height / 2
        }

        // 6. Clamp supaya tidak keluar layar
        x = max(16, min(x, container.bounds.width - size.width - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))

        frame.origin = CGPoint(x: x, y: y)

        // 7. Animasi masuk
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        // 8. Auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
}*/

/*
import UIKit

final class TooltipView: UIView {

    // MARK: - Init
    private let text: String
    private let sourceView: UIView   // view yang jadi “tembok” penempelan
    private let orientation: Orientation

    enum Orientation {
        case top, bottom, left, right
    }

    init(text: String,
         sourceView: UIView,
         orientation: Orientation = .top,
         showIn container: UIView? = nil) {
        self.text       = text
        self.sourceView = sourceView
        self.orientation = orientation
        super.init(frame: .zero)
        setup()
        
        // kalau nilai showIn diberikan, langsung tampilkan
        if let container = container {
            show(in: container)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor          = .white
        lbl.font               = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines      = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false

        label.text = text
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        // shadow
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.3
        layer.shadowOffset  = CGSize(width: 0, height: 2)

        // tap-to-dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        addGestureRecognizer(tap)
    }

    func show(in container: UIView) {
        // 1. Pastikan tooltip lama dihapus
        container.subviews
            .compactMap { $0 as? TooltipView }
            .forEach { $0.removeFromSuperview() }

        // 2. Tambahkan ke superview dulu
        container.addSubview(self)

        // 3. Layout dulu supaya size valid
        container.layoutIfNeeded()
        translatesAutoresizingMaskIntoConstraints = true

        // 4. Hitung ukuran tooltip
        let maxWidth = min(container.bounds.width * 0.8,
                           container.bounds.width - 32)   // 16 pt padding kiri-kanan
        label.preferredMaxLayoutWidth = maxWidth          // <─ tambahkan ini
        let size = systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        frame.size = size

        // 5. Hitung posisi berdasarkan sourceView
        let sourceRect = sourceView.convert(sourceView.bounds, to: container)

        var x: CGFloat
        var y: CGFloat

        switch orientation {
        case .top:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.minY - size.height - 8
        case .bottom:
            x = sourceRect.midX - size.width / 2
            y = sourceRect.maxY + 8
        case .left:
            x = sourceRect.minX - size.width - 8
            y = sourceRect.midY - size.height / 2
        case .right:
            x = sourceRect.maxX + 8
            y = sourceRect.midY - size.height / 2
        }

        // 6. Clamp supaya tidak keluar layar
        x = max(16, min(x, container.bounds.width - size.width - 16))
        y = max(16, min(y, container.bounds.height - size.height - 16))

        frame.origin = CGPoint(x: x, y: y)

        // 7. Animasi masuk
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.transform = .identity
        }

        // 8. Auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dismissSelf()
        }
    }

    @objc private func dismissSelf() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                           self.alpha = 0
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }) { _ in
                           self.removeFromSuperview()
                       }
    }
}*/

