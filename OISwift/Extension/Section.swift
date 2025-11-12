//
//  Section.swift
//  OISwift
//
//  Created by keenoi on 25/11/24.
//

import UIKit

open class Section<Header: UIView, Footer: UIView>: UIView {
    private let stackView = UIStackView()
    private var headerView: Header?
    private var footerView: Footer?
    private var contentViews: [UIView]
    
    // Initializer dengan header dan footer opsional
    public init(header: Header? = nil, footer: Footer? = nil, @UIStackViewBuilder content: () -> [UIView]) {
        self.headerView = header
        self.footerView = footer
        self.contentViews = content()
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Tambahkan header jika ada
        if let headerView = headerView {
            stackView.addArrangedSubview(headerView)
        }
        
        // Tambahkan setiap view dari content ke dalam stackView
        for view in contentViews {
            stackView.addArrangedSubview(view)
        }
        
        // Tambahkan footer jika ada
        if let footerView = footerView {
            stackView.addArrangedSubview(footerView)
        }
        
        addSubview(stackView)
        
        // Constraints agar stackView memenuhi seluruh area Section
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
