//
//  ListKit.swift
//  OISwift
//
//  Created by keenoi on 19/01/26.
//

// MARK: LIST TABLE
import UIKit

final class ListKit<Item>: UIView {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let content: (Item) -> UIView
    private let id: (Item) -> AnyHashable

    private var itemMap: [AnyHashable: Item] = [:]
    private var viewCache: [AnyHashable: UIView] = [:]

    private var dataSource: UITableViewDiffableDataSource<Section, AnyHashable>!
    private enum Section { case main }

    // MARK: - Init
    init(_ items: [Item],
         id: @escaping (Item) -> AnyHashable,
         content: @escaping (Item) -> UIView) {
        self.id = id
        self.content = content
        super.init(frame: .zero)
        setupTable()
        setupDataSource()
        applySnapshot(items)
    }

    convenience init<T: Identifiable>(_ items: [T], content: @escaping (T) -> UIView) where T == Item {
        self.init(items, id: { $0.id }, content: content)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HostedCell.self, forCellReuseIdentifier: HostedCell.reuseID)

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(
            tableView: tableView
        ) { [weak self] tableView, indexPath, identifier in

            guard
                let self = self,
                let item = self.itemMap[identifier],
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: HostedCell.reuseID,
                    for: indexPath
                ) as? HostedCell
            else { return UITableViewCell() }

            // Cached view?
            let view: UIView
            if let cached = self.viewCache[identifier] {
                view = cached
            } else {
                let newView = self.content(item)
                self.viewCache[identifier] = newView
                view = newView
            }

            cell.render(view)
            return cell
        }
    }

    // MARK: - Snapshot (Fixed)
    func applySnapshot(_ items: [Item], animated: Bool = false) {
        let newIDs = items.map { id($0) }

        // Perbaikan #1 — remove hanya cache yang tidak dipakai
        let newSet = Set(newIDs)
        viewCache.keys
            .filter { !newSet.contains($0) }
            .forEach { viewCache.removeValue(forKey: $0) }

        // Perbaikan ID aman
        itemMap = [:]
        for (theID, item) in zip(newIDs, items) {
            itemMap[theID] = item // aman meskipun duplicate
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newIDs)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    // MARK: - Perbaikan #3
    /// Update satu item secara granular
    func updateItem(_ item: Item, animated: Bool = true) {
        let itemID = id(item)

        // replace value
        itemMap[itemID] = item

        // remove old cached view supaya build ulang
        viewCache[itemID] = nil

        // reload item in place
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([itemID])
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    /// Paksa layout ulang kalau ada UIView yang berubah ukuran internal
    func reloadLayout() {
        tableView.performBatchUpdates(nil)
    }
}

// =============================================================
// HostedCell
// =============================================================
private final class HostedCell: UITableViewCell {
    static let reuseID = "HostedCell"
    private var hostedView: UIView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    func render(_ view: UIView) {
        hostedView?.removeFromSuperview()
        hostedView = view

        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let bottom = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = .defaultHigh

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottom
        ])

        view.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}

/*
// MARK: LIST COLLECTION
import UIKit

final class ListCollection<Item>: UIView {

    private var collectionView: UICollectionView!
    private let content: (Item) -> UIView
    private let id: (Item) -> AnyHashable

    private var itemMap: [AnyHashable: Item] = [:]
    private var viewCache: [AnyHashable: UIView] = [:]

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private enum Section { case main }

    init(_ items: [Item],
         id: @escaping (Item) -> AnyHashable,
         content: @escaping (Item) -> UIView) {
        self.id = id
        self.content = content
        super.init(frame: .zero)
        setupCollectionView()
        setupDataSource()
        applySnapshot(items)
    }

    convenience init<T: Identifiable>(_ items: [T], content: @escaping (T) -> UIView) where T == Item {
        self.init(items, id: { $0.id }, content: content)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupCollectionView() {
        // 1. Gunakan List Configuration agar look & feel-nya mirip UITableView/List SwiftUI
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)

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

    private func setupDataSource() {
        // 2. Cell Registration (Cara modern, tidak perlu reuseID manual lagi)
        let cellRegistration = UICollectionView.CellRegistration<HostedCollectionCell, AnyHashable> { [weak self] cell, indexPath, identifier in
            guard let self = self, let item = self.itemMap[identifier] else { return }

            let view: UIView
            if let cached = self.viewCache[identifier] {
                view = cached
            } else {
                let newView = self.content(item)
                self.viewCache[identifier] = newView
                view = newView
            }
            cell.render(view)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    func applySnapshot(_ items: [Item], animated: Bool = true) {
        let newIDs = items.map { id($0) }
        
        // Cleanup cache
        let newSet = Set(newIDs)
        viewCache.keys.filter { !newSet.contains($0) }.forEach { viewCache.removeValue(forKey: $0) }

        itemMap = [:]
        for (theID, item) in zip(newIDs, items) {
            itemMap[theID] = item
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newIDs)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// =============================================================
// HostedCollectionCell
// =============================================================
private final class HostedCollectionCell: UICollectionViewCell {
    private var hostedView: UIView?

    func render(_ view: UIView) {
        // Pastikan tidak add view yang sama berulang kali
        guard hostedView != view else { return }
        
        hostedView?.removeFromSuperview()
        hostedView = view

        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        // Di CollectionView List, constraint harus sangat kuat agar self-sizing bekerja
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Kita tidak hapus hostedView dari cache, cuma lepas dari hierarchy cell
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
*/




/*
import UIKit

// =======================================================
// MARK: - LRU Cache (Stable & Efficient)
// =======================================================
final class LRUCache<Key: Hashable, Value> {
    private let maxSize: Int
    private var dict: [Key: Value] = [:]
    private var order: [Key] = []
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    subscript(key: Key) -> Value? {
        get {
            guard let value = dict[key] else { return nil }
            if let idx = order.firstIndex(of: key) { order.remove(at: idx) }
            order.append(key)
            return value
        }
        set {
            if let newValue = newValue {
                dict[key] = newValue
                
                if let idx = order.firstIndex(of: key) {
                    order.remove(at: idx)
                }
                order.append(key)
                
                if order.count > maxSize {
                    let oldest = order.removeFirst()
                    dict.removeValue(forKey: oldest)
                }
            } else {
                dict.removeValue(forKey: key)
                order.removeAll(where: { $0 == key })
            }
        }
    }
    
    func removeAll() {
        dict.removeAll()
        order.removeAll()
    }
    
    func remove(keys: [Key]) {
        for k in keys {
            dict.removeValue(forKey: k)
            order.removeAll(where: { $0 == k })
        }
    }
}



// =======================================================
// MARK: - Hosted Cell (Stable, No Layout Churn)
// =======================================================
final class HostedCollectionCell: UICollectionViewCell {
    private var hostedView: UIView?
    
    func render(_ view: UIView) {
        guard hostedView !== view else { return }  // jika sama, skip (stabil)
        
        hostedView?.removeFromSuperview()
        hostedView = view
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}



// =======================================================
// MARK: - ListCollection (Final Stable Version, ID Optional)
// =======================================================
public final class ListCollection<Item>: UIView {
    
    public enum Axis {
        case vertical, horizontal
    }
    
    // MARK: Properties
    private let axis: Axis
    private let content: (Item) -> UIView
    private let idProvider: (Item) -> AnyHashable     // final id resolver
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    private var itemMap: [AnyHashable: Item] = [:]
    private let viewCache = LRUCache<AnyHashable, UIView>(maxSize: 200)
    
    private enum Section { case main }
    
    
    
    // ===================================================
    // MARK: - INIT (ID OPTIONAL, AXIS DEFAULT VERTICAL)
    // ===================================================
    public init(
        _ items: [Item],
        axis: Axis = .vertical,
        id: ((Item) -> AnyHashable)? = nil,
        content: @escaping (Item) -> UIView
    ) {
        self.axis = axis
        self.content = content
        
        // ===================================================
        // MARK: ID Provider Logic (OPSIONAL & AUTO)
        // ===================================================
        if let explicitID = id {
            self.idProvider = explicitID                      // case 1: user memberikan id
        }
        else if Item.self is Identifiable.Type {
            self.idProvider = { (item: Item) in               // case 2: Identifiable otomatis
                (item as! Identifiable).id as! AnyHashable
            }
        }
        else {
            self.idProvider = { item in                       // case 3: Auto-ID stabil
                AnyHashable(ObjectIdentifier(item as AnyObject))
            }
        }
        
        super.init(frame: .zero)
        
        setupCollectionView()
        setupDataSource()
        applySnapshot(items)
    }
    
    
    // MARK: - Convenience Init (Identifiable)
    public convenience init<T: Identifiable>(
        _ items: [T],
        content: @escaping (T) -> UIView
    ) where T == Item {
        self.init(
            items,
            axis: .vertical,
            id: { $0.id },
            content: content
        )
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    
    // ===================================================
    // MARK: - CollectionView Setup
    // ===================================================
    private func setupCollectionView() {
        
        let layout: UICollectionViewCompositionalLayout
        
        switch axis {
        case .vertical:
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = true
            config.backgroundColor = .clear
            layout = UICollectionViewCompositionalLayout.list(using: config)
            
        case .horizontal:
            layout = UICollectionViewCompositionalLayout { _, _ in
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
    
    
    
    // ===================================================
    // MARK: - DataSource Setup
    // ===================================================
    private func setupDataSource() {
        
        let registration = UICollectionView.CellRegistration<HostedCollectionCell, AnyHashable> {
            [weak self] cell, _, identifier in
            
            guard let self else { return }
            guard let item = self.itemMap[identifier] else { return }
            
            // view caching stabil
            let view = self.viewCache[identifier] ?? {
                let newView = self.content(item)
                self.viewCache[identifier] = newView
                return newView
            }()
            
            cell.render(view)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { cv, indexPath, identifier in
            cv.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: identifier
            )
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
        let identifier = idProvider(item)
        
        itemMap[identifier] = item
        viewCache[identifier] = nil
        
        var snap = dataSource.snapshot()
        if snap.itemIdentifiers.contains(identifier) {
            snap.reloadItems([identifier])
            dataSource.apply(snap, animatingDifferences: true)
        }
    }
    
    
    public func clearCache() {
        viewCache.removeAll()
    }
    
    
    public func currentItems() -> [Item] {
        dataSource.snapshot().itemIdentifiers.compactMap { itemMap[$0] }
    }
}*/





// =======================================================
// MARK: - LRU Cache
// =======================================================




// =======================================================
// MARK: - Hosted Cell
// =======================================================



