//
//  Website.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation


func getCsrfTokenByPage(page: String) -> String? {
    if page.components(separatedBy: "csrf-token\" content=\"").count <= 1 {
        return nil
    }
    let csrf_token = page.components(separatedBy: "csrf-token\" content=\"")[1].components(separatedBy: "\"")[0]
    return csrf_token
}

func getXsrfTokenByPage(page: String) -> String? {
    if page.components(separatedBy: "'Rsi-XSRF', 'token' : '").count <= 1 {
        return nil
    }
    let xsrf_token = page.components(separatedBy: "'Rsi-XSRF', 'token' : '")[1].components(separatedBy: "', 'ttl' : 1800 }")[0]
    return xsrf_token
}

func generateRandomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let randomString = (0..<length).map{ _ in letters.randomElement()! }
    return String(randomString)
}

func getCurrentMillisecondTimestamp() -> Int64 {
    let now = Date()
    let timestamp = Int64(now.timeIntervalSince1970 * 1000)
    return timestamp
}
