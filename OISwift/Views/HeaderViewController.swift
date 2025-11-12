//
//  HeaderViewController.swift
//  OISwift
//
//  Created by keenoi on 03/09/24.
//

import UIKit

class HeaderViewController: UIViewController {

    var table = Table()
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView()
    }
}

extension HeaderViewController {
    fileprivate func contentView() {
        setView()
        
        view.VStack {
            table
        }.padding().background(.white)
    }
    
    fileprivate func setView() {
        table
            .setRegister(MyCell1.self, forCellReuseIdentifier: "Cell1")
            .setRegister(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
            .delegate(self)
            .dataSource(self)
            .separatorStyle(.none)
    }
}

extension HeaderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = table.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? MyCell1 else { return UITableViewCell() }
            cell.delegate = self
            return cell
        }
        guard let cell = table.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? UITableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = "Index \(indexPath.row)"
        return cell
    }
}

extension HeaderViewController: UITableViewCellDelegate {
    func onHide(_ cell: MyCell1) {
        //cell.isHideTop.toggle()
        let indexSet = IndexSet(integer: 0)
        table.reloadSections(indexSet, with: .fade)
        //.reloadSections(IndexSet(integer: 0), with: .fade)
    }
}

protocol UITableViewCellDelegate: AnyObject {
    func onHide(_ cell: MyCell1)
}

class MyCell1: UITableViewCell {
    weak var delegate: UITableViewCellDelegate?
    static let identifier = "MyCell1"
    @SBinding var isHideTop = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.VStack(spacing: 10) {
            Button().content {
                self.isHideTop.toggle()
                self.delegate?.onHide(self)
            } setup: { b in
                b.title("Test").foregroundColor(.gray).cornerRadius(5).height(40).stroke()
            }

            Button().content {
                
            } setup: { b in
                b.title("Hide").foregroundColor(.gray).cornerRadius(5).height(40).stroke()
            }.isHidden($isHideTop)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
