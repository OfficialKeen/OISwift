//
//  WebPViewController.swift
//  OISwift
//
//  Created by keenoi on 23/12/24.
//

import UIKit
import ImageIO
import UniformTypeIdentifiers

class WebPViewController: UIViewController {

    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupImageView()
        imageView.loadWebPImage(from: "https://d1u45303vu7w9v.cloudfront.net/zenwel/l/6768c9e59cd8b.webp")
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func loadWebPImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL tidak valid.")
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                print("Gagal mengambil data gambar.")
                return
            }

            guard let source = CGImageSourceCreateWithData(data as CFData, nil),
                  let type = CGImageSourceGetType(source),
                  UTType(type as String)?.conforms(to: .image) == true else {
                print("File bukan gambar atau format tidak didukung.")
                return
            }

            if let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("Gagal membuat CGImage.")
            }
        }
    }
}

/*extension UIImageView {
    func loadWebPImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL tidak valid.")
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                print("Gagal mengambil data gambar.")
                return
            }

            guard let source = CGImageSourceCreateWithData(data as CFData, nil),
                  let type = CGImageSourceGetType(source),
                  UTType(type as String)?.conforms(to: .image) == true else {
                print("File bukan gambar atau format tidak didukung.")
                return
            }

            if let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                print("Gagal membuat CGImage.")
            }
        }
    }
}*/

extension UIImageView {
    func loadWebPImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL tidak valid.")
            return
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)

        // Periksa apakah respons sudah ada di cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            print("Menggunakan gambar dari cache.")
            self.image = cachedImage
        }

        // Unduh gambar untuk memeriksa pembaruan
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Gagal mengunduh gambar: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let source = CGImageSourceCreateWithData(data as CFData, nil),
                  CGImageSourceGetType(source) != nil,
                  let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
                print("Gagal memproses gambar.")
                return
            }

            let image = UIImage(cgImage: cgImage)

            // Simpan ke cache
            if let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            }

            DispatchQueue.main.async {
                self.image = image
                print("Gambar diperbarui dari server.")
            }
        }

        task.resume()
    }
}
