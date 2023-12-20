//
//  Login.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation


func Rsilogin(rsiAPI: RSIApi = RsiApi, email: String, password: String) async -> String? {
    
    rsiAPI.setToken(token: "")
    rsiAPI.setDevice(device: getDeviceId())
    
    let newRsiToken = try? await rsiAPI.getDefaultRsiToken()
    
    if newRsiToken == nil {
        return nil
    }
    
    rsiAPI.setToken(token: newRsiToken!)
    
    
    await rsiAPI.setCsrfToken()
    
//    do {
//        try await Task.sleep(nanoseconds: 10_000_000_000)
//    } catch {
//
//    }
    
    
    let result = try? await rsiAPI.login(loginBody: LoginBody(captcha: RecaptchaV3().getRecaptchaToken(), email: email , password: password))
    
//    await rsiAPI.setCsrfToken()
    
    debugPrint(result)
    
    if result == nil {
        return nil
    }
    
    if result!.errors == nil {
        return nil
    }
    
    if result!.errors![0].code == "MultiStepRequiredException" {
        
        let deviceId = result!.errors![0].extensions.details.device_id!
        let rsiToken = result!.errors![0].extensions.details.session_id!
        
        setDeviceId(deviceId: deviceId)
        rsiAPI.setToken(token: rsiToken)
        rsiAPI.setDevice(device: deviceId)
        
        debugPrint("New RSI Token \(rsiToken)")
        
        
        
        
//        await rsiAPI.setCsrfToken()
        

        
        return rsiToken
        
    }
    
    return nil
}


func RsiMultiLogin(rsiAPI: RSIApi = RsiApi, code: String) async -> Bool {
    await rsiAPI.setCsrfToken()
    do {
        try await Task.sleep(nanoseconds: 4_000_000_000)
    } catch {

    }
    let loginResult = await rsiAPI.multiStepLogin(multiStepLoginBody: MultiStepLoginBody(code: code))
    debugPrint(loginResult)
    if loginResult == nil {
        return false
    }
    
    return true
}
