//
//  IndicatorViewController.swift
//  OISwift
//
//  Created by keenoi on 15/07/24.
//

import UIKit

class IndicatorViewController: UIViewController {

    @SBinding var isHideText = false
    @SBinding var syncText = "Sync Now"
    @SBinding var syncTextTint: UInt = 0x333333
    
    var loaderView = LoaderView()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.VStack(spacing: 10) {
            NavigationLinkView().content {
                self.isHideText = true
                self.loaderView.startAnimatingAndReturn()
                // stop animasi 3 detik
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.loaderView.stopAnimatingAndReturn()
                    self.isHideText = false
                    self.syncText = "Success Sync"
                    self.syncTextTint = 0x147575
                }
            } setup: { vie in
                vie.VStack(alignment: .center) {
                    Text()
                        .text($syncText)
                        .font(14, weight: .regular)
                        .foregroundColor($syncTextTint)
                        .isHidden($isHideText)
                    
                    loaderView
                        .setStyle(.medium)
                        .setColor(0x6694CE)
                        .setHidesWhenStopped(true)
                }
                .background(.white)
                .stroke()
                .height(40)
                .cornerRadius(40/2)
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
}
