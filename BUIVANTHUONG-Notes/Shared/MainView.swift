//
//  ContentView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 23/06/2023.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var isAuthenticated = AppManager.IsAuthenticated()
    @StateObject private var myNotesViewModel = MyNotesViewModel()
    @StateObject private var socialNotesViewModel = MyNotesViewModel()

    var body: some View {
        Group {
            if networkMonitor.isConnected {
                if isAuthenticated {
                    HomeView(
                        myNotesViewModel: myNotesViewModel,
                        socialNotesViewModel: socialNotesViewModel
                    )
                } else {
                    LoginView()
                }
            } else {
                NoNetworkView()
            }
        }
        .onReceive(AppManager.Authenticated) {
            isAuthenticated = $0
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
