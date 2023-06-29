//
//  NoteModel.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import Foundation
import FirebaseFirestore

struct NoteModel: Codable {
    var id: String? = nil
    var username: String? = nil
    var noteText: String = ""
    var updateDate: Date = Date()
    
    enum CodingKeys: CodingKey {
        case username
        case noteText
        case updateDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.noteText = try container.decodeIfPresent(String.self, forKey: .noteText) ?? ""
        self.updateDate = try container.decodeIfPresent(Timestamp.self, forKey: .updateDate)?.dateValue() ?? Date()

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.noteText, forKey: .noteText)
        try container.encodeIfPresent(Timestamp(date: self.updateDate), forKey: .noteText)
    }
}

extension NoteModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(noteText)
        hasher.combine(updateDate)
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        lhs.username == rhs.username
        && lhs.noteText == rhs.noteText
        && lhs.updateDate == rhs.updateDate

    }

}
