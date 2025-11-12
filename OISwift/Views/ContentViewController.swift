//
//  ContentViewController.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

import UIKit

class ContentViewController: UIViewController, UISearchBarDelegate {

    @SBinding var isHideText = true
    @SBinding var ishide = true
    @SBinding var isHideNavBar = false
    @SBinding var textChange = "Keen"
    @SBinding var textViewChange = ""
    
    @SBinding var value: Int = 1
    
    @SBinding private var progressValue: Float = 0.0
    @SBinding private var percentLabel = ""
    
    let itemss = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    let items = [
        (title: "First", image: UIImage(named: "first_icon"), activeImage: UIImage(named: "first_icon_active")),
        (title: "Second", image: UIImage(named: "second_icon"), activeImage: UIImage(named: "second_icon_active")),
        (title: "Third", image: UIImage(named: "third_icon"), activeImage: UIImage(named: "third_icon_active"))
    ]
    @SBinding var selectedIndex: Int = 0
    let segmentedControl = Segmented()
    
    @SBinding var maskedString = "12234238742UWER9873T5"
    var maksed = "123239423R4"
    
    @SBinding var myemail = ""
    @SBinding var mypassword = ""
    @SBinding var btnColor: UInt = 0xA0A0A0
    @SBinding var btnDisable = true
    
    @SBinding var otpCode = ""
    @SBinding var isResend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView1()
        //contentView2()
        //contentView3()
        //contentView4()
        //contentView5()
        //contentView6()
        //contentView7()
        //contentView8()
        //contentView9()
        //contentView10()
        //contentView11()
        //contentView12()
        //contentView13()
        //contentView14()
        //contentView15()
        //contentView16()
        //contentView17()
        //contentView18()
    }
}

extension ContentViewController {
    fileprivate func contentView1() {
        view.VStack(spacing: 10) {
            
            View().VStack {
                SearchBar()
                    .backgroundImage()
                    .background(.clear)
                    .font(16, weight: .medium)
                    .placeholder("search text...")
                    .delegate(self)
                    .onTextChanged { searchBar, searchText  in
                        let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                        debugPrint("DEBUG: Text 1 onTextChanged [\(escapedString ?? "")] | [\(searchBar.text ?? "")]")
                    }
                    .onSubmit { searchBar in
                        self.view.endEditing(true)
                        debugPrint("DEBUG: Text 2 onSubmit [\(searchBar.text ?? "")]")
                    }
                    .onDidTap { searchBar in
                        debugPrint("DEBUG: Text 3 onDidTap [\(searchBar.text ?? "")]")
                    }
                    .onChange { searchBar, range, string in
                        debugPrint("DEBUG: Text 4 shouldChangeTextInRange [\(searchBar.text ?? "")] | [\(range)] | [\(string)]")
                        return true
                    }
                    .onResultsListButton { searchBar in
                        debugPrint("DEBUG: Text 6 onResultsListButton [\(searchBar.text ?? "")]")
                    }
                    .onScopeButton { searchBar, selectionScope in
                        debugPrint("DEBUG: Text 7 selectedScopeButtonIndexDidChange [\(searchBar.text ?? "")] | [\(selectionScope)]")
                    }
            }
            .background(0xF0F0F0)
            .cornerRadius(5)
            .height(40)
            
            TextField()
                .placeholder("Some enter text here...", font: .systemFont(ofSize: 10))
                .text($textChange)
                .background(0xF0F0F0)
                .cornerRadius(5)
                .stroke(0xE0E0E0, lineWidth: 1)
                .foregroundColor(0x333333)
                .tintColor(.red)
                .font(16)
                .height(35)
                .padding(left: 10)
                //.isSecure()
                .addImageSecureEye()
                /*.addImage(position: .right, "left".renderingImage, padding: 10) {
                    debugPrint("DEBUG: 123123")
                }*/
                .onSubmit {
                    debugPrint("DEBUG: return onSubmit")
                }
                .onEditingChange { textfield in
                    debugPrint("DEBUG: textfield [\(textfield.text ?? "")])")
                }
                .onChange { textField, range, string in
                    let current = textField.text ?? ""
                    let final   = (current as NSString).replacingCharacters(in: range, with: string)
                    debugPrint("DEBUG: return onChange [\(textField.text ?? "")] | [\(range.length)] | [\(string)] | [\(final)]")
                    return true
                }
                
                /*.onEditingChange { text in
                    if text.isEmpty {
                        debugPrint("DEBUG: return onEditingChange Empty")
                    } else {
                        debugPrint("DEBUG: return onEditingChange \(text)")
                    }
                    
                }*/
                .onReturn {
                    debugPrint("DEBUG: return onDidReturn)")
                    return true
                }
                .onDidTap {
                    debugPrint("DEBUG: return onDidTap")
                    return true
                }
                .onDidEndTap {
                    debugPrint("DEBUG: return onDidEndTap")
                }
                .onShouldEndEditing {
                    debugPrint("DEBUG: return onShouldEndEditing")
                    return true
                }
                .onDidEndEditing {
                    debugPrint("DEBUG: return onDidEndEditing")
                }
            
            View().HStack(spacing: 10, alignment: .center) {
                Segmented()
                    .items(["Rp", "%"])
                    .fontSize(20, weight: .black)
                    .setDefaultIndex(0)
                    .selectedColor(0x00D79E)
                    .titleSelectColor(.white)
                    .width(100)
                    .onValueChanged { index in
                        debugPrint("DEBUG: index [\(index)]")
                    }
                
                Image()
                    .renderingMode(.alwaysTemplate)
                    .frame(width: 40, height: 40)
                    .cornerRadius(40/2)
                    .image("spiderman")
                    .clipped()
                    .scaledToFill()
                
                Text()
                    .text("Beautiful eCommerce ")
                    .font(14, weight: .medium)
                
                View().VStack {
                    Toggle()
                        .onChange { on in
                            debugPrint("DEBUG: OnChange [\(on.isOn)]")
                        }
                }
                
                Spacer()
            }
            
            View().HStack(spacing: 10) {
                TextField()
                    .placeholder("Some enter text here...", font: .systemFont(ofSize: 16))
                    .keyboardNumber()
                
                Segmented()
                    .items(["%", "Rp"])
                    .fontSize(16)
                    .setDefaultIndex($selectedIndex)
                    .selectedColor(0x2881F5)
                    .titleSelectColor(.white)
                    .width(100)
                    .onValueChanged { index in
                        debugPrint("DEBUG: index [\(index)]")
                    }
            }.stroke(0x2881F5).cornerRadius(5).height(45).padding(.leading, 10)
            
            ProgressView()
                .onProgress(0.0, animated: true)
                .progressTintColor(0x00D79E)
                .trackTintColor(0xF0F0F0)
                .progressViewStyle(.bar)
                .height(10)
                .cornerRadius(3)
            
            Text()
                .text("Beautiful eCommerce UI Kit for your online store")
                .font(20)
                .foregroundColor(UIColor(hex: 0x333333))
                .fontWeight(.light)
                .multilineTextAlignment(.left)
                .baselineOffset(10)
                
            Button().content {
                debugPrint("DEBUG: Did Button")
                self.isHideText.toggle()
                self.ishide.toggle()
                debugPrint("DEBUG: $textChange [\(self.textChange)]")
            } setup: { button in
                button
                    .title("Submit")
                    .foregroundColor(0xFFFFFFF)
                    .font(size: 16, weight: .medium)
                    .stroke()
                    .background(0xE64DFF)
                    .cornerRadius([.bottomRight], 30)
                    .height(40)
                    .shadow(color: 0x333333, radius: 5, opacity: 10, offset: CGSize(width: 1, height: 4))
            }
            
            View()
                .background(.white)
                .height(80)
                .cornerRadius([.topLeft, .bottomRight], 30)
                .shadow(color: 0x333333, opacity: 0.5, radius: 4, offset: CGSize(width: 0, height: 2))

            View().VStack {
                Text()
                    .text("Beautiful eCommerce UI Kit for your online store")
                    .font(20)
                    .foregroundColor(UIColor(hex: 0x333333))
                    .fontWeight(.light)
                    .multilineTextAlignment(.left)
                    .baselineOffset(10)
            }
            .padding(16)
            .background(.systemTeal)
            .stroke(0x333333, lineWidth: 2)
            .cornerRadius([.topLeft, .bottomRight], 30)
            .shadow(color: 0x333333, opacity: 0.5, radius: 4, offset: CGSize(width: 0, height: 2))
            .isHidden($ishide)
            
            TextView()
                .text("TextView")
                .font(.systemFont(ofSize: 16, weight: .medium))
                .foregroundColor(.black)
                .height(60)
                .cornerRadius(5)
                .background(0xF0F0F0)
            
            View().HStack {
                Spacer()
                Segmented()
                    .items([
                        //(UIImage(named: "left")),
                        //(UIImage(named: "product"))
                        UIImage(systemName: "paperplane"),
                        UIImage(systemName: "trash")
                    ])
                    .imageSize(width: 25, height: 25)
                    .setDefaultIndex(0)
                    .selectedColor(0x00D79E)
                    .titleSelectColor(.white)
                    .width(100)
                    .height(40)
                    .onValueChanged { index in
                        debugPrint("DEBUG: index [\(index)]")
                    }
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func contentView2() {
        view.VStack {
            View().HStack(spacing: 10) {
                Text().text("\($value)")
                
                Spacer()
                
                Button().content {
                    
                } setup: { button in
                    button
                        .title("-")
                        .background(.lightGray)
                        .frame(width: 30, height: 30)
                }
                
                Button().content {
                    
                } setup: { button in
                    button
                        .title("+")
                        .background(.lightGray)
                        .frame(width: 30, height: 30)
                }

            }
            .background(0xF0F0F0)
            .cornerRadius(5)
            .height(50)
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func contentView3() {
        view.VStack {
            Scroll { views in
                views.VStack(spacing: 10) {
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                    
                    View().height(100).background(.systemTeal)
                }
            }
        }
    }
    
    fileprivate func contentView4() {
        view.VStack {
            TextView().text($textViewChange).height(100).cornerRadius(5).foregroundColor(0xF0F0F0)
            
            Button().content {
                debugPrint("DEBUG: textViewChange [\(self.textViewChange)]")
            } setup: { button in
                button
                    .title("Submit")
                    .background(0xF0F0F0)
                    .cornerRadius(5)
                    .height(40)
            }
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func contentView5() {
        view.VStack(spacing: 10) {
            ProgressView()
                .onProgress($progressValue)
                .progressViewStyle(.default)
                .trackTintColor(.lightGray)
                .progressTintColor(.blue)
                .cornerRadius(5)
            
            Text().text($percentLabel)
            
            Button().content {
                self.progressValue = 0.0
                self.animateProgress()
            } setup: { button in
                button
                    .title("Submit")
                    .background(0xF0F0F0)
                    .cornerRadius(5)
                    .height(40)
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func contentView6() {
        // Create dummy images
        let image1 = UIImage(named: "left")!
        let image2 = UIImage(named: "class")!
        let image3 = UIImage(named: "product")!
        image1.withTintColor(UIColor(hex: 0x333333), renderingMode: .alwaysTemplate)
        image2.withTintColor(UIColor(hex: 0x333333), renderingMode: .alwaysTemplate)
        image3.withTintColor(UIColor(hex: 0x333333), renderingMode: .alwaysTemplate)
        let images = [image1, image2, image3]
        
        view.VStack(spacing: 10) {
            segmentedControl
                .setDefaultIndex(selectedIndex)
                .selectedColor(0xF0F0F0)
                .titleSelectColor(.blue)
                .titleUnselectColor(.systemTeal)
                .onValueChanged { [weak self] index in
                    self?.selectedIndex = index
                }
            
                //
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    fileprivate func contentView7() {
        view.VStack {
            contentScrollView()
        }
        .padding()
        .background(.systemBackground)
        //.navigationTitle("Keen 🥳")
        //.navigationBarTitleDisplayMode(.always)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                View().HStack(spacing: 10) {
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image(systemName: "heart.fill")
                    }
                    View().VStack(distribution: .fillEqually) {
                        Text().text("My Chat").font(14, weight: .medium)
                        Text().text("online").font(12, weight: .regular)
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                View().HStack {
                    Text().text("Center")
                    Text().text("🥳")
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                View().HStack(spacing: 10) {
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image(systemName: "camera.circle")
                    }
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image(systemName: "camera.macro")
                    }
                    //Image().image(systemName: "")
                    //Image().image(systemName: "heart.fill")
                    //Text().text("Right")
                    //Text().text("Right")
                }
            }
        }
        //.ignoresNavBar($isHideNavBar)
        .ignoresNavBar(false)
        //.ignoresSafeArea()
    }
    
    
    
    
    
    fileprivate func contentView8() {
        //let items = ["All", "Simple", "Difficult", "Hard"]
        var isCondition = false
        @SBinding var isHideCell = false
        view.VStack(spacing: 10) {
            Button().content {
                isCondition.toggle()
            } setup: { b in
                b.title("Test").stroke().cornerRadius(5).height(45).foregroundColor(.black)
            }

            /*ListView(0..<50) { index in
                if isCondition {
                    return [
                        View().VStack {
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                                self.navigationController?.pushViewController(ViewController(), animated: true)
                            } setup: { views in
                                views.VStack {
                                    View().HStack(spacing: 10, alignment: .center) {
                                        Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                        View().VStack(distribution: .fillEqually) {
                                            Text().text("Index \(index)").font(14, weight: .medium)
                                            Text().text("reguler").font(12, weight: .regular)
                                        }
                                        Spacer()
                                    }.background(.systemTeal).cornerRadius(5).padding().height(50)
                                }
                            }
                        }
                    ]
                } else {
                    return [
                        View().VStack {
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                                self.navigationController?.pushViewController(ViewController(), animated: true)
                            } setup: { views in
                                views.VStack {
                                    View().HStack(spacing: 10, alignment: .center) {
                                        Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                        View().VStack(distribution: .fillEqually) {
                                            Text().text("Index \(index)").font(14, weight: .medium)
                                            Text().text("reguler").font(12, weight: .regular)
                                        }
                                        Spacer()
                                    }.background(.systemOrange).cornerRadius(5).padding().height(50)
                                }
                            }
                        }
                    ]
                }
            }*/
            
            
            /*ListView(0..<10) { index in
                NavigationLinkView().content {
                    debugPrint("DEBUG: Index [\(index)]")
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                } setup: { views in
                    views.VStack {
                        View().HStack(spacing: 10, alignment: .center) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                            View().VStack(distribution: .fillEqually) {
                                Text().text("Index \(index)").font(14, weight: .medium)
                                Text().text("reguler").font(12, weight: .regular)
                            }
                            Spacer()
                        }.cornerRadius(5).padding().height(50).background(.systemTeal)
                    }
                }
            }*/
            
            
            /*ListView(0..<3) {
                Text().text("Header").font(14, weight: .medium).multilineTextAlignment(.left)
            } footer: {
                Text().text("Footer")
            } content: { index in
                NavigationLinkView().content {
                    debugPrint("DEBUG: Index [\(index)]")
                    isHideCell.toggle()
                    //self.navigationController?.pushViewController(ViewController(), animated: true)
                } setup: { views in
                    views.VStack(spacing: 10) {
                        View().HStack(spacing: 10, alignment: .center) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                            View().VStack(distribution: .fillEqually) {
                                Text().text("Index \(index)").font(14, weight: .medium)
                            }
                        }.cornerRadius(5).padding().background(.systemTeal)
                        
                        View().VStack {
                            ListView(0..<2) { index1 in
                                View().HStack(spacing: 10, alignment: .center) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                                    View().VStack(distribution: .fillEqually) {
                                        Text().text("Index \(index1)").font(14, weight: .medium)
                                    }
                                }.cornerRadius(5).padding().background(.systemOrange)
                            }
                        }.padding(.leading, 30).height(100).isHidden($isHideCell)
                    }
                }
            }*/
            
            Spacer()
        }
        .padding()
        .background(.systemBackground)
        .navigationTitle("ListView")
        .navigationBarTitleDisplayMode(.always)
    }
    
    
    
    
    fileprivate func contentView9() {
        view.VStack {
            Scroll { views in
                views.VStack {
                    Text().text("Header")
                    /*ListView(0..<20) { index in
                        Text().text("Item \(index)")
                        /*NavigationLinkView().content {
                            debugPrint("DEBUG: Index [\(index)]")
                            self.navigationController?.pushViewController(ViewController(), animated: true)
                        } setup: { views in
                            views.HStack(spacing: 10, alignment: .center) {
                                Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                View().VStack(distribution: .fillEqually) {
                                    Text().text("Index \(index)").font(14, weight: .medium)
                                    Text().text("reguler").font(12, weight: .regular)
                                }
                                Spacer()
                            }.background(.systemTeal).cornerRadius(5).padding().height(50)
                        }*/
                    }*/
                    Text().text("Footer")
                }
            }
        }
        .padding()
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)
        
        /*view.VStack(spacing: 10) {
            ForEach(0..<20) { index in
                NavigationLinkView().content {
                    debugPrint("DEBUG: Index [\(index)]")
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                } setup: { views in
                    views.HStack(spacing: 10, alignment: .center) {
                        Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                        View().VStack(distribution: .fillEqually) {
                            Text().text("Index \(index)").font(14, weight: .medium)
                            Text().text("reguler").font(12, weight: .regular)
                        }
                        Spacer()
                    }.background(.systemTeal).cornerRadius(5).padding().height(50)
                }
            }
            
            View().HStack(spacing: 10, distribution: .fillEqually) {
                View().background(.lightGray).cornerRadius(5)
                View().background(.systemGreen).cornerRadius(5)
            }.height(40)
        }
        .padding()
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)*/
    }
    
    
    fileprivate func contentView10() {
        view.addView {
            /*ListView(0..<50, axis: .horizontal) { index in
                NavigationLinkView().content {
                    debugPrint("DEBUG: Index [\(index)]")
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                } setup: { views in
                    views.HStack(spacing: 10, alignment: .center) {
                        Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                        View().VStack(distribution: .fillEqually) {
                            Text().text("Index \(index)").font(14, weight: .medium)
                            Text().text("reguler").font(12, weight: .regular)
                        }
                        Spacer()
                    }.background(.systemTeal).cornerRadius(5).padding().height(50)
                }
            }*/
        }
        view.backgroundColor = .white
    }
        
    fileprivate func contentView11() {
        /*let v = View(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        v.backgroundColor = .systemBlue
        //v.concaveCornerRadius(20)
        v.concaveEnds(depth: 0.1)
        
        view.addSubview(v)
        v.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 100)
        v.centerInSuperview()*/
        view.backgroundColor = .white
        view.VStack(centerXY: true) {
            View().concaveEnds(depth: 0.1).background(.red).frame(width: 200, height: 100)
        }
        .background(.white)
        .padding()
    }
    
    fileprivate func contentView12() {
        view.VStack {
            contentScrollView()
        }
        .padding()
        .background(.systemBackground)
        //.navigationTitle("Keen 🥳")
        //.navigationBarTitleDisplayMode(.always)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text().text("My Chat").font(14, weight: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                View().HStack(spacing: 10) {
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image("service")
                    }
                }
            }
        }
        //.ignoresNavBar($isHideNavBar)
        .ignoresNavBar(false)
        //.ignoresSafeArea()
    }
    
    fileprivate func contentView13() {
        view.VStack(spacing: 16) {
            View().height(50).background(.systemCyan)
            View().VStack(spacing: 16) {
                Centered(.centerXY) {
                    View().HStack(spacing: 10) {
                        View().height(30).width(30).background(.systemTeal)
                        View().height(30).width(30).background(.systemTeal)
                    }
                }
            }
        }
        .padding()
        .background(.systemBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text().text("My Chat").font(14, weight: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                View().HStack(spacing: 10) {
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image("service")
                    }
                }
            }
        }
        //.ignoresNavBar($isHideNavBar)
        .ignoresNavBar(false)
        //.ignoresSafeArea()
    }
    
    fileprivate func contentView14() {
        view.backgroundColor = .white
        view.VStack(spacing: 16, centered: .centerY) {
            View().height(100).background(.systemBlue)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text().text("My Chat").font(14, weight: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                View().HStack(spacing: 10) {
                    Button().content {
                        self.navigationController?.pushViewController(ZStackViewController(), animated: true)
                    } setup: { button in
                        button.image("service")
                    }
                }
            }
        }
        .ignoresNavBar(false)
        //.ignoresSafeArea()
    }
    
    fileprivate func contentView15() {
        view.VStack {
            Text().textMasked($maskedString)
            Text().textMasked(maskedString)
            Text().textMasked(maksed)
            
            Text().textMaskedCombine($maskedString)
            Text().textMaskedCombine(maskedString)
            Text().textMaskedCombine(maksed)
            Spacer()
        }.padding().background(.white)
    }
    
    fileprivate func contentView16() {
        view.VStack(spacing: 20) {
            TextField().text($myemail).stroke(0xF0F0F0).cornerRadius(5).height(40)
                .onEditingChange { text in
                    if self.mypassword != "" {
                        self.btnColor = text == "" ? 0xA0A0A0 : 0x00D79E
                        self.btnDisable.toggle()
                    }
                }
            TextField().text($mypassword).stroke(0xF0F0F0).cornerRadius(5).height(40)
                .onEditingChange { text in
                    if self.myemail != "" {
                        self.btnColor = text == "" ? 0xA0A0A0 : 0x00D79E
                        self.btnDisable.toggle()
                    }
                }
            Button().content {
                debugPrint("DEBUG: Did Save")
            } setup: { btn in
                btn.title("Save").background($btnColor).cornerRadius(5).height(40).disable($btnDisable)
            }
            Spacer()
        }.padding(20).background(.white)
    }
    
    fileprivate func contentView17() {
        view.VStack(spacing: 20) {
            Segmented()
                .items(
                    texts: ["Appointment", "Products", "Service", "Invoice"],
                    images: [UIImage(named: "calendar"), UIImage(named: "product")?.resized(to: CGSize(width: 15, height: 24)), UIImage(named: "service"), UIImage(named: "file-text")]
                )
                .fontSize(14, weight: .medium)
                .selectedColor(0x00D79E)
                .titleSelectColor(0xFFFFFF)
                .height(40)
            Spacer()
        }.padding(20).background(.white)
    }
    
    fileprivate func contentView18() {
        view.VStack(spacing: 20) {
            TextFieldOTP()
                .digit(6)
                .textColor(.darkGray)
                .textSize(16)
                //.cornerRadius(5)
                .keyboardMode(.alphanumeric)
                .stroke(width: 1, corner: 5)
                .strokeColors(0xF0F0F0, to: 0xDDDDDD)
                .backgroundColors(0xF5F5F5, to: 0xF0F0F0)
                .spacing(10)
                .height(45)
                .onChange { code in
                    let codeNew = "123123"
                    if code != codeNew {
                        print("Kode Salah")
                    } else {
                        print("Kode Bener")
                    }
                }
                .reset($isResend)
                /*.onCodeCompleted { code in
                    print("Kode OTP 2: \(code)")
                }*/
                .padding(.horizontal, 10)
                
            Button().content {
                self.isResend = true
            } setup: { button in
                button
                    .title("Submit")
                    .foregroundColor(0xFFFFFFF)
                    .font(size: 16, weight: .medium)
                    .stroke()
                    .background(0xE64DFF)
                    .cornerRadius([.bottomRight], 30)
                    .height(40)
                    .shadow(color: 0x333333, radius: 5, opacity: 10, offset: CGSize(width: 1, height: 4))
            }
            Spacer()
        }.padding(20).background(.white)
    }
    
    fileprivate func contentScrollView() -> UIView {
        View().VStack {
            Scroll { views in
                views.VStack(spacing: 10) {
                    Button().content {
                        self.isHideNavBar.toggle()
                    } setup: { b in
                        b.title("Submit").background(.systemTeal).cornerRadius(5).height(40)
                    }
                    
                    TextField().placeholder("Input...").padding(10).stroke().height(30).cornerRadius(5).foregroundColor(.systemTeal)

                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                    
                    View().height(100).background(.systemOrange)
                }
            }
        }
    }
    
    private func animateProgress() {
        let duration: TimeInterval = 1.0 // Durasi total animasi
        let steps = 100
        let stepDuration = duration / Double(steps)
        
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) { [weak self] in
                let currentProgress = Float(step) / Float(steps)
                self?.progressValue = currentProgress
                self?.percentLabel = "\(Int(currentProgress * 100))%"
                
            }
        }
    }
}
extension NavigationLinkView {
    func squareButton(with image: String, backgroundColor: UInt = 0xF0F0F0) {
        self.HStack {
            Image()
                .frame(width: 20, height: 20)
                .renderingMode(.alwaysTemplate)
                .image(image)
                .foregroundColor(0x333333)
                .scaledToFit()
        }
        .background(backgroundColor)
        .cornerRadius(5)
        .padding(.all, 10)
        .frame(width: 40, height: 40)
    }
}

extension Button {
    func fab(with imageName: String = "plus-white", size: CGFloat = 56, backgroundColor: UInt = 0x00D79E) {
        self
            .image(imageName)
            .background(backgroundColor)
            .cornerRadius(size/2)
            .shadow(color: UIColor(hex: 0x333333), radius: 5, opacity: 0.3, offset: CGSize(width: 1, height: 1))
            .frame(width: CGFloat(size), height: CGFloat(size))
    }
}
