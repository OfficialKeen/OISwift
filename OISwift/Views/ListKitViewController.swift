//
//  ListKitViewController.swift
//  OISwift
//
//  Created by keenoi on 19/01/26.
//

import UIKit

class ListKitViewController: UIViewController {

    @SBinding var itemsRows: [RowItem] = (1...20).map {
        RowItem(title: "Item \($0)")
    }
    
    @SBinding var itemsRows2: [RowItem] = (1...10).map {
        RowItem(title: "Item \($0)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //content1()
        //content2()
        content3()
    }
}

extension ListKitViewController {
    func content1() {
        view.VStack {
            ListKit(itemsRows) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Text().text(rows.title).font(12, weight: .medium)
                }.padding()
            }
        }.background(.white).padding()
    }
}

extension ListKitViewController {
    func content2() {
        view.VStack {
            ListCollection($itemsRows, axis: .horizontal, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Text().text(rows.title).font(12, weight: .medium)
                }.padding().frame(width: 100, height: 100).cornerRadius(10).stroke()
            }
        }.background(.white).padding()
    }
}

extension ListKitViewController {
    func content3() {
        view.VStack {
            ListCollection($itemsRows) { rows in
                View().VStack {
                    Text().text(rows.title).font(12, weight: .medium)
                    View().VStack {
                        ListCollection(self.$itemsRows2, axis: .horizontal) { rowss in
                            Text().text(rowss.title).font(12, weight: .medium)
                        }
                    }
                }.height(100)
            }
        }.background(.white).padding()
    }
}
