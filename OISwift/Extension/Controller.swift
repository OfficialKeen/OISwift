//
//  Controller.swift
//  OISwift
//
//  Created by keenoi on 19/05/24.
//

import UIKit

public extension UIViewController {
    func background(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
    func background(_ hex: Int) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.background(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
    }
    
    func ishideBar(_ isHidden: Bool = true) {
        self.navigationController?.isNavigationBarHidden = isHidden
    }
}

