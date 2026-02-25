//
//  PagerViewController.swift
//  OISwift
//
//  Created by keenoi on 26/01/25.
//

import UIKit

class PagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView()
    }
}

extension PagerViewController {
    fileprivate func contentView() {
        view.backgroundColor = .systemBackground
        //pagesView1()
        //pagesView2()
        pagesView3()
    }
    
    func pagesView1() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(0..<3, axis: .horizontal, multiplier: 3, isPaging: true) { index in
                        view.HStack(alignment: .center, distribution: .fillEqually) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                        }.background(.systemTeal).cornerRadius(5).padding().height(50)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Bounces")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func pagesView2() {
        view.VStack {
            
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Bounces")
        .navigationBarTitleDisplayMode(.always)
    }
    
    fileprivate func pagesView3() {
        view.VStack(spacing: 10) {
            Button().content {
                
            } setup: { b in
                b.title("Next").stroke(.green).cornerRadius(5).height(45).foregroundColor(.white).background(.systemTeal)
            }
            
            Scroll(multiplier: 3, isPaging: true, bounce: true) { views in
                views.HStack(spacing: 10) {
                    View().VStack {
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                    }
                    
                    View().VStack {
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Spacer()
                    }
                    
                    View().VStack {
                        Text()
                            .text("But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasur")
                            .font(16)
                            .multilineTextAlignment(.left)
                        
                        Spacer()
                    }
                }
            }
            
            Button().content {
                
            } setup: { b in
                b.title("Next").stroke(.green).cornerRadius(5).height(45).foregroundColor(.white).background(.systemTeal)
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Bounces")
        .navigationBarTitleDisplayMode(.always)
    }
}
