//
//  SideMenuViewController.swift
//  OISwift
//
//  Created by keenoi on 21/02/25.
//

import UIKit

enum MenuMode {
    case flexible
    case fix(MenuSize) // Fix mode dengan ukuran tertentu
}

enum MenuSize {
    case full
    case half
    case tip
    case hidden
}

class SideMenuViewController: UIViewController {

    var isMenuOpen = false
    var menuWidth: CGFloat = 400
    var menuHeight: CGFloat = 200
    var menuView: UIView!
    var currentMenuSide: MenuSide = .rightSide // Default sisi menu

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
        setupGestureRecognizers()
    }

    func setupMenu() {
        view.backgroundColor = .white
        menuView = UIView()
        menuView.backgroundColor = .white
        
        menuView.layer.cornerRadius = 20
        menuView.layer.masksToBounds = false  // **Pastikan ini diatur ke false**
        
        // Menambahkan shadow pada menu
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.3 // Opasitas bayangan
        menuView.layer.shadowOffset = CGSize(width: 0, height: 3) // Offset bayangan
        menuView.layer.shadowRadius = 5 // Radius bayangan (semakin besar semakin
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        view.addSubview(menuView)
        view.bringSubviewToFront(menuView)
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
        // Menambahkan gesture ke menuView, bukan ke seluruh view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuView.addGestureRecognizer(panGesture)
    }

    @objc func showMenuButtonTapped() {
        toggleMenu()
    }

    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                // Sembunyikan menu dengan efek bounce
                self.hideMenu()
            } else {
                // Tampilkan menu dengan efek bounce
                self.showMenu()
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
            // Tentukan apakah menu harus dibuka atau ditutup berdasarkan kecepatan dan posisi
            if velocity.x > 500 || self.shouldOpenMenu() {
                self.showMenu()
                self.isMenuOpen = true
            } else {
                self.hideMenu()
                self.isMenuOpen = false
            }

        default:
            break
        }
    }

    // Update frame menu berdasarkan sisi yang dipilih
    func updateMenuFrame() {
        switch currentMenuSide {
        case .leftSide:
            menuView.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        case .topSide:
            menuView.frame = CGRect(x: 0, y: -menuHeight, width: view.frame.width, height: menuHeight)
        case .rightSide:
            menuView.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        case .bottomSide:
            menuView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: menuHeight)
        }
    }

    // Tampilkan menu dengan efek bounce
    func showMenu() {
        UIView.animate(
            withDuration: 0.5, // Durasi animasi
            delay: 0,
            usingSpringWithDamping: 0.6, // Nilai damping (0 = sangat berisi, 1 = tidak berisi)
            initialSpringVelocity: 0.5, // Kecepatan awal animasi
            options: .curveEaseInOut,
            animations: {
                switch self.currentMenuSide {
                case .leftSide:
                    self.menuView.frame.origin.x = 0
                case .topSide:
                    self.menuView.frame.origin.y = 0
                case .rightSide:
                    self.menuView.frame.origin.x = self.view.frame.width - self.menuWidth
                case .bottomSide:
                    self.menuView.frame.origin.y = self.view.frame.height - self.menuHeight
                }
            },
            completion: nil
        )
    }

    // Sembunyikan menu dengan efek bounce
    func hideMenu() {
        UIView.animate(
            withDuration: 0.6, // Durasi animasi
            delay: 0,
            usingSpringWithDamping: 0.6, // Damping memberikan efek bounce
            initialSpringVelocity: 0.8, // Kecepatan awal animasi
            options: [.curveEaseInOut],
            animations: {
                switch self.currentMenuSide {
                case .leftSide:
                    self.menuView.frame.origin.x = -self.menuWidth
                case .topSide:
                    self.menuView.frame.origin.y = -self.menuHeight
                case .rightSide:
                    self.menuView.frame.origin.x = self.view.frame.width
                case .bottomSide:
                    self.menuView.frame.origin.y = self.view.frame.height
                }
            },
            completion: nil
        )
    }

    // Update posisi menu saat di-drag
    func updateMenuPosition(with translation: CGPoint) {
        switch currentMenuSide {
        case .leftSide:
            let newX = menuView.frame.origin.x + translation.x
            if newX >= -menuWidth && newX <= 0 {
                menuView.frame.origin.x = newX
            }
        case .topSide:
            let newY = menuView.frame.origin.y + translation.y
            if newY >= -menuHeight && newY <= 0 {
                menuView.frame.origin.y = newY
            }
        case .rightSide:
            let newX = menuView.frame.origin.x + translation.x
            if newX >= view.frame.width - menuWidth && newX <= view.frame.width {
                menuView.frame.origin.x = newX
            }
        case .bottomSide:
            let newY = menuView.frame.origin.y + translation.y
            if newY >= view.frame.height - menuHeight && newY <= view.frame.height {
                menuView.frame.origin.y = newY
            }
        }
    }

    // Cek apakah menu harus dibuka berdasarkan posisi saat ini
    func shouldOpenMenu() -> Bool {
        switch currentMenuSide {
        case .leftSide:
            return menuView.frame.origin.x > -menuWidth / 2
        case .topSide:
            return menuView.frame.origin.y > -menuHeight / 2
        case .rightSide:
            return menuView.frame.origin.x < view.frame.width - menuWidth / 2
        case .bottomSide:
            return menuView.frame.origin.y < view.frame.height - menuHeight / 2
        }
    }
}

class sideClass: UIView {
    
}
/*import UIKit

class SideMenuViewController: UIViewController {

    var isMenuOpen = false
    let menuWidth: CGFloat = 400
    var menuView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton() // Tambahkan tombol dulu
        setupMenu() // Baru tambahkan menuView
        setupGestureRecognizers()
    }

    func setupMenu() {
        menuView = UIView()
        menuView.backgroundColor = .systemTeal
        menuView.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        view.addSubview(menuView)
        view.backgroundColor = .white
        // Pastikan menuView berada di paling depan
        view.bringSubviewToFront(menuView)
        
        let button = UIButton(type: .system)
        button.setTitle("Tombol di Menu", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        // Nonaktifkan translatesAutoresizingMaskIntoConstraints
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Tambahkan tombol ke view
        menuView.addSubview(button)
        
        // Atur constraints
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: menuView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }

    func setupShowMenuButton() {
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setTitle("Show Menu", for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        
        // Nonaktifkan translatesAutoresizingMaskIntoConstraints
        showMenuButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Tambahkan tombol ke view
        view.addSubview(showMenuButton)
        
        // Atur constraint untuk menempatkan tombol di tengah
        NSLayoutConstraint.activate([
            showMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showMenuButton.widthAnchor.constraint(equalToConstant: 100),
            showMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func showMenuButtonTapped() {
        toggleMenu()
    }

    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.isMenuOpen {
                self.menuView.frame.origin.x = self.view.frame.width
            } else {
                self.menuView.frame.origin.x = self.view.frame.width - self.menuWidth
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
            let newX = menuView.frame.origin.x + translation.x
            if newX >= view.frame.width - menuWidth && newX <= view.frame.width {
                menuView.frame.origin.x = newX
            }
            gesture.setTranslation(.zero, in: view)

        case .ended:
            if velocity.x > 500 || menuView.frame.origin.x < view.frame.width - menuWidth / 2 {
                UIView.animate(withDuration: 0.3) {
                    self.menuView.frame.origin.x = self.view.frame.width - self.menuWidth
                }
                isMenuOpen = true
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.menuView.frame.origin.x = self.view.frame.width
                }
                isMenuOpen = false
            }

        default:
            break
        }
    }
}*/
