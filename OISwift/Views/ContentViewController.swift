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
    @SBinding var textChange = "Keen"
    @SBinding var textViewChange = ""
    
    @SBinding var value: Int = 1
    
    @SBinding private var progressValue: Float = 0.0
    @SBinding private var percentLabel = ""
    
    let items = [
        (title: "First", image: UIImage(named: "first_icon"), activeImage: UIImage(named: "first_icon_active")),
        (title: "Second", image: UIImage(named: "second_icon"), activeImage: UIImage(named: "second_icon_active")),
        (title: "Third", image: UIImage(named: "third_icon"), activeImage: UIImage(named: "third_icon_active"))
    ]
    @SBinding var selectedIndex: Int = 0
    let segmentedControl = Segmented()
    override func viewDidLoad() {
        super.viewDidLoad()

        //contentView2()
        //contentView3()
        //contentView4()
        //contentView5()
        contentView6()
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
                .addImage(position: .right, "left".renderingImage, padding: 10) {
                    debugPrint("DEBUG: 123123")
                }
                .onSubmit {
                    debugPrint("DEBUG: return onSubmit")
                }
                .onChange { textField, range, string in
                    debugPrint("DEBUG: return onChange [\(textField.text ?? "")] | [\(range.length)] | [\(string)]")
                    return true
                }
                .onEditingChange { text in
                    if text.isEmpty {
                        debugPrint("DEBUG: return onEditingChange Empty")
                    } else {
                        debugPrint("DEBUG: return onEditingChange \(text)")
                    }
                    
                }
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
            Scroll().content { views in
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
