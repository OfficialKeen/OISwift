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
    @discardableResult
    public func content(multiplier: CGFloat? = nil, isPaging: Bool = false, showIndicatorScroll: Bool = false, content: (UIView) -> UIView) -> Scroll {
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
}
