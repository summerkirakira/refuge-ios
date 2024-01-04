//
//  FileManager.swift
//  Refuge
//
//  Created by Summerkirakira on 17/12/2023.
//

import Foundation


func saveAsJSON<T: Encodable>(_ value: T, to filePath: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let jsonData = try encoder.encode(value)
        try jsonData.write(to: filePath, options: .atomicWrite)
        debugPrint("Data saved successfully to: \(filePath.absoluteString)")
    } catch {
        throw error
    }
}

func loadFromJSON<T: Decodable>(_ type: T.Type, from filePath: URL) throws -> T {
    do {
        let jsonData = try Data(contentsOf: filePath)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(type, from: jsonData)
        return decodedData
    } catch {
        throw error
    }
}

func saveArrayAsJSON<T: Encodable>(_ array: [T], to filePath: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let jsonData = try encoder.encode(array)
        try jsonData.write(to: filePath, options: .atomicWrite)
        debugPrint("Data saved successfully to: \(filePath.absoluteString)")
    } catch {
        throw error
    }
}

func loadArrayFromJSON<T: Decodable>(_ type: T.Type, from filePath: URL) throws -> [T] {
    do {
        let jsonData = try Data(contentsOf: filePath)
        let decoder = JSONDecoder()
        let array = try decoder.decode([T].self, from: jsonData)
        return array
    } catch {
        debugPrint(error)
        throw error
    }
}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}


func saveDictionaryToPlist(_ dictionary: [String: String], dictName: String) {
    do {
        let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(dictName).plist")
        let data = try PropertyListEncoder().encode(dictionary)
        try data.write(to: plistURL)
        print("Dictionary saved to \(plistURL.absoluteString)")
    } catch {
        print("Error encoding or writing dictionary: \(error)")
    }
}

// 从文件中读取并解码字典
func loadDictionaryFromPlist(dictName: String) -> [String: String]? {
    do {
        let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(dictName).plist")
        let data = try Data(contentsOf: plistURL)
        let decodedDictionary = try PropertyListDecoder().decode([String: String].self, from: data)
        print("Dictionary loaded from \(plistURL.absoluteString)")
        return decodedDictionary
    } catch {
        print("Error reading or decoding dictionary: \(error)")
        return nil
    }
}


func getDeviceId() -> String {
    let deviceID = UserDefaults.standard.string(forKey: "deviceId")
    if deviceID == nil {
        return ""
    }
    return deviceID!
}

func setDeviceId(deviceId: String) {
    UserDefaults.standard.set(deviceId, forKey: "deviceId")
}
