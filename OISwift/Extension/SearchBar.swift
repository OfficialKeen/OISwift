//
//  SearchBar.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit

class SearchBar: UISearchBar {
    @discardableResult
    public func delegate(_ delegate: UISearchBarDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func prompt(_ prompt: String? = nil) -> Self {
        self.prompt = prompt
        return self
    }
    
    @discardableResult
    public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    public func barButtonItems(_ items: [UIBarButtonItem]? = nil) -> Self {
        self.setShowsCancelButton(true, animated: true)
        return self
    }
    
    @discardableResult
    public func scopeBar(_ selectedScope: Int? = nil) -> Self {
        self.showsScopeBar = true
        return self
    }
    
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
    
    @discardableResult
    public func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        self.autocorrectionType = type
        return self
    }
    
    @discardableResult
    public func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        self.autocapitalizationType = type
        return self
    }
    
    @discardableResult
    public func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.clearButtonMode = mode
        }
        return self
    }
    
    @discardableResult
    public func showsBookmarkButton(_ shows: Bool) -> Self {
        self.showsBookmarkButton = shows
        return self
    }
    
    @discardableResult
    public func showsCancelButton(_ shows: Bool = false) -> Self {
        self.showsCancelButton = shows
        return self
    }
    
    @discardableResult
    public func backgroundImage(_ image: UIImage = UIImage()) -> Self {
        self.backgroundImage = image
        return self
    }
    
    @discardableResult
    public func textAttributes(_ attributes: [NSAttributedString.Key : Any]?) -> Self {
        if let attributes = attributes {
            if #available(iOS 13.0, *) {
                self.searchTextField.defaultTextAttributes = attributes
            } else {
                // Fallback on earlier versions
            }
        }
        return self
    }
    
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        if let searchBarTextField = self.value(forKey: "searchField") as? UITextField {
            searchBarTextField.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    public func background(_ hex: UInt) -> Self {
        if let searchBarTextField = self.value(forKey: "searchField") as? UITextField {
            let color = UIColor(hex: UInt32(hex))
            searchBarTextField.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat) -> Self {
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
    func isHidden(_ bool: Bool = true) -> Self {
        self.isHidden = bool
        return self
    }
    
    @discardableResult
    func isHidden(_ state: SBinding<Bool>) -> Self {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
    
    @discardableResult
    func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
}

extension SearchBar: UISearchBarDelegate {
    private struct AssociatedKeys {
        static var searchBarTextChangedActionKey: UInt8 = 0
        static var searchBarTextDidBeginEditingActionKey: UInt8 = 0
        static var searchBarTextDidEndEditingActionKey: UInt8 = 0
        static var shouldChangeTextInRangeActionKey: UInt8 = 0
        static var searchBarSearchButtonClickedActionKey: UInt8 = 0
        static var searchBarCancelButtonClickedActionKey: UInt8 = 0
        static var searchBarResultsListButtonClickedActionKey: UInt8 = 0
        static var selectedScopeButtonIndexDidChangeActionKey: UInt8 = 0
        
    }
}

extension SearchBar { //textDidChange
    private var searchTextDidChangeAction: ((UISearchBar, String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarTextChangedActionKey) as? (UISearchBar, String) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarTextChangedActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onTextChanged(_ action: @escaping (UISearchBar, String) -> Void, for searchBar: UISearchBar? = nil) -> Self {
        self.delegate = self
        self.searchTextDidChangeAction = action
        return self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChangeAction?(searchBar, searchText)
    }
}

extension SearchBar { //searchBarTextDidBeginEditing
    private var searchBarTextDidBeginEditingAction: ((UISearchBar) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarTextDidBeginEditingActionKey) as? (UISearchBar) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarTextDidBeginEditingActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onDidTap(_ action: @escaping (UISearchBar) -> Void) -> Self {
        self.delegate = self
        self.searchBarTextDidBeginEditingAction = action
        return self
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarTextDidBeginEditingAction?(searchBar)
    }
}

extension SearchBar { //searchBarTextDidEndEditing
    private var searchBarTextDidEndEditingAction: ((UISearchBar) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarTextDidEndEditingActionKey) as? (UISearchBar) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarTextDidEndEditingActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onDidEndTap(_ action: @escaping (UISearchBar) -> Void) -> Self {
        self.delegate = self
        self.searchBarTextDidEndEditingAction = action
        return self
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditingAction?(searchBar)
    }
}

extension SearchBar { //shouldChangeTextInRange
    private var shouldChangeTextInRangeAction: ((UISearchBar, NSRange, String) -> Bool)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.shouldChangeTextInRangeActionKey) as? (UISearchBar, NSRange, String) -> Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldChangeTextInRangeActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onChange(_ action: @escaping (UISearchBar, NSRange, String) -> Bool) -> Self {
        self.delegate = self
        self.shouldChangeTextInRangeAction = action
        return self
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeTextInRangeAction?(searchBar, range, text) ?? true
    }
}

extension SearchBar { //searchBarSearchButtonClicked
    private var searchBarSearchButtonClickedAction: ((UISearchBar) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarSearchButtonClickedActionKey) as? (UISearchBar) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarSearchButtonClickedActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onSubmit(_ action: @escaping (UISearchBar) -> Void) -> Self {
        self.delegate = self
        self.searchBarSearchButtonClickedAction = action
        return self
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarSearchButtonClickedAction?(searchBar)
    }
}

extension SearchBar { //searchBarCancelButtonClicked
    private var searchBarCancelButtonClickedAction: ((UISearchBar) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarCancelButtonClickedActionKey) as? (UISearchBar) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarCancelButtonClickedActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onCancelButton(_ action: @escaping (UISearchBar) -> Void) -> Self {
        self.delegate = self
        self.searchBarCancelButtonClickedAction = action
        return self
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButtonClickedAction?(searchBar)
    }
}

extension SearchBar { //searchBarResultsListButtonClicked
    private var searchBarResultsListButtonClickedAction: ((UISearchBar) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.searchBarResultsListButtonClickedActionKey) as? (UISearchBar) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.searchBarResultsListButtonClickedActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onResultsListButton(_ action: @escaping (UISearchBar) -> Void) -> Self {
        self.delegate = self
        self.searchBarResultsListButtonClickedAction = action
        return self
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBarResultsListButtonClickedAction?(searchBar)
    }
}

extension SearchBar { //selectedScopeButtonIndexDidChange
    private var selectedScopeButtonIndexDidChangeAction: ((UISearchBar, Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.selectedScopeButtonIndexDidChangeActionKey) as? (UISearchBar, Int) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.selectedScopeButtonIndexDidChangeActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func onScopeButton(_ action: @escaping (UISearchBar, Int) -> Void) -> Self {
        self.delegate = self
        self.selectedScopeButtonIndexDidChangeAction = action
        return self
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedScopeButtonIndexDidChangeAction?(searchBar, selectedScope)
    }
}

extension SearchBar {
    @discardableResult
    public func placeholder(_ placeholder: SBinding<String>) -> Self {
        self.placeholder = placeholder.wrappedValue
        placeholder.didSet = { [weak self] newValue in
            self?.placeholder = newValue
        }
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool = true) -> Self {
        if #available(iOS 16.4, *) {
            self.isEnabled = isEnabled
        } else {
            self.isUserInteractionEnabled = isEnabled
        }
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            if #available(iOS 16.4, *) {
                self?.isEnabled = newIsEnabled
            } else {
                self?.isUserInteractionEnabled = newIsEnabled
                // Fallback on earlier versions
            }
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension SearchBar {
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size, weight: weight)
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ colorHex: UInt) -> Self {
        let color = UIColor(hex: UInt32(colorHex))
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = color
        return self
    }
}

