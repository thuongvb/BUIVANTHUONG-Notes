//
//  DocumentReference+Combine.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 28/06/2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension DocumentReference {
    public func setData(_ documentData: [String: Any]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.setData(documentData) { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
        
    public func setData(_ documentData: [String: Any], merge: Bool) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.setData(documentData, merge: merge) { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    public func delete() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.delete() { error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
        
    public func getDocument(source: FirestoreSource = .default) -> AnyPublisher<DocumentSnapshot, Error> {
        Future<DocumentSnapshot, Error> { [weak self] promise in
            self?.getDocument(source: source, completion: { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot, snapshot.data() != nil {
                    promise(.success(snapshot))
                } else {
                    promise(.failure(FirestoreError.nilResultError))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    public func getDocument<D: Decodable>(source: FirestoreSource = .default, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper()) -> AnyPublisher<D?, Error> {
        getDocument(source: source).map {
            do {
                return try documentSnapshotMapper($0)
            } catch {
                print("error for \(self.path): \(error)")
               return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
    public var cacheFirstGetDocument: AnyPublisher<DocumentSnapshot, Error> {
        getDocument(source: .cache)
            .catch { (error) -> AnyPublisher<DocumentSnapshot, Error> in
                print("error loading from cache for path \(self.path): \(error)")
                return self.getDocument(source: .server)
        }.eraseToAnyPublisher()
    }
    
    public func cacheFirstGetDocument<D: Decodable>(as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper()) -> AnyPublisher<D?, Error> {
        cacheFirstGetDocument.map {
            do {
                return try documentSnapshotMapper($0)
            } catch {
                print("error for \(self.path): \(error)")
               return nil
            }
        }
        .eraseToAnyPublisher()
    }
}

extension DocumentSnapshot {
    public static func defaultMapper<D: Decodable>() -> (DocumentSnapshot) throws -> D? {
        { try $0.data(as: D.self) }
    }
}
