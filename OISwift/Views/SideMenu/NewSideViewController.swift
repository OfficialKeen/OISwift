//
//  NewSideViewController.swift
//  OISwift
//
//  Created by keenoi on 16/05/25.
//

import UIKit

enum SideMenu {
    case bottomSide
    case topSide
    case leftSide
    case rightSide // Tambahkan kasus ini
}

class NewSideViewController: UIViewController {
    
    var currentMenuSide: SideMenu = .leftSide
    var menuViewController: UIViewController!
    
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
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .systemTeal
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 0
        menuViewController.view.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuViewController.view.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Set Default ke Navigation Bar
        let setDefaultButton = UIBarButtonItem(title: "Set Default", style: .plain, target: self, action: #selector(setDefaultButtonTapped))
        navigationItem.rightBarButtonItem = setDefaultButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
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
                initialMenuSize = menuViewController.view.frame.size.height / view.frame.height
            case .leftSide, .rightSide:
                initialMenuSize = menuViewController.view.frame.size.width / view.frame.width
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
                targetSize = closestMenuSize(for: menuViewController.view.frame.size.height / view.frame.height)
            case .leftSide, .rightSide:
                targetSize = closestMenuSize(for: menuViewController.view.frame.size.width / view.frame.width)
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
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialSize, width: view.frame.width, height: initialSize)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: initialSize)
        case .leftSide:
            menuViewController.view.frame = CGRect(x: 0, y: 0, width: initialSize, height: view.frame.height)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width - initialSize, y: 0, width: initialSize, height: view.frame.height)
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
                self.menuViewController.view.frame.size.height = newSize
                self.menuViewController.view.frame.origin.y = self.currentMenuSide == .bottomSide ? self.view.frame.height - newSize : 0
            }, completion: nil)
        case .leftSide, .rightSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuViewController.view.frame.size.width = newSize
                self.menuViewController.view.frame.origin.x = self.currentMenuSide == .rightSide ? self.view.frame.width - newSize : 0
            }, completion: nil)
        }
    }
}

/*
----------- BottomSide, TopSide, LeftSide, RightSide -----------
import UIKit

enum SideMenu {
    case bottomSide
    case topSide
    case leftSide
}

class NewSideViewController: UIViewController {
    
    var currentMenuSide: SideMenu = .leftSide
    var menuViewController: UIViewController!
    
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
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .systemTeal
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 0
        menuViewController.view.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuViewController.view.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Set Default ke Navigation Bar
        let setDefaultButton = UIBarButtonItem(title: "Set Default", style: .plain, target: self, action: #selector(setDefaultButtonTapped))
        navigationItem.rightBarButtonItem = setDefaultButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
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
                initialMenuSize = menuViewController.view.frame.size.height / view.frame.height
            case .leftSide:
                initialMenuSize = menuViewController.view.frame.size.width / view.frame.width
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
            }
            newSize = max(min(newSize, maxMenuSize), minMenuSize)
            updateMenuSize(newSize)
            
        case .ended:
            var targetSize: CGFloat
            switch currentMenuSide {
            case .bottomSide, .topSide:
                targetSize = closestMenuSize(for: menuViewController.view.frame.size.height / view.frame.height)
            case .leftSide:
                targetSize = closestMenuSize(for: menuViewController.view.frame.size.width / view.frame.width)
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
        case .leftSide:
            initialSize = view.frame.size.width * initialMenuSize
        }
        
        switch currentMenuSide {
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialSize, width: view.frame.width, height: initialSize)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: initialSize)
        case .leftSide:
            menuViewController.view.frame = CGRect(x: 0, y: 0, width: initialSize, height: view.frame.height)
        }
    }
    
    func updateMenuSize(_ sizePercentage: CGFloat) {
        var newSize: CGFloat
        switch currentMenuSide {
        case .bottomSide, .topSide:
            newSize = view.frame.size.height * sizePercentage
        case .leftSide:
            newSize = view.frame.size.width * sizePercentage
        }
        
        switch currentMenuSide {
        case .bottomSide, .topSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuViewController.view.frame.size.height = newSize
                self.menuViewController.view.frame.origin.y = self.currentMenuSide == .bottomSide ? self.view.frame.height - newSize : 0
            }, completion: nil)
        case .leftSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuViewController.view.frame.size.width = newSize
                self.menuViewController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}*/


/*
------ 2 SideMenu ------
import UIKit

enum SideMenu {
    case bottomSide
    case topSide
}

class NewSideViewController: UIViewController {
    
    var isMenuOpen = false
    var menuHeight: CGFloat = 200
    var currentMenuSide: SideMenu = .bottomSide
    var menuViewController: UIViewController!
    
    var initialMenuHeight: CGFloat = 0.4 // Default tinggi menu (40% dari layar)
    let maxMenuHeight: CGFloat = 0.9 // Maksimum height (90% dari layar)
    let minMenuHeight: CGFloat = 0.1 // Minimum height (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupNavigationBar()
        setupGestureRecognizers()
    }
    
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .systemTeal
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 0
        menuViewController.view.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuViewController.view.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Set Default ke Navigation Bar
        let setDefaultButton = UIBarButtonItem(title: "Set Default", style: .plain, target: self, action: #selector(setDefaultButtonTapped))
        navigationItem.rightBarButtonItem = setDefaultButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
    }
    
    @objc func setDefaultButtonTapped() {
        // Mengembalikan ukuran menu ke default
        initialMenuHeight = 0.4
        updateMenuHeight(initialMenuHeight)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialMenuHeight = menuViewController.view.frame.height / view.frame.height
            
        case .changed:
            var newHeight = initialMenuHeight
            switch currentMenuSide {
            case .bottomSide:
                newHeight -= (translation.y / view.frame.height)
            case .topSide:
                newHeight += (translation.y / view.frame.height)
            }
            newHeight = max(min(newHeight, maxMenuHeight), minMenuHeight)
            updateMenuHeight(newHeight)
            
        case .ended:
            let targetSize = closestMenuHeight(for: menuViewController.view.frame.height / view.frame.height)
            updateMenuHeight(targetSize)
            
        default:
            break
        }
    }
    
    func closestMenuHeight(for currentHeight: CGFloat) -> CGFloat {
        let menuHeights: [CGFloat] = [0.1, 0.4, 0.9]
        var closest = menuHeights[0]
        var smallestDifference = abs(currentHeight - closest)
        
        for height in menuHeights {
            let difference = abs(currentHeight - height)
            if difference < smallestDifference {
                closest = height
                smallestDifference = difference
            }
        }
        
        return closest
    }
    
    func updateMenuFrame() {
        let initialHeight = view.frame.height * initialMenuHeight
        
        switch currentMenuSide {
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialHeight, width: view.frame.width, height: initialHeight)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: initialHeight)
        }
    }
    
    func updateMenuHeight(_ sizePercentage: CGFloat) {
        let newSize = view.frame.height * sizePercentage
        
        switch currentMenuSide {
        case .bottomSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuViewController.view.frame.size.height = newSize
                self.menuViewController.view.frame.origin.y = self.view.frame.height - newSize
            }, completion: nil)
        case .topSide:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.menuViewController.view.frame.size.height = newSize
                self.menuViewController.view.frame.origin.y = 0
            }, completion: nil)
        }
    }
}*/
/*
----------- SIDE BOTTOM -----------
 
import UIKit

enum SideMenu {
    case bottomSide
    case topSide
}

class NewSideViewController: UIViewController {
    
    var isMenuOpen = false
    var menuHeight: CGFloat = 200
    var currentMenuSide: SideMenu = .bottomSide
    var menuViewController: UIViewController!
    
    var initialMenuHeight: CGFloat = 0.4 // Default tinggi menu (40% dari layar)
    let maxMenuHeight: CGFloat = 0.9 // Maksimum height (80% dari layar)
    let minMenuHeight: CGFloat = 0.0 // Minimum height (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupNavigationBar()
        setupGestureRecognizers()
    }
    
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .systemTeal
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 0
        menuViewController.view.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuViewController.view.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Set Default ke Navigation Bar
        let setDefaultButton = UIBarButtonItem(title: "Set Default", style: .plain, target: self, action: #selector(setDefaultButtonTapped))
        navigationItem.rightBarButtonItem = setDefaultButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
    }
    
    @objc func setDefaultButtonTapped() {
        // Mengembalikan ukuran menu ke default
        initialMenuHeight = 0.9
        updateMenuHeight(initialMenuHeight)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialMenuHeight = menuViewController.view.frame.height / view.frame.height
            
        case .changed:
            var newHeight = initialMenuHeight - (translation.y / view.frame.height)
            newHeight = max(min(newHeight, maxMenuHeight), minMenuHeight)
            updateMenuHeight(newHeight)
            
        case .ended:
            let targetSize = closestMenuHeight(for: menuViewController.view.frame.height / view.frame.height)
            updateMenuHeight(targetSize)
            
        default:
            break
        }
    }
    
    func closestMenuHeight(for currentHeight: CGFloat) -> CGFloat {
        let menuHeights: [CGFloat] = [0.1, 0.4, 0.8]
        var closest = menuHeights[0]
        var smallestDifference = abs(currentHeight - closest)
        
        for height in menuHeights {
            let difference = abs(currentHeight - height)
            if difference < smallestDifference {
                closest = height
                smallestDifference = difference
            }
        }
        
        return closest
    }
    
    func updateMenuFrame() {
        let initialHeight = view.frame.height * initialMenuHeight
        menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialHeight, width: view.frame.width, height: initialHeight)
    }
    
    func updateMenuHeight(_ sizePercentage: CGFloat) {
        let newSize = view.frame.height * sizePercentage
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.menuViewController.view.frame.size.height = newSize
            self.menuViewController.view.frame.origin.y = self.view.frame.height - newSize
        }, completion: nil)
    }
}*/

/*import UIKit

enum SideMenu {
    case bottomSide
}

class NewSideViewController: UIViewController {
    
    var isMenuOpen = false
    var menuHeight: CGFloat = 200
    var currentMenuSide: SideMenu = .bottomSide
    var menuViewController: UIViewController!
    
    var initialMenuHeight: CGFloat = 0.4 // Default tinggi menu (40% dari layar)
    let maxMenuHeight: CGFloat = 0.8 // Maksimum height (80% dari layar)
    let minMenuHeight: CGFloat = 0.1 // Minimum height (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupNavigationBar()
        setupGestureRecognizers()
    }
    
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .systemTeal
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 20
        menuViewController.view.layer.masksToBounds = false
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuViewController.view.layer.shadowRadius = 5
    }
    
    func setupNavigationBar() {
        // Tambahkan tombol Show Menu ke Navigation Bar
        let showMenuButton = UIBarButtonItem(title: "Show Menu", style: .plain, target: self, action: #selector(showMenuButtonTapped))
        navigationItem.rightBarButtonItem = showMenuButton
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
    }
    
    @objc func showMenuButtonTapped() {
        toggleMenu()
    }
    
    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                self.hideMenu()
            } else {
                self.showMenu()
            }
            self.isMenuOpen = !self.isMenuOpen
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialMenuHeight = menuViewController.view.frame.height / view.frame.height
            
        case .changed:
            var newHeight = initialMenuHeight - (translation.y / view.frame.height)
            newHeight = max(min(newHeight, maxMenuHeight), minMenuHeight)
            updateMenuHeight(newHeight)
            
        case .ended:
            let targetSize = closestMenuHeight(for: menuViewController.view.frame.height / view.frame.height)
            updateMenuHeight(targetSize)
            
        default:
            break
        }
    }
    
    func closestMenuHeight(for currentHeight: CGFloat) -> CGFloat {
        let menuHeights: [CGFloat] = [0.1, 0.4, 0.8]
        var closest = menuHeights[0]
        var smallestDifference = abs(currentHeight - closest)
        
        for height in menuHeights {
            let difference = abs(currentHeight - height)
            if difference < smallestDifference {
                closest = height
                smallestDifference = difference
            }
        }
        
        return closest
    }
    
    func updateMenuFrame() {
        let initialHeight = view.frame.height * initialMenuHeight
        menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialHeight, width: view.frame.width, height: initialHeight)
    }
    
    func showMenu() {
        // Reset initialMenuHeight to default value
        initialMenuHeight = 0.4
        let initialHeight = view.frame.height * initialMenuHeight
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame.origin.y = self.view.frame.height - initialHeight
            self.menuViewController.view.frame.size.height = initialHeight
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame.origin.y = self.view.frame.height
        }
    }
    
    func updateMenuHeight(_ sizePercentage: CGFloat) {
        let newSize = view.frame.height * sizePercentage
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.menuViewController.view.frame.size.height = newSize
            self.menuViewController.view.frame.origin.y = self.view.frame.height - newSize
        }, completion: nil)
    }
}*/
