//
//  ZStackViewController.swift
//  OISwift
//
//  Created by keenoi on 25/07/24.
//

import UIKit

class ZStackViewController: UIViewController {

    @SBinding var isHideDot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dotView()
        listView()
    }
}

extension ZStackViewController {
    fileprivate func dotView() {
        view.VStack {
            View().HStack(spacing: 10, alignment: .center) {
                NavigationLinkView().content {
                    self.isHideDot.toggle()
                } setup: { views in
                    views.ZStack {
                        View().VStack(alignment: .center) {
                            Image()
                                .image("service")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .clipped()
                                .scaledToFit()
                        }.background(0xF0F0F0).frame(width: 40, height: 40).cornerRadius(5)
                        View().HStack(isModifyAlignment: true, modifyAlignment: .topTrailing) {
                            View()
                            View().background(.systemRed).frame(width: 12, height: 12).cornerRadius(12/2)
                        }.padding(2).isHidden($isHideDot)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func listView() {
        view.VStack {
            View().ZStack {
                View().HStack(spacing: 10, alignment: .center) {
                    Image()
                        .image("service")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipped()
                        .scaledToFit()
                    
                    View().VStack {
                        Text().text("123543123").font(10).foregroundColor(.systemBlue)
                        Text().text("Title")
                        Text().text("Description").font(12)
                        Text().text("Modified by John Doe on Thu 10 Jul 24, 14:08").font(10)
                    }
                }
                
                View().HStack(spacing: 10) {
                    View()
                    Text().text("Description").font(10)
                    Image()
                        .image(systemName: "arrow.right.circle.dotted")
                        .foregroundColor(0x333333)
                        .resizable()
                        .clipped()
                        .scaledToFit()
                        /*.frame(width: 20, height: 20)*/
                }
            }
            Spacer()
        }
        .padding()
        .background(.white)
    }
}
