//
//  MyNotesViewModel.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import SwiftUI
import FirebaseFirestore
import Combine

class MyNotesViewModel: ObservableObject {
    let db = Firestore.firestore()
    var cancelBag = Set<AnyCancellable>()

    @Published var notes: [NoteModel] = []
    
    init() {}
    
    deinit {
        cancelBag.forEach { $0.cancel() }
        cancelBag.removeAll()
    }
    
    var noteDocumentSnapshotMapper: (DocumentSnapshot) throws -> NoteModel? {
        {
            var note =  try $0.data(as: NoteModel.self)
            note.id = $0.documentID
            return note
        }
    }

    func updateANote(noteText: String, id: String? = nil, completion: (() -> Void)?) {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        
        let updateDate = Date()
        
        if let id = id {
            db.collection("notes")
                .document(id)
                .setData([
                    "noteText" : noteText,
                    "updateDate": Timestamp(date: updateDate)
                ], merge: true)
                .sink { completion in
                    switch completion {
                    case .finished: print("🏁 finished")
                    case .failure(let error): print("❗️ failure: \(error)")
                    }
                } receiveValue: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    if let index = self.notes.firstIndex(where: { $0.id == id }) {
                        self.notes[index].noteText = noteText
                        self.notes[index].updateDate = updateDate
                        self.notes = self.notes.sorted(by: { $0.updateDate > $1.updateDate })
                        completion?()
                    }
                }
                .store(in: &cancelBag)

            return
        }
        
        db.collection("notes")
            .addDocument(
                data: [
                    "username" : username,
                    "noteText" : noteText,
                    "updateDate": Timestamp(date: updateDate)
                ]
            )
            .flatMap {
                $0.cacheFirstGetDocument(as: NoteModel.self, documentSnapshotMapper: self.noteDocumentSnapshotMapper)
            }
            .sink { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                
                if let note = $0,
                   self.notes.filter({ $0.noteText == note.noteText }).isEmpty {
                    self.notes.insert(note, at: 0)
                    completion?()
                }
            }
            .store(in: &cancelBag)
    }

    
    func getMyListNotes() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        db.collection("notes")
            .whereField("username", isEqualTo: username)
            .getDocuments(as: NoteModel.self, documentSnapshotMapper: self.noteDocumentSnapshotMapper)
            .sink { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.notes = $0.sorted(by: { $0.updateDate > $1.updateDate })
            }
            .store(in: &cancelBag)
    }
    
    func getListNotes() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        db.collection("notes")
            .whereField("username", isNotEqualTo: username)
            .getDocuments(as: NoteModel.self)
            .sink { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.notes = $0.sorted(by: { $0.updateDate > $1.updateDate })
            }
            .store(in: &cancelBag)
    }

    
    func deleteANote(id: String) {
        guard AppManager.IsAuthenticated(), !id.isEmpty else {
            return
        }
        
        db.collection("notes")
            .document(id)
            .delete()
            .sink { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.notes.removeAll(where: {$0.id == id})
            }
            .store(in: &cancelBag)
    }

    
    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "username")
        AppManager.Authenticated.send(false)
    }

    
}
