//
//  DefaultApi.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation
import Alamofire

public class DefaultApi {
    
    var serverAdress: String = ""
    
    init(serverAdress: String) {
        self.serverAdress = serverAdress
    }
    
    
    let defaultUserAgent: String = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"

    func getRequest(endPoint: String) -> DataRequest {
        var request = URLRequest(url: URL(string: serverAdress + endPoint)!)
        request.method = .get
        request.headers.add(.userAgent(defaultUserAgent))
        return AF.request(request)
    }
}
