//
//  FlexibleCollectionSectionViewController.swift
//  OISwift
//
//  Created by keenoi on 15/06/25.
//

import UIKit

class FlexibleCollectionSectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let userName = "John Doe"
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
            //cell.configure(with: userName)
            //cell.contentView.backgroundColor = .systemOrange
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
            cell.configure(with: items[indexPath.row])
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            //let cell = collectionView.cellForItem(at: indexPath) as? SearchCell
            /*
             default = 110
             2 Collection = 150
             1 Collection + warning = 160
             full = 210,
            */
            let height = 210//cell?.ishideCollection == true ? 50 : 200
            return CGSize(width: Int(collectionView.frame.width) - 40, height: height)
        } else {
            return CGSize(width: collectionView.frame.width - 40, height: 50)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("User selected: \(userName)")
        } else {
            print("Item selected: \(items[indexPath.row])")
        }
    }
}

class UserCell: UICollectionViewCell {
    static let reuseIdentifier = "UserCell"
    
    let profileImageView = UIImageView()
    let userNameLabel = UILabel()
    let hideButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure profileImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 25 // Assuming a circular image
        profileImageView.isHidden = true // Default hidden
        
        // Configure userNameLabel
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Configure hideButton
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        hideButton.setTitle("Show", for: .normal)
        hideButton.backgroundColor = .systemGreen
        hideButton.layer.cornerRadius = 5
        hideButton.addTarget(self, action: #selector(toggleProfileImage), for: .touchUpInside)
        
        // Create a vertical stack view
        let stackView = UIStackView(arrangedSubviews: [profileImageView, userNameLabel, hideButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with name: String) {
        userNameLabel.text = name
        profileImageView.image = UIImage(systemName: "person.fill") // Placeholder image
    }
    
    @objc private func toggleProfileImage() {
        profileImageView.isHidden = !profileImageView.isHidden
        hideButton.setTitle(profileImageView.isHidden ? "Show" : "Hide", for: .normal)
        hideButton.backgroundColor = profileImageView.isHidden ? .systemGreen : .systemRed
        
        // Notify the collection view to update the layout
        if let collectionView = superview as? UICollectionView {
            collectionView.performBatchUpdates({
                //collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }
}

class ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "ItemCell"
    
    let itemLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: String) {
        itemLabel.text = item
    }
}

class SearchCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchCell"
    @SBinding var ishideBarcode = true
    @SBinding var ishideCollection = false
    @SBinding var ishideWarning = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentView() {
        contentView.VStack(spacing: 5) {
            searchView()
            collectionsView()
        }
    }
    
    func searchView() -> UIView {
        self.HStack(spacing: 10) {
            HStack {
                SearchBar()
                    .font(14, weight: .medium)
                    .foregroundColor(0x333333)
                    .backgroundImage()
                    .background(.clear)
                    .placeholder("Search")
                VStack {
                    Image().image(systemName: "qrcode.viewfinder").foregroundColor(0xCACACA).scaledToFit()
                }.frame(width: 40, height: 40).padding().isHidden($ishideBarcode)
            }.background(0xF0F0F0).cornerRadius(5)
            
            Segmented()
                .items([
                    UIImage(systemName: "paperplane"),
                    UIImage(systemName: "qrcode.viewfinder")
                ])
                .imageSize(width: 25, height: 25)
                .setDefaultIndex(0)
                .width(90)
                .onValueChanged { index in
                    debugPrint("DEBUG: index ishideCollection [\(self.ishideCollection)] | ishideWarning [\(self.ishideWarning)]")
                    self.ishideBarcode.toggle()
                    //self.ishideCollection = index == 1 ? false : true
                    //self.ishideWarning = index == 2 ? false : true
                }
        }.height(40)
    }
    
    fileprivate func collectionsView() -> UIView {
        self.VStack(spacing: 5) {
            View().height(40).background(0xF0F0F0).cornerRadius(20)
            View().height(40).background(0xF0F0F0).cornerRadius(20).isHidden($ishideCollection)
            
            View().VStack {
                Text().text("Some items cannot be purchased due to backdate transaction.").font(14).multilineTextAlignment(.left)
            }.background(0xFFF6E6).cornerRadius(10).isHidden($ishideWarning).padding()
            Text().text("20 Items in PT. Ngadiran Sungadi").font(14).multilineTextAlignment(.left)
        }
    }
}
