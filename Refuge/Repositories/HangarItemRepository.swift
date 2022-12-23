//
//  HangarItemRepository.swift
//  Refuge
//
//  Created by 弘培郑 on 23/12/2022.
//

import CoreData
import Foundation

public class HangarItemRepository: ObservableObject{
    @Published var items: [HangarItem] = []
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("hangar_item.data")
    }
    
    @discardableResult
    func load() async throws -> [HangarItem] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let hangarItems):
                    continuation.resume(returning: hangarItems)
                }
            }
        }
    }
    
    @discardableResult
    func save() async throws -> Int? {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: self.items) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    
    func load(completion: @escaping (Result<[HangarItem], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try HangarItemRepository.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let hangarItems = try JSONDecoder().decode([HangarItem].self, from: file.availableData)
                DispatchQueue.main.async {
                    self.items = hangarItems
                    completion(.success(hangarItems))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func save(scrums: [HangarItem], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try HangarItemRepository.fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    self.items = scrums
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

public let repository = HangarItemRepository()
