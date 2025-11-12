//
//  ListViewController.swift
//  OISwift
//
//  Created by keenoi on 04/11/24.
//

import UIKit

struct Fruit: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var fruiteType: [FruitType]
}

struct FruitType: Identifiable, Equatable {
    var id = UUID()
    var name: String
}

class ListViewController: UIViewController {
    var fruits1 = [
        Fruit(name: "Apple", fruiteType: [
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple2")
        ]),
        Fruit(name: "Banana", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "Apple", fruiteType: [
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple2")
        ]),
        Fruit(name: "Cherry", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "Apple", fruiteType: [
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple2")
        ]),
        Fruit(name: "Date", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "Apple", fruiteType: [
            FruitType(name: "Mbah Apple"),
            FruitType(name: "Mbah Apple2")
        ]),
        Fruit(name: "Elderberry", fruiteType: [FruitType(name: "Mbah Elderberry")])
    ]
    
    let fruits2 = [
        Fruit(name: "1", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "2", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "3", fruiteType: [FruitType(name: "Mbah Elderberry")]),
        Fruit(name: "4", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "5", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "6", fruiteType: [FruitType(name: "Mbah Elderberry")]),
        Fruit(name: "7", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "8", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "9", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "9", fruiteType: [FruitType(name: "Mbah Elderberry")]),
        Fruit(name: "10", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "11", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "12", fruiteType: [FruitType(name: "Mbah Elderberry")])
    ]
    
    let fruits3 = [
        Fruit(name: "Apple", fruiteType: [FruitType(name: "Mbah Apple")]),
        Fruit(name: "Banana", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "Cherry", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "Date", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "Elderberry", fruiteType: [FruitType(name: "Mbah Elderberry")])
    ]
    
    let fruits4 = [
        Fruit(name: "Apple", fruiteType: [FruitType(name: "Mbah Apple")]),
        Fruit(name: "Banana", fruiteType: [FruitType(name: "Mbah Banana")]),
        Fruit(name: "Cherry", fruiteType: [FruitType(name: "Mbah Cherry")]),
        Fruit(name: "Date", fruiteType: [FruitType(name: "Mbah Date")]),
        Fruit(name: "Elderberry", fruiteType: [FruitType(name: "Mbah Elderberry")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView()
        //listView()
        //rowColumnView()
        //sectionView()
        //flexInfScrollView()
        //bouncesVerticalView()
        //bouncesHorizontalView()
        //verticalPagingView()
        //horizontalPagingView()
        
        //refreshableListView()
        //reorderView()
        //tabItems()
    }
}

extension ListViewController {
    func contentView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    Section(header: Text().text("Header 1")) {
                        ForEach(fruits1) { fruit2 in
                            View().HStack(spacing: 10, alignment: .center) {
                                Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                                View().VStack(distribution: .fillEqually) {
                                    Text().text(fruit2.name).font(14, weight: .medium)
                                }
                            }.cornerRadius(5).padding().background(.systemOrange)
                        }
                    }
                    
                    Section(header: Text().text("Header 2")) {
                        ForEach(fruits1) { fruit2 in
                            ForEach(fruit2.fruiteType) { datas in
                                View().HStack(spacing: 10, alignment: .center) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                                    View().VStack(distribution: .fillEqually) {
                                        Text().text(fruit2.name).font(14, weight: .medium)
                                        Text().text(datas.name).font(14, weight: .medium)
                                    }
                                }.cornerRadius(5).padding().background(.systemTeal)
                            }
                        }
                        
                        ForEach(fruits2) { fruit2 in
                            ForEach(fruit2.fruiteType) { datas in
                                View().HStack(spacing: 10, alignment: .center) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                                    View().VStack(distribution: .fillEqually) {
                                        Text().text(fruit2.name).font(14, weight: .medium)
                                        Text().text(datas.name).font(14, weight: .medium)
                                    }
                                }.cornerRadius(5).padding().background(.systemTeal)
                            }
                        }
                    }
                    
                    
                    Button().content {
                        
                    } setup: { b in
                        b.title("ForEach").stroke(.green).cornerRadius(5).height(45).foregroundColor(.white).background(.systemTeal)
                    }
                    
                    
                    ForEach(fruits1) { fruit2 in
                        View().HStack(spacing: 10, alignment: .center) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 20, height: 20).scaledToFit()
                            View().VStack(distribution: .fillEqually) {
                                Text().text(fruit2.name).font(14, weight: .medium)
                            }
                        }.cornerRadius(5).padding().background(.systemTeal)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func listView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    Section(header: Text().text("Status").font(12)) {
                        ForEach(fruits2, axis: .horizontal) { fruit2 in
                            View().HStack(spacing: 10, alignment: .center) {
                                Image().image(systemName: "person.circle").foregroundColor(.systemTeal).frame(width: 45, height: 45).scaledToFit()
                            }.cornerRadius(50/2).padding().frame(width: 50, height: 50).stroke(.systemOrange)
                        }
                    }
                    
                    Section(header: Text().text("Columns").font(12)) {
                        ForEach(1..<4, columns: 2) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                    
                    Section(header: Text().text("Columns").font(12)) {
                        ForEach(1..<4, columns: 2) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                    
                    Section(header: Text().text("Columns").font(12)) {
                        ForEach(1..<4, columns: 2) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                    
                    Section(header: Text().text("List").font(12)) {
                        ForEach(fruits2) { fruit2 in
                            View().HStack(spacing: 10, alignment: .center) {
                                Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                View().VStack(distribution: .fillEqually) {
                                    Text().text(fruit2.name).font(14, weight: .medium)
                                    Text().text("reguler").font(12, weight: .regular)
                                }
                                Spacer()
                            }.background(.systemTeal).cornerRadius(5).padding().height(50)
                        }
                    }
                    
                    ForEach(fruits1, axis: .horizontal) { fruit2 in
                        View().HStack(spacing: 10, alignment: .center) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                            View().VStack(distribution: .fillEqually) {
                                Text().text(fruit2.name).font(14, weight: .medium)
                                Text().text("reguler").font(12, weight: .regular)
                            }
                            Spacer()
                        }.background(.systemTeal).cornerRadius(5).padding().height(50)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func rowColumnView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    Section(header: Text().text("Columns").font(12)) {
                        ForEach(1..<14, columns: 3) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                    
                    Section(header: Text().text("Rows").font(12)) {
                        ForEach(1..<18, rows: 2, axis: .horizontal) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func sectionView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(fruits1, spacing: 10) { fruit in
                        Section(header: Text().text(fruit.name)) {
                            ForEach(fruit.fruiteType) { fruitsss in
                                Text().text(fruitsss.name).font(20, weight: .medium)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Section")
        //.navigationBarTitleDisplayMode(.always)
    }
    
    func flexInfScrollView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    Section(header: Text().text("Flexible/Infinity").font(12)) {
                        ForEach(1..<18, axis: .horizontal) { index in
                            NavigationLinkView().content {
                                debugPrint("DEBUG: Index [\(index)]")
                            } setup: { view in
                                view.VStack(alignment: .center, distribution: .fillEqually) {
                                    Image().image(systemName: "person.circle").foregroundColor(0x333333)//.frame(width: 40, height: 40).scaledToFit()
                                    Text().text("\(index)").font(14, weight: .medium)
                                }.background(.systemTeal).cornerRadius(5).padding().height(100)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Flexible/Infinity Scroll")
        //.navigationBarTitleDisplayMode(.always)
    }
    
    func bouncesVerticalView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(fruits1) { index in
                        view.HStack(alignment: .center, distribution: .fillEqually) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                            Text().text("\(index.name)").font(14, weight: .medium)
                            Spacer()
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
    
    func bouncesHorizontalView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(0..<3, axis: .horizontal) { index in
                        View().HStack(alignment: .center, distribution: .fillEqually) {
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
    
    func verticalPagingView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(fruits1.indices) { index in
                        self.cellView(for: self.fruits1[index], at: index)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Bounces")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func horizontalPagingView() {
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
    
    func reorderView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(fruits1) { index in
                        view.HStack(alignment: .center, distribution: .fillEqually) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                            Text().text("\(index.name)").font(14, weight: .medium)
                            Spacer()
                        }.background(.systemTeal).cornerRadius(5).padding().height(50)
                    }
                    /*.onMove { indexSet, destinationIndex in
                        print("Moved item from \(indexSet.first!) to \(destinationIndex)")
                        self.handleItemMove(from: indexSet.first!, to: destinationIndex)
                    }*/
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Reorder")
        .navigationBarTitleDisplayMode(.always)
    }
    
    func tabItems() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    Section(header: Text().text("Tab Items").font(12)) {
                        ForEach(fruits3, axis: .horizontal) { fruit2 in
                            View().HStack(spacing: 3, alignment: .center) {
                                Text().text(fruit2.name).font(12)
                            }.cornerRadius(30/2).padding().height(30).stroke(.systemOrange).width(fruit2.name.toCGFloat())
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .navigationTitle("ForEach")
        .navigationBarTitleDisplayMode(.always)
    }
}

extension ListViewController {
    fileprivate func cellView(for item: Fruit, at index: Int) -> some View {
        let viewss = View()
        viewss.HStack(spacing: 5) {
            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 30, height: 30).scaledToFit()
            Text().text("\(item.name)").font(14, weight: .medium)
            Spacer()
        }
        .background(index % 2 == 0 ? 0xF0F0F0 : 0xFFFFFF)
        .cornerRadius(5)
        .padding()
        
        return viewss
    }
}

extension ListViewController {
    fileprivate func refreshableListView() {
        view.VStack {
            List { view in
                view.VStack(spacing: 10) {
                    ForEach(0..<20) { index in
                        view.HStack(alignment: .center, distribution: .fillEqually) {
                            Image().image(systemName: "person.circle").foregroundColor(0x333333).frame(width: 40, height: 40).scaledToFit()
                            Text().text("\(index)").font(14, weight: .medium)
                            Spacer()
                        }.background(.systemTeal).cornerRadius(5).padding().height(50)
                    }
                }
            }
            /*.refreshable {
                print("Fetching data for refresh...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("Data refreshed!")
                    //completion() // Call completion when done
                }
            }*/
            /*.refreshable { completion in
                print("Fetching data for refresh...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("Data refreshed!")
                    completion() // Call completion when done
                }
            }
            .loadMore { completion in
                print("Fetching more data...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("More data loaded!")
                    completion() // Call completion when done
                }
            }*/
        }
        .padding(16)
        .background(.white)
        .navigationTitle("Refresh List")
    }
}

extension String {
    /// Convert string.count to CGFloat
    func toCGFloat() -> CGFloat {
        CGFloat(self.count)
    }
}
