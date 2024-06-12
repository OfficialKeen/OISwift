//
//  CheckView.swift
//  OISwift
//
//  Created by keenoi on 19/05/24.
//

/*import UIKit

@IBDesignable
open class UICheckBox: UIControl {
    
    // MARK: - Properties
    
    public enum Style {
        case square
        case circle
        case cross
        case tick
    }
    
    public enum BorderStyle {
        case square
        case roundedSquare(radius: CGFloat)
        case rounded
    }
    
    private var style: Style = .circle
    private var borderStyle: BorderStyle = .roundedSquare(radius: 8)
    private var borderWidth: CGFloat = 1.75
    private var checkmarkSize: CGFloat = 0.5
    private var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    private var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    private var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    private var checkboxBackgroundColor: UIColor = .white
    private var increasedTouchRadius: CGFloat = 5
    private var useHapticFeedback: Bool = true
    private var isChecked: Bool = false {
        didSet {
            setNeedsDisplay()
            sendActions(for: .valueChanged)
            if useHapticFeedback {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    @discardableResult
    public func style(_ style: Style) -> UICheckBox {
        self.style = style
        return self
    }
    
    @discardableResult
    public func borderStyle(_ borderStyle: BorderStyle) -> UICheckBox {
        self.borderStyle = borderStyle
        return self
    }
    
    @discardableResult
    public func borderWidth(_ width: CGFloat) -> UICheckBox {
        borderWidth = width
        return self
    }
    
    @discardableResult
    public func checkmarkSize(_ size: CGFloat) -> UICheckBox {
        checkmarkSize = size
        return self
    }

    @discardableResult
    public func uncheckedBorderColor(_ color: UIColor) -> UICheckBox {
        uncheckedBorderColor = color
        return self
    }

    @discardableResult
    public func uncheckedBorderColor(_ hex: UInt32) -> UICheckBox {
        return uncheckedBorderColor(UIColor(hex: hex))
    }

    @discardableResult
    public func checkedBorderColor(_ color: UIColor) -> UICheckBox {
        checkedBorderColor = color
        return self
    }

    @discardableResult
    public func checkedBorderColor(_ hex: UInt32) -> UICheckBox {
        return checkedBorderColor(UIColor(hex: hex))
    }

    @discardableResult
    public func checkmarkColor(_ color: UIColor) -> UICheckBox {
        checkmarkColor = color
        return self
    }

    @discardableResult
    public func checkmarkColor(_ hex: UInt32) -> UICheckBox {
        return checkmarkColor(UIColor(hex: hex))
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor) -> UICheckBox {
        checkboxBackgroundColor = color
        return self
    }

    @discardableResult
    public func backgroundColor(_ hex: UInt32) -> UICheckBox {
        return backgroundColor(UIColor(hex: hex))
    }
    
    @discardableResult
    public func increasedTouchRadius(_ radius: CGFloat) -> UICheckBox {
        increasedTouchRadius = radius
        return self
    }
    
    @discardableResult
    public func useHapticFeedback(_ use: Bool) -> UICheckBox {
        useHapticFeedback = use
        return self
    }
    
    @discardableResult
    public func isChecked(_ checked: Bool) -> UICheckBox {
        isChecked = checked
        return self
    }
    
    @discardableResult
    public func isChecked(_ state: SBinding<Bool>) -> Self {
        self.isChecked = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isChecked = newValue
        }
        return self
    }
    
    @discardableResult
    public func valueChanged(_ action: @escaping (Bool) -> Void) -> UICheckBox {
        addTarget(self, action: #selector(valueChangedHandler(_:)), for: .valueChanged)
        valueChangedAction = action
        return self
    }
    
    private var valueChangedAction: ((Bool) -> Void)?
    
    @objc private func valueChangedHandler(_ sender: UICheckBox) {
        valueChangedAction?(sender.isChecked)
    }
    
    // MARK: - Touch Handling
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isChecked = !isChecked
    }
    
    // MARK: - Drawing

    open override func draw(_ rect: CGRect) {
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        var shapePath: UIBezierPath!
        switch borderStyle {
        case .square:
            shapePath = UIBezierPath(rect: newRect)
        case .roundedSquare(let radius):
            shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        case .rounded:
            shapePath = UIBezierPath(ovalIn: newRect)
        }
        
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        if isChecked {
            switch style {
            case .square:
                drawInnerSquare(frame: newRect)
            case .circle:
                drawCircle(frame: newRect)
            case .cross:
                drawCross(frame: newRect)
            case .tick:
                drawCheckMark(frame: newRect)
            }
        }
    }

    private func drawCheckMark(frame: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }

    private func drawCircle(frame: CGRect) {
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkmarkColor.setFill()
        ovalPath.fill()
    }

    private func drawInnerSquare(frame: CGRect) {
        let padding = bounds.width * 0.3
        let innerRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)
        checkmarkColor.setFill()
        rectanglePath.fill()
    }

    private func drawCross(frame: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        let group: CGRect = CGRect(x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5), y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02)
        
        context.saveGState()
        context.translateBy(x: group.minX + 14.91, y: group.minY)
        context.rotate(by: 35 * CGFloat.pi/180)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        context.saveGState()
        context.translateBy(x: group.minX, y: group.minY + 1.72)
        context.rotate(by: -35 * CGFloat.pi/180)
        
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()
    }
}

extension UICheckBox {
    @discardableResult
    public func isEnabled(_ isEnabled: Bool = true) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
    
    @discardableResult
    public func defaultStyle(_ style: Style) -> Self {
        switch style {
        case .square:
            self.squareStyle()
        case .circle:
            // Set code for circle style
            self.circleStyle()
        case .cross:
            // Set code for cross style
            self.crossStyle()
        case .tick:
            self.tickStyle()
        }
        return self
    }
    
    @discardableResult
    func squareStyle(style: UICheckBox.Style = .square,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: UICheckBox.BorderStyle = .roundedSquare(radius: 20.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> UICheckBox {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func circleStyle(style: UICheckBox.Style = .circle,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: UICheckBox.BorderStyle = .roundedSquare(radius: 20.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> UICheckBox {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func crossStyle(style: UICheckBox.Style = .cross,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: UICheckBox.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> UICheckBox {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func tickStyle(style: UICheckBox.Style = .tick,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: UICheckBox.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> UICheckBox {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func customStyle(style: UICheckBox.Style = .tick,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: UICheckBox.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> UICheckBox {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
}*/


import UIKit

@IBDesignable
public class CheckView: UIControl {
    
    // MARK: - Properties
    
    public enum Style {
        case square
        case circle
        case cross
        case tick
    }
    
    public enum BorderStyle {
        case square
        case roundedSquare(radius: CGFloat)
        case rounded
    }
    
    private var style: Style = .circle
    private var borderStyle: BorderStyle = .roundedSquare(radius: 8)
    private var borderWidth: CGFloat = 1.75
    private var checkmarkSize: CGFloat = 0.5
    private var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    private var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    private var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    private var checkboxBackgroundColor: UIColor = .white
    private var increasedTouchRadius: CGFloat = 5
    private var useHapticFeedback: Bool = true
    private var isChecked: Bool = false {
        didSet {
            setNeedsDisplay()
            sendActions(for: .valueChanged)
            if useHapticFeedback {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    @discardableResult
    public func style(_ style: Style) -> CheckView {
        self.style = style
        return self
    }
    
    @discardableResult
    public func borderStyle(_ borderStyle: BorderStyle) -> CheckView {
        self.borderStyle = borderStyle
        return self
    }
    
    @discardableResult
    public func borderWidth(_ width: CGFloat) -> CheckView {
        borderWidth = width
        return self
    }
    
    @discardableResult
    public func checkmarkSize(_ size: CGFloat) -> CheckView {
        checkmarkSize = size
        return self
    }

    @discardableResult
    public func uncheckedBorderColor(_ color: UIColor) -> CheckView {
        uncheckedBorderColor = color
        return self
    }

    @discardableResult
    public func uncheckedBorderColor(_ hex: UInt32) -> CheckView {
        return uncheckedBorderColor(UIColor(hex: hex))
    }

    @discardableResult
    public func checkedBorderColor(_ color: UIColor) -> CheckView {
        checkedBorderColor = color
        return self
    }

    @discardableResult
    public func checkedBorderColor(_ hex: UInt32) -> CheckView {
        return checkedBorderColor(UIColor(hex: hex))
    }

    @discardableResult
    public func checkmarkColor(_ color: UIColor) -> CheckView {
        checkmarkColor = color
        return self
    }

    @discardableResult
    public func checkmarkColor(_ hex: UInt32) -> CheckView {
        return checkmarkColor(UIColor(hex: hex))
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor) -> CheckView {
        checkboxBackgroundColor = color
        return self
    }

    @discardableResult
    public func backgroundColor(_ hex: UInt32) -> CheckView {
        return backgroundColor(UIColor(hex: hex))
    }
    
    @discardableResult
    public func increasedTouchRadius(_ radius: CGFloat) -> CheckView {
        increasedTouchRadius = radius
        return self
    }
    
    @discardableResult
    public func useHapticFeedback(_ use: Bool) -> CheckView {
        useHapticFeedback = use
        return self
    }
    
    @discardableResult
    public func isChecked(_ checked: Bool) -> CheckView {
        isChecked = checked
        return self
    }
    
    @discardableResult
    public func isChecked(_ state: SBinding<Bool>) -> Self {
        self.isChecked = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isChecked = newValue
        }
        return self
    }
    
    @discardableResult
    public func valueChanged(_ action: @escaping (Bool) -> Void) -> CheckView {
        addTarget(self, action: #selector(valueChangedHandler(_:)), for: .valueChanged)
        valueChangedAction = action
        return self
    }
    
    @discardableResult
    public func frame(width: CGFloat, height: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func isHidden(_ bool: Bool = true) -> Self {
        self.isHidden = bool
        return self
    }
    
    @discardableResult
    public func isHidden(_ state: SBinding<Bool>) -> Self {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    private var valueChangedAction: ((Bool) -> Void)?
    
    @objc private func valueChangedHandler(_ sender: CheckView) {
        valueChangedAction?(sender.isChecked)
    }
    
    // MARK: - Touch Handling
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isChecked = !isChecked
    }
    
    // MARK: - Drawing

    open override func draw(_ rect: CGRect) {
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        var shapePath: UIBezierPath!
        switch borderStyle {
        case .square:
            shapePath = UIBezierPath(rect: newRect)
        case .roundedSquare(let radius):
            shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        case .rounded:
            shapePath = UIBezierPath(ovalIn: newRect)
        }
        
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        if isChecked {
            switch style {
            case .square:
                drawInnerSquare(frame: newRect)
            case .circle:
                drawCircle(frame: newRect)
            case .cross:
                drawCross(frame: newRect)
            case .tick:
                drawCheckMark(frame: newRect)
            }
        }
    }

    private func drawCheckMark(frame: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }

    private func drawCircle(frame: CGRect) {
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkmarkColor.setFill()
        ovalPath.fill()
    }

    private func drawInnerSquare(frame: CGRect) {
        let padding = bounds.width * 0.3
        let innerRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)
        checkmarkColor.setFill()
        rectanglePath.fill()
    }

    private func drawCross(frame: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        let group: CGRect = CGRect(x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5), y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02)
        
        context.saveGState()
        context.translateBy(x: group.minX + 14.91, y: group.minY)
        context.rotate(by: 35 * CGFloat.pi/180)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        context.saveGState()
        context.translateBy(x: group.minX, y: group.minY + 1.72)
        context.rotate(by: -35 * CGFloat.pi/180)
        
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()
    }
}

extension CheckView {
    @discardableResult
    public func isEnabled(_ isEnabled: Bool = true) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
    
    @discardableResult
    public func defaultStyle(_ style: Style) -> Self {
        switch style {
        case .square:
            self.squareStyle()
        case .circle:
            // Set code for circle style
            self.circleStyle()
        case .cross:
            // Set code for cross style
            self.crossStyle()
        case .tick:
            self.tickStyle()
        }
        return self
    }
    
    @discardableResult
    public func squareStyle(style: CheckView.Style = .square,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: CheckView.BorderStyle = .roundedSquare(radius: 20.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> CheckView {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func circleStyle(style: CheckView.Style = .circle,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: CheckView.BorderStyle = .roundedSquare(radius: 20.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> CheckView {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func crossStyle(style: CheckView.Style = .cross,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: CheckView.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> CheckView {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func tickStyle(style: CheckView.Style = .tick,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: CheckView.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> CheckView {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func customStyle(style: CheckView.Style = .tick,
                             borderWidth: CGFloat = 1.0,
                             borderColor: UIColor = .clear,
                             checkColorHex: UInt32 = 0x4D9BFF,
                             uncheckColorHex: UInt32 = 0x777777,
                             borderStyle: CheckView.BorderStyle = .roundedSquare(radius: 5.0),
                             width: CGFloat = 20,
                             height: CGFloat = 20,
                             isChecked: Bool = false,
                             isEnabled: Bool = true) -> CheckView {
        let disableColor = UIColor(hex: 0xE0E0E0)
        let checkColor = UIColor(hex: checkColorHex)
        let uncheckColor = UIColor(hex: uncheckColorHex)
        
        self.style = style
        self.borderWidth = borderWidth
        self.checkboxBackgroundColor = checkColor
        self.uncheckedBorderColor = isEnabled ? uncheckColor : disableColor
        self.checkmarkColor = isEnabled ? checkColor : disableColor
        self.checkedBorderColor = isEnabled ? checkColor : disableColor
        self.borderStyle = borderStyle
        self.frame(width: width, height: height)
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        return self
    }
}
