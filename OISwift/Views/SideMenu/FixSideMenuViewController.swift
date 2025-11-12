//
//  FixSideMenuViewController.swift
//  OISwift
//
//  Created by keenoi on 03/03/25.
//

import UIKit

class FixSideMenuViewController: UIViewController {
    
    var isMenuOpen = false
    var menuWidth: CGFloat = 200
    var menuHeight: CGFloat = 200
    var currentMenuSide: MenuSide = .bottomSide // Default sisi menu
    var menuViewController: UIViewController!
    
    var initialMenuHeight: CGFloat = 0.4 // Ukuran tetap 0.4 dari tinggi layar
    let maxMenuHeight: CGFloat = 0.8 // Maksimum height (80% dari layar)
    let minMenuHeight: CGFloat = 0.1 // Minimum height (10% dari layar)
    
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
        menuViewController.view.backgroundColor = .lightGray
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        menuViewController.view.layer.cornerRadius = 20
        menuViewController.view.layer.masksToBounds = false  // **Pastikan ini diatur ke false**
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3 // Opasitas bayangan
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3) // Offset bayangan
        menuViewController.view.layer.shadowRadius = 10 // Radius bayangan (semakin besar semakin lembut)
        
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
        
        // Sembunyikan menu secara default
        hideMenu()
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
    
    // Update frame menu berdasarkan sisi yang dipilih
    func updateMenuFrame() {
        let menuHeight = view.frame.height * initialMenuHeight // Menggunakan ukuran tetap
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuHeight, width: view.frame.width, height: menuHeight)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - menuHeight, width: view.frame.width, height: menuHeight)
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
            let menuHeight = view.frame.height * initialMenuHeight
            menuViewController.view.frame.origin.y = view.frame.height - menuHeight
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
    
    // Setup gesture recognizers untuk interaksi menu pada menuViewController
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        menuViewController.view.addGestureRecognizer(panGesture)  // Apply pan gesture to menuViewController.view
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            // Simpan posisi awal ketika pan gesture dimulai
            break
            
        case .changed:
            // Ubah posisi menu berdasarkan pergerakan jari
            let newY = menuViewController.view.frame.origin.y + translation.y
            
            // Batasi pergerakan menu hanya pada area yang valid
            if newY >= view.frame.height - (view.frame.height * initialMenuHeight) && newY <= view.frame.height {
                menuViewController.view.frame.origin.y = newY
                gesture.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            // Tentukan apakah menu harus tetap terbuka atau ditutup berdasarkan posisi akhir
            if menuViewController.view.frame.origin.y <= view.frame.height - (view.frame.height * 0.1) {
                // Sembunyikan menu jika lebih dari batas bawah
                hideMenu()
            } else {
                // Tampilkan menu jika cukup besar
                showMenu()
            }
            
        default:
            break
        }
    }
}

/*import UIKit

class FixSideMenuViewController: UIViewController {
    
    var isMenuOpen = false
    var menuWidth: CGFloat = 400
    var menuHeight: CGFloat = 200
    var currentMenuSide: MenuSide = .rightSide // Default sisi menu
    var menuViewController: UIViewController!
    
    var menuHeights: [CGFloat] = [0.1, 0.4, 0.6, 0.8] // Daftar proporsi ukuran menu
    var currentHeightIndex = 1 // Menyimpan indeks ukuran saat ini (0.4)
    
    var initialMenuHeight: CGFloat = 1 // Ukuran tetap 0.4 dari tinggi layar
    let maxMenuHeight: CGFloat = 0.8 // Maksimum height (80% dari layar)
    let minMenuHeight: CGFloat = 0.1 // Minimum height (10% dari layar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowMenuButton()
        setupMenu()
    }
    
    // Setup menu dengan menambahkan MenuViewController sebagai child
    func setupMenu() {
        view.backgroundColor = .white
        
        // Inisialisasi MenuViewController
        menuViewController = UIViewController()
        menuViewController.view.backgroundColor = .lightGray
        
        // Tambahkan MenuViewController sebagai Child
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Atur frame awal berdasarkan sisi menu
        updateMenuFrame()
        
        // Menambahkan efek rounded corners pada menu
        //menuViewController.view.layer.cornerRadius = 20
        menuViewController.view.layer.masksToBounds = false  // **Pastikan ini diatur ke false**
        
        // Menambahkan shadow pada menu
        menuViewController.view.layer.shadowColor = UIColor.black.cgColor
        menuViewController.view.layer.shadowOpacity = 0.3 // Opasitas bayangan
        menuViewController.view.layer.shadowOffset = CGSize(width: 0, height: 3) // Offset bayangan
        menuViewController.view.layer.shadowRadius = 10 // Radius bayangan (semakin besar semakin lembut)
        
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
        
        // Sembunyikan menu secara default
        hideMenu()
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
    
    // Update frame menu berdasarkan sisi yang dipilih
    func updateMenuFrame() {
        // Mengatur ukuran menu menjadi tetap (misalnya 0.4)
        let menuHeight = view.frame.height * initialMenuHeight
        
        switch currentMenuSide {
        case .leftSide:
            menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        case .topSide:
            menuViewController.view.frame = CGRect(x: 0, y: -menuHeight, width: view.frame.width, height: menuHeight)
        case .rightSide:
            menuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: menuWidth, height: view.frame.height)
        case .bottomSide:
            menuViewController.view.frame = CGRect(x: 0, y: view.frame.height - menuHeight, width: view.frame.width, height: menuHeight)
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
            let menuHeight = view.frame.height * initialMenuHeight
            menuViewController.view.frame.origin.y = view.frame.height - menuHeight
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
}*/
