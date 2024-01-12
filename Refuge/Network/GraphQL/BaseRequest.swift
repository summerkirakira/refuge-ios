//
//  BaseRequest.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation
import Alamofire

struct GraphQLRequest<Input: Encodable, Output: Decodable> {
    let url: String
    let query: String
    let variables: Input?
    let headers: HTTPHeaders?

    init(url: String, query: String, variables: Input? = nil, headers: HTTPHeaders? = nil) {
        self.url = url
        self.query = query
        self.variables = variables
        self.headers = headers
    }

}

struct Paylaod<Variable: Encodable>: Encodable {
    let query: String
    let variables: Variable
}

func performGraphQLRequest<Input: Encodable, Output: Decodable>(request: GraphQLRequest<Input, Output>, completion: @escaping (Result<Output, Error>) -> Void) {
//    debugPrint(RsiApi.getHeaders())
    let jsonData = try? JSONEncoder().encode(request.variables)
    let jsonString = String(data: jsonData!, encoding: .utf8)
//    debugPrint(jsonString)
    AF.request(request.url,
               method: .post,
               parameters: ["query": request.query, "variables": jsonString],
               encoder: JSONParameterEncoder.default,
               headers: RsiApi.getHeaders())
        .responseDecodable(of: Output.self) { response in
            
            let allHeaders = response.response?.allHeaderFields
            
            if allHeaders != nil {
                if let setCookieHeader = allHeaders!["Set-Cookie"] as? String {
                    let token = setCookieHeader.components(separatedBy: ";")[0].components(separatedBy: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    RsiApi.setToken(token: token)
                    // 在这里可以进一步处理 Set-Cookie 字段
                }
            }
            
            if response.data != nil {
                let str = String(bytes: response.data!, encoding: .utf8)
//                debugPrint(str)
            }
            
            switch response.result {
            case .success(let data):
                
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
//                debugPrint(error)
                if response.data != nil {
                    let str = String(bytes: response.data!, encoding: .utf8)
//                    debugPrint(str)
                }
            }
        }
}

func performGraphQLRequestForString<Input: Encodable, Output: Decodable>(request: GraphQLRequest<Input, Output>, completion: @escaping (Result<Output, Error>) -> Void) {
//    debugPrint(RsiApi.getHeaders())
    let jsonData = try? JSONEncoder().encode(request.variables)
    let jsonString = String(data: jsonData!, encoding: .utf8)
//    debugPrint(jsonString)
    AF.request(request.url,
               method: .post,
               parameters: ["query": request.query, "variables": jsonString],
               encoder: JSONParameterEncoder.default,
               headers: RsiApi.getHeaders())
        .responseDecodable(of: Output.self) { response in
            
            let allHeaders = response.response?.allHeaderFields
            
            if allHeaders != nil {
                if let setCookieHeader = allHeaders!["Set-Cookie"] as? String {
                    let token = setCookieHeader.components(separatedBy: ";")[0].components(separatedBy: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    RsiApi.setToken(token: token)
                    // 在这里可以进一步处理 Set-Cookie 字段
                }
            }
            
            
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
//                debugPrint(error)
            }
        }
}


func performGraphQLRequestAsync<Input: Encodable, Output: Decodable>(request: GraphQLRequest<Input, Output>) async throws -> Output
{
    try await withUnsafeThrowingContinuation { continuation in

        performGraphQLRequest(request: request) { result in
            switch result {
            case .success(let data):
                continuation.resume(returning: data)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
