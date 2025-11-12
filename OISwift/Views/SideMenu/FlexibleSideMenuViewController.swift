//
//  FlexibleSideMenuViewController.swift
//  OISwift
//
//  Created by keenoi on 25/02/25.
//

enum MenuSide {
    case leftSide
    case topSide
    case rightSide
    case bottomSide
}

import UIKit

class FlexibleSideMenuViewController: UIViewController {
    
    var isMenuOpen = true
    var menuWidth: CGFloat = 200
    var menuHeight: CGFloat = 200
    var currentMenuSide: MenuSide = .bottomSide // Default sisi menu
    var menuViewController: UIViewController!
    
    // Daftar proporsi ukuran menu untuk tinggi dan lebar menu
    var menuHeights: [CGFloat] = [0.1, 0.4, 0.9] // Untuk top dan bottom menu
    
    var initialMenuHeight: CGFloat = 0.4 // Default tinggi menu (10% dari layar)
    var initialMenuWidth: CGFloat = 0.3 // Default lebar menu (30% dari layar)
    let maxMenuHeight: CGFloat = 0.8 // Maksimum height (80% dari layar)
    let minMenuHeight: CGFloat = 0.1 // Minimum height (10% dari layar)
    let maxMenuWidth: CGFloat = 0.7 // Maksimum width (70% dari layar)
    let minMenuWidth: CGFloat = 0.1 // Minimum width (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
        setupGestureRecognizers() // Gesture recognizer sekarang ada di menuViewController
    }
    
    // Setup menu dengan menambahkan MenuViewController sebagai child
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .white
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.backgroundColor = .systemTeal
        menuViewController.view.layer.cornerRadius = 20
        menuViewController.view.layer.masksToBounds = false  // **Pastikan ini diatur ke false**
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3 // Opasitas bayangan
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3) // Offset bayangan
        menuViewController.view.layer.shadowRadius = 5 // Radius bayangan (semakin besar semakin lembut)
        
        // Menambahkan separator di tengah menu
        let separatorView = UIView()
        separatorView.backgroundColor = .darkGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        menuViewController.view.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.centerXAnchor.constraint(equalTo: menuViewController.view.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: menuViewController.view.topAnchor, constant: 20),
            separatorView.widthAnchor.constraint(equalToConstant: 60),
            separatorView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    // Menambahkan tombol untuk membuka menu
    func setupShowMenuButton() {
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setTitle("Show Menu", for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        
        showMenuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showMenuButton)
        
        NSLayoutConstraint.activate([
            showMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showMenuButton.widthAnchor.constraint(equalToConstant: 100),
            showMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Setup gesture recognizers untuk interaksi menu pada menuViewController
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)  // Apply pan gesture to menuViewController.view
    }
    
    @objc func showMenuButtonTapped() {
        toggleMenu()
    }
    
    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                // Sembunyikan menu
                self.hideMenu()
            } else {
                // Tampilkan menu
                self.showMenu()
            }
            self.isMenuOpen = !self.isMenuOpen
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            // Simpan ukuran awal saat gesture dimulai
            initialMenuHeight = menuViewController.view.frame.height / view.frame.height
            initialMenuWidth = menuViewController.view.frame.width / view.frame.width
            
        case .changed:
            // Ubah ukuran menu berdasarkan pergerakan jari
            if currentMenuSide == .bottomSide || currentMenuSide == .topSide {
                var newHeight = initialMenuHeight - (translation.y / view.frame.height)
                
                // Jika menu sudah melewati batas proporsi tertinggi
                if newHeight > menuHeights.last! {
                    // Efek bounce ke atas
                    newHeight = menuHeights.last! + (translation.y / view.frame.height) * 0.2
                }
                // Jika menu sudah melewati batas proporsi terendah
                else if newHeight < menuHeights.first! {
                    // Efek bounce ke bawah
                    newHeight = menuHeights.first! - (translation.y / view.frame.height) * 0.2
                }
                
                // Batasi tinggi menu agar tetap berada dalam rentang yang sesuai
                let clampedHeight = max(min(newHeight, menuHeights.last!), menuHeights.first!)
                updateMenuHeight(clampedHeight, isHeight: true)
            }
            else if currentMenuSide == .leftSide || currentMenuSide == .rightSide {
                var newWidth = initialMenuWidth - (translation.x / view.frame.width)
                
                // Jika menu sudah melewati batas proporsi tertinggi
                if newWidth > maxMenuWidth {
                    // Efek bounce ke kiri
                    newWidth = maxMenuWidth + (translation.x / view.frame.width) * 0.2
                }
                // Jika menu sudah melewati batas proporsi terendah
                else if newWidth < minMenuWidth {
                    // Efek bounce ke kanan
                    newWidth = minMenuWidth - (translation.x / view.frame.width) * 0.2
                }
                
                // Batasi lebar menu agar tetap berada dalam rentang yang sesuai
                let clampedWidth = max(min(newWidth, maxMenuWidth), minMenuWidth)
                updateMenuHeight(clampedWidth, isHeight: false)
            }
            
        case .ended:
            // Tentukan ukuran menu berdasarkan posisi gesture
            let targetSize = closestMenuHeight(for: menuViewController.view.frame.height / view.frame.height)
            updateMenuHeight(targetSize, isHeight: true)
            
        default:
            break
        }
    }
    
    // Mencari nilai yang paling mendekati currentHeight dari menuHeights
    func closestMenuHeight(for currentHeight: CGFloat) -> CGFloat {
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
    
    // Update frame menu berdasarkan sisi yang dipilih
    func updateMenuFrame() {
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuHeight, width: view.frame.width, height: menuHeight)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        case .bottomSide:
            let initialHeight = view.frame.height * initialMenuHeight
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - initialHeight, width: view.frame.width, height: initialHeight)
        }
    }
    
    // Tampilkan menu berdasarkan sisi yang dipilih
    func showMenu() {
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame.origin.x = 0
        case .topSide:
            menuViewController.view.frame.origin.y = 0
        case .rightSide:
            menuViewController.view.frame.origin.x = view.frame.width - menuWidth
        case .bottomSide:
            let initialHeight = view.frame.height * initialMenuHeight
            menuViewController.view.frame.origin.y = view.frame.height - initialHeight
        }
    }
    
    // Sembunyikan menu berdasarkan sisi yang dipilih
    func hideMenu() {
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame.origin.x = -menuWidth
        case .topSide:
            menuViewController.view.frame.origin.y = -menuHeight
        case .rightSide:
            menuViewController.view.frame.origin.x = view.frame.width
        case .bottomSide:
            menuViewController.view.frame.origin.y = view.frame.height
        }
    }
    
    // Update tinggi/lebar menu dengan animasi smooth dan bounce
    func updateMenuHeight(_ sizePercentage: CGFloat, isHeight: Bool) {
        let newSize: CGFloat
        
        if isHeight {
            newSize = view.frame.height * sizePercentage
        } else {
            newSize = view.frame.width * sizePercentage
        }
        
        // Gunakan animasi spring untuk efek bounce
        UIView.animate(
            withDuration: 0.5, // Durasi animasi
            delay: 0,
            usingSpringWithDamping: 0.6, // Nilai damping (0 = sangat berisi, 1 = tidak berisi)
            initialSpringVelocity: 0.5, // Kecepatan awal animasi
            options: .curveEaseInOut,
            animations: {
                if isHeight {
                    self.menuViewController.view.frame.size.height = newSize
                    self.menuViewController.view.frame.origin.y = self.view.frame.height - newSize
                } else {
                    self.menuViewController.view.frame.size.width = newSize
                    self.menuViewController.view.frame.origin.x = self.view.frame.width - newSize
                }
            },
            completion: nil
        )
    }
}



//================================================================================================================




/*import UIKit

class FlexibleSideMenuViewController: UIViewController {

    var isMenuOpen = false
    var currentMenuSide: MenuSide = .bottomSide // Default sisi menu
    var currentMenuMode: MenuMode = .flexible // Default mode menu
    var menuViewController: RightViewController!
    var panGesture: UIPanGestureRecognizer!

    // Ukuran menu berdasarkan tipe
    var menuFullSize: CGFloat {
        switch currentMenuSide {
        case .leftSide, .rightSide:
            return view.frame.width * 0.8 // 80% lebar layar
        case .topSide, .bottomSide:
            return view.frame.height * 0.8 // 80% tinggi layar
        }
    }

    var menuHalfSize: CGFloat {
        return menuFullSize / 2
    }

    var menuTipSize: CGFloat {
        return 50 // Ukuran kecil untuk tip
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
        setupGestureRecognizers()
    }

    func setupMenu() {
        view.backgroundColor = .white
        // Inisialisasi MenuViewController
        menuViewController = RightViewController()
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi dan ukuran menu
        updateMenuFrame()
    }

    func setupShowMenuButton() {
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setTitle("Show Menu", for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        
        showMenuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showMenuButton)
        
        NSLayoutConstraint.activate([
            showMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showMenuButton.widthAnchor.constraint(equalToConstant: 100),
            showMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
    }

    @objc func showMenuButtonTapped() {
        toggleMenu()
    }

    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                self.setMenuSize(.hidden)
            } else {
                self.setMenuSize(.tip) // Default buka tip size
            }
            self.isMenuOpen = !self.isMenuOpen
        }
    }

    @objc func handleTap() {
        if isMenuOpen {
            toggleMenu()
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .began, .changed:
            // Geser menu berdasarkan gerakan jari
            self.updateMenuPosition(with: translation)
            gesture.setTranslation(.zero, in: view)

        case .ended:
            // Tentukan ukuran menu berdasarkan posisi saat ini
            let newSize = self.calculateMenuSize()
            self.setMenuSize(newSize)
            self.isMenuOpen = newSize != .hidden

        default:
            break
        }
    }

    // Update frame menu berdasarkan sisi dan ukuran
    func updateMenuFrame() {
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame = CGRect(x: -menuFullSize, y: 0, width: menuFullSize, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuFullSize, width: view.frame.width, height: menuFullSize)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuFullSize, height: view.frame.height)
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: menuFullSize)
        }
    }

    // Set ukuran menu
    func setMenuSize(_ size: MenuSize) {
        UIView.animate(withDuration: 0.3) {
            switch self.currentMenuSide {
            case .leftSide:
                self.menuViewController.view.frame.origin.x = size == .hidden ? -self.menuFullSize : 0
            case .topSide:
                self.menuViewController.view.frame.origin.y = size == .hidden ? -self.menuFullSize : 0
            case .rightSide:
                self.menuViewController.view.frame.origin.x = size == .hidden ? self.view.frame.width : self.view.frame.width - self.menuFullSize
            case .bottomSide:
                self.menuViewController.view.frame.origin.y = size == .hidden ? self.view.frame.height : self.view.frame.height - self.menuFullSize
            }
        }
    }

    // Update posisi menu saat di-drag
    func updateMenuPosition(with translation: CGPoint) {
        switch currentMenuSide {
        case .leftSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= -menuFullSize && newX <= 0 {
                menuViewController.view.frame.origin.x = newX
            }
        case .topSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= -menuFullSize && newY <= 0 {
                menuViewController.view.frame.origin.y = newY
            }
        case .rightSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= view.frame.width - menuFullSize && newX <= view.frame.width {
                menuViewController.view.frame.origin.x = newX
            }
        case .bottomSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= view.frame.height - menuFullSize && newY <= view.frame.height {
                menuViewController.view.frame.origin.y = newY
            }
        }
    }

    // Cek apakah menu harus dibuka berdasarkan posisi saat ini
    func shouldOpenMenu() -> Bool {
        switch currentMenuSide {
        case .leftSide:
            return menuViewController.view.frame.origin.x > -menuFullSize / 2
        case .topSide:
            return menuViewController.view.frame.origin.y > -menuFullSize / 2
        case .rightSide:
            return menuViewController.view.frame.origin.x < view.frame.width - menuFullSize / 2
        case .bottomSide:
            return menuViewController.view.frame.origin.y < view.frame.height - menuFullSize / 2
        }
    }

    // Hitung ukuran menu berdasarkan posisi saat ini
    func calculateMenuSize() -> MenuSize {
        let thresholdFull = menuFullSize * 0.75 // 75% dari ukuran penuh
        let thresholdHalf = menuFullSize * 0.5  // 50% dari ukuran penuh
        let thresholdTip = menuFullSize * 0.25  // 25% dari ukuran penuh

        switch currentMenuSide {
        case .leftSide:
            let currentX = menuViewController.view.frame.origin.x
            if currentX > -thresholdFull {
                return .full
            } else if currentX > -thresholdHalf {
                return .half
            } else if currentX > -thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .topSide:
            let currentY = menuViewController.view.frame.origin.y
            if currentY > -thresholdFull {
                return .full
            } else if currentY > -thresholdHalf {
                return .half
            } else if currentY > -thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .rightSide:
            let currentX = menuViewController.view.frame.origin.x
            if currentX < view.frame.width - thresholdFull {
                return .full
            } else if currentX < view.frame.width - thresholdHalf {
                return .half
            } else if currentX < view.frame.width - thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .bottomSide:
            let currentY = menuViewController.view.frame.origin.y
            if currentY < view.frame.height - thresholdFull {
                return .full
            } else if currentY < view.frame.height - thresholdHalf {
                return .half
            } else if currentY < view.frame.height - thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        }
    }
}*/


/*import UIKit

class FlexibleSideMenuViewController: UIViewController {

    var isMenuOpen = false
    var currentMenuSide: MenuSide = .bottomSide // Default sisi menu
    var currentMenuSize: MenuSize = .tip // Default ukuran menu
    var menuViewController: RightViewController!
    var panGesture: UIPanGestureRecognizer!

    // Ukuran menu berdasarkan tipe
    var menuFullSize: CGFloat {
        switch currentMenuSide {
        case .leftSide, .rightSide:
            return view.frame.width * 0.8 // 80% lebar layar
        case .topSide, .bottomSide:
            return view.frame.height * 0.8 // 80% tinggi layar
        }
    }

    var menuHalfSize: CGFloat {
        return menuFullSize / 2
    }

    var menuTipSize: CGFloat {
        return 50 // Ukuran kecil untuk tip
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
        setupGestureRecognizers()
    }

    func setupMenu() {
        view.backgroundColor = .white
        // Inisialisasi MenuViewController
        menuViewController = RightViewController()
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi dan ukuran menu
        updateMenuFrame()
    }

    func setupShowMenuButton() {
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setTitle("Show Menu", for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        
        showMenuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showMenuButton)
        
        NSLayoutConstraint.activate([
            showMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showMenuButton.widthAnchor.constraint(equalToConstant: 100),
            showMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)
    }

    @objc func showMenuButtonTapped() {
        toggleMenu()
    }

    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                self.setMenuSize(.hidden)
            } else {
                self.setMenuSize(.half) // Default buka full size
            }
            self.isMenuOpen = !self.isMenuOpen
        }
    }

    @objc func handleTap() {
        if isMenuOpen {
            toggleMenu()
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .began, .changed:
            // Geser menu berdasarkan gerakan jari
            self.updateMenuPosition(with: translation)
            gesture.setTranslation(.zero, in: view)

        case .ended:
            // Tentukan ukuran menu berdasarkan kecepatan dan posisi
            if velocity.x > 500 || self.shouldOpenMenu() {
                self.setMenuSize(self.calculateMenuSize())
                self.isMenuOpen = true
            } else {
                self.setMenuSize(.hidden)
                self.isMenuOpen = false
            }

        default:
            break
        }
    }

    // Update frame menu berdasarkan sisi dan ukuran
    func updateMenuFrame() {
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame = CGRect(x: -menuFullSize, y: 0, width: menuFullSize, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuFullSize, width: view.frame.width, height: menuFullSize)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuFullSize, height: view.frame.height)
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: menuFullSize)
        }
    }

    // Set ukuran menu
    func setMenuSize(_ size: MenuSize) {
        currentMenuSize = size
        UIView.animate(withDuration: 0.3) {
            switch self.currentMenuSide {
            case .leftSide:
                self.menuViewController.view.frame.origin.x = size == .hidden ? -self.menuFullSize : 0
            case .topSide:
                self.menuViewController.view.frame.origin.y = size == .hidden ? -self.menuFullSize : 0
            case .rightSide:
                self.menuViewController.view.frame.origin.x = size == .hidden ? self.view.frame.width : self.view.frame.width - self.menuFullSize
            case .bottomSide:
                self.menuViewController.view.frame.origin.y = size == .hidden ? self.view.frame.height : self.view.frame.height - self.menuFullSize
            }
        }
    }

    // Update posisi menu saat di-drag
    func updateMenuPosition(with translation: CGPoint) {
        switch currentMenuSide {
        case .leftSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= -menuFullSize && newX <= 0 {
                menuViewController.view.frame.origin.x = newX
            }
        case .topSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= -menuFullSize && newY <= 0 {
                menuViewController.view.frame.origin.y = newY
            }
        case .rightSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= view.frame.width - menuFullSize && newX <= view.frame.width {
                menuViewController.view.frame.origin.x = newX
            }
        case .bottomSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= view.frame.height - menuFullSize && newY <= view.frame.height {
                menuViewController.view.frame.origin.y = newY
            }
        }
    }

    // Cek apakah menu harus dibuka berdasarkan posisi saat ini
    func shouldOpenMenu() -> Bool {
        switch currentMenuSide {
        case .leftSide:
            return menuViewController.view.frame.origin.x > -menuFullSize / 2
        case .topSide:
            return menuViewController.view.frame.origin.y > -menuFullSize / 2
        case .rightSide:
            return menuViewController.view.frame.origin.x < view.frame.width - menuFullSize / 2
        case .bottomSide:
            return menuViewController.view.frame.origin.y < view.frame.height - menuFullSize / 2
        }
    }

    // Hitung ukuran menu berdasarkan posisi saat ini
    func calculateMenuSize() -> MenuSize {
        let thresholdFull = menuFullSize * 0.75
        let thresholdHalf = menuFullSize * 0.5
        let thresholdTip = menuFullSize * 0.25

        switch currentMenuSide {
        case .leftSide:
            let currentX = menuViewController.view.frame.origin.x
            if currentX > -thresholdFull {
                return .full
            } else if currentX > -thresholdHalf {
                return .half
            } else if currentX > -thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .topSide:
            let currentY = menuViewController.view.frame.origin.y
            if currentY > -thresholdFull {
                return .full
            } else if currentY > -thresholdHalf {
                return .half
            } else if currentY > -thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .rightSide:
            let currentX = menuViewController.view.frame.origin.x
            if currentX < view.frame.width - thresholdFull {
                return .full
            } else if currentX < view.frame.width - thresholdHalf {
                return .half
            } else if currentX < view.frame.width - thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        case .bottomSide:
            let currentY = menuViewController.view.frame.origin.y
            if currentY < view.frame.height - thresholdFull {
                return .full
            } else if currentY < view.frame.height - thresholdHalf {
                return .half
            } else if currentY < view.frame.height - thresholdTip {
                return .tip
            } else {
                return .hidden
            }
        }
    }
}*/
