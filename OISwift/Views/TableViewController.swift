//
//  TableViewController.swift
//  OISwift
//
//  Created by keenoi on 20/06/24.
//

import UIKit

class TableViewController: UIViewController {

    var tableView = Table()
    
    // Buat instance UITableView
    var students: [MyStudent] = [
        MyStudent(id: 1, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 2, name: "Jane Smith", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 3, name: "Sam Brown", character: "S", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 4, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 5, name: "Jane Smith", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 6, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 7, name: "John Doe", character: "J", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 8, name: "Jane Smith", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 9, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 10, name: "Sam Brown", character: "S", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 12, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 12, name: "Jane Smith", character: "J", tanggal_lahir: "03 Jan 2000"),
        MyStudent(id: 13, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 14, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 15, name: "Jane Smith", character: "J", tanggal_lahir: "03 Jan 2000"),
        MyStudent(id: 16, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 17, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 18, name: "Jane Smith", character: "J", tanggal_lahir: "04 Jan 2000"),
        MyStudent(id: 19, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000")
    ]
    
    var mahasiswa: [MyMahasiswa] = [
        MyMahasiswa(id: 1, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 2, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 3, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 4, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 5, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 6, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 7, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 8, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 9, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 10, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 11, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 12, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 13, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 14, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 15, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 16, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 17, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 18, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 19, nama: "Budi", character: "B", tanggal_lahir: "01 Jan 2000")
    ]
    
    //var buku: [Buku] = []
    var buku: [Bukus] = [
        Bukus(id: 1, nama: "Buku 1", character: "J"),
        Bukus(id: 2, nama: "Buku 2", character: "J"),
        Bukus(id: 3, nama: "Buku 3", character: "S")
    ]
    var meja: [Mejas] = [
        Mejas(id: 1, nama: "Meja 1", character: "A"),
        Mejas(id: 2, nama: "Meja 2", character: "S"),
        Mejas(id: 3, nama: "Meja 3", character: "B")
    ]
    var burung: [Burungs] = [
        Burungs(id: 1, nama: "Burung 1", character: "A"),
        Burungs(id: 2, nama: "Burung 2", character: "S"),
        Burungs(id: 3, nama: "Burung 3", character: "B")
    ]
    
    var groupedStudents: [(String, [MyStudent])] = []
    var groupedMahasiswa: [(String, [MyMahasiswa])] = []

    var studentSectionTitles: [String] = []
    var mahasiswaSectionTitles: [String] = []
    
    var selectedIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension TableViewController {
    fileprivate func contentView() {
        listView()
        view.VStack(spacing: 10) {
            Segmented()
                .items(["Data Student dan Data Mahasiswa", "Data Buku", "Data Guru", "Data Burung"])
                .setDefaultIndex(selectedIndex)
                .fontSize(14, weight: .medium)
                .selectedColor(0x2882F5)
                .titleSelectColor(0xFFFFFF)
                .height(40)
                .onValueChanged { index in
                    self.selectedIndex = index
                    self.tableView.reloadData()
                }
            tableView
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func listView() {
        tableView
            .setRegister(SegmentCell.self, forCellReuseIdentifier: "SegmentCell")
            .setRegister(MyViewCell.self, forCellReuseIdentifier: "cell")
            .delegate(self)
            .dataSource(self)
            .separatorStyle(.none)
    }
    
    func groupData() {
        // Grouping students
        var studentsDict: [String: [MyStudent]] = [:]
        for student in students {
            let key = student.character
            if var studentArray = studentsDict[key] {
                studentArray.append(student)
                studentsDict[key] = studentArray
            } else {
                studentsDict[key] = [student]
            }
        }
        
        // Convert studentsDict to sorted array of tuples
        groupedStudents = studentsDict.sorted { $0.key < $1.key }
        
        // Grouping mahasiswa
        var mahasiswaDict: [String: [MyMahasiswa]] = [:]
        for mhs in mahasiswa {
            let key = mhs.character
            if var mahasiswaArray = mahasiswaDict[key] {
                mahasiswaArray.append(mhs)
                mahasiswaDict[key] = mahasiswaArray
            } else {
                mahasiswaDict[key] = [mhs]
            }
        }
        
        // Convert mahasiswaDict to sorted array of tuples
        groupedMahasiswa = mahasiswaDict.sorted { $0.key < $1.key }
        
        // Update section titles
        studentSectionTitles = groupedStudents.map { $0.0 }
        mahasiswaSectionTitles = groupedMahasiswa.map { $0.0 }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedIndex {
        case 0:
            return 2 + (students.isEmpty ? 1 : studentSectionTitles.count) + (mahasiswa.isEmpty ? 1 : mahasiswaSectionTitles.count)
        case 1, 2, 3:
            return 2 // Buku, Meja, and Burung
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Hanya ada 1 row untuk UISegmentedControl di section 0
            
        case 1:
            switch selectedIndex {
            case 0:
                return students.isEmpty ? 1 : studentSectionTitles.count // Menampilkan jumlah section berdasarkan students
            case 1:
                return buku.isEmpty ? 1 : buku.count // Menampilkan jumlah data buku
            case 2:
                return meja.isEmpty ? 1 : meja.count // Menampilkan jumlah data meja
            case 3:
                return burung.isEmpty ? 1 : burung.count // Menampilkan jumlah data burung
            default:
                return 0
            }
            
        case 2:
            switch selectedIndex {
            case 0:
                return mahasiswa.isEmpty ? 1 : mahasiswaSectionTitles.count // Menampilkan jumlah section berdasarkan mahasiswa
            default:
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Menggunakan SegmentCell untuk section pertama
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
            return cell
        } else {
            // Menggunakan MyViewCell untuk section lainnya
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyViewCell
            
            // Reset font dan ukuran teks default untuk cell yang bisa digunakan kembali
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            
            switch selectedIndex {
            case 0:
                if indexPath.section == 0 {
                    cell.textLabel?.text = "Data Student"
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                    cell.backgroundColor = .gray
                } else if indexPath.section == 1 + (students.isEmpty ? 1 : studentSectionTitles.count) {
                    cell.textLabel?.text = "Data Mahasiswa"
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                    cell.backgroundColor = .gray
                } else if indexPath.section == 1 && students.isEmpty {
                    cell.textLabel?.text = "Data Student Kosong"
                } else if indexPath.section == 2 + (students.isEmpty ? 1 : studentSectionTitles.count) && mahasiswa.isEmpty {
                    cell.textLabel?.text = "Data Mahasiswa Kosong"
                } else if indexPath.section <= studentSectionTitles.count {
                    let student = groupedStudents[indexPath.section - 1].1[indexPath.row]
                    cell.textLabel?.text = student.name
                } else {
                    let mahasiswa = groupedMahasiswa[indexPath.section - 2 - (students.isEmpty ? 1 : studentSectionTitles.count)].1[indexPath.row]
                    cell.textLabel?.text = mahasiswa.nama
                }
            case 1:
                if indexPath.section == 0 {
                    if buku.isEmpty {
                        cell.textLabel?.text = "Data Buku Kosong"
                    }
                } else {
                    cell.textLabel?.text = buku[indexPath.row].nama
                }
            case 2:
                if indexPath.section == 0 {
                    if meja.isEmpty {
                        cell.textLabel?.text = "Data Meja Kosong"
                    }
                } else {
                    cell.textLabel?.text = meja[indexPath.row].nama
                }
            case 3:
                if indexPath.section == 0 {
                    if burung.isEmpty {
                        cell.textLabel?.text = "Data Burung Kosong"
                    }
                } else {
                    cell.textLabel?.text = burung[indexPath.row].nama
                }
            default:
                break
            }
            
            return cell
        }
    }
}















struct Student {
    let id: Int
    let name: String
    let character: String
    let tanggal_lahir: String
}

struct Mahasiswa {
    let id: Int
    let nama: String
    let character: String
    let tanggal_lahir: String
}

struct Bukus {
    let id: Int
    let nama: String
    let character: String
}

struct Mejas {
    let id: Int
    let nama: String
    let character: String
}

struct Burungs {
    let id: Int
    let nama: String
    let character: String
}


class SegmentCell: UITableViewCell {
    var segmentedControl: UISegmentedControl!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Inisialisasi UISegmentedControl
        segmentedControl = UISegmentedControl(items: ["Data Student dan Data Mahasiswa", "Data Pekerja", "Data Guru"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        // Menambahkan segmentedControl ke dalam contentView
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentedControl)
        
        // Menyusun layout segmentedControl dalam cell
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func segmentedControlChanged() {
        // Mengirimkan perubahan segmented control ke delegate
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
