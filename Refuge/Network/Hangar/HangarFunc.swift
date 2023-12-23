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

func giftHangarItem(rsiAPI: RSIApi = RsiApi, pledge_id: String, password: String, email: String) async -> BasicResponseBody? {
    let postBody = GiftPledgeRequestBody(pledge_id: pledge_id, current_password: password, email: email)
    let result: BasicResponseBody? = try? await rsiAPI.basicPostRequest(endPoint: "api/account/giftPledge", postBody: postBody)
    return result
}

func cancelGiftHangarItem(rsiAPI: RSIApi = RsiApi, pledge_id: String) async -> BasicResponseBody? {
    let postBody = CancelPledgeRequestBody(pledge_id: pledge_id)
    let result: BasicResponseBody? = try? await rsiAPI.basicPostRequest(endPoint: "api/account/cancelGift", postBody: postBody)
    return result
}
