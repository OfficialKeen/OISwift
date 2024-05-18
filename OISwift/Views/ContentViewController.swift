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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
