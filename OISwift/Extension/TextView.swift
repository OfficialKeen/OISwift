//
//  TextView.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

/*import UIKit

extension UITextView {
    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    public func foregroundColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    public func tintColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat = 16, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])

        self.font = UIFont(descriptor: fontDescriptor, size: size)
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = UIFont.preferredFont(forTextStyle: style)
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.textContainerInset = insets
        return self
    }
    
    private var placeholderLabel: UILabel? {
        return self.viewWithTag(100) as? UILabel
    }
    
    @discardableResult
    func placeholder(_ text: String, fontSize: CGFloat? = nil, font: UIFont? = nil, position: CGPoint) -> Self {
        let placeholderLabel = UILabel()
        placeholderLabel.font = font ?? self.font // Gunakan font default jika tidak diberikan
        placeholderLabel.textColor = UIColor.purple
        placeholderLabel.text = text
        placeholderLabel.font = placeholderLabel.font.withSize(fontSize ?? 16) // Gunakan ukuran font default 17 jika tidak diberikan
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = position // Mengatur posisi placeholder sesuai parameter
        placeholderLabel.tag = 100 // for accessing the placeholder label later
        self.addSubview(placeholderLabel)
        
        // Menambahkan observer untuk notifikasi ketika teks berubah
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        return self
    }
    
    @objc private func textDidChange() {
        // Sembunyikan placeholder jika terdapat teks
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}*/

/*import UIKit

public class TextView: UITextView, UITextViewDelegate {
    private var textBinding: SBinding<String>?
    // MARK: - Private properties
    private var onChangeHandler: ((UITextView) -> Void)?
    private weak var externalDelegate: UITextViewDelegate?
    private var placeholderLabel: UILabel?
    private var paddingInset: UIEdgeInsets = .zero
    
    // MARK: - Init
    public init() {
        super.init(frame: .zero, textContainer: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.delegate = self
        self.backgroundColor = .clear
        self.font = UIFont.systemFont(ofSize: 15)
        self.isScrollEnabled = true
        self.textContainerInset = paddingInset
    }
    
    // MARK: - Public chainable modifiers
    
    @discardableResult
    public func text(_ binding: SBinding<String>) -> Self {
        self.textBinding = binding
        self.text = binding.wrappedValue
        return self
    }
    
    @discardableResult
    public func text(_ value: String) -> Self {
        self.text = value
        return self
    }
    
    @discardableResult
    public func placeholder(_ value: String, color: UIColor = .lightGray) -> Self {
        if placeholderLabel == nil {
            let label = UILabel()
            label.font = self.font
            label.textColor = color
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: textContainerInset.top + 2),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textContainerInset.left + 5),
                label.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -textContainerInset.right - 5)
            ])
            placeholderLabel = label
        }
        placeholderLabel?.text = value
        placeholderLabel?.isHidden = !(self.text?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        placeholderLabel?.font = self.font
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func border(width: CGFloat, color: UIColor) -> Self {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    public func padding(_ inset: CGFloat) -> Self {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return padding(insets)
    }
    
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        self.textContainerInset = insets
        self.paddingInset = insets
        placeholderLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top + 2).isActive = true
        placeholderLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left + 5).isActive = true
        return self
    }
    
    @discardableResult
    public func onChange(_ action: @escaping (UITextView) -> Void) -> Self {
        self.onChangeHandler = action
        self.delegate = self
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextViewDelegate) -> Self {
        self.externalDelegate = delegate
        return self
    }
    
    // MARK: - UITextViewDelegate
    public func textViewDidChange(_ textView: UITextView) {
        textBinding?.wrappedValue = textView.text
        placeholderLabel?.isHidden = !textView.text.isEmpty
        onChangeHandler?(textView)
        externalDelegate?.textViewDidChange?(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        externalDelegate?.textViewDidBeginEditing?(textView)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        externalDelegate?.textViewDidEndEditing?(textView)
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat = 16, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])

        self.font = UIFont(descriptor: fontDescriptor, size: size)
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = UIFont.preferredFont(forTextStyle: style)
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
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
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat) -> Self {
        layer.maskedCorners = []
        
        if corner.contains(.topLeft) {
            layer.maskedCorners.insert(.layerMinXMinYCorner)
        }
        
        if corner.contains(.bottomLeft) {
            layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }
        
        if corner.contains(.topRight) {
            layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        
        if corner.contains(.bottomRight) {
            layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
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
    public func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    @discardableResult
    public func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func placeholder(_ text: String, fontSize: CGFloat? = nil, font: UIFont? = nil, position: CGPoint) -> Self {
        let placeholderLabel = UILabel()
        placeholderLabel.font = font ?? self.font
        placeholderLabel.textColor = UIColor.purple
        placeholderLabel.text = text
        placeholderLabel.font = placeholderLabel.font.withSize(fontSize ?? 16)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = position
        placeholderLabel.tag = 100
        self.addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        return self
    }
    
    @objc private func textDidChange() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}*/

import UIKit

public class TextView: UITextView, UITextViewDelegate {
    private var textBinding: SBinding<String>?
    private var editableBinding: SBinding<Bool>?
    // MARK: - Private properties
    private var onChangeHandler: ((UITextView) -> Void)?
    private weak var externalDelegate: UITextViewDelegate?
    private var placeholderLabel: UILabel?
    private var paddingInset: UIEdgeInsets = .zero
    
    // MARK: - Init
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.delegate = self
        self.backgroundColor = .clear
        self.font = UIFont.systemFont(ofSize: 15)
        self.isScrollEnabled = true
        self.textContainerInset = paddingInset
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        // remove binding handler to avoid retain cycles
        textBinding?.didSet = nil
        editableBinding?.didSet = nil
    }
    
    // MARK: - Public chainable modifiers
    
    @discardableResult
    public func text(_ binding: SBinding<String>) -> Self {
        // clear previous handler
        textBinding?.didSet = nil
        
        self.textBinding = binding
        self.text = binding.wrappedValue
        // observe perubahan dari binding (misal diubah oleh TextField atau logic luar)
        binding.didSet = { [weak self] newValue in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.text != newValue {
                    // Set text programmatically without triggering extra behaviors
                    self.text = newValue
                    self.placeholderLabel?.isHidden = !newValue.isEmpty
                }
            }
        }
        return self
    }
    
    @discardableResult
    public func text(_ value: String) -> Self {
        self.text = value
        placeholderLabel?.isHidden = !value.isEmpty
        return self
    }
    
    @discardableResult
    public func placeholder(_ value: String, color: UIColor = .lightGray) -> Self {
        if placeholderLabel == nil {
            let label = UILabel()
            label.font = self.font
            label.textColor = color
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: textContainerInset.top + 2),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textContainerInset.left + 5),
                label.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -textContainerInset.right - 5)
            ])
            placeholderLabel = label
        }
        placeholderLabel?.text = value
        placeholderLabel?.isHidden = !(self.text?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        placeholderLabel?.font = self.font
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func border(width: CGFloat, color: UIColor) -> Self {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    public func padding(_ inset: CGFloat) -> Self {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return padding(insets)
    }
    
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        self.textContainerInset = insets
        self.paddingInset = insets
        // Update placeholder constraints if placeholderLabel exists
        if let label = placeholderLabel {
            // Deactivate existing top/leading constraints then add new ones would be ideal,
            // but to keep API stable, we activate additional constraints which are consistent with prior anchors.
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top + 2).isActive = true
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left + 5).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func onChange(_ action: @escaping (UITextView) -> Void) -> Self {
        self.onChangeHandler = action
        self.delegate = self
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextViewDelegate) -> Self {
        self.externalDelegate = delegate
        return self
    }
    
    // MARK: - UITextViewDelegate
    public func textViewDidChange(_ textView: UITextView) {
        // update binding ketika user mengetik
        textBinding?.wrappedValue = textView.text
        placeholderLabel?.isHidden = !textView.text.isEmpty
        onChangeHandler?(textView)
        externalDelegate?.textViewDidChange?(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        externalDelegate?.textViewDidBeginEditing?(textView)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        externalDelegate?.textViewDidEndEditing?(textView)
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        placeholderLabel?.font = font
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat = 16, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]
        
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])
        
        self.font = UIFont(descriptor: fontDescriptor, size: size)
        placeholderLabel?.font = self.font
        return self
    }
    
    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = UIFont.preferredFont(forTextStyle: style)
        placeholderLabel?.font = self.font
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
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
    
    // keep both cornerRadius overloads as in original API
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat) -> Self {
        layer.maskedCorners = []
        
        if corner.contains(.topLeft) {
            layer.maskedCorners.insert(.layerMinXMinYCorner)
        }
        
        if corner.contains(.bottomLeft) {
            layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }
        
        if corner.contains(.topRight) {
            layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        
        if corner.contains(.bottomRight) {
            layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
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
    public func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    @discardableResult
    public func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func placeholder(_ text: String, fontSize: CGFloat? = nil, font: UIFont? = nil, position: CGPoint) -> Self {
        if placeholderLabel == nil {
            let label = UILabel()
            label.font = font ?? self.font
            label.textColor = UIColor.purple
            label.text = text
            label.font = label.font.withSize(fontSize ?? 16)
            label.sizeToFit()
            label.frame.origin = position
            label.tag = 100
            label.translatesAutoresizingMaskIntoConstraints = true
            self.addSubview(label)
            placeholderLabel = label
        } else {
            placeholderLabel?.text = text
            placeholderLabel?.font = placeholderLabel?.font.withSize(fontSize ?? (placeholderLabel?.font.pointSize ?? 16))
            placeholderLabel?.frame.origin = position
            placeholderLabel?.isHidden = !self.text.isEmpty
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        return self
    }
    
    @objc private func textDidChangeNotification(_ note: Notification) {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }

    @discardableResult
    public func editable(_ flag: Bool = false) -> Self {
        editableBinding?.didSet = nil
        editableBinding = nil
        self.isEditable = flag
        return self
    }

    @discardableResult
    public func editable(_ state: SBinding<Bool>) -> Self {
        editableBinding?.didSet = nil
        editableBinding = state
        self.isEditable = state.wrappedValue
        state.didSet = { [weak self] newValue in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isEditable = newValue
            }
        }
        return self
    }
}
