//
//  BounceScollViewController.swift
//  OISwift
//
//  Created by keenoi on 17/11/24.
//

import UIKit

class BounceScollViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var contentHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupContentView()
        populateContentView(with: 10) // Atur jumlah item
    }

    // MARK: - Setup Scroll View
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Setup Content View
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemGray5
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Tambahkan constraint untuk tinggi konten
        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 500) // Default tinggi
        contentHeightConstraint?.isActive = true
    }

    // MARK: - Populate Content
    private func populateContentView(with itemCount: Int) {
        // Clear content view and update its height
        resetContentView(for: itemCount)

        for i in 0..<itemCount {
            let label = createItemLabel(for: i)
            contentView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(i * 50) + 20),
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                label.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

    // MARK: - Helper Functions
    private func resetContentView(for itemCount: Int) {
        // Clear all subviews
        contentView.subviews.forEach { $0.removeFromSuperview() }

        // Update content height
        let totalHeight = CGFloat(itemCount * 50 + 20)
        contentHeightConstraint?.constant = totalHeight
    }

    private func createItemLabel(for index: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item \(index + 1)"
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }
}
/*import UIKit

class BounceScollViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var contentHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
    }

    private func setupScrollView() {
        // Konfigurasi UIScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        // Auto Layout untuk scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Konfigurasi contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        //contentView.backgroundColor = .systemGray5

        // Auto Layout untuk contentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Tambahkan tinggi konten sebagai constraint variabel
        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 50) // Default tinggi
        contentHeightConstraint?.isActive = true

        // Tambahkan item ke contentView
        setupContentItems(itemCount: 20) // Jumlah item diatur di sini
    }

    private func setupContentItems(itemCount: Int) {
        // Hapus semua subview sebelumnya (jika ada)
        contentView.subviews.forEach { $0.removeFromSuperview() }

        for i in 0..<itemCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Item \(i + 1)"
            label.textAlignment = .center
            label.backgroundColor = .systemBlue
            label.textColor = .white
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true

            contentView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(i * 50) + 20),
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                label.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

        // Perbarui tinggi konten berdasarkan jumlah item
        let totalHeight = CGFloat(itemCount * 50 + 20) // Total tinggi
        contentHeightConstraint?.constant = totalHeight
    }
}

// MARK: - UIScrollViewDelegate
extension BounceScollViewController: UIScrollViewDelegate {
    func scrollViewDidLayoutSubviews(_ scrollView: UIScrollView) {
        // Atur contentInset hanya jika konten lebih kecil dari tinggi scroll view
        if scrollView.contentSize.height <= scrollView.bounds.height {
            let inset = (scrollView.bounds.height - scrollView.contentSize.height) / 2
            scrollView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        } else {
            scrollView.contentInset = .zero // Reset contentInset jika konten melebihi layar
        }
    }
}*/
