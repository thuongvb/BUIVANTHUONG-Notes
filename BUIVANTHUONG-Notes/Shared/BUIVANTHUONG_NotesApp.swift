//
//  BUIVANTHUONG_NotesApp.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 23/06/2023.
//

import SwiftUI

@main
struct BUIVANTHUONG_NotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(networkMonitor)
        }
    }
}
