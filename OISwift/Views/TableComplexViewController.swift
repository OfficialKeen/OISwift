//
//  TableComplexViewController.swift
//  OISwift
//
//  Created by keenoi on 22/06/24.
//

import UIKit

class TableComplexViewController: UIViewController {

    var tableView = Table()
    var currentDataType: Int = 0
    
    // Inisialisasi data
    var students: [Students] = [
        Students(id: 1, name: "John Doe", character: "J"),
        Students(id: 2, name: "Jane Smith", character: "J"),
        Students(id: 3, name: "Sam Brown", character: "S"),
        Students(id: 4, name: "John Doe", character: "J"),
        Students(id: 5, name: "Jane Smith", character: "J"),
        Students(id: 6, name: "Sam Brown", character: "S"),
        Students(id: 7, name: "John Doe", character: "J"),
        Students(id: 8, name: "Jane Smith", character: "J"),
        Students(id: 9, name: "Sam Brown", character: "S"),
        Students(id: 10, name: "Sam Brown", character: "S"),
        Students(id: 12, name: "John Doe", character: "J"),
        Students(id: 12, name: "Jane Smith", character: "J"),
        Students(id: 13, name: "Sam Brown", character: "S"),
        Students(id: 14, name: "John Doe", character: "J"),
        Students(id: 15, name: "Jane Smith", character: "J"),
        Students(id: 16, name: "Sam Brown", character: "S"),
        Students(id: 17, name: "John Doe", character: "J"),
        Students(id: 18, name: "Jane Smith", character: "J"),
        Students(id: 19, name: "Sam Brown", character: "S")
    ]
    
    var mahasiswa: [Mahasiswas] = [
        Mahasiswas(id: 1, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 2, nama: "Siti", character: "S"),
        Mahasiswas(id: 3, nama: "Budi", character: "B"),
        Mahasiswas(id: 4, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 5, nama: "Siti", character: "S"),
        Mahasiswas(id: 6, nama: "Budi", character: "B"),
        Mahasiswas(id: 7, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 8, nama: "Siti", character: "S"),
        Mahasiswas(id: 9, nama: "Budi", character: "B"),
        Mahasiswas(id: 10, nama: "Budi", character: "B"),
        Mahasiswas(id: 11, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 12, nama: "Siti", character: "S"),
        Mahasiswas(id: 13, nama: "Budi", character: "B"),
        Mahasiswas(id: 14, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 15, nama: "Siti", character: "S"),
        Mahasiswas(id: 16, nama: "Budi", character: "B"),
        Mahasiswas(id: 17, nama: "Ahmad", character: "A"),
        Mahasiswas(id: 18, nama: "Siti", character: "S"),
        Mahasiswas(id: 19, nama: "Budi", character: "B")
    ]
    
    var groupedStudents: [String: [String]] = [:]
    var groupedMahasiswa: [String: [String]] = [:]
    var studentSectionTitles: [String] = []
    var mahasiswaSectionTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView()
        groupData()
    }
    
    fileprivate func contentView() {
        listView()
        view.VStack(spacing: 10) {
            Segmented()
                .items(["Data Student dan Data Mahasiswa", "Data Pekerja", "Data Guru"])
                .setDefaultIndex(currentDataType)
                .fontSize(14, weight: .medium)
                .selectedColor(0x2882F5)
                .titleSelectColor(0xFFFFFF)
                .height(40)
                .onValueChanged { index in
                    self.currentDataType = index
                    self.tableView.reloadData()
                }
            tableView
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func listView() {
        tableView
            .setRegister(UITableViewCell.self, forCellReuseIdentifier: "cell")
            .delegate(self)
            .dataSource(self)
            .separatorStyle(.none)
    }
    
    func groupData() {
        for student in students {
            let key = student.character
            if var studentArray = groupedStudents[key] {
                studentArray.append(student.name)
                groupedStudents[key] = studentArray
            } else {
                groupedStudents[key] = [student.name]
            }
        }
        
        for mhs in mahasiswa {
            let key = mhs.character
            if var mahasiswaArray = groupedMahasiswa[key] {
                mahasiswaArray.append(mhs.nama)
                groupedMahasiswa[key] = mahasiswaArray
            } else {
                groupedMahasiswa[key] = [mhs.nama]
            }
        }
        
        studentSectionTitles = groupedStudents.keys.sorted()
        mahasiswaSectionTitles = groupedMahasiswa.keys.sorted()
        
    }
}

extension TableComplexViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + studentSectionTitles.count + mahasiswaSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 + studentSectionTitles.count {
            return 1 // Section header
        } else if section <= studentSectionTitles.count {
            let key = studentSectionTitles[section - 1]
            return groupedStudents[key]?.count ?? 0
        } else {
            let key = mahasiswaSectionTitles[section - 2 - studentSectionTitles.count]
            return groupedMahasiswa[key]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Data Student"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        } else if indexPath.section == 1 + studentSectionTitles.count {
            cell.textLabel?.text = "Data Mahasiswa"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        } else if indexPath.section <= studentSectionTitles.count {
            let key = studentSectionTitles[indexPath.section - 1]
            if let names = groupedStudents[key] {
                cell.textLabel?.text = names[indexPath.row]
            }
        } else {
            let key = mahasiswaSectionTitles[indexPath.section - 2 - studentSectionTitles.count]
            if let names = groupedMahasiswa[key] {
                cell.textLabel?.text = names[indexPath.row]
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 + studentSectionTitles.count {
            return nil
        } else if section <= studentSectionTitles.count {
            return studentSectionTitles[section - 1]
        } else {
            return mahasiswaSectionTitles[section - 2 - studentSectionTitles.count]
        }
    }
}

struct Students {
    let id: Int
    let name: String
    let character: String
}

struct Mahasiswas {
    let id: Int
    let nama: String
    let character: String
}

