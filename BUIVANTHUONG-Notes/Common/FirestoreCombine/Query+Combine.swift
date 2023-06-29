//
//  FirebaseExtension.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import FirebaseFirestore
import Combine

extension Query {
    public func getDocuments(source: FirestoreSource = .default) -> AnyPublisher<QuerySnapshot, Error> {
        Future<QuerySnapshot, Error> { [weak self] promise in
            self?.getDocuments(source: source, completion: { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                } else {
                    promise(.failure(FirestoreError.nilResultError))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func getDocuments<D: Decodable>(source: FirestoreSource = .default, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper(), querySnapshotMapper: @escaping (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] = QuerySnapshot.defaultMapper()) -> AnyPublisher<[D], Error> {
        getDocuments(source: source)
            .map { querySnapshotMapper($0, documentSnapshotMapper) }
            .eraseToAnyPublisher()
    }
}

extension QuerySnapshot {
    public static func defaultMapper<D: Decodable>() -> (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] {
        { (snapshot, documentSnapshotMapper) in
            var dArray: [D] = []
            snapshot.documents.forEach {
                do {
                    if let d = try documentSnapshotMapper($0) {
                        dArray.append(d)
                    }
                } catch {
                    print("Document snapshot mapper error for \($0.reference.path): \(error)")
                }
            }
            return dArray
        }
    }
}
