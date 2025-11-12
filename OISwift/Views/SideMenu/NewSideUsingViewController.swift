//
//  NewSideUsingViewController.swift
//  OISwift
//
//  Created by keenoi on 16/05/25.
//

import UIKit

class NewSideUsingViewController: UIViewController {
    
    var currentMenuSide: SideMenu = .rightSide
    var menuView: UIView!
    
    var initialMenuSize: CGFloat = 0.4 // Default ukuran menu (40% dari layar)
    let maxMenuSize: CGFloat = 0.9 // Maksimum ukuran (90% dari layar)
    let minMenuSize: CGFloat = 0.2 // Minimum ukuran (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupNavigationBar()
        setupGestureRecognizers()
        updateMenuFrame()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateMenuFrame()
        }, completion: nil)
    }
    
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuView
        menuView = UIView()
        menuView.backgroundColor = .systemTeal
        
        // Tambahkan MenuView ke view utama
        view.addSubview(menuView)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuView.layer.cornerRadius = 0
        menuView.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.3
        menuView.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuView.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Set Default ke Navigation Bar
        let setDefaultButton = UIBarButtonItem(title: "Set Default", style: .plain, target: self, action: #selector(setDefaultButtonTapped))
        navigationItem.rightBarButtonItem = setDefaultButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuView.addGestureRecognizer(panGesture)
    }
    
    @objc func setDefaultButtonTapped() {
        // Mengembalikan ukuran menu ke default
        initialMenuSize = 0.4
        updateMenuSize(initialMenuSize)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            switch currentMenuSide {
            case .bottomSide, .topSide:
                initialMenuSize = menuView.frame.size.height / view.frame.height
            case .leftSide, .rightSide:
                initialMenuSize = menuView.frame.size.width / view.frame.width
            }
        case .changed:
            var newSize = initialMenuSize
            switch currentMenuSide {
            case .bottomSide:
                newSize -= (translation.y / view.frame.height)
            case .topSide:
                newSize += (translation.y / view.frame.height)
            case .leftSide:
                newSize += (translation.x / view.frame.width)
            case .rightSide:
                newSize -= (translation.x / view.frame.width)
            }
            newSize = max(min(newSize, maxMenuSize), minMenuSize)
            updateMenuSize(newSize)
            
        case .ended:
            var targetSize: CGFloat
            switch currentMenuSide {
            case .bottomSide, .topSide:
                targetSize = closestMenuSize(for: menuView.frame.size.height / view.frame.height)
            case .leftSide, .rightSide:
                targetSize = closestMenuSize(for: menuView.frame.size.width / view.frame.width)
            }
            updateMenuSize(targetSize)
            
        default:
            break
        }
    }
    
    func closestMenuSize(for currentSize: CGFloat) -> CGFloat {
        let menuSizes: [CGFloat] = [0.2, 0.4, 0.9]
        var closest = menuSizes[0]
        var smallestDifference = abs(currentSize - closest)
        
        for size in menuSizes {
            let difference = abs(currentSize - size)
            if difference < smallestDifference {
                closest = size
                smallestDifference = difference
            }
        }
        
        return closest
    }
    
    func updateMenuFrame() {
        let initialSize: CGFloat
        switch currentMenuSide {
        case .bottomSide, .topSide:
            initialSize = view.frame.size.height * initialMenuSize
        case .leftSide, .rightSide:
            initialSize = view.frame.size.width * initialMenuSize
        }
        
        switch currentMenuSide {
        case .bottomSide:
            menuView.frame = CGRect(x: 0, y: view.frame.height - initialSize, width: view.frame.width, height: initialSize)
        case .topSide:
            menuView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: initialSize)
        case .leftSide:
            menuView.frame = CGRect(x: 0, y: 0, width: initialSize, height: view.frame.height)
        case .rightSide:
            menuView.frame = CGRect(x: view.frame.width - initialSize, y: 0, width: initialSize, height: view.frame.height)
        }
    }
    
    func updateMenuSize(_ sizePercentage: CGFloat) {
        var newSize: CGFloat
        switch currentMenuSide {
        case .bottomSide, .topSide:
            newSize = view.frame.size.height * sizePercentage
        case .leftSide, .rightSide:
            newSize = view.frame.size.width * sizePercentage
        }
        
        switch currentMenuSide {
        case .bottomSide, .topSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuView.frame.size.height = newSize
                self.menuView.frame.origin.y = self.currentMenuSide == .bottomSide ? self.view.frame.height - newSize : 0
            }, completion: nil)
        case .leftSide, .rightSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuView.frame.size.width = newSize
                self.menuView.frame.origin.x = self.currentMenuSide == .rightSide ? self.view.frame.width - newSize : 0
            }, completion: nil)
        }
    }
}
