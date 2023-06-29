//
//  HomeView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 26/06/2023.
//

import SwiftUI

enum TabbarItem: Int, CaseIterable {
    case notes = 0,
         myNotes
    
    var title: String {
        switch self {
        case .notes:
            return "Notes"
        case .myNotes:
            return "My Notes"
        }
    }
    
    var iconName: String {
        switch self {
        case .notes:
            return "person.3.sequence.fill"
        case .myNotes:
            return "note.text"
        }
    }
}

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var myNotesViewModel: MyNotesViewModel
    @ObservedObject var socialNotesViewModel: MyNotesViewModel

    @State private var tabSelection = 0
    private var heightTabbar: CGFloat = 70
    
    init(
        myNotesViewModel: MyNotesViewModel,
        socialNotesViewModel: MyNotesViewModel
    ) {
        self.myNotesViewModel = myNotesViewModel
        self.socialNotesViewModel = socialNotesViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabSelection) {
                    SocialNotesView(viewModel: socialNotesViewModel)
                        .tag(0)
                    MyNotesView(viewModel: myNotesViewModel)
                        .tag(1)
                }
                .clipShape(Rectangle())
                .padding(.bottom)
                
                customTabbarView
                    .padding(6)
                    .frame(height: heightTabbar)
                    .background(Color.navBar)
                    .cornerRadius(35)
                    .padding(.horizontal, 26)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(
                Text((TabbarItem(rawValue: tabSelection) ?? .myNotes).title)
            )
            .toolbarBackground(
                Color.navBar,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        
    }
    
    private var customTabbarView: some View {
        HStack {
            ForEach(TabbarItem.allCases, id: \.self){ item in
                Button {
                    tabSelection = item.rawValue
                } label: {
                    customTabItem(
                        imageName: item.iconName,
                        title: item.title,
                        isActive: (tabSelection == item.rawValue)
                    )
                }
            }
        }

    }
}

extension HomeView {
    func customTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        let foregroundColor: Color = isActive ? .white : .white.opacity(0.4)
        
        return HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .renderingMode(.template)
                .foregroundColor(foregroundColor)
                .frame(width: 20, height: 20)
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(foregroundColor)
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(myNotesViewModel: .init(), socialNotesViewModel: .init())
    }
}
