//
//  ListCollection.swift
//  OISwift
//
//  Created by keenoi on 24/01/26.
//

import UIKit

// =======================================================
// MARK: - ListCollection (Final + SBinding Support)
// =======================================================
public final class ListCollection<Item>: UIView {
    
    public enum Axis { case vertical, horizontal }
    
    private let axis: Axis
    private let content: (Item) -> UIView
    private let idProvider: (Item) -> AnyHashable
    
    private var binding: SBinding<[Item]>?
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    private var itemMap: [AnyHashable: Item] = [:]
    private let viewCache = LRUCache<AnyHashable, UIView>(maxSize: 200)
    
    private enum Section { case main }
    
    private var showsSeparators: Bool = false
    // ===================================================
    // MARK: - INIT NORMAL
    // ===================================================
    public init(
        _ items: [Item],
        axis: Axis = .vertical,
        id: ((Item) -> AnyHashable)? = nil,
        content: @escaping (Item) -> UIView
    ) {
        self.axis = axis
        self.content = content
        
        if let explicitID = id {
            self.idProvider = explicitID
        }
        else if Item.self is Identifiable.Type {
            self.idProvider = { (item: Item) in
                (item as! Identifiable).id as! AnyHashable
            }
        }
        else {
            self.idProvider = { item in AnyHashable(ObjectIdentifier(item as AnyObject)) }
        }
        
        super.init(frame: .zero)
        
        setupCollectionView()
        setupDataSource()
        applySnapshot(items, animated: false)
    }
    
    
    
    // ===================================================
    // MARK: - INIT WITH BINDING
    // ===================================================
    public convenience init(
        _ binding: SBinding<[Item]>,
        axis: Axis = .vertical,
        id: ((Item) -> AnyHashable)? = nil,
        content: @escaping (Item) -> UIView
    ) {
        self.init(binding.wrappedValue, axis: axis, id: id, content: content)
        
        self.binding = binding
        
        // Auto-update ketika binding berubah
        binding.onChange { [weak self] oldValue, newValue in
            self?.applySnapshot(oldValue)
        }
    }
    
    
    
    public convenience init<T: Identifiable>(
        _ binding: SBinding<[T]>,
        content: @escaping (T) -> UIView
    ) where T == Item {
        self.init(binding, axis: .vertical, id: { $0.id }, content: content)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    
    
    // ===================================================
    // MARK: - Setup CollectionView
    // ===================================================
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        switch axis {
        case .vertical:
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = showsSeparators
            config.backgroundColor = .clear
            return UICollectionViewCompositionalLayout.list(using: config)
            
        case .horizontal:
            return UICollectionViewCompositionalLayout { _, _ in
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .estimated(120),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .estimated(120),
                        heightDimension: .estimated(60)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        }
    }
    
    
    
    // ===================================================
    // MARK: - DataSource
    // ===================================================
    private func setupDataSource() {
        
        let registration = UICollectionView.CellRegistration<HostedCollectionCell, AnyHashable> {
            [weak self] cell, indexPath, identifier in
            
            guard let self else { return }
            guard let item = self.itemMap[identifier] else { return }
            
            // Check cache first
            if let cachedView = self.viewCache[identifier] {
                // Remove from cache immediately before using
                self.viewCache[identifier] = nil
                cell.render(cachedView)
            } else {
                // Create new view
                let newView = self.content(item)
                cell.render(newView)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { cv, indexPath, identifier in
            cv.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: identifier)
        }
    }
    
    
    
    
    // ===================================================
    // MARK: - Public API
    // ===================================================
    public func applySnapshot(_ items: [Item], animated: Bool = true) {
        let ids = items.map(idProvider)
        itemMap = Dictionary(uniqueKeysWithValues: zip(ids, items))
        
        var snap = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snap.appendSections([.main])
        snap.appendItems(ids)
        
        dataSource.apply(snap, animatingDifferences: animated)
    }
    
    
    
    public func updateItem(_ item: Item) {
        let id = idProvider(item)
        
        // Update internal map
        itemMap[id] = item
        viewCache[id] = nil
        
        // Reload snapshot item
        var snap = dataSource.snapshot()
        if snap.itemIdentifiers.contains(id) {
            snap.reloadItems([id])
            dataSource.apply(snap, animatingDifferences: true)
        }
        
        // Sync ke binding
        if let binding = binding {
            var items = binding.wrappedValue
            if let idx = items.firstIndex(where: { idProvider($0) == id }) {
                items[idx] = item
                binding.wrappedValue = items
            }
        }
    }
    
    
    
    public func currentItems() -> [Item] {
        dataSource.snapshot().itemIdentifiers.compactMap { itemMap[$0] }
    }
    
    
    public func clearCache() {
        viewCache.removeAll()
    }
}

extension ListCollection {
    @discardableResult
    public func separator(_ isVisible: Bool = true) -> Self {
        guard axis == .vertical else { return self }

        self.showsSeparators = isVisible
        
        // Rebuild layout
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
        
        return self
    }
}
