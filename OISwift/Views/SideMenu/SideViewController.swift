//
//  RightViewController.swift
//  OISwift
//
//  Created by keenoi on 21/02/25.
//

import UIKit

class MainSideController: UIViewController {

    var isMenuOpen = false
    var menuWidth: CGFloat = 200
    var menuHeight: CGFloat = 200
    var currentMenuSide: MenuSide = .bottomSide // Default sisi menu
    var menuViewController: SideViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
        setupGestureRecognizers()
    }

    func setupMenu() {
        // Inisialisasi MenuViewController
        view.backgroundColor = .white
        menuViewController = SideViewController()
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
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

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }

    @objc func showMenuButtonTapped() {
        toggleMenu()
    }
    
    @objc func toggleMenu() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6, // Damping untuk efek bounce
                       initialSpringVelocity: 0.5,  // Kecepatan animasi awal
                       options: .curveEaseInOut, // Animasi yang halus
                       animations: {
            if self.isMenuOpen {
                // Sembunyikan menu dengan efek bounce
                self.hideMenu()
            } else {
                // Tampilkan menu dengan efek bounce
                self.showMenu()
            }
            self.isMenuOpen = !self.isMenuOpen
        }, completion: nil)
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
            menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuHeight, width: view.frame.width, height: menuHeight)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: menuHeight)
        }
    }
    
    func showMenu() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            switch self.currentMenuSide {
            case .leftSide:
                self.menuViewController.view.frame.origin.x = 0
            case .topSide:
                self.menuViewController.view.frame.origin.y = 0
            case .rightSide:
                self.menuViewController.view.frame.origin.x = self.view.frame.width - self.menuWidth
            case .bottomSide:
                self.menuViewController.view.frame.origin.y = self.view.frame.height - self.menuHeight
            }
        }, completion: nil)
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            switch self.currentMenuSide {
            case .leftSide:
                self.menuViewController.view.frame.origin.x = -self.menuWidth
            case .topSide:
                self.menuViewController.view.frame.origin.y = -self.menuHeight
            case .rightSide:
                self.menuViewController.view.frame.origin.x = self.view.frame.width
            case .bottomSide:
                self.menuViewController.view.frame.origin.y = self.view.frame.height
            }
        }, completion: nil)
    }


    // Update posisi menu saat di-drag
    func updateMenuPosition(with translation: CGPoint) {
        switch currentMenuSide {
        case .leftSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= -menuWidth && newX <= 0 {
                menuViewController.view.frame.origin.x = newX
            }
        case .topSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= -menuHeight && newY <= 0 {
                menuViewController.view.frame.origin.y = newY
            }
        case .rightSide:
            let newX = menuViewController.view.frame.origin.x + translation.x
            if newX >= view.frame.width - menuWidth && newX <= view.frame.width {
                menuViewController.view.frame.origin.x = newX
            }
        case .bottomSide:
            let newY = menuViewController.view.frame.origin.y + translation.y
            if newY >= view.frame.height - menuHeight && newY <= view.frame.height {
                menuViewController.view.frame.origin.y = newY
            }
        }
    }

    // Cek apakah menu harus dibuka berdasarkan posisi saat ini
    func shouldOpenMenu() -> Bool {
        switch currentMenuSide {
        case .leftSide:
            return menuViewController.view.frame.origin.x > -menuWidth / 2
        case .topSide:
            return menuViewController.view.frame.origin.y > -menuHeight / 2
        case .rightSide:
            return menuViewController.view.frame.origin.x < view.frame.width - menuWidth / 2
        case .bottomSide:
            return menuViewController.view.frame.origin.y < view.frame.height - menuHeight / 2
        }
    }
}

class SideViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        
        // Tambahkan tombol
        let button = UIButton(type: .system)
        button.setTitle("Tombol di Menu", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.black, for: .normal)
        
        // Nonaktifkan translatesAutoresizingMaskIntoConstraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismis), for: .touchUpInside)
        // Tambahkan tombol ke view
        view.addSubview(button)
        
        // Atur constraints
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 50), // Jarak dari atas
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Jarak dari kiri
            button.widthAnchor.constraint(equalToConstant: 150), // Lebar tombol
            button.heightAnchor.constraint(equalToConstant: 40) // Tinggi tombol
        ])
    }
    
    @objc func handleDismis() {
        dismiss(animated: true)
    }
}
