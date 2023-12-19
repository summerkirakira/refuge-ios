//
//  UserParser.swift
//  Refuge
//
//  Created by SummerKirakira on 27/11/2023.
//

import Foundation
import SwiftSoup

func parseNewUser(email: String, password: String, rsi_device: String, rsi_token: String) async throws -> User? {
    RsiApi.setToken(token: rsi_token)
    RsiApi.setDevice(device: rsi_device)
    
    let referrel_page = try? await RsiApi.getPage(endPoint: "account/referral-program")
    if referrel_page == nil {
        return nil
    }
    let referral_doc: Document? = try? SwiftSoup.parse(referrel_page!)
    if referral_doc == nil {
        return nil
    }
    let userName = try? referral_doc!.select(".c-account-sidebar__profile-info-displayname").first()?.text()
    let userHandle = try? referral_doc!.select(".c-account-sidebar__profile-info-handle").first()?.text()
    var userImage =
    try? referral_doc!.select(".c-account-sidebar__profile-metas-avatar").first()?.attr("style").replacingOccurrences(of: "background-image:url('", with: "").replacingOccurrences(of: "');", with: "")
    let userCreditsString =
    try? referral_doc!.select(".c-account-sidebar__profile-info-credits-amount--pledge").first()?.text().replacingOccurrences(of: "$", with: "")
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "USD", with: "")
        .replacingOccurrences(of: ",", with: "")
    let userUECString =
    try? referral_doc!.select(".c-account-sidebar__profile-info-credits-amount--uec").first()?.text()
        .replacingOccurrences(of: "¤", with: "")
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "UEC", with: "")
        .replacingOccurrences(of: ",", with: "")
    let userRECString =
    try? referral_doc!.select(".c-account-sidebar__profile-info-credits-amount--rec").first()?.text()
        .replacingOccurrences(of: "¤", with: "")
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "REC", with: "")
        .replacingOccurrences(of: ",", with: "")
    let recruitNumberString =
    try? referral_doc!.select("div.progress").first()?.select(".label").first()?.text()
        .replacingOccurrences(of: "Total recruits: ", with: "")
    
    let totalReferralNumberString =
    try? referral_doc!.select("a[href='/account/referral-program'][data-type='pending']").first()?.text()
        .replacingOccurrences(of: "Prospects (", with: "")
        .replacingOccurrences(of: ")", with: "")
    
    let referralCode = try? referral_doc!.select("#share-referral-form").first()?.select("input").first()?.attr("value")
    
    let billing_page = try? await RsiApi.getPage(endPoint: "account/billing")
    
    if billing_page == nil {
        return nil
    }
    
    let billing_doc: Document? = try? SwiftSoup.parse(billing_page!)
    
    if billing_doc == nil {
        return nil
    }
    
    let totalSpentString = try? billing_doc!.select(".spent-line").last()?.select("em").first()?.text()
        .replacingOccurrences(of: "$", with: "")
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "USD", with: "")
        .replacingOccurrences(of: ",", with: "")
    
    let userInfoPage = try? await RsiApi.getPage(endPoint: "citizens/\(userHandle!)")
    if userInfoPage == nil {
        return nil
    }
    
    let userInfoDoc: Document? = try? SwiftSoup.parse(userInfoPage!)
    
    if userInfoDoc == nil {
        return nil
    }
    
    let enlisted = try? userInfoDoc!.select(".left-col").last()?.select(".entry").first()?.select("strong").first()?.text()
    let orgName = try? userInfoDoc!.select(".right-col").first()?.select(".entry").first()?.select("a").first()?.text()
    var orgLogoUrl = try? userInfoDoc!.select(".right-col").first()?.select(".thumb").first()?.select("img").first()?.attr("src")
    let orgRank = try? userInfoDoc!.select(".right-col").first()?.select(".entry")[2].select("strong").first()?.text()
    let orgId = try? userInfoDoc!.select(".right-col").first()?.select(".thumb").first()?.select("a").first()?.attr("href").split(separator: "/")[1]
    var orgIdString: String? = nil
    if orgId != nil {
        orgIdString = String(orgId!)
    }
    let rankList = try? userInfoDoc!.select(".ranking").first()?.select("span")
    var orgLevel = 0
    if rankList != nil {
        for item in rankList! {
            let activeString = try? item.attr("class")
            if activeString == nil {
                continue
            }
            if activeString! == "active" {
                orgLevel += 1
            }
        }
    }
    
    debugPrint(userName, userHandle, userImage, userRECString, userCreditsString, totalSpentString, enlisted, orgName, orgLogoUrl, orgId, referralCode, recruitNumberString, totalReferralNumberString)
    
    if (userImage == nil || userHandle == nil || referralCode == nil || recruitNumberString == nil || totalReferralNumberString == nil || userCreditsString == nil || userUECString == nil || userRECString == nil || totalSpentString == nil || enlisted == nil) {
        return nil
    }
    
    if (userImage!.starts(with: "/")) {
        userImage = "https://robertsspaceindustries.com" + userImage!
    }
    
    if (orgLogoUrl != nil && orgLogoUrl!.starts(with: "/")) {
        orgLogoUrl = "https://robertsspaceindustries.com" + orgLogoUrl!
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    
    let registerTime = dateFormatter.date(from: enlisted!)
    dateFormatter.dateFormat = "yyyy年MM月dd日"
    let registerTimeString = dateFormatter.string(from: registerTime!)

    
    let newUser = User(
        handle: userHandle!,
        email: email,
        password: password,
        rsi_token: rsi_token,
        profileImage: userImage!,
        referralCode: referralCode!,
        referralCount: Int(recruitNumberString!)!,
        referralProspectCount: Int(totalReferralNumberString!)!,
        
        usd: Int(Float(userCreditsString!)! * 100),
        uec: Int(userUECString!)!,
        rec: Int(userRECString!)!,
        
        hangarValue: 0,
        totalSpent: Int(Float(totalSpentString!)! * 100),
        organization: orgIdString,
        organizationName: orgName,
        organizationImage: orgLogoUrl,
        orgRank: orgRank,
        orgLevel: orgLevel,
        registerTime: registerTime!,
        registerTimeString: registerTimeString
    )

    return newUser
}
