//
//  SegmentedViewController.swift
//  OISwift
//
//  Created by keenoi on 22/06/24.
//

import UIKit

class SegmentedViewController: UIViewController {

    var tableView = Table()
    
    // Inisialisasi data
    //var students: [MyStudent] = []
    var students: [MyStudent] = [
        MyStudent(id: 1, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 2, name: "Jane Smith", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 3, name: "Sam Brown", character: "S", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 4, name: "John Doe", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 5, name: "Jane Smith", character: "J", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 6, name: "Sam Brown", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyStudent(id: 7, name: "John Doe", character: "J", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 8, name: "Jane Smith", character: "J", tanggal_lahir: "05 Jan 2000"),
        MyStudent(id: 9, name: "Sam Brown", character: "S", tanggal_lahir: "05 Jan 2000"),
        MyStudent(id: 10, name: "Sam Brown", character: "S", tanggal_lahir: "02 Jan 2000"),
        MyStudent(id: 12, name: "John Doe", character: "J", tanggal_lahir: "05 Jan 2000"),
        MyStudent(id: 12, name: "Jane Smith", character: "J", tanggal_lahir: "03 Jan 2000"),
        MyStudent(id: 13, name: "Sam Brown", character: "S", tanggal_lahir: "06 Jan 2000"),
        MyStudent(id: 14, name: "John Doe", character: "J", tanggal_lahir: "06 Jan 2000"),
        MyStudent(id: 15, name: "Jane Smith", character: "J", tanggal_lahir: "03 Jan 2000"),
        MyStudent(id: 16, name: "Sam Brown", character: "S", tanggal_lahir: "09 Jan 2000"),
        MyStudent(id: 17, name: "John Doe", character: "J", tanggal_lahir: "09 Jan 2000"),
        MyStudent(id: 18, name: "Jane Smith", character: "J", tanggal_lahir: "04 Jan 2000"),
        MyStudent(id: 19, name: "Sam Brown", character: "S", tanggal_lahir: "09 Jan 2000")
    ]

    var mahasiswa: [MyMahasiswa] = [
        MyMahasiswa(id: 1, nama: "Ahmad", character: "A", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 2, nama: "Siti", character: "S", tanggal_lahir: "01 Jan 2000"),
        MyMahasiswa(id: 3, nama: "Budi", character: "B", tanggal_lahir: "02 Jan 2000"),
        MyMahasiswa(id: 4, nama: "Ahmad", character: "A", tanggal_lahir: "02 Jan 2000"),
        MyMahasiswa(id: 5, nama: "Siti", character: "S", tanggal_lahir: "03 Jan 2000"),
        MyMahasiswa(id: 6, nama: "Budi", character: "B", tanggal_lahir: "03 Jan 2000"),
        MyMahasiswa(id: 7, nama: "Ahmad", character: "A", tanggal_lahir: "04 Jan 2000"),
        MyMahasiswa(id: 8, nama: "Siti", character: "S", tanggal_lahir: "04 Jan 2000"),
        MyMahasiswa(id: 9, nama: "Budi", character: "B", tanggal_lahir: "05 Jan 2000"),
        MyMahasiswa(id: 10, nama: "Budi", character: "B", tanggal_lahir: "05 Jan 2000"),
        MyMahasiswa(id: 11, nama: "Ahmad", character: "A", tanggal_lahir: "06 Jan 2000"),
        MyMahasiswa(id: 12, nama: "Siti", character: "S", tanggal_lahir: "06 Jan 2000"),
        MyMahasiswa(id: 13, nama: "Budi", character: "B", tanggal_lahir: "07 Jan 2000"),
        MyMahasiswa(id: 14, nama: "Ahmad", character: "A", tanggal_lahir: "07 Jan 2000"),
        MyMahasiswa(id: 15, nama: "Siti", character: "S", tanggal_lahir: "08 Jan 2000"),
        MyMahasiswa(id: 16, nama: "Budi", character: "B", tanggal_lahir: "08 Jan 2000"),
        MyMahasiswa(id: 17, nama: "Ahmad", character: "A", tanggal_lahir: "09 Jan 2000"),
        MyMahasiswa(id: 18, nama: "Siti", character: "S", tanggal_lahir: "09 Jan 2000"),
        MyMahasiswa(id: 19, nama: "Budi", character: "B", tanggal_lahir: "09 Jan 2000")
    ]
    
    var buku: [Buku] = []
    /*var buku: [Buku] = [
        Buku(id: 1, nama: "John Doe", character: "J"),
        Buku(id: 2, nama: "Jane Smith", character: "J"),
        Buku(id: 3, nama: "Sam Brown", character: "S")
    ]*/
    var meja: [Meja] = [
        Meja(id: 1, nama: "Ahmad", character: "A"),
        Meja(id: 2, nama: "Siti", character: "S"),
        Meja(id: 3, nama: "Budi", character: "B"),
        Meja(id: 4, nama: "Budi", character: "B")
    ]
    var burung: [Burung] = [
        Burung(id: 1, nama: "Ahmad", character: "A"),
        Burung(id: 2, nama: "Siti", character: "S"),
        Burung(id: 3, nama: "Budi", character: "B")
    ]
    
    //var groupedStudents: [String: [String]] = [:]
    //var groupedMahasiswa: [String: [String]] = [:]
    
    var groupedStudents: [(String, [MyStudent])] = []
    var groupedMahasiswa: [(String, [MyMahasiswa])] = []
    
    var studentSectionTitles: [String] = []
    var mahasiswaSectionTitles: [String] = []
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView()
        groupData()
    }
    
    fileprivate func contentView() {
        listView()
        view.VStack(spacing: 10) {
            Segmented()
                .items(["Student Mahasiswa", "Buku", "Meja", "Burung"])
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
            .setRegister(MyViewCell.self, forCellReuseIdentifier: "cell")
            .delegate(self)
            .dataSource(self)
            .separatorStyle(.none)
    }
    
    // Mengelompokkan data berdasarkan karakter
    /*func groupData() {
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
    }*/
    
    func groupData() {
        // Grouping students
        /*var studentsDict: [String: [MyStudent]] = [:]
        for student in students {
            let key = student.tanggal_lahir
            if var studentArray = studentsDict[key] {
                studentArray.append(student)
                studentsDict[key] = studentArray
            } else {
                studentsDict[key] = [student]
            }
        }
        
        // Convert studentsDict to sorted array of tuples
        groupedStudents = studentsDict.sorted { $0.key < $1.key }*/
        
        
        
        // Grouping mahasiswa
        /*var mahasiswaDict: [String: [MyMahasiswa]] = [:]
        for mhs in mahasiswa {
            let key = mhs.tanggal_lahir
            if var mahasiswaArray = mahasiswaDict[key] {
                mahasiswaArray.append(mhs)
                mahasiswaDict[key] = mahasiswaArray
            } else {
                mahasiswaDict[key] = [mhs]
            }
        }
        
        // Convert mahasiswaDict to sorted array of tuples
        groupedMahasiswa = mahasiswaDict.sorted { $0.key < $1.key }*/
        
        let groupedTemp = Dictionary(grouping: students, by: { $0.tanggal_lahir })
        groupedStudents = groupedTemp.sorted { $0.key < $1.key }
        
        let groupedMahasiswaTemp = Dictionary(grouping: mahasiswa, by: { $0.tanggal_lahir })
        groupedMahasiswa = groupedMahasiswaTemp.sorted { $0.key < $1.key }
        // Update section titles
        studentSectionTitles = groupedStudents.map { $0.0 }
        mahasiswaSectionTitles = groupedMahasiswa.map { $0.0 }
    }
}

extension SegmentedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedIndex {
        case 0:
            return 2 + (students.isEmpty ? 1 : studentSectionTitles.count) + (mahasiswa.isEmpty ? 1 : mahasiswaSectionTitles.count)
        case 1, 2, 3:
            return 2 // Menampilkan dua section untuk Buku, Meja, dan Burung
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            if section == 0 || section == 1 + (students.isEmpty ? 1 : studentSectionTitles.count) {
                return 1 // Section header
            } else if section == 1 && students.isEmpty {
                return 1 // "Data Student Kosong"
            } else if section == 2 + (students.isEmpty ? 1 : studentSectionTitles.count) && mahasiswa.isEmpty {
                return 1 // "Data Mahasiswa Kosong"
            } else if section <= studentSectionTitles.count {
                //let key = studentSectionTitles[section - 1]
                //return groupedStudents[key]?.count ?? 0
                return groupedStudents[section - 1].1.count
            } else {
                //let key = mahasiswaSectionTitles[section - 2 - (students.isEmpty ? 1 : studentSectionTitles.count)]
                //return groupedMahasiswa[key]?.count ?? 0
                return groupedMahasiswa[section - 2 - (students.isEmpty ? 1 : studentSectionTitles.count)].1.count
            }
        case 1:
            if section == 0 {
                return buku.isEmpty ? 1 : 0 // Jika buku kosong, kembalikan 1 untuk "Data Buku Kosong"
            } else {
                return buku.count
            }
        case 2:
            if section == 0 {
                return meja.isEmpty ? 1 : 0 // Jika meja kosong, kembalikan 1 untuk "Data Meja Kosong"
            } else {
                return meja.count
            }
        case 3:
            if section == 0 {
                return burung.isEmpty ? 1 : 0 // Jika burung kosong, kembalikan 1 untuk "Data Burung Kosong"
            } else {
                return burung.count
            }
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyViewCell
        
        // Reset font and size to default for reusable cell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        switch selectedIndex {
        case 0:
            if indexPath.section == 0 {
                cell.textLabel?.text = "Data Student"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                cell.backgroundColor = .gray
            } else if indexPath.section == 1 && students.isEmpty {
                cell.textLabel?.text = "Data Student Kosong"
            } else if indexPath.section == 1 + (students.isEmpty ? 1 : studentSectionTitles.count) {
                cell.textLabel?.text = "Data Mahasiswa"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                cell.backgroundColor = .gray
            } else if indexPath.section == 2 + (students.isEmpty ? 1 : studentSectionTitles.count) && mahasiswa.isEmpty {
                cell.textLabel?.text = "Data Mahasiswa Kosong"
                /*} else if indexPath.section <= studentSectionTitles.count {
                 let key = studentSectionTitles[indexPath.section - 1]
                 if let names = groupedStudents[key] {
                 cell.textLabel?.text = names[indexPath.row]
                 }
                 } else {
                 let key = mahasiswaSectionTitles[indexPath.section - 2 - (students.isEmpty ? 1 : studentSectionTitles.count)]
                 if let names = groupedMahasiswa[key] {
                 cell.textLabel?.text = names[indexPath.row]
                 }
                 }*/
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
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedIndex {
        case 0:
            if section == 0 {
                return nil
            } else if section == 1 && students.isEmpty {
                return nil
            } else if section == 1 + (students.isEmpty ? 1 : studentSectionTitles.count) {
                return nil
            } else if section == 2 + (students.isEmpty ? 1 : studentSectionTitles.count) && mahasiswa.isEmpty {
                return nil
            } else if section <= studentSectionTitles.count {
                return studentSectionTitles[section - 1]
            } else {
                return mahasiswaSectionTitles[section - 2 - (students.isEmpty ? 1 : studentSectionTitles.count)]
            }
        case 1, 2, 3:
            return nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch selectedIndex {
        case 0:
            if section == 0 || section == 1 + (students.isEmpty ? 1 : studentSectionTitles.count) {
                return 50 // Height for "Data Student" and "Data Mahasiswa" headers
            } else {
                return 30 // Height for other headers
            }
        case 1, 2, 3:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 // Footer height to create space between sections
    }
}

class MyViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Konfigurasi tampilan default untuk sel
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method untuk konfigurasi tampilan sel
    func configureCell() {
        // Tambahkan konfigurasi tampilan di sini
        textLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    // Override prepareForReuse untuk mengatur ulang sel saat akan digunakan kembali
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset nilai-nilai yang perlu direset ketika sel digunakan kembali
        textLabel?.font = UIFont.systemFont(ofSize: 16) // Reset font size
        backgroundColor = .white // Reset background color
    }
}








struct MyStudent {
    let id: Int
    let name: String
    let character: String
    let tanggal_lahir: String
}

struct MyMahasiswa {
    let id: Int
    let nama: String
    let character: String
    let tanggal_lahir: String
}

struct Buku {
    let id: Int
    let nama: String
    let character: String
}

struct Meja {
    let id: Int
    let nama: String
    let character: String
}

struct Burung {
    let id: Int
    let nama: String
    let character: String
}
