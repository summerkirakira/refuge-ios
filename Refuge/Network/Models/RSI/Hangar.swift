//
//  Hangar.swift
//  Refuge
//
//  Created by Summerkirakira on 20/12/2023.
//

import Foundation


struct GiftPledgeRequestBody: Encodable {
    let pledge_id: String
    let current_password: String
    let email: String
    let name: String = "StarRefuge"
}

struct CancelPledgeRequestBody: Encodable {
    let pledge_id: String
}

struct ReclaimRequestBody: Encodable {
    let pledge_id: String
    let current_password: String
}

struct BasicResponseBody: Decodable {
    let success: Int
    let code: String
    let msg: String
}
