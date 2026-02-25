//
//  RefreshViewController.swift
//  OISwift
//
//  Created by keenoi on 27/11/24.
//

import UIKit

struct Mahasis {
    let id: Int
    let nama: String
    let jurusan: String
}

class RefreshViewController: UIViewController {
    @SBinding var mahasiswaList = [
        Mahasis(id: 1, nama: "John Doe", jurusan: "Informatika"),
        Mahasis(id: 2, nama: "Jane Smith", jurusan: "Biologi"),
        Mahasis(id: 3, nama: "Robert Brown", jurusan: "Teknik Mesin")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView()
    }
    
    // Simulasikan pengambilan data mahasiswa dari API
    private func loadDataFromAPI(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // Simulasi delay 2 detik
            // Simulasi data mahasiswa
            let mahasiswaData = [
                Mahasis(id: 4, nama: "John Ngadiran", jurusan: "Informatika")
            ]
            // Simulasi setelah data diambil dari API
            //self.mahasiswaList = mahasiswaData
            self.mahasiswaList.append(contentsOf: mahasiswaData)
            completion(true) // Menandakan bahwa data telah dimuat
        }
    }
}

extension RefreshViewController {
    fileprivate func contentView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    /*ForEach($mahasiswaList) { maha in
                        NavigationLinkView().content {
                            debugPrint("DEBUG: maha [\(maha.nama)]")
                        } setup: { views in
                            views.HStack(spacing: 10) {
                                Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                Text().text(maha.nama).font(14, weight: .medium)
                                Spacer()
                            }.background(.systemTeal).cornerRadius(5).padding().height(50)
                        }
                    }*/
                }
            }
            
            .refreshable { completion in
                debugPrint("DEBUG: Succes 1 [\(self.mahasiswaList.count)]")
                self.loadDataFromAPI { success in
                    debugPrint("DEBUG: Succes 2 [\(success)] | [\(self.mahasiswaList.count)]")
                    completion()
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Refresh List")
    }
}
