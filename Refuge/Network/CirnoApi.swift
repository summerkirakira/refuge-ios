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
        request.addValue("cirno-token", forHTTPHeaderField: getUuid())
        return AF.request(request)
    }
    
    func getPostHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "cirno-token": getUuid(),
            "Content-Type": "application/json"
            ]
        return headers
    }
    
    func getVersion() async -> Version? {
        do {
            let value = try await getRequest(endPoint: "version/latest").serializingDecodable(Version.self).value
            return value
        } catch {
            return nil
        }
    }

    func getTranslationVersion() async -> TranslationVersion? {
        do {
            let value = try await getRequest(endPoint: "translation/version").serializingDecodable(TranslationVersion.self).value
            return value
        } catch {
            return nil
        }
    }
    
    func getTranslation() async -> [Translation]{
        do {
            let value = try await getRequest(endPoint: "translation/all").serializingDecodable([Translation].self).value
            return value
        } catch {
            return []
        }
    }

    func getShipAlias(url: URL) async -> [ShipAlias] {
        do {
            let value = try await AF.request(url).serializingDecodable([ShipAlias].self).value
            return value
        } catch {
            return []
        }
    }
    
    func getBanners() async -> [Banner] {
        do {
            let value = try await getRequest(endPoint: "banner").serializingDecodable([Banner].self).value
            return value
        } catch {
            return []
        }
    }
    
    func getRefugeVersion(postBody: RefugeVersion) async -> Version? {
        let result: Version? = try? await self.basicPostRequest(endPoint: "version", postBody: postBody)
        return result
    }
    
    func basicPostRequest<Input: Encodable, Output: Decodable>(endPoint: String, postBody: Input) async throws -> Output {
        try await withCheckedThrowingContinuation{ continuation in
            AF.request(serverAdress + endPoint,
                       method: .post,
                       parameters: postBody,
                       encoder: JSONParameterEncoder.default,
                       headers: self.getPostHeaders()
            )
            .responseDecodable(of: Output.self) { response in
                switch response.result {
                case .success(let value):
                    debugPrint("Post \(endPoint), headers \(self.getPostHeaders()), response \(value)")
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
