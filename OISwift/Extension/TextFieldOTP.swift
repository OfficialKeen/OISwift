//
//  TextFieldOTP.swift
//  OISwift
//
//  Created by keenoi on 12/09/25.
//


/*import UIKit

public final class TextFieldOTP: UITextField, UITextFieldDelegate {

    // MARK: - Configurable Properties (didSet → auto re-render)
    private var digitCount: Int = 6 { didSet { rebuild() } }
    private var borderWidth: CGFloat = 1 { didSet { restyle() } }
    private var borderColor: UIColor = .lightGray { didSet { restyle() } }
    private var activeBorderColor: UIColor?
    private var activeBorderWidth: CGFloat?
    private var cornerRadius: CGFloat = 6 { didSet { restyle() } }
    private var fontDigit: UIFont = .systemFont(ofSize: 20) { didSet { restyle() } }
    private var textColorDigit: UIColor = .label { didSet { restyle() } }
    private var secureDigit: Bool = false { didSet { refreshText() } }

    // MARK: - Event & Binding
    private var onEditingChangeAction: ((String) -> Void)?
    private var bindingStorage: SBinding<String>?

    // MARK: - UI Subviews
    private let stack = UIStackView()
    private var labels: [UILabel] = []
    private var labelIndex: [UILabel: Int] = [:]   // lookup indeks label

    // MARK: - Life-Cycle
    public override init(frame: CGRect) { super.init(frame: frame); common() }
    public required init?(coder: NSCoder) { super.init(coder: coder); common() }

    private func common() {
        delegate = self
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        // Tap area agar bisa focus
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tap)

        // Stack container
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        rebuild()
        // Auto-focus (opsional)
        DispatchQueue.main.async { _ = self.becomeFirstResponder() }
    }

    // MARK: - Public Chain-able API
    @discardableResult public func digits(_ count: Int) -> Self { digitCount = count; return self }
    @discardableResult public func border(width: CGFloat, color: UIColor) -> Self { borderWidth = width; borderColor = color; return self }
    @discardableResult public func borderActive(_ color: UIColor, width: CGFloat? = nil) -> Self { activeBorderColor = color; activeBorderWidth = width; return self }
    @discardableResult public func cornerRadius(_ r: CGFloat) -> Self { cornerRadius = r; return self }
    @discardableResult public func digitFont(_ f: UIFont) -> Self { fontDigit = f; return self }
    @discardableResult public func digitColor(_ c: UIColor) -> Self { textColorDigit = c; return self }
    @discardableResult public func secure(_ flag: Bool = true) -> Self { secureDigit = flag; return self }
    @discardableResult public func width(_ c: CGFloat) -> Self { widthAnchor.constraint(equalToConstant: c).isActive = true; return self }
    @discardableResult public func height(_ c: CGFloat) -> Self { heightAnchor.constraint(equalToConstant: c).isActive = true; return self }

    @discardableResult public func text(_ state: SBinding<String>) -> Self {
        bindingStorage = state
        self.text = state.wrappedValue
        refreshText()
        state.didSet = { [weak self] new in
            self?.text = new
            self?.refreshText()
        }
        addTarget(self, action: #selector(bindingChanged), for: .editingChanged)
        return self
    }
    @objc private func bindingChanged() { bindingStorage?.wrappedValue = self.text ?? "" }

    @discardableResult public func onEditingChange(_ action: @escaping (String) -> Void) -> Self {
        onEditingChangeAction = action
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return self
    }
    @objc private func editingChanged() { onEditingChangeAction?(text ?? "") }

    // MARK: - Rebuild & Style
    private func rebuild() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        labels.removeAll(); labelIndex.removeAll()
        for idx in 0..<digitCount {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            lbl.addGestureRecognizer(tap)
            lbl.tag = idx
            stack.addArrangedSubview(lbl)
            labels.append(lbl)
            labelIndex[lbl] = idx
        }
        restyle()
    }

    private func restyle() {
        labels.forEach {
            $0.font = fontDigit
            $0.textColor = textColorDigit
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }
        refreshText()
    }

    private func refreshText() {
        let txt = self.text ?? ""
        let display = secureDigit ? String(repeating: "•", count: txt.count) : txt

        // 🔍 Hitung posisi cursor yang bener
        let cursorIdx = currentCursorIndex

        for (idx, lbl) in labels.enumerated() {
            let isCurrentlyEditing = (idx == cursorIdx)
            let isFilled = idx < txt.count

            // 🔴 Kalau ini kotak yang lagi aktif → MERAH
            if isCurrentlyEditing {
                lbl.layer.borderColor = UIColor.gray.cgColor
                lbl.layer.borderWidth = 2
            } else {
                // ✅ Kalau sudah terisi → active color, kalau belum → default
                lbl.layer.borderColor = (isFilled ? activeBorderColor ?? borderColor : borderColor).cgColor
                lbl.layer.borderWidth = activeBorderWidth ?? borderWidth
            }

            // Update teks per kotak
            lbl.text = idx < display.count ? String(display[display.index(display.startIndex, offsetBy: idx)]) : nil
        }
    }
    
    private var currentCursorIndex: Int {
        guard let range = selectedTextRange else { return 0 }
        return offset(from: beginningOfDocument, to: range.start)
    }
    
    public override func caretRect(for position: UITextPosition) -> CGRect {
        let idx = currentCursorIndex
        guard idx < labels.count else { return super.caretRect(for: position) }
        var rect = labels[idx].convert(labels[idx].bounds, to: self)
        rect.size.width = 1
        return rect
    }

    @objc private func textDidChange() {
        refreshText()
        let pos = position(from: beginningOfDocument, offset: (text ?? "").count) ?? beginningOfDocument
        selectedTextRange = textRange(from: pos, to: pos)
    }

    // MARK: - Tap-to-Edit Feature ---------------------------------------------
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let lbl = sender.view as? UILabel,
              let targetIdx = labelIndex[lbl] else { return }

        // 1. JANGAN POTONG TEXT – biar isian tetap utuh
        // 2. Cuma pindah kursor
        let newPosition = position(from: beginningOfDocument, offset: targetIdx) ?? beginningOfDocument
        selectedTextRange = textRange(from: newPosition, to: newPosition)

        // 3. Refresh UI supaya kotak yang ditap jadi “active”
        refreshText()
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: range, with: string)
        return updated.count <= digitCount
    }
}*/
/*
import UIKit

public final class TextFieldOTP: UITextField, UITextFieldDelegate {

    // MARK: - Configurable Properties (didSet → auto re-render)
    private var digitCount: Int = 6 { didSet { rebuild() } }
    private var borderWidth: CGFloat = 1 { didSet { restyle() } }
    private var borderColor: UIColor = .lightGray { didSet { restyle() } }
    private var activeBorderColor: UIColor?
    private var activeBorderWidth: CGFloat?
    private var cornerRadius: CGFloat = 6 { didSet { restyle() } }
    private var fontDigit: UIFont = .systemFont(ofSize: 20) { didSet { restyle() } }
    private var textColorDigit: UIColor = .label { didSet { restyle() } }
    private var secureDigit: Bool = false { didSet { refreshText() } }

    // MARK: - Event & Binding
    private var onEditingChangeAction: ((String) -> Void)?
    private var bindingStorage: SBinding<String>?

    // MARK: - UI Subviews
    private let stack = UIStackView()
    private var labels: [UILabel] = []
    private var labelIndex: [UILabel: Int] = [:]   // lookup indeks label

    // MARK: - Life-Cycle
    public override init(frame: CGRect) { super.init(frame: frame); common() }
    public required init?(coder: NSCoder) { super.init(coder: coder); common() }

    private func common() {
        delegate = self
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        // Tap area agar bisa focus
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tap)

        // Stack container
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        rebuild()
        // Auto-focus (opsional)
        DispatchQueue.main.async { _ = self.becomeFirstResponder() }
    }

    // MARK: - Public Chain-able API
    @discardableResult public func digits(_ count: Int) -> Self { digitCount = count; return self }
    @discardableResult public func border(width: CGFloat, color: UIColor) -> Self { borderWidth = width; borderColor = color; return self }
    @discardableResult public func borderActive(_ color: UIColor, width: CGFloat? = nil) -> Self { activeBorderColor = color; activeBorderWidth = width; return self }
    @discardableResult public func cornerRadius(_ r: CGFloat) -> Self { cornerRadius = r; return self }
    @discardableResult public func digitFont(_ f: UIFont) -> Self { fontDigit = f; return self }
    @discardableResult public func digitColor(_ c: UIColor) -> Self { textColorDigit = c; return self }
    @discardableResult public func secure(_ flag: Bool = true) -> Self { secureDigit = flag; return self }
    @discardableResult public func width(_ c: CGFloat) -> Self { widthAnchor.constraint(equalToConstant: c).isActive = true; return self }
    @discardableResult public func height(_ c: CGFloat) -> Self { heightAnchor.constraint(equalToConstant: c).isActive = true; return self }

    @discardableResult public func text(_ state: SBinding<String>) -> Self {
        bindingStorage = state
        self.text = state.wrappedValue
        refreshText()
        state.didSet = { [weak self] new in
            self?.text = new
            self?.refreshText()
        }
        addTarget(self, action: #selector(bindingChanged), for: .editingChanged)
        return self
    }
    @objc private func bindingChanged() { bindingStorage?.wrappedValue = self.text ?? "" }

    @discardableResult public func onEditingChange(_ action: @escaping (String) -> Void) -> Self {
        onEditingChangeAction = action
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return self
    }
    @objc private func editingChanged() { onEditingChangeAction?(text ?? "") }

    // MARK: - Rebuild & Style
    private func rebuild() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        labels.removeAll(); labelIndex.removeAll()
        for idx in 0..<digitCount {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            lbl.addGestureRecognizer(tap)
            lbl.tag = idx
            stack.addArrangedSubview(lbl)
            labels.append(lbl)
            labelIndex[lbl] = idx
        }
        restyle()
    }

    private func restyle() {
        labels.forEach {
            $0.font = fontDigit
            $0.textColor = textColorDigit
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }
        refreshText()
    }

    private func refreshText() {
        let txt = self.text ?? ""
        let display = secureDigit ? String(repeating: "•", count: txt.count) : txt

        for (idx, lbl) in labels.enumerated() {
            let isActive = idx <= txt.count
            lbl.layer.borderColor = (isActive ? activeBorderColor ?? borderColor : borderColor).cgColor
            lbl.layer.borderWidth = activeBorderWidth ?? borderWidth
            lbl.text = idx < display.count ? String(display[display.index(display.startIndex, offsetBy: idx)]) : nil
        }
    }

    // MARK: - Cursor & Input
    private var currentCursorIndex: Int { min((text ?? "").count, digitCount - 1) }

    public override func caretRect(for position: UITextPosition) -> CGRect {
        let idx = currentCursorIndex
        guard idx < labels.count else { return super.caretRect(for: position) }
        var rect = labels[idx].convert(labels[idx].bounds, to: self)
        rect.size.width = 1
        return rect
    }

    @objc private func textDidChange() {
        refreshText()
        let pos = position(from: beginningOfDocument, offset: (text ?? "").count) ?? beginningOfDocument
        selectedTextRange = textRange(from: pos, to: pos)
    }

    // MARK: - Tap-to-Edit Feature ---------------------------------------------
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let lbl = sender.view as? UILabel,
              let targetIdx = labelIndex[lbl] else { return }

        // a. pangkas teks hingga indeks target (bisa dihilangi jika ingin preserve)
        let newText = String((text ?? "").prefix(targetIdx))
        text = newText

        // b. pindah kursor
        let pos = position(from: beginningOfDocument, offset: targetIdx) ?? beginningOfDocument
        selectedTextRange = textRange(from: pos, to: pos)

        // c. refresh UI
        refreshText()
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: range, with: string)
        return updated.count <= digitCount
    }
}*/
/*import UIKit

public final class TextFieldOTP: UITextField, UITextFieldDelegate {

    // MARK: - Private storage untuk chaining
    private var digitCount: Int = 6
    private var borderWidth: CGFloat = 1
    private var borderColor: UIColor = .lightGray
    private var cornerRadius: CGFloat = 6
    private var fontDigit: UIFont = .systemFont(ofSize: 20)
    private var textColorDigit: UIColor = .label
    private var secureDigit: Bool = false
    
    // Callback
    public var onFilled: ((String) -> Void)?
    
    // MARK: - UI
    private let stackView = UIStackView()
    private var digitLabels: [UILabel] = []
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
        tintColor = .clear
        textColor = .clear // sembunyikan text-field asli
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        renderDigits()
    }
    
    // MARK: - Chain-able setters
    @discardableResult
    public func digits(_ count: Int) -> Self {
        digitCount = count
        return self
    }
    
    @discardableResult
    public func border(width: CGFloat, color: UIColor) -> Self {
        borderWidth = width
        borderColor = color
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func digitFont(_ font: UIFont) -> Self {
        fontDigit = font
        return self
    }
    
    @discardableResult
    public func digitColor(_ color: UIColor) -> Self {
        textColorDigit = color
        return self
    }
    
    @discardableResult
    public func secure(_ flag: Bool = true) -> Self {
        secureDigit = flag
        return self
    }
    
    // MARK: - Build / reload
    @discardableResult
    public func build() -> Self {
        renderDigits()
        return self
    }
    
    private func renderDigits() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        digitLabels.removeAll()
        
        for _ in 0..<digitCount {
            let label = UILabel()
            label.textAlignment = .center
            label.font = fontDigit
            label.textColor = textColorDigit
            label.layer.borderWidth = borderWidth
            label.layer.borderColor = borderColor.cgColor
            label.layer.cornerRadius = cornerRadius
            label.isUserInteractionEnabled = true
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
    }
    
    // MARK: - Logic
    @objc private func textDidChange() {
        let text = self.text ?? ""
        let display = secureDigit ? String(repeating: "•", count: text.count) : text
        
        for (index, label) in digitLabels.enumerated() {
            if index < display.count {
                let idx = display.index(display.startIndex, offsetBy: index)
                label.text = String(display[idx])
            } else {
                label.text = nil
            }
        }
        
        if text.count == digitCount {
            onFilled?(text)
        }
    }
    
    // MARK: - Delegate
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: range, with: string)
        return updated.count <= digitCount
    }
}*/

/*
import UIKit

public final class TextFieldOTP: UITextField, UITextFieldDelegate {

    // MARK: - Private Props
    private let stack = UIStackView()
    private var labels: [UILabel] = []
    private var underlines: [UIView] = []

    private var digitCount: Int
    private var _spacing: CGFloat = 8
    private var _digitFont: UIFont = .systemFont(ofSize: 24, weight: .medium)
    private var _digitColor: UIColor = .label
    private var _cornerRadius: CGFloat = 0
    
    private var _borderActiveColor:   UIColor = .systemBlue
    private var _borderInactiveColor: UIColor = .separator
    private var _borderWidth:         CGFloat = 0

    private var _fixedWidth:  CGFloat?
    private var _fixedHeight: CGFloat = 40
    
    private var codeChanged: ((String) -> Void)?
    private var codeCompleted: ((String) -> Void)?

    // MARK: - Init
    public init(digits: Int) {
        self.digitCount = digits
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        delegate = self
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        tintColor = .clear
        textColor = .clear
        borderStyle = .none

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = _spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        (0..<digitCount).forEach { _ in
            let label = UILabel()
            label.textAlignment = .center
            label.font = _digitFont
            label.textColor = _digitColor
            label.text = ""
            label.translatesAutoresizingMaskIntoConstraints = false

            let cell = UIView()
            cell.addSubview(label)
            stack.addArrangedSubview(cell)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.topAnchor),
                label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])

            cell.layer.borderWidth = _borderWidth == 0 ? 1 : _borderWidth
            cell.layer.borderColor = _borderInactiveColor.cgColor
            
            if _cornerRadius > 0 { cell.layer.cornerRadius = _cornerRadius }

            labels.append(label)
        }
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }

    // MARK: - Chaining API
    @discardableResult
    public func spacing(_ value: CGFloat) -> Self {
        _spacing = value
        stack.spacing = value
        return self
    }

    @discardableResult
    public func digitFont(_ font: UIFont) -> Self {
        _digitFont = font
        labels.forEach { $0.font = font }
        return self
    }

    @discardableResult
    public func digitColor(_ color: UIColor) -> Self {
        _digitColor = color
        labels.forEach { $0.textColor = color }
        return self
    }

    // MARK: - Chaining API
    @discardableResult
    public func borderActive(_ color: UIColor) -> Self {
        _borderActiveColor = color
        return self
    }

    @discardableResult
    public func borderInactive(_ color: UIColor) -> Self {
        _borderInactiveColor = color
        stack.arrangedSubviews.forEach { $0.layer.borderColor = color.cgColor }
        return self
    }

    @discardableResult
    public func borderWidth(_ width: CGFloat) -> Self {
        _borderWidth = width
        stack.arrangedSubviews.forEach { $0.layer.borderWidth = width }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        _cornerRadius = radius
        stack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = radius
            $0.layer.borderWidth = radius > 0 ? 1 : 0
        }
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> Self {
        stack.heightAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }
    
    @discardableResult
    public func onCodeChanged(_ action: @escaping (String) -> Void) -> Self {
        codeChanged = action
        return self
    }

    @discardableResult
    public func onCodeCompleted(_ action: @escaping (String) -> Void) -> Self {
        codeCompleted = action
        return self
    }

    // MARK: - Delegate
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: range, with: string)

        guard updated.count <= digitCount, string.allSatisfy({ $0.isNumber }) else { return false }

        textField.text = updated
        refreshUI(updated)

        codeChanged?(updated)
        if updated.count == digitCount {
            codeCompleted?(updated)
            resignFirstResponder()
        }
        return false
    }

    private func refreshUI(_ code: String) {
        labels.enumerated().forEach { idx, label in
            let filled = idx < code.count
            label.text = filled ? String(code[code.index(code.startIndex, offsetBy: idx)]) : ""
            UIView.animate(withDuration: 0.15) {
                self.stack.arrangedSubviews[idx].layer.borderColor = filled
                    ? self._borderActiveColor.cgColor
                    : self._borderInactiveColor.cgColor
            }
        }
    }

    // Public helper
    public func clear() {
        text = ""
        refreshUI("")
    }
}*/
/*
import UIKit

public final class TextFieldOTP: UITextField, UITextFieldDelegate {

    // MARK: - Private Props
    private let stack = UIStackView()
    private var labels: [UILabel] = []

    private var digitCount: Int
    private var _spacing: CGFloat = 8
    private var _digitFont: UIFont = .systemFont(ofSize: 24, weight: .medium)
    private var _digitColor: UIColor = .label
    private var _cornerRadius: CGFloat = 0

    private var _borderActiveColor:   UIColor = .systemBlue
    private var _borderInactiveColor: UIColor = .separator
    private var _borderWidth:         CGFloat = 0

    private var _fixedHeight: CGFloat = 40

    private var currentIndex: Int = 0

    private var codeChanged: ((String) -> Void)?
    private var codeCompleted: ((String) -> Void)?

    // MARK: - Init
    public init(digits: Int) {
        self.digitCount = digits
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setup() {
        delegate = self
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        tintColor = .clear
        textColor = .clear
        borderStyle = .none

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = _spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 40 * CGFloat(digitCount) + _spacing * CGFloat(digitCount - 1)),
            stack.heightAnchor.constraint(equalToConstant: _fixedHeight)
        ])

        (0..<digitCount).forEach { idx in
            let label = UILabel()
            label.textAlignment = .center
            label.font = _digitFont
            label.textColor = _digitColor
            label.text = ""
            label.translatesAutoresizingMaskIntoConstraints = false

            let cell = UIView()
            cell.addSubview(label)
            stack.addArrangedSubview(cell)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.topAnchor),
                label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])

            cell.layer.borderWidth = _borderWidth == 0 ? 1 : _borderWidth
            cell.layer.borderColor = _borderInactiveColor.cgColor
            if _cornerRadius > 0 { cell.layer.cornerRadius = _cornerRadius }

            let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            cell.tag = idx
            cell.addGestureRecognizer(tap)
            cell.isUserInteractionEnabled = true

            labels.append(label)
        }
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }

    // MARK: - Chaining API
    @discardableResult
    public func spacing(_ value: CGFloat) -> Self {
        _spacing = value
        stack.spacing = value
        return self
    }

    @discardableResult
    public func digitFont(_ font: UIFont) -> Self {
        _digitFont = font
        labels.forEach { $0.font = font }
        return self
    }

    @discardableResult
    public func digitColor(_ color: UIColor) -> Self {
        _digitColor = color
        labels.forEach { $0.textColor = color }
        return self
    }

    @discardableResult
    public func borderActive(_ color: UIColor) -> Self {
        _borderActiveColor = color
        return self
    }

    @discardableResult
    public func borderInactive(_ color: UIColor) -> Self {
        _borderInactiveColor = color
        stack.arrangedSubviews.forEach { $0.layer.borderColor = color.cgColor }
        return self
    }

    @discardableResult
    public func borderWidth(_ width: CGFloat) -> Self {
        _borderWidth = width
        stack.arrangedSubviews.forEach { $0.layer.borderWidth = width }
        return self
    }

    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        _cornerRadius = radius
        stack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = radius
            $0.layer.borderWidth = radius > 0 ? 1 : 0
        }
        return self
    }

    @discardableResult
    public func height(_ value: CGFloat) -> Self {
        stack.heightAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }

    @discardableResult
    public func onCodeChanged(_ action: @escaping (String) -> Void) -> Self {
        codeChanged = action
        return self
    }

    @discardableResult
    public func onCodeCompleted(_ action: @escaping (String) -> Void) -> Self {
        codeCompleted = action
        return self
    }

    // MARK: - Obj-C Helpers
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let idx = sender.view?.tag else { return }
        currentIndex = idx
        becomeFirstResponder()
        setCursor(at: idx)
    }

    private func setCursor(at index: Int) {
        let str = text ?? ""
        let pos = min(index, str.count)
        if let newPos = position(from: beginningOfDocument, offset: pos) {
            selectedTextRange = textRange(from: newPos, to: newPos)
        }
    }

    // MARK: - Delegate
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let rng = Range(range, in: current) else { return false }
        var updated = current.replacingCharacters(in: rng, with: string)

        if string.isEmpty, range.location == 0, currentIndex > 0 {
            currentIndex -= 1
            setCursor(at: currentIndex)
            return false
        }

        guard updated.count <= digitCount, string.allSatisfy({ $0.isNumber }) else { return false }

        textField.text = updated
        refreshUI(updated)

        if !string.isEmpty, currentIndex < digitCount - 1 {
            currentIndex += 1
            setCursor(at: currentIndex)
        }

        codeChanged?(updated)
        if updated.count == digitCount { codeCompleted?(updated) }
        return false
    }

    private func refreshUI(_ code: String) {
        labels.enumerated().forEach { idx, label in
            let filled = idx < code.count
            label.text = filled ? String(code[code.index(code.startIndex, offsetBy: idx)]) : ""
            UIView.animate(withDuration: 0.15) {
                self.stack.arrangedSubviews[idx].layer.borderColor = filled
                    ? self._borderActiveColor.cgColor
                    : self._borderInactiveColor.cgColor
            }
        }
    }

    // MARK: - Public helper
    public override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        if let str = text, !str.isEmpty { setCursor(at: str.count) }
        return ok
    }

    public func clear() {
        text = ""
        refreshUI("")
    }
}*/

// MARK: New Version

import UIKit

protocol OTPFieldDelegate: AnyObject {
    func didPressBackspace(in field: OTPTextField)
}

class OTPTextField: UITextField {
    weak var otpDelegate: OTPFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        if text?.isEmpty == true {
            otpDelegate?.didPressBackspace(in: self)
        }
    }
}

public class TextFieldOTP: UIStackView {

    private var resetBinding: SBinding<Bool>?
    
    private var mode: OTPKeyboardMode = .numeric
    
    private var filledBorderColor: UIColor = .systemPink
    private var emptyBorderColor:  UIColor = .systemGray4
    private var emptyBgColor: UIColor = .clear
    private var filledBgColor: UIColor = .clear
    
    private var digitCount: Int = 4
    private var onChange: ((String) -> Void)?
    private var onComplete: ((String) -> Void)?

    private var textFields: [OTPTextField] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - SwiftUI-style chaining
    @discardableResult
    public func digit(_ count: Int) -> Self {
        self.digitCount = max(3, min(count, 8)) // clamp 3-8
        rebuildFields()
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        textFields.forEach { $0.textColor = color }
        return self
    }
    
    @discardableResult
    public func textSize(_ size: CGFloat) -> Self {
        textFields.forEach {
            $0.font = .systemFont(ofSize: size)
        }
        return self
    }
    
    @discardableResult
    public func textSize(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        textFields.forEach {
            $0.font = .systemFont(ofSize: size, weight: weight)
        }
        return self
    }
    
    @discardableResult
    public func textColor(hex: UInt) -> Self {
        let color = UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hex & 0x0000FF) / 255,
            alpha: 1
        )
        return textColor(color)
    }

    @discardableResult
    public func spacing(_ value: CGFloat) -> Self {
        self.spacing = value
        return self
    }
    
    @discardableResult
    public func strokeColors(_ from: UIColor = .systemGray4,
                      to: UIColor = .systemGray4) -> Self {
        self.emptyBorderColor  = from
        self.filledBorderColor = to
        textFields.forEach { updateBorderColor(for: $0) }
        return self
    }
    
    @discardableResult
    public func strokeColors(_ from: UInt = 0xF0F0F0,
                      to: UInt = 0xDDDDDD) -> Self {
        let emptyColor = UIColor(
            red: CGFloat((from & 0xFF0000) >> 16) / 255,
            green: CGFloat((from & 0x00FF00) >> 8) / 255,
            blue: CGFloat(from & 0x0000FF) / 255,
            alpha: 1
        )
        let filledColor = UIColor(
            red: CGFloat((to & 0xFF0000) >> 16) / 255,
            green: CGFloat((to & 0x00FF00) >> 8) / 255,
            blue: CGFloat(to & 0x0000FF) / 255,
            alpha: 1
        )
        return strokeColors(emptyColor, to: filledColor)
    }
    
    @discardableResult
    public func backgroundColors(_ from: UIColor = .systemGray6,
                          to: UIColor = .systemTeal) -> Self {
        self.emptyBgColor = from
        self.filledBgColor = to
        refreshAllBackgroundColors()
        return self
    }
    
    @discardableResult
    public func backgroundColors(_ from: UInt = 0xF0F0F0,
                          to: UInt = 0xDDDDDD) -> Self {
        let emptyColor = UIColor(
            red: CGFloat((from & 0xFF0000) >> 16) / 255,
            green: CGFloat((from & 0x00FF00) >> 8) / 255,
            blue: CGFloat(from & 0x0000FF) / 255,
            alpha: 1
        )
        let filledColor = UIColor(
            red: CGFloat((to & 0xFF0000) >> 16) / 255,
            green: CGFloat((to & 0x00FF00) >> 8) / 255,
            blue: CGFloat(to & 0x0000FF) / 255,
            alpha: 1
        )
        return backgroundColors(emptyColor, to: filledColor)
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        textFields.forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = radius
        }
        return self
    }
    
    @discardableResult
    func onChange(_ action: @escaping (String) -> Void) -> Self {
        self.onChange = action
        return self
    }
    
    @discardableResult
    public func onCodeCompleted(_ action: @escaping (String) -> Void) -> Self {
        self.onComplete = action
        return self
    }

    @discardableResult
    public func reset(_ binding: SBinding<Bool>) -> Self {
        self.resetBinding = binding
        binding.didSet = { [weak self] newValue in
            if newValue {
                self?.resetFields()
                binding.wrappedValue = false
            }
        }
        return self
    }
    
    private func resetFields() {   // ← rename ini
        textFields.forEach { $0.text = "" }
        refreshAllVisuals()
        textFields.first?.becomeFirstResponder()
        onChange?(code())
    }
    
    // MARK: - Setup
    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        rebuildFields()
    }
    
    private func refreshAllVisuals() {
        textFields.forEach {
            updateBorderColor(for: $0)
            updateBackgroundColor(for: $0)
        }
    }
    
    private func updateBackgroundColor(for field: OTPTextField) {
        let isFilled = !(field.text ?? "").isEmpty
        field.backgroundColor = isFilled ? filledBgColor : emptyBgColor
    }

    private func refreshAllBackgroundColors() {
        textFields.forEach { updateBackgroundColor(for: $0) }
    }

    private func rebuildFields() {
        textFields.forEach { $0.removeFromSuperview() }
        textFields.removeAll()

        for _ in 0..<digitCount {
            let field = OTPTextField()
            field.textAlignment = .center
            field.keyboardType = .numberPad
            field.font = .systemFont(ofSize: 24)
            field.borderStyle = .none
            field.delegate = self
            field.otpDelegate = self
            textFields.append(field)
            addArrangedSubview(field)
        }

        textFields.first?.becomeFirstResponder()
    }

    private func code() -> String {
        textFields.compactMap { $0.text }.joined()
    }
    
    private func animate(_ field: UITextField) {
        UIView.animate(withDuration: 0.08, animations: {
            field.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            field.alpha = 0.6
        }) { _ in
            UIView.animate(withDuration: 0.08) {
                field.transform = .identity
                field.alpha = 1
            }
        }
    }
    
    private func updateBorderColor(for field: OTPTextField) {
        let isFilled = !(field.text ?? "").isEmpty
        let targetColor = isFilled ? filledBorderColor : emptyBorderColor

        // 1) roundedRect atau pill
        if field.layer.borderWidth > 0 {
            field.layer.borderColor = targetColor.cgColor
        }

        // 2) bottomLine
        if let line = field.layer.sublayers?.first(where: { $0.name == "borderLayer" }) {
            line.backgroundColor = targetColor.cgColor
        }
    }
    
    @discardableResult
    public func stroke(width: CGFloat = 0,
                corner: CGFloat = 0,
                shadowRadius: CGFloat = 0,
                shadowColor: UIColor = .black,
                shadowOpacity: Float = 0.15,
                shadowOffset: CGSize = CGSize(width: 0, height: 2)) -> Self {
        
        textFields.forEach {
            $0.borderStyle = .none
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = corner
            $0.layer.borderWidth = width
            
            // Shadow
            $0.layer.shadowRadius = shadowRadius
            $0.layer.shadowColor = shadowColor.cgColor
            $0.layer.shadowOpacity = shadowRadius > 0 ? shadowOpacity : 0
            $0.layer.shadowOffset = shadowOffset
        }
        
        refreshAllVisuals()
        return self
    }
    
    @discardableResult
    func stroke(_ style: OTPBorderStyle) -> Self {
        textFields.forEach { applyBorder(style, to: $0) }
        return self
    }

    private func applyBorder(_ style: OTPBorderStyle, to field: OTPTextField) {
        switch style {
        case .none:
            field.borderStyle = .none
            field.layer.sublayers?.removeAll { $0.name == "borderLayer" }

        case .bottomLine(let color, let thickness):
            field.borderStyle = .none
            field.layer.sublayers?.removeAll { $0.name == "borderLayer" }
            let line = CALayer()
            line.name = "borderLayer"
            line.backgroundColor = color.cgColor
            line.frame = CGRect(x: 0, y: field.bounds.height - thickness,
                                width: field.bounds.width, height: thickness)
            field.layer.addSublayer(line)

        case .roundedRect(let color, let width, let corner):
            field.borderStyle = .none
            field.layer.masksToBounds = true
            field.layer.cornerRadius = corner
            field.layer.borderColor = color.cgColor
            field.layer.borderWidth = width

        case .pill(let color):
            field.borderStyle = .none
            field.layer.masksToBounds = true
            field.layer.cornerRadius = field.bounds.height / 2
            field.layer.borderColor = color.cgColor
            field.layer.borderWidth = 2
            
        case .solidColor(let color):
            field.borderStyle = .none
            field.layer.masksToBounds = true
            field.layer.cornerRadius = 8
            field.layer.borderColor = color.cgColor
            field.layer.borderWidth = 2
            
        case .hex(let rgb):
            let color = UIColor(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                blue: CGFloat(rgb & 0x0000FF) / 255,
                alpha: 1
            )
            applyBorder(.solidColor(color), to: field)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldOTP: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let field = textField as? OTPTextField,
              let currentIndex = textFields.firstIndex(of: field) else { return false }

        // Allow only 0-9 and max 1 character
        //guard string.count <= 1, Int(string) != nil || string.isEmpty else { return false }
        let allowed: CharacterSet = mode == .numeric ? .decimalDigits : .alphanumerics
        guard string.count <= 1,
              (string.rangeOfCharacter(from: allowed) != nil || string.isEmpty) else {
            return false
        }

        // Kalau field udah terisi & user ngetik baru → langsung timpa
        if !string.isEmpty, textField.text?.isEmpty == false {
            textField.text = string
            updateBorderColor(for: field)
            animate(textField)
            // Auto move next
            let nextIndex = currentIndex + 1
            if nextIndex < textFields.count {
                textFields[nextIndex].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                onComplete?(code())
            }
            return false
        }

        // Behavior normal (kosong → isi, atau delete)
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        textField.text = newText

        if !newText.isEmpty {
            let nextIndex = currentIndex + 1
            if nextIndex < textFields.count {
                textFields[nextIndex].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                onComplete?(code())
            }
        }
        refreshAllVisuals()
        onChange?(code())
        return false
    }
}

// MARK: - OTPFieldDelegate
extension TextFieldOTP: OTPFieldDelegate {
    func didPressBackspace(in field: OTPTextField) {
        guard let index = textFields.firstIndex(of: field), index > 0 else { return }
        let prev = textFields[index - 1]
        prev.text = ""
        updateBorderColor(for: prev)
        animate(prev)
        refreshAllVisuals()
        prev.becomeFirstResponder()
    }
}

enum OTPBorderStyle {
    case none
    case bottomLine(color: UIColor, thickness: CGFloat = 2)
    case roundedRect(color: UIColor, width: CGFloat = 1, corner: CGFloat = 8)
    case pill(color: UIColor)
    case solidColor(UIColor)
    case hex(UInt32)
}

enum OTPKeyboardMode {
    case numeric      // 0-9 doang
    case alphanumeric // A-Z, a-z, 0-9
}

extension TextFieldOTP {
    private func applyMode() {
        textFields.forEach {
            switch mode {
            case .numeric:
                $0.keyboardType = .numberPad
            case .alphanumeric:
                $0.keyboardType = .asciiCapable   // full keyboard
            }
        }
    }
    
    @discardableResult
    func keyboardMode(_ mode: OTPKeyboardMode) -> Self {
        self.mode = mode
        applyMode()
        return self
    }
}
