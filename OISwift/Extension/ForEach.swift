//
//  ForEach.swift
//  OISwift
//
//  Created by keenoi on 25/11/24.
//

/*import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis

    public init(_ data: Data, columns: Int = 1, rows: Int = 1, axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 8, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        super.init(frame: .zero)
        
        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints untuk ScrollView atau mainStackView
        if axis == .horizontal, let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                
                mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    // Layout untuk axis .vertical
    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            // Jika sudah mencapai jumlah kolom yang diinginkan, tambahkan row ke mainStackView
            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }
        
        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            for _ in 0..<placeholdersNeeded {
                let placeholder = UIView()
                placeholder.backgroundColor = .clear
                currentRowStackView.addArrangedSubview(placeholder)
            }
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    // Layout untuk axis .horizontal
    private func setupHorizontalLayout() {
        var currentColumnStackView = createColumnStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentColumnStackView.addArrangedSubview(view)

            // Jika sudah mencapai jumlah baris yang diinginkan, tambahkan column ke mainStackView
            if (index + 1) % rows == 0 {
                mainStackView.addArrangedSubview(currentColumnStackView)
                currentColumnStackView = createColumnStackView()
            }
        }
        
        if !currentColumnStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
            for _ in 0..<placeholdersNeeded {
                let placeholder = UIView()
                placeholder.backgroundColor = .clear
                currentColumnStackView.addArrangedSubview(placeholder)
            }
            mainStackView.addArrangedSubview(currentColumnStackView)
        }
    }

    // Fungsi untuk membuat row `UIStackView` untuk kolom (axis .vertical)
    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = mainStackView.spacing
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    // Fungsi untuk membuat column `UIStackView` untuk baris (axis .horizontal)
    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }
}*/



/*import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis

    public init(_ data: Data, columns: Int = 1, rows: Int = 1, axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 8, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        super.init(frame: .zero)
        
        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints untuk ScrollView atau mainStackView
        if axis == .horizontal, let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                
                mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    // Layout untuk axis .vertical
    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            // Jika sudah mencapai jumlah kolom yang diinginkan, tambahkan row ke mainStackView
            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }
        
        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            for _ in 0..<placeholdersNeeded {
                let placeholder = UIView()
                placeholder.backgroundColor = .clear
                currentRowStackView.addArrangedSubview(placeholder)
            }
            mainStackView.addArrangedSubview(currentRowStackView)
        }
        
        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            for _ in 0..<placeholdersNeeded {
                let placeholder = UIView()
                placeholder.backgroundColor = .clear
                currentRowStackView.addArrangedSubview(placeholder)
            }
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    // Layout untuk axis .horizontal
    private func setupHorizontalLayout() {
        var currentColumnStackView = createColumnStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentColumnStackView.addArrangedSubview(view)

            // Jika sudah mencapai jumlah baris yang diinginkan, tambahkan column ke mainStackView
            if (index + 1) % rows == 0 {
                mainStackView.addArrangedSubview(currentColumnStackView)
                currentColumnStackView = createColumnStackView()
            }
        }
        
        if !currentColumnStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
            for _ in 0..<placeholdersNeeded {
                let placeholder = UIView()
                placeholder.backgroundColor = .clear
                currentColumnStackView.addArrangedSubview(placeholder)
            }
            mainStackView.addArrangedSubview(currentColumnStackView)
        }
    }

    // Fungsi untuk membuat row `UIStackView` untuk kolom (axis .vertical)
    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = mainStackView.spacing
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    // Fungsi untuk membuat column `UIStackView` untuk baris (axis .horizontal)
    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }
}*/

/*import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis
    private var multiplier: CGFloat?
    private var isPaging: Bool

    public init(
        _ data: Data,
        columns: Int = 1,
        rows: Int = 1,
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 8,
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        self.multiplier = multiplier
        self.isPaging = isPaging
        super.init(frame: .zero)
        
        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.isPagingEnabled = isPaging // Aktivasi paging jika diperlukan
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints untuk ScrollView atau mainStackView
        if axis == .horizontal, let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                
                mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
            
            // Jika multiplier diatur, ubah lebar mainStackView
            if let multiplier = multiplier {
                NSLayoutConstraint.activate([
                    mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: multiplier)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }

        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            addPlaceholders(to: currentRowStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    private func setupHorizontalLayout() {
        // Jika elemen hanya satu baris di horizontal layout, gunakan langsung mainStackView
        if rows == 1 {
            for item in data {
                let view = contentBuilder(item)
                mainStackView.addArrangedSubview(view)
            }
        } else {
            var currentColumnStackView = createColumnStackView()

            for (index, item) in data.enumerated() {
                let view = contentBuilder(item)
                currentColumnStackView.addArrangedSubview(view)

                if (index + 1) % rows == 0 {
                    mainStackView.addArrangedSubview(currentColumnStackView)
                    currentColumnStackView = createColumnStackView()
                }
            }

            if !currentColumnStackView.arrangedSubviews.isEmpty {
                let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
                addPlaceholders(to: currentColumnStackView, count: placeholdersNeeded)
                mainStackView.addArrangedSubview(currentColumnStackView)
            }
        }

        // Pastikan distribusi stack view horizontal mengisi ruang secara merata
        mainStackView.distribution = .fillEqually
    }

    private func addPlaceholders(to stackView: UIStackView, count: Int) {
        for _ in 0..<count {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            stackView.addArrangedSubview(placeholder)
        }
    }

    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = mainStackView.spacing
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }
}*/


/*import UIKit

open class ForEach<Data, Content: UIView>: UIView, UIScrollViewDelegate where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis
    private var multiplier: CGFloat?
    private var isPaging: Bool
    private var pageControl: UIPageControl?
    private var emptyStateView: UIView?

    // Primary initializer
    public init(
        _ data: Data,
        columns: Int = 1,
        rows: Int = 1,
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 8,
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        emptyStateView: UIView? = nil,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        self.multiplier = multiplier
        self.isPaging = isPaging
        self.emptyStateView = emptyStateView
        super.init(frame: .zero)
        
        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.isPagingEnabled = isPaging
            scrollView.delegate = self
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }
        
        setupViews()
    }

    // Failable initializer for NSCoder
    required public init?(coder: NSCoder) {
        // Provide default values for properties
        self.data = [] as! Data // Ensure the type conforms to an empty collection
        self.contentBuilder = { _ in Content() }
        self.columns = 1
        self.rows = 1
        self.axis = .vertical
        self.multiplier = nil
        self.isPaging = false
        self.emptyStateView = nil

        super.init(coder: coder)

        // Log an error if this initializer is used
        assertionFailure("init(coder:) has not been fully implemented.")
    }

    private func setupViews() {
        if data.isEmpty {
            setupEmptyStateView()
            return
        }

        if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints for ScrollView or mainStackView
        if axis == .horizontal, let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                
                mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
            
            if let multiplier = multiplier {
                NSLayoutConstraint.activate([
                    mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: multiplier)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }

        if isPaging {
            setupPageControl()
        }
    }

    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }

        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            addPlaceholders(to: currentRowStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    private func setupHorizontalLayout() {
        if rows == 1 {
            for item in data {
                let view = contentBuilder(item)
                mainStackView.addArrangedSubview(view)
            }
        } else {
            var currentColumnStackView = createColumnStackView()

            for (index, item) in data.enumerated() {
                let view = contentBuilder(item)
                currentColumnStackView.addArrangedSubview(view)

                if (index + 1) % rows == 0 {
                    mainStackView.addArrangedSubview(currentColumnStackView)
                    currentColumnStackView = createColumnStackView()
                }
            }

            if !currentColumnStackView.arrangedSubviews.isEmpty {
                let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
                addPlaceholders(to: currentColumnStackView, count: placeholdersNeeded)
                mainStackView.addArrangedSubview(currentColumnStackView)
            }
        }

        mainStackView.distribution = .fillEqually
    }

    private func setupPageControl() {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = Int(ceil(Double(data.count) / Double(columns * rows)))
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        self.pageControl = pageControl
    }

    private func setupEmptyStateView() {
        guard let emptyView = emptyStateView else { return }
        addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emptyView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            emptyView.heightAnchor.constraint(equalTo: emptyView.widthAnchor)
        ])
    }

    private func updatePageControl(scrollView: UIScrollView) {
        guard isPaging, let pageControl = pageControl else { return }
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }

    private func addPlaceholders(to stackView: UIStackView, count: Int) {
        for _ in 0..<count {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            stackView.addArrangedSubview(placeholder)
        }
    }

    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = mainStackView.spacing
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl(scrollView: scrollView)
    }
}*/

import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis
    private var multiplier: CGFloat?
    private var isPaging: Bool

    public init(
        _ data: Data,
        columns: Int = 1,
        rows: Int = 1,
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 8,
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        content: @escaping (Data.Element) -> Content
    ) {
        // Validasi data kosong
        guard !data.isEmpty else {
            print("Warning: Data collection is empty. Skipping view creation.")
            self.data = data
            self.contentBuilder = content
            self.columns = columns
            self.rows = rows
            self.axis = axis
            self.multiplier = multiplier
            self.isPaging = isPaging
            super.init(frame: .zero)
            return
        }

        self.data = data
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        self.multiplier = multiplier
        self.isPaging = isPaging
        super.init(frame: .zero)

        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        if axis == .horizontal || (axis == .vertical && isPaging) {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = (axis == .horizontal)
            scrollView.alwaysBounceVertical = (axis == .vertical)
            scrollView.isPagingEnabled = isPaging
            scrollView.showsVerticalScrollIndicator = !isPaging
            scrollView.showsHorizontalScrollIndicator = !isPaging
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }
        
        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        if axis == .vertical && isPaging {
            setupVerticalPagingLayout()
        } else if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints untuk ScrollView atau mainStackView
        if let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])

            if axis == .horizontal {
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                    mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                    mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
                ])
                if let multiplier = multiplier {
                    NSLayoutConstraint.activate([
                        mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: multiplier)
                    ])
                }
            } else if axis == .vertical && isPaging {
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                    mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                    mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
                ])
                // Tinggi stackView untuk paging
                NSLayoutConstraint.activate([
                    mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: CGFloat(data.count))
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }

        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            addPlaceholders(to: currentRowStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    private func setupHorizontalLayout() {
        var currentColumnStackView = createColumnStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentColumnStackView.addArrangedSubview(view)

            if (index + 1) % rows == 0 {
                mainStackView.addArrangedSubview(currentColumnStackView)
                currentColumnStackView = createColumnStackView()
            }
        }

        if !currentColumnStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
            addPlaceholders(to: currentColumnStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentColumnStackView)
        }

        mainStackView.distribution = .fillEqually
    }

    private func setupVerticalPagingLayout() {
        // Menambahkan semua elemen ke mainStackView
        for item in data {
            let view = contentBuilder(item)
            mainStackView.addArrangedSubview(view)
        }
    }

    private func addPlaceholders(to stackView: UIStackView, count: Int) {
        for _ in 0..<count {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            stackView.addArrangedSubview(placeholder)
        }
    }

    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = mainStackView.spacing
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }
}

/*import UIKit

open class ForEach<Data, Content: UIView>: UIView where Data: Collection {
    private var data: Data
    private var contentBuilder: (Data.Element) -> Content
    private let mainStackView = UIStackView()
    private var scrollView: UIScrollView?
    private var columns: Int
    private var rows: Int
    private var axis: NSLayoutConstraint.Axis
    private var multiplier: CGFloat?
    private var isPaging: Bool

    // Memodifikasi init untuk mendukung binding
    public init(
        _ data: SBinding<Data>,
        columns: Int = 1,
        rows: Int = 1,
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 8,
        multiplier: CGFloat? = nil,
        isPaging: Bool = false,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data.wrappedValue // Mengambil nilai awal dari binding
        self.contentBuilder = content
        self.columns = columns
        self.rows = rows
        self.axis = axis
        self.multiplier = multiplier
        self.isPaging = isPaging
        super.init(frame: .zero)

        mainStackView.axis = axis
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        // Mengupdate data saat terjadi perubahan
        data.didSet = { [weak self] newValue in
            self?.data = newValue
            self?.setupViews() // Refresh tampilan saat data berubah
        }

        if axis == .horizontal || (axis == .vertical && isPaging) {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = (axis == .horizontal)
            scrollView.alwaysBounceVertical = (axis == .vertical)
            scrollView.isPagingEnabled = isPaging
            scrollView.showsVerticalScrollIndicator = !isPaging
            scrollView.showsHorizontalScrollIndicator = !isPaging
            scrollView.addSubview(mainStackView)
            self.scrollView = scrollView
            addSubview(scrollView)
        } else {
            addSubview(mainStackView)
        }

        setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        if axis == .vertical && isPaging {
            setupVerticalPagingLayout()
        } else if axis == .vertical {
            setupVerticalLayout()
        } else {
            setupHorizontalLayout()
        }

        // Constraints untuk ScrollView atau mainStackView
        if let scrollView = scrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])

            if axis == .horizontal {
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                    mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                    mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
                ])
                if let multiplier = multiplier {
                    NSLayoutConstraint.activate([
                        mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: multiplier)
                    ])
                }
            } else if axis == .vertical && isPaging {
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                    mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                    mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                    mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                    mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
                ])
                // Tinggi stackView untuk paging
                NSLayoutConstraint.activate([
                    mainStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: CGFloat(data.count))
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    // Layout Methods: setupVerticalLayout, setupHorizontalLayout, setupVerticalPagingLayout tetap sama...

    private func setupVerticalLayout() {
        var currentRowStackView = createRowStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentRowStackView.addArrangedSubview(view)

            if (index + 1) % columns == 0 {
                mainStackView.addArrangedSubview(currentRowStackView)
                currentRowStackView = createRowStackView()
            }
        }

        if !currentRowStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = columns - currentRowStackView.arrangedSubviews.count
            addPlaceholders(to: currentRowStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentRowStackView)
        }
    }

    private func setupHorizontalLayout() {
        var currentColumnStackView = createColumnStackView()

        for (index, item) in data.enumerated() {
            let view = contentBuilder(item)
            currentColumnStackView.addArrangedSubview(view)

            if (index + 1) % rows == 0 {
                mainStackView.addArrangedSubview(currentColumnStackView)
                currentColumnStackView = createColumnStackView()
            }
        }

        if !currentColumnStackView.arrangedSubviews.isEmpty {
            let placeholdersNeeded = rows - currentColumnStackView.arrangedSubviews.count
            addPlaceholders(to: currentColumnStackView, count: placeholdersNeeded)
            mainStackView.addArrangedSubview(currentColumnStackView)
        }

        mainStackView.distribution = .fillEqually
    }

    private func setupVerticalPagingLayout() {
        // Menambahkan semua elemen ke mainStackView
        for item in data {
            let view = contentBuilder(item)
            mainStackView.addArrangedSubview(view)
        }
    }
    
    private func addPlaceholders(to stackView: UIStackView, count: Int) {
        for _ in 0..<count {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            stackView.addArrangedSubview(placeholder)
        }
    }

    private func createRowStackView() -> UIStackView {
        // Gunakan variabel untuk menyimpan UIStackView
        var rowStackView: UIStackView?

        // Pastikan UIStackView dibuat di thread utama
        DispatchQueue.main.async {
            rowStackView = UIStackView()
            rowStackView?.axis = .horizontal
            rowStackView?.spacing = self.mainStackView.spacing
            rowStackView?.distribution = .fillEqually
        }

        // Tunggu sampai rowStackView berhasil diinisialisasi
        while rowStackView == nil {
            // Hindari penggunaan while yang blocking, lebih baik pakai completion handler
            // Sementara, Anda bisa memberi sedikit waktu agar thread utama selesai
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }

        // Jika masih nil setelah proses, maka gagal
        guard let validRowStackView = rowStackView else {
            fatalError("Failed to create UIStackView")
        }

        // Kembalikan UIStackView yang sudah valid
        return validRowStackView
    }


    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView()
        columnStackView.axis = .vertical
        columnStackView.spacing = mainStackView.spacing
        columnStackView.distribution = .fillEqually
        return columnStackView
    }
}*/

