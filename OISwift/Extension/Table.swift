//
//  Table.swift
//  OISwift
//
//  Created by keenoi on 19/05/24.
//

/*import UIKit

extension UITableView {
    @discardableResult
    public func reload() -> Self {
        self.reloadData()
        return self
    }
    
    @discardableResult
    public func setRegister(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) -> Self {
        self.register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func setRegister(_ nib: UINib?, forCellReuseIdentifier identifier: String) -> Self {
        guard let nib = nib else { fatalError("Nib is nil") }
        self.register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        self.showsVerticalScrollIndicator()
        self.showsHorizontalScrollIndicator()
        return self
    }
    
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.contentInsetAdjustmentBehavior = behavior
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    public func rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsIndicator: Bool = false) -> Self {
        self.showsVerticalScrollIndicator = showsIndicator
        return self
    }
    
    @discardableResult
    public func showsHorizontalScrollIndicator(_ showsIndicator: Bool = false) -> Self {
        self.showsHorizontalScrollIndicator = showsIndicator
        return self
    }
    
    @discardableResult
    public func infinityHeaderView(_ headerView: UIView) -> Self {
        self.tableHeaderView = headerView
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = size.height
        headerView.frame.size.height = height
        self.tableHeaderView = headerView
        return self
    }
    
    @discardableResult
    public func infinityFooterView(_ footerView: UIView) -> Self {
        self.tableFooterView = footerView
        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = size.height
        footerView.frame.size.height = height
        self.tableFooterView = footerView
        return self
    }
    
    @discardableResult
    public func didSelectRowAt(_ closure: @escaping (UITableView, IndexPath) -> Void) -> Self {
        return self
    }
}

extension UITableView {
    @discardableResult
    public func dynamicHeight() -> Self {
        self.contentSize = .zero // Set initial content size to zero
        return self
    }

    override open var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}*/


import UIKit

public class Table: UITableView {
    @discardableResult
    public func reload() -> Self {
        self.reloadData()
        return self
    }
    
    @discardableResult
    public func setRegister(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) -> Self {
        self.register(cellClass, forCellReuseIdentifier: identifier)
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
    
    @discardableResult
    public func setRegister(_ nib: UINib?, forCellReuseIdentifier identifier: String) -> Self {
        guard let nib = nib else { fatalError("Nib is nil") }
        self.register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        self.showsVerticalScrollIndicator()
        self.showsHorizontalScrollIndicator()
        return self
    }
    
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.contentInsetAdjustmentBehavior = behavior
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    public func rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsIndicator: Bool = false) -> Self {
        self.showsVerticalScrollIndicator = showsIndicator
        return self
    }
    
    @discardableResult
    public func showsHorizontalScrollIndicator(_ showsIndicator: Bool = false) -> Self {
        self.showsHorizontalScrollIndicator = showsIndicator
        return self
    }
    
    @discardableResult
    public func infinityHeaderView(_ headerView: UIView) -> Self {
        self.tableHeaderView = headerView
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = size.height
        headerView.frame.size.height = height
        self.tableHeaderView = headerView
        return self
    }
    
    @discardableResult
    public func infinityFooterView(_ footerView: UIView) -> Self {
        self.tableFooterView = footerView
        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = size.height
        footerView.frame.size.height = height
        self.tableFooterView = footerView
        return self
    }
    
    @discardableResult
    public func didSelectRowAt(_ closure: @escaping (UITableView, IndexPath) -> Void) -> Self {
        return self
    }
}

extension Table {
    @discardableResult
    public func dynamicHeight() -> Self {
        self.contentSize = .zero // Set initial content size to zero
        return self
    }

    override open var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
