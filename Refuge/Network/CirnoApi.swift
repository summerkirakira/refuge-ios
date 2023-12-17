//
//  CirnoApi.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation
import Alamofire

let CirnoApi = CIRNOApi()

import Foundation
public class CIRNOApi: DefaultApi{
    
    init() {
        super.init(serverAdress: "http://biaoju.site:6088/")
    }
    
    override func getRequest(endPoint: String) -> DataRequest {
        var request = URLRequest(url: URL(string: serverAdress + endPoint)!)
        request.method = .get
        request.headers.add(.userAgent(defaultUserAgent))
        return AF.request(request)
    }
    
    func getVersion() async -> Version? {
        do {
            let value = try await getRequest(endPoint: "version/latest").serializingDecodable(Version.self).value
            return value
        } catch {
            return nil
        }
    }
    func getTranslation() async -> [Translation] {
        do {
            let value = try await getRequest(endPoint: "translation/all").serializingDecodable([Translation].self).value
            return value
        } catch {
            return []
        }
    }
}
