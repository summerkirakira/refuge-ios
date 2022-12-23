//
//  CirnoApi.swift
//  Refuge
//
//  Created by 弘培郑 on 23/12/2022.
//

import Foundation
public class CirnoApi: DefaultApi{
    
    init() {
        super.init(serverAdress: "http://biaoju.site:6088/")
    }
    
    func getVersion() async -> Version? {
        do {
            let value = try await getRequest(endPoint: "version/latest").serializingDecodable(Version.self).value
            return value
        } catch {
            return nil
        }
    }
}
