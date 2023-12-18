//
//  UserRepository.swift
//  Refuge
//
//  Created by SummerKirakira on 27/11/2023.
//

import CoreData
import Foundation

public class UserRepository: ObservableObject{
    @Published var users: [User] = []
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("users.data")
    }
    
    @discardableResult
    func load() async throws -> [User] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let users):
                    continuation.resume(returning: users)
                }
            }
        }
    }
    
    @discardableResult
    func save() async throws -> Int? {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: self.users) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    
    func load(completion: @escaping (Result<[User], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try UserRepository.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let users = try JSONDecoder().decode([User].self, from: file.availableData)
                DispatchQueue.main.async {
                    self.users = users
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func save(scrums: [User], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try UserRepository.fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    self.users = scrums
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getUser(handle: String) -> User? {
        for user in self.users {
            if user.handle == handle {
                return user
            }
        }
        return nil
    }
    
    func addUser(user: User) {
        var newUsers: [User] = []
        for currentUser in self.users {
            if currentUser.handle != user.handle {
                newUsers.append(currentUser)
            }
        }
        newUsers.append(user)
        self.users = newUsers
    }
    
    func setCurrentUser(user: User) {
        self.addUser(user: user)
        UserDefaults.standard.set(user.handle, forKey: "current_user")
    }
    
    func getCurrentUser(handle: String) -> User? {
        let currentUserName = UserDefaults.standard.string(forKey: "current_user")
        if currentUserName == nil {
            return nil
        }
        return getUser(handle: currentUserName!)
    }
    
    func getUsers() -> [User] {
        return self.users
    }
    
}

public let userRepo = UserRepository()