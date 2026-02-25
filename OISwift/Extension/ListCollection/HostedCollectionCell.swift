//
//  HostedCollectionCell.swift
//  OISwift
//
//  Created by keenoi on 24/01/26.
//

import UIKit

final class HostedCollectionCell: UICollectionViewCell {
    private var hostedView: UIView?
    
    func render(_ view: UIView) {
        hostedView?.removeFromSuperview()
        hostedView = view
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
