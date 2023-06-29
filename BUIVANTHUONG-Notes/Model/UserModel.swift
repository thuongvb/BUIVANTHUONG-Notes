//
//  UserModel.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import Foundation

struct UserModel: Codable {
    var username: String? = nil
    var id: String? = nil
    
    enum CodingKeys: CodingKey {
        case username
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.id, forKey: .id)
    }
}

extension UserModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.username == rhs.username
    }

}
