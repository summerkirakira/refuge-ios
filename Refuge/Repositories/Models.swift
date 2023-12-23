//
//  Models.swift
//  Refuge
//
//  Created by SummerKirakira on 27/11/2023.
//

import Foundation


struct User: Codable {
    var handle: String
    let name: String
    var email: String
    var password: String
    let rsi_token: String
    let profileImage: String
    let referralCode: String
    let referralCount: Int
    let referralProspectCount: Int
    
    let usd: Int
    let uec: Int
    let rec: Int
    
    var hangarValue: Int
    var currentHangarValue: Int = 0
    let totalSpent: Int
    
    let organization: String?
    let organizationName: String?
    let organizationImage: String?
    let orgRank: String?
    let orgLevel: Int
    
    let registerTime: Date
    let registerTimeString: String
    var extra: String = ""
}

struct Banner: Codable {
    let id: Int
    let url: String
}
