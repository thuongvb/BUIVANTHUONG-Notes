//
//  AppManager.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import Foundation
import Combine

struct AppManager {
    static let Authenticated = PassthroughSubject<Bool, Never>()
    
    static func IsAuthenticated() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil
    }
}
