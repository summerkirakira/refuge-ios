//
//  Models.swift
//  Refuge
//
//  Created by SummerKirakira on 27/11/2023.
//

import Foundation


struct User: Identifiable, Codable {
    let id: Int
    let handle: String
    let email: String
    let password: String
    let rsi_token: String
    let profileImage: String
    let referralCode: String
    let referralCount: Int
    let referralProspectCount: Int
    
    let usd: Int
    let uec: Int
    let rec: Int
    
    let hangarValue: Int
    let totalSpent: Int
    
    let organization: String
    let organizationImage: String
    let orgRank: String
    
    let registerTime: Date
    var extra: String = ""
}
