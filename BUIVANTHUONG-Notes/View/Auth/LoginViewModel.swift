//
//  SignupView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import SwiftUI
import FirebaseFirestore
import Combine

class LoginViewModel: ObservableObject {
    let db = Firestore.firestore()
    var cancelBag = Set<AnyCancellable>()

    @Published var user: UserModel? {
        didSet {
            guard let username = user?.username else {
                return
            }
            
            UserDefaults.standard.set(username, forKey: "username")
            AppManager.Authenticated.send(true)
        }
    }
    @Published var isExist: Bool?

    init() {}
    
    deinit {
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
    }
    
    var userDocumentSnapshotMapper: (DocumentSnapshot) throws -> UserModel? {
        {
            var user =  try $0.data(as: UserModel.self)
            user.id = $0.documentID
            user.username = user.username
            return user
        }
    }

    func checkUsername(with username: String) {
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments(as: UserModel.self, documentSnapshotMapper: userDocumentSnapshotMapper)
            .compactMap({ $0.first })
            .sink { [weak self] completion in
                self?.isExist = false
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.isExist = true
                self?.user = $0
            }
            .store(in: &cancelBag)
    }
    
    func createAUser(with username: String) {
        db.collection("users")
            .addDocument(data: ["username" : username])
            .flatMap {
                $0.cacheFirstGetDocument(as: UserModel.self, documentSnapshotMapper: self.userDocumentSnapshotMapper)
            }
            .sink { [weak self] completion in
                self?.isExist = false
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.user = $0
            }
            .store(in: &cancelBag)
    }
}
