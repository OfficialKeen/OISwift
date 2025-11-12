//
//  ScrollView.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//


/*import UIKit

@resultBuilder
struct OIContentViewBuilder {
    static func buildBlock(_ content: UIView) -> UIView {
        return content
    }
}

extension UIScrollView {
    @discardableResult
    public func content(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, content: (UIView) -> UIView) -> UIScrollView {
        let contentView = content(UIView())
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        if showIndicatorScroll {
            self.showsVerticalScrollIndicator = true
            self.showsHorizontalScrollIndicator = true
        } else {
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
        }
        
        self.isPagingEnabled = isPaging
        
        if let multiplier = multiplier {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        }
        
        // Panggil observer untuk menangani notifikasi keyboard
        self.adjustForKeyboard()
        
        return self
    }
    
    func adjustForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
}

extension UIView {
    @discardableResult
    public func scrollViewContent(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, @OIContentViewBuilder content: (UIView) -> UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        let contentView = content(UIView())
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        if showIndicatorScroll {
            scrollView.showsVerticalScrollIndicator = true
            scrollView.showsHorizontalScrollIndicator = true
        } else {
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
        }
        
        scrollView.isPagingEnabled = isPaging == false ? false : true
        
        if let multiplier = multiplier {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: multiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])

        return scrollView
    }
}*/

import UIKit

@resultBuilder
struct OIContentViewBuilder {
    static func buildBlock(_ content: UIView) -> UIView {
        return content
    }
}

public class Scroll: UIScrollView {
    // Initializer
    public init(
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        showIndicatorScroll: Bool = false,
        bounce: Bool = false,
        content: (UIView) -> UIView
    ) {
        super.init(frame: .zero)
        
        // Setup content view
        let contentView = content(UIView())
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView properties
        bounces = bounce
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = showIndicatorScroll
        showsHorizontalScrollIndicator = showIndicatorScroll
        isPagingEnabled = isPaging
        
        // Apply constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier ?? 1.0)
        ])
        
        // Adjust for keyboard
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        DispatchQueue.main.async {
            self.contentInset.bottom = keyboardHeight
            self.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            self.contentInset.bottom = 0
            self.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/*import UIKit

@resultBuilder
struct OIContentViewBuilder {
    static func buildBlock(_ content: UIView) -> UIView {
        return content
    }
}

public class Scroll: UIScrollView {
    @discardableResult
    public func content(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, bounce: Bool = true, content: (UIView) -> UIView) -> Scroll {
        let contentView = content(UIView())
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        bounces = bounce
        if showIndicatorScroll {
            self.showsVerticalScrollIndicator = true
            self.showsHorizontalScrollIndicator = true
        } else {
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
        }
        
        self.isPagingEnabled = isPaging
        
        if let multiplier = multiplier {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        }
        
        // Panggil observer untuk menangani notifikasi keyboard
        self.adjustForKeyboard()
        
        return self
    }
    
    func adjustForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
}*/

extension UIView {
    @discardableResult
    public func scrollViewContent(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, @OIContentViewBuilder content: (UIView) -> UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        let contentView = content(UIView())
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        if showIndicatorScroll {
            scrollView.showsVerticalScrollIndicator = true
            scrollView.showsHorizontalScrollIndicator = true
        } else {
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
        }
        
        scrollView.isPagingEnabled = isPaging == false ? false : true
        
        if let multiplier = multiplier {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: multiplier)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])

        return scrollView
    }
}
