//
//  DefaultApi.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation
import Alamofire


let simpleReq = DefaultApi(serverAdress: "")

public class DefaultApi {
    
    var serverAdress: String = ""
    
    init(serverAdress: String) {
        self.serverAdress = serverAdress
    }
    
    
    let defaultUserAgent: String = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5410.0 Safari/537.36"

    func getRequest(endPoint: String) -> DataRequest {
        var request = URLRequest(url: URL(string: serverAdress + endPoint)!)
        request.method = .get
        request.headers.add(.userAgent(defaultUserAgent))
        return AF.request(request)
    }
    
    func getPost(url: String, parameters: [String: Any]) -> DataRequest {
        return AF.request(url, method: .post, parameters: parameters)
    }
    
    func requestAsync(endPoint: String) async throws -> String {
        try await withUnsafeThrowingContinuation{ continuation in
            getRequest(endPoint: endPoint).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func postAsync(url: String, parameters: [String: Any]) async throws -> String {
        try await withUnsafeThrowingContinuation{ continuation in
            getPost(url: url, parameters: parameters).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
