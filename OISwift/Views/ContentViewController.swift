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
    
    var items = [
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
    
    
    /*@SBinding var itemsRows: [RowItem] = [
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the first time!"),
        RowItem(title: "This is the second time!"),
        RowItem(title: "This is the third time!")
    ]*/
    
    @SBinding var itemsRows: [RowItem] = (1...10).map {
        RowItem(title: "Item \($0)")
    }
    
    @SBinding var totalCount = ""
    
    private var currentPage = 1
    private let perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //contentView1()
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
        
        // MARK: List TableView
        //contentView19()
        //contentView20()
        //contentView21()
        //contentView22()
        //contentView23()
        //contentView24()
        contentView25()
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
                .onChange { text in
                    debugPrint("DEBUG: Text Change [\(text.text ?? "")]")
                }
            
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
        view.VStack(spacing: 10) {
            TextView().text($textViewChange).height(100).cornerRadius(5).foregroundColor(0x333333).editable()
            TextField().text($textChange).height(35).stroke().cornerRadius(5)
            Button().content {
                self.textViewChange = self.textChange
                debugPrint("DEBUG: textViewChange [\(self.textViewChange)]")
            } setup: { button in
                button
                    .title("Submit")
                    .background(.systemTeal)
                    .stroke()
                    .cornerRadius(5)
                    .height(35)
            }
            Spacer()
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
    
    @available(iOS 15.0, *)
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


class AppointmentViewController: UIViewController {
    
    var tableView = Table()
    var tabCollectionView: UICollectionView!
    
    @SBinding var isSelectCustomer = false
    @SBinding var isShowCustomer = false
    @SBinding var isCollection = false
    @SBinding var isBookingProcess = false
    @SBinding var isTwoButton = false
    
    @SBinding var textCancel = "More"//Checkout
    @SBinding var textCancelColor = UInt(0x000000)
    @SBinding var textCancelStrokeColor = UInt(0x000000)
    @SBinding var textCancelStrokeLine = CGFloat(0)
    @SBinding var textCancelBackgroundColor = UInt(0xF0F0F0)
    
    @SBinding var textNext = "View Invoice"//Save Appointment
    @SBinding var textNextColor = UInt(0x2882F5)
    @SBinding var textNextStrokeColor = UInt(0xF0F0F0)//0xFAFAFA
    @SBinding var textNextStrokeLine = CGFloat(1)
    @SBinding var textNextBackgroundColor = UInt(0xFFFFFF)
    
    @SBinding var isCancelRequest = false
    
    @SBinding var textAmount = ""
    @SBinding var isBottom = false
    
    var tabArray = ["Cust One Zenwel", "Cust Two", "Cust Three Olsera", "Cust Four", "Cust Five Jakarta", "Cust Six", "Cust Seven Time"]
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView()
    }
}

extension AppointmentViewController {
    func contentView() {
        setTable()
        setCollectionView()
        view.VStack {
            View().VStack {
                tableView
                Spacer().background(.systemOrange)
            }.padding()
            bottomView()
        }.background(.white).padding(0).ignoresSafeArea(.bottom)
    }
    
    func setTable() {
        tableView
            .setRegister(UITableViewCell.self, forCellReuseIdentifier: "cell")
            .delegate(self)
            .dataSource(self)
            .separatorStyle(.none)
    }
    
    func bottomView() -> UIView {
        View().VStack {
            bottomViews()
        }.cornerRadius([.topLeft, .topRight], 20).stroke(0xF0F0F0)
    }
}

extension AppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        cell.textLabel?.text = "Index \(indexPath.row+1)"
        return cell
    }
}

extension AppointmentViewController {
    func bottomViews() -> UIView {
        View().VStack(spacing: 10) {
            NavigationLinkView().content {
                
            } setup: { vie in
                vie.HStack(spacing: 10) {
                    Image().image(systemName: "paperplane").frame(width: 20, height: 20).foregroundColor(.darkGray).scaledToFit()
                    Text().text("Search customer").foregroundColor(.systemBlue).font(14)
                }.padding(.horizontal, 10)
            }.background(0xFAFAFA).cornerRadius(5).height(35).isHidden($isSelectCustomer)
            
            View().HStack(spacing: 10) {
                Image().image(systemName: "person.circle").frame(width: 30, height: 30).foregroundColor(.darkGray).scaledToFit()
                Text().text("Keen Customer").foregroundColor(0x333333).font(14)
                Spacer()
                NavigationLinkView().content {
                    
                } setup: { vie in
                    vie.HStack(spacing: 5, alignment: .center) {
                        Image().image(systemName: "text.bubble").height(16).foregroundColor(0x333333).scaledToFit()
                        Text().text("Notify").foregroundColor(0x333333).font(14)
                    }.padding(.horizontal, 10)
                }.background(0xF0F0F0).cornerRadius(5).height(35)
                NavigationLinkView().content {
                    
                } setup: { vie in
                    vie.VStack(alignment: .center) {
                        Image().image(systemName: "rectangle.and.pencil.and.ellipsis").height(40).foregroundColor(0x333333).scaledToFit()
                    }
                }
            }.isHidden($isShowCustomer)
            
            View().VStack {
                tabCollectionView
            }.height(40).isHidden($isCollection)
            
            View().HStack(spacing: 10, alignment: .center, distribution: .equalCentering) {
                Text().text("Total").font(14, weight: .medium).foregroundColor(.systemRed)
                Text().text($textAmount).font(14, weight: .medium).foregroundColor(.systemRed)
            }
            
            View().VStack(alignment: .center) {
                View().HStack(spacing: 5, alignment: .center) {
                    Image().image(systemName: "timer").height(14).foregroundColor(0x333333).scaledToFit()
                    Text().text("Booking Process").foregroundColor(0x333333).font(12)
                }.height(35)
            }.isHidden($isBookingProcess)
            
            View().HStack(spacing: 10, alignment: .center, distribution: .fillEqually) {
                NavigationLinkView().content {
                    
                } setup: { vie in
                    vie.VStack(spacing: 5, alignment: .center) {
                        Text().text($textCancel).foregroundColor($textCancelColor).font(14, weight: .medium)
                    }.padding(.horizontal, 10).cornerRadius(5).stroke($textCancelStrokeColor, lineWidth: $textCancelStrokeLine).background($textCancelBackgroundColor).height(35)
                }
                
                NavigationLinkView().content {
                    
                } setup: { vie in
                    vie.VStack(spacing: 5, alignment: .center) {
                        Text().text($textNext).foregroundColor($textNextColor).font(14, weight: .medium)
                    }.padding(.horizontal, 10).cornerRadius(5).stroke($textNextStrokeColor, lineWidth: $textNextStrokeLine).background($textNextBackgroundColor).height(35)
                }
            }.isHidden($isTwoButton)
            
            View().VStack {
                NavigationLinkView().content {
                    
                } setup: { vie in
                    vie.VStack(alignment: .center) {
                        View().HStack(spacing: 5, alignment: .center) {
                            Image().image(systemName: "exclamationmark.triangle").height(16).foregroundColor(.white).scaledToFit()
                            Text().text("Cancel Request").foregroundColor(.white).font(14, weight: .medium)
                        }
                    }
                }.background(.systemOrange).cornerRadius(5).height(35)
            }.isHidden($isCancelRequest)
        }.padding(16).isHidden($isBottom)
    }
}

// MARK: CollectionView
extension AppointmentViewController {
    fileprivate func setCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabCollectionView.backgroundColor = .clear
        tabCollectionView.allowsMultipleSelection = false
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.register(AppointmentTabItemCell.self, forCellWithReuseIdentifier: AppointmentTabItemCell.identifier)
    }
}

extension AppointmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppointmentTabItemCell.identifier, for: indexPath) as? AppointmentTabItemCell else { return UICollectionViewCell() }
        let items = tabArray[indexPath.row]
        cell.cust = items
        return cell
    }
}

extension AppointmentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = AppointmentTabItemCell(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 30))
        cell.cust = tabArray[indexPath.item]
        let textWidth = (cell.cust as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width
        let cellWidth = textWidth + 10
        return CGSize(width: cellWidth, height: 30)
    }
}

// MARK: Cell
import UIKit

class AppointmentTabItemCell: UICollectionViewCell {
    
    static let identifier = "BlockRoomTabItemCell"
    @SBinding var cust = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.VStack(alignment: .center) {
            Text().text($cust).font(12)
        }.background(0xF0F0F0).height(30).cornerRadius(30/2)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: New List TableView

struct User: Hashable {
    let id: UUID = .init()
    let name: String
}

// misal model biasa tanpa Hashable
class Person {
    let uuid = UUID()
    let name: String
    init(name: String) { self.name = name }
}

// MARK: - Model (pakai id)
struct RowItem: Identifiable {
    let id: Int = Int.random(in: 1...999999)
    let title: String
}


extension ContentViewController {
    func contentView19() {
        let lisst = ListViews()
        let users = [
            User(name: "Budi"),
            User(name: "Andi"),
            User(name: "Citra")
        ]

        let people: [Person] = [Person(name: "Budi"), Person(name: "Andi")]
        /*view.VStack {
            ListViews {
                View().background(.systemTeal).height(100)
                View().background(.systemOrange).height(100)
                View().background(.systemTeal).height(100)
                View().background(.systemOrange).height(100)
                View().background(.systemTeal).height(100)
                View().background(.systemOrange).height(100)
            }.refreshable { void in
                void()
            }
            Spacer().height(100)
        }.padding().background(.white)*/
        
        /*view.VStack {
            ListViews(users) { user in
                Text().text(user.name)
            }.refreshable { void in
                void()
            }
        }.padding().background(.white)*/
        
        /*view.VStack {
            lisst.configure(users) { user in
                Text().text(user.name)
            }.refreshable { void in
                void()
            }
        }.padding().background(.white)*/
        
        /*view.VStack {
            lisst.configure(people, id: { $0.uuid as AnyHashable }) { person in
                Text().text(person.name)
                Text().text(person.name)
                Text().text(person.uuid.uuidString)
            }.refreshable { void in
                void()
            }
        }.padding().background(.white)*/
        
        /*view.VStack {
            lisst.configure(people, id: { $0.uuid as AnyHashable }) { person in
                self.personn(person: person.name)
            }.refreshable { void in
                void()
            }
        }.padding().background(.white)*/
    }
    
    func personn(person: String) -> UIView {
        View().VStack {
            Text().text(person)
        }
    }
}

extension ContentViewController {
    func contentView20() {
        @SBinding var items: [String] = ["A", "B", "C"]
        @SBinding var people: [Person] = [Person(name: "Budi"), Person(name: "Andi")]
        @SBinding var itemsRows: [RowItem] = [
            RowItem(title: "This is the first time!"),
            RowItem(title: "This is the second time!"),
            RowItem(title: "This is the third time!")
        ]
        let listView = ListViews()
        @SBinding var textInput = ""
        view.VStack(spacing: 10) {
            TextField().text($textInput).height(35).background(0xF0F0F0).cornerRadius(10)
            Button {
                //items.append(textInput)
                itemsRows.append(RowItem(title: textInput))
                //people.append(Person(name: textInput))
                //itemsRows.removeAll()
                //textInput = ""
                //listView.updateItems(items)
            } setup: { btn in
                btn.title("Add").background(.systemTeal).height(35).cornerRadius(35/2)
            }

            /*ListViews($items) { item in
                Text().text(item)
            }.refreshable { void in
                void()
            }*/
            
            ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                }.height(30).cornerRadius(10).padding(.horizontal, 10)
            }
            .listStyle(.card)
            .separator(.hidden)
            .listRowBackground(alternate: .lightGray, and: .lightText)
            .onSelect { item in
                print("Item:", item)
            }
            .onSelectIndex { index in
                print("Index:", index)
            }
            .onSelect { item, index in
                print("Selected:", item, "at:", index)
            }
            .onDeselect { index in
                print("Deselected row:", index)
            }
            .onHighlight { index in
                print("Row sedang ditekan:", index)
            }
            .onUnhighlight { index in
                print("Row stop ditekan:", index)
            }
            .onRowTapGesture { item in
                print("Tapped:", item)
            }
            .refreshable { void in
                void()
            }
            
            /*ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                }.height(30).cornerRadius(10).padding(.horizontal, 10)
            }
            .onSelect { item in
                print("Tap item:", item)
            }
            .refreshable { done in
                /*DispatchQueue.global().async {
                    // fetch / process
                    let newItem = RowItem(title: "From refresh")
                    DispatchQueue.main.async {
                        itemsRows.insert(newItem, at: 0)
                        // panggil done setelah update UI
                        done()
                    }
                }*/
                done()
            }*/
            
            
            
            /*.refreshable {
                //Thread.sleep(forTimeInterval: 1)
                //itemsRows.insert(RowItem(title: "Refreshed!"), at: 0)
            }*/
            /*.onReachBottom {
                itemsRows.append(RowItem(title: "Loaded more!"))
            }*/
            //.listRowBackground(.systemTeal)
            //.separatorPadding(50, 50)
            //.paddingHorizontal(10)
            //.background(.systemOrange)
            
            /*listView.configure($items) { item in
                Text().text(item)
            }.refreshable { void in
                void()
            }*/
            
            /*ListViews($people, id: { $0.uuid as AnyHashable }) { person in
                Text().text(person.name)
            }.refreshable { void in
                void()
            }*/
            
            /*listView.configure($people, id: { $0.uuid as AnyHashable }) { person in
                Text().text(person.name)
            }.refreshable { void in
                void()
            }*/
        }.padding().background(.white)
    }
}

extension ContentViewController {
    func contentView21() {
        @SBinding var items: [String] = ["A", "B", "C"]
        @SBinding var people: [Person] = [Person(name: "Budi"), Person(name: "Andi")]
        let listView = ListViews()
        @SBinding var textInput = ""
        view.VStack(spacing: 10) {
            TextField().text($textInput).height(35).background(0xF0F0F0).cornerRadius(10)
            Button {
                items.append(textInput)
                //people.append(Person(name: textInput))
                //textInput = ""
                //listView.updateItems(items)
            } setup: { btn in
                btn.title("Add").background(.systemTeal).height(35).cornerRadius(35/2)
            }

            listView.configure($items) { item in
                Text().text(item)
            }
            .onDelete { indexes in
                for i in indexes.sorted(by: >) {
                    items.remove(at: i)
                }
                listView.updateItems(items)
            }

            /*ListViews($items) { item in
                Text().text(item)
            }.onDelete(showDeleteButton: false) { [weak self] indexes in
                guard let self else { return }
                
                for i in indexes.sorted(by: >) {
                    items.remove(at: i)
                }
            }*/
            
            /*listView.configure($items) { item in
                Text().text(item)
            }.refreshable { void in
                void()
            }*/
            
            /*ListViews($people, id: { $0.uuid as AnyHashable }) { person in
                Text().text(person.name)
            }.refreshable { void in
                void()
            }*/
            
            /*listView.configure($people, id: { $0.uuid as AnyHashable }) { person in
                Text().text(person.name)
            }.refreshable { void in
                void()
            }*/
        }.padding().background(.white)
    }
}

extension ContentViewController {
    func contentView22() {
        @SBinding var textInput = ""
        @SBinding var searchText = ""
        @SBinding var isMoveItems = false
        view.VStack(spacing: 10) {
            TextField().text($searchText).height(35).background(0xF0F0F0).cornerRadius(10)
            Button {
                //self.itemsRows.append(RowItem(title: textInput))
                isMoveItems.toggle()
            } setup: { btn in
                btn.title("Add").background(.systemTeal).height(35).cornerRadius(35/2)
            }
            Text().text($totalCount)
            
            ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                    Spacer()
                    Button {
                        guard let index = self.itemsRows.firstIndex(where: { $0.id == rows.id }) else { return }
                        self.itemsRows.remove(at: index)
                    } setup: { btn in
                        btn.image(systemName: "trash").foregroundColor(.systemRed).frame(width: 14, height: 14)
                    }

                }.height(30).cornerRadius(10).padding(.horizontal, 10)
            }
            .currentPage(1)    // mulai page 1
            .perPage(10)       // per page 10 items
            .totalData { total in self.totalCount = "Total Items: \(total)" }
            .totalPages(4)   // totalPages optional, bukan wajib (di server nanti update)
            .onSelect { item, index in
                print("Selected:", item, "at:", index)
            }
            /*.onMove { [weak self] from, to in
                guard let self = self else { return }
                var arr = self.$itemsRows.wrappedValue
                let moved = arr.remove(at: from)
                arr.insert(moved, at: to)
                self.$itemsRows.wrappedValue = arr
            }*/
            /*.onDelete(.left, title: "Hapus", systemImage: "trash") { [weak self] indexSet in
                guard let self = self else { return }
                
                // Hapus dari array sesuai index yang kena swipe
                for index in indexSet.sorted(by: >) {
                    self.$itemsRows.wrappedValue.remove(at: index)
                }
            }*/
            
            .refreshable { done in
                // versi dengan completion (tetap optional). Kita simulate fetch.
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1) // simulasi network

                    DispatchQueue.main.async {
                        // Ambil 10 item pertama (prefix)
                        // Asumsi lo mau tampilkan items 1..10 saat refresh
                        // Kalau itemsRows berasal dari server, replace dengan page1 result.
                        // Di sini kita contoh: ambil prefix dari current source (local sim)
                        self.itemsRows = Array(self.itemsRows.prefix(10))
                        // tidak perlu panggil list.endReachLoading karena autopilot updatePagingStateAfterItemsChange() akan reset isLoadingMore
                        done() // endRefreshing
                    }
                }
            }
            .onReachBottom {
                print("onReachBottom closure called")
                // ini closure dipanggil saat user mendekati bottom.
                // Kita load 10 item berikutnya dan append ke itemsRows.

                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1) // simulasi network delay

                    // compute next batch start index (1-based index for title)
                    // saat ini itemsRows.count mungkin 10,20,etc.
                    let start = self.itemsRows.count + 1
                    let end = start + 10 - 1

                    let more: [RowItem] = (start...end).map { i in
                        RowItem(title: "Item \(i)")
                    }

                    DispatchQueue.main.async {
                        // append new items (perPage = 10)
                        self.itemsRows.append(contentsOf: more)
                        // tidak perlu panggil endReachLoading() karena updatePagingStateAfterItemsChange() dipanggil saat storedItems diassign/ snapshot apply
                        // jika server return totalPages, jangan lupa update via .totalPages(receivedTotal)
                    }
                }
            }
            .searchable($searchText, source: $itemsRows) { row, query in
                debugPrint("DEBUG: Search [\(row)] | [\(query)]")
                return row.title.lowercased().contains(query.lowercased())
            }
            /*.onMove($isMoveItems) { [weak self] from, to in
                /*guard let self = self else { return }
                var arr = self.$itemsRows.wrappedValue
                let moved = arr.remove(at: from)
                arr.insert(moved, at: to)
                self.$itemsRows.wrappedValue = arr*/
                
                
                guard let self = self else { return }
                
                // Misal data lu pake @SBinding var items: [Item]
                var arr = self.itemsRows              // atau itemsBinding.wrappedValue
                
                let moved = arr.remove(at: from)
                arr.insert(moved, at: to)
                
                self.itemsRows = arr
            }*/
            /*.onMove($isMoveItems) { [weak self] from, to in
                guard let self = self else { return }

                print("FROM:", from, "TO:", to)
                print("BEFORE:", self.items)

                var arr = self.items
                let moved = arr.remove(at: from)
                arr.insert(moved, at: to)
                self.items = arr

                print("AFTER:", self.items)
            }*/
            /*.onMove($isMoveItems) { [weak self] from, to in
                guard let self = self else { return }

                // 1. Ambil source
                var rows = self.itemsRows

                // 2. Ambil item yang dipindah
                let moved = rows.remove(at: from)

                // 3. Insert ke posisi baru
                rows.insert(moved, at: to)

                // 4. Assign balik ke binding
                self.itemsRows = rows
            }*/
        }.padding().background(.white)
    }
}

extension ContentViewController {
    func contentView23() {
        @SBinding var textInput = ""
        @SBinding var searchText = ""
        @SBinding var isMoveItems = false
        //itemsRows.removeAll()
        view.VStack(spacing: 10) {
            TextField().text($textInput).height(35).background(0xF0F0F0).cornerRadius(10).keyboardNumber().ignoreZeroFirst().ignoreEmpty(fallback: 1)
            Button {
                //self.itemsRows.append(RowItem(title: textInput))
                isMoveItems.toggle()
            } setup: { btn in
                btn.title("Add").background(.systemTeal).height(35).cornerRadius(35/2)
            }
            
            View().VStack {
                SearchBar()
                    .backgroundImage()
                    .background(.clear)
                    .font(16, weight: .medium)
                    .placeholder("search text...")
                    .delegate(self)
                    .onSubmit { searchBar in
                        self.view.endEditing(true)
                        let q = (searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
                        searchText = q       // trigger actual searchable logic
                    }
                    .onTextChanged { _, text in
                        let q = text.trimmingCharacters(in: .whitespaces)
                        if q.isEmpty {
                            searchText = ""  // reset list
                        }
                    }

            }
            .background(0xF0F0F0)
            .cornerRadius(5)
            .height(40)
            
            Text().text($totalCount)
            
            ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                    Spacer()
                    Button {
                        guard let index = self.itemsRows.firstIndex(where: { $0.id == rows.id }) else { return }
                        self.itemsRows.remove(at: index)
                    } setup: { btn in
                        btn.image(systemName: "trash").foregroundColor(.systemRed).frame(width: 14, height: 14)
                    }

                }.height(30).cornerRadius(10).padding(.horizontal, 10)
            }
            .currentPage(1)
            .perPage(10)
            .totalData { total in self.totalCount = "Total Items: \(total)" }
            //.totalPages(4)
            .onSelect { item, index in
                self.view.endEditing(true)
                print("Selected:", item, "at:", index)
            }
            .refreshable { done in
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    DispatchQueue.main.async {
                        self.itemsRows = Array(self.itemsRows.prefix(10))
                        done()
                    }
                }
            }
            .onReachBottom {
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    let start = self.itemsRows.count + 1
                    let end = start + 10 - 1

                    let more: [RowItem] = (start...end).map { i in
                        RowItem(title: "Item \(i)")
                    }

                    DispatchQueue.main.async {
                        self.itemsRows.append(contentsOf: more)
                    }
                }
            }
            .emptyState {
                View().VStack(spacing: 8, alignment: .center) {
                    Image().image(systemName: "tray")
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                        .foregroundColor(.lightGray)

                    Text().text("Belum ada data")
                        .font(14, weight: .medium)
                        .foregroundColor(.lightGray)
                }
            }
            .searchable($searchText, source: $itemsRows) { row, query in
                return row.title.lowercased().contains(query.lowercased())
            }
        }.padding().background(.white)
    }
}

extension ContentViewController {
    func contentView24() {
        @SBinding var textInput = ""
        @SBinding var searchText = ""
        @SBinding var isMoveItems = false
        view.VStack(spacing: 10) {
            ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                    Spacer()
                    Button {
                        guard let index = self.itemsRows.firstIndex(where: { $0.id == rows.id }) else { return }
                        self.itemsRows.remove(at: index)
                    } setup: { btn in
                        btn.image(systemName: "trash").foregroundColor(.systemRed).frame(width: 14, height: 14)
                    }
                }.height(100).cornerRadius(10).padding(.horizontal, 10)
            }
            .currentPage(1)
            .perPage(10)
            .onSelect { item, index in
                self.view.endEditing(true)
                print("Selected:", item, "at:", index)
            }
            .refreshable { done in
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    DispatchQueue.main.async {
                        self.itemsRows = Array(self.itemsRows.prefix(10))
                        done()
                    }
                }
            }
            .onReachBottom {
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    let start = self.itemsRows.count + 1
                    let end = start + 10 - 1

                    let more: [RowItem] = (start...end).map { i in
                        RowItem(title: "Item \(i)")
                    }

                    DispatchQueue.main.async {
                        self.itemsRows.append(contentsOf: more)
                    }
                }
            }
            .emptyState {
                View().VStack(spacing: 8, alignment: .center) {
                    Image().image(systemName: "tray")
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                        .foregroundColor(.lightGray)

                    Text().text("Belum ada data")
                        .font(14, weight: .medium)
                        .foregroundColor(.lightGray)
                }
            }
            .searchable($searchText, source: $itemsRows) { row, query in
                return row.title.lowercased().contains(query.lowercased())
            }
        }.padding().background(.white).navigationTitle("List").navigationBarTitleDisplayMode(.never)
    }
}

extension ContentViewController {
    func contentView25() {
        @SBinding var textInput = ""
        @SBinding var searchText = ""
        @SBinding var isMoveItems = false
        //itemsRows.removeAll()
        view.VStack(spacing: 10) {
            /*View().VStack {
                SearchBar()
                    .backgroundImage()
                    .background(.clear)
                    .font(16, weight: .medium)
                    .placeholder("search text...")
                    .delegate(self)
                    .onSubmit { searchBar in
                        self.view.endEditing(true)
                        let q = (searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
                        searchText = q       // trigger actual searchable logic
                    }
                    .onTextChanged { _, text in
                        let q = text.trimmingCharacters(in: .whitespaces)
                        if q.isEmpty {
                            searchText = ""  // reset list
                        }
                    }

            }
            .background(0xF0F0F0)
            .cornerRadius(5)
            .height(40)
            
            Text().text($totalCount)*/
            
            ListViews($itemsRows, id: \.id) { rows in
                View().HStack(spacing: 10, alignment: .center) {
                    Image().image(systemName: "checkmark.circle").frame(width: 14, height: 14).scaledToFit()
                    Text().text(rows.title).font(12, weight: .medium)
                    Spacer()
                    Button {
                        guard let index = self.itemsRows.firstIndex(where: { $0.id == rows.id }) else { return }
                        self.itemsRows.remove(at: index)
                    } setup: { btn in
                        btn.image(systemName: "trash").foregroundColor(.systemRed).frame(width: 14, height: 14)
                    }

                }.height(30).cornerRadius(10).padding(.horizontal, 10)
            }
            .currentPage(1)
            .perPage(10)
            .totalData { total in self.totalCount = "Total Items: \(total)" }
            .totalPages(4)
            .onSelect { item, index in
                self.view.endEditing(true)
                print("Selected:", item, "at:", index)
            }
            .refreshable { done in
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    DispatchQueue.main.async {
                        self.itemsRows = Array(self.itemsRows.prefix(10))
                        done()
                    }
                }
            }
            .onReachBottom {
                self.view.endEditing(true)
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    let start = self.itemsRows.count + 1
                    let end = start + 10 - 1

                    let more: [RowItem] = (start...end).map { i in
                        RowItem(title: "Item \(i)")
                    }

                    DispatchQueue.main.async {
                        self.itemsRows.append(contentsOf: more)
                    }
                }
            }
            .emptyState {
                View().VStack(spacing: 8, alignment: .center) {
                    Image().image(systemName: "tray")
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                        .foregroundColor(.lightGray)

                    Text().text("Belum ada data")
                        .font(14, weight: .medium)
                        .foregroundColor(.lightGray)
                }
            }
            .searchable($searchText, source: $itemsRows) { row, query in
                return row.title.lowercased().contains(query.lowercased())
            }
        }.padding().background(.white)
    }
}
