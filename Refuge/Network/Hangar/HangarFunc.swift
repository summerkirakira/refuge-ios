//
//  HangarFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 20/12/2023.
//

import Foundation


func reclaimHangarItem(rsiAPI: RSIApi = RsiApi, pledge_id: String, password: String) async -> BasicResponseBody? {
    let postBody = ReclaimRequestBody(pledge_id: pledge_id, current_password: password)
    let result: BasicResponseBody? = try? await rsiAPI.basicPostRequest(endPoint: "api/account/reclaimPledge", postBody: postBody)
    return result
}
