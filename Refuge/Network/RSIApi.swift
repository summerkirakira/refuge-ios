//
//  RSIApi.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation
import Alamofire


let RsiApi = RSIApi()


public class RSIApi: DefaultApi{
    
    let referer = "https://robertsspaceindustries.com/"
    var rsi_device = getDeviceId()
    var rsi_token = ""
    var csrf_token = ""
    var rsi_cookie_constent = "{stamp:%27yW0Q5I4vGut12oNYLMr/N0OUTu+Q5WcW8LJgDKocZw3n9aA+4Ro4pA==%27%2Cnecessary:true%2Cpreferences:true%2Cstatistics:true%2Cmarketing:true%2Cver:1%2Cutc:1647068701970%2Cregion:%27gb%27}"
    var rsi_cookie = ""
    var rsi_account_auth: String? = nil
    var rsi_ship_upgrades_context: String? = nil
    var rsi_csrf_token = ""
    var xsrf = ""
    var marker = ""
    var extra_cookies: [String] = []
    
    func setRSICookie(rsiToken: String, rsiDevice: String) {
        rsi_device = rsiDevice
        rsi_token = rsiToken
        // rsi_cookie = "CookieConsent=$RSI_COOKIE_CONSTENT;_rsi_device=\(rsi_device);Rsi-Token=\(rsi_token)"
    }
    
    func setRSIAccountAuth(token: String) {
        rsi_account_auth = token
    }

    func setRSIShipUpgradesContext(context: String) {
        rsi_ship_upgrades_context = context
    }

    func getShipUpgradesCookie() -> String {
        return "Rsi-Ship-Upgrades-Context=\(rsi_ship_upgrades_context);Rsi-Account-Auth=\(rsi_account_auth);"
    }

    func getRsiBasicCookie() -> [HTTPCookie] {
        let cookie = [
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "Rsi-Token",
                .value: rsi_token,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "_rsi_device",
                .value: rsi_device,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "x-rsi-device",
                .value: rsi_device,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "x-rsi-token",
                .value: rsi_token,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!
        ]
        return cookie
    }

    func getHeaders() -> HTTPHeaders {
        let cookies = getRsiBasicCookie()
        
        var cookieList: [String] = []
        for cookie in cookies {
            cookieList.append("\(cookie.name)=\(cookie.value)")
        }
        
        var cookieString = "Rsi-Token=\(rsi_token); _rsi_device=\(rsi_device);"
        
        if extra_cookies.count > 0 {
            cookieString = cookieString + ";" + extra_cookies.joined(separator: ";")
        }
        
        if rsi_account_auth != nil {
            cookieString += "; Rsi-Account-Auth=\(rsi_account_auth!); "
        }
        
        if rsi_ship_upgrades_context != nil {
            cookieString += "Rsi-ShipUpgrades-Context=\(rsi_ship_upgrades_context!);"
        }
        
        if xsrf != "" {
            cookieString += "Rsi-XSRF=\(xsrf)"
        }
        
        var headers: HTTPHeaders = HTTPCookieStorage.shared.cookies?.reduce(into: [:]) { dict, cookie in
                dict[cookie.name] = cookie.value
            } ?? [:]
        
//        debugPrint(cookies)

        headers["Referer"] = referer
        headers["User-Agent"] = defaultUserAgent
        headers["X-Csrf-Token"] = rsi_csrf_token
        headers["cookie"] = cookieString
        headers["x-rsi-token"] = rsi_token
        headers["x-rsi-device"] = rsi_device
        
        

        return headers
    }
    
    func getDefaultDevice() -> String {
        return getDeviceId()
    }


    func setToken(token: String) {
        rsi_token = token
    }

    func setDevice(device: String) {
        rsi_device = device
    }
    
    func setCsrfToken() async {
        let token = await getCsrfToken()
        if token == nil {
            return
        }
        rsi_csrf_token = token!
    }
    
    func getCsrfToken() async -> String? {
        let page = try? await getPage(endPoint: "")
        if page == nil {
            return nil
        }
        let xsrf_token = getXsrfTokenByPage(page: page!)
        self.marker = generateRandomString(length: 22)
        if xsrf_token != nil {
            xsrf = "\(xsrf_token!):\(self.marker):\(String(getCurrentMillisecondTimestamp() + 1800 * 1000))"
        }
        return getCsrfTokenByPage(page: page!)
    }
    
    
    func getAuthToken() async throws -> String? {
        try await withUnsafeThrowingContinuation{ continuation in
            AF.request(serverAdress + "api/account/v2/setAuthToken", 
                       method: .post,
                       parameters: [:],
                       headers: RsiApi.getHeaders()
            ).response { response in
                switch response.result {
                case .success(let value):
                    let headerFields = response.response?.allHeaderFields as? [String: String]
                    if headerFields == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let setCookieHeader = headerFields!["Set-Cookie"]
                    if setCookieHeader == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let token = setCookieHeader?.components(separatedBy: ";")[0].components(separatedBy: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    self.rsi_account_auth = token
                    continuation.resume(returning: token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getUpgradeContextToken() async throws -> String? {
        try await withUnsafeThrowingContinuation{ continuation in
            AF.request(serverAdress + "api/ship-upgrades/setContextToken",
                       method: .post,
                       parameters: [:],
                       headers: RsiApi.getHeaders()
            ).response { response in
                switch response.result {
                case .success(let value):
                    let headerFields = response.response?.allHeaderFields as? [String: String]
                    if headerFields == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let setCookieHeader = headerFields!["Set-Cookie"]
                    if setCookieHeader == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let token = setCookieHeader?.components(separatedBy: ";")[0].components(separatedBy: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    self.rsi_ship_upgrades_context = token
                    continuation.resume(returning: token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func getDefaultRsiToken() async throws -> String? {
        try await withUnsafeThrowingContinuation{ continuation in
            AF.request(serverAdress + "grphql", method: .get, headers: RsiApi.getHeaders()).response { response in
                switch response.result {
                case .success(let value):
                    let headerFields = response.response?.allHeaderFields as? [String: String]
                    if headerFields == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let setCookieHeader = headerFields!["Set-Cookie"]
                    if setCookieHeader == nil {
                        continuation.resume(returning: "")
                        return
                    }
                    let token = setCookieHeader?.components(separatedBy: ";")[0].components(separatedBy: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    continuation.resume(returning: token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func basicPostRequest<Input: Encodable, Output: Decodable>(endPoint: String, postBody: Input) async throws -> Output {
        try await withCheckedThrowingContinuation{ continuation in
            AF.request(serverAdress + endPoint,
                       method: .post,
                       parameters: postBody,
                       encoder: JSONParameterEncoder.default,
                       headers: self.getHeaders()
            )
            .responseDecodable(of: Output.self) { response in
                switch response.result {
                case .success(let value):
                    debugPrint("Post \(endPoint), headers \(self.getHeaders()), response \(value)")
                    continuation.resume(returning: value)
                case .failure(let error):
                    debugPrint("Request Error: \(error)")
                    debugPrint(response.data)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func basicPostRequestForString<Input: Encodable>(endPoint: String, postBody: Input) async throws -> String {
        try await withCheckedThrowingContinuation{ continuation in
            AF.request(serverAdress + endPoint,
                       method: .post,
                       parameters: postBody,
                       encoder: JSONParameterEncoder.default,
                       headers: self.getHeaders()
            )
            .responseString { response in
                switch response.result {
                case .success(let value):
                    debugPrint("Post \(endPoint), headers \(self.getHeaders()), response \(value)")
                    continuation.resume(returning: value)
                case .failure(let error):
                    debugPrint("Request Error: \(error)")
                    debugPrint(response.data)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func login(loginBody: LoginBody) async throws -> LoginProperty? {
        let graphQlReq: GraphQLRequest<LoginBody, LoginProperty> = GraphQLRequest<LoginBody, LoginProperty>(url: self.serverAdress + "graphql", query: LoginQuery, variables: loginBody)
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func multiStepLogin(multiStepLoginBody: MultiStepLoginBody) async -> MultiStepLoginProperty? {
        
        debugPrint("Multi Header \(self.getHeaders())")
        
        let graphQlReq = GraphQLRequest<MultiStepLoginBody, MultiStepLoginProperty>(url: self.serverAdress + "graphql", query: MultiStepLoginQuery, variables: multiStepLoginBody)
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }


    init() {
        super.init(serverAdress: "https://robertsspaceindustries.com/")
    }
    
    override func getRequest(endPoint: String) -> DataRequest {
        var request = URLRequest(url: URL(string: serverAdress + endPoint)!)
        request.method = .get
        request.headers = getHeaders()
        return AF.request(request)
    }

    func getPage(endPoint: String) async throws -> String {
//        do {
            try await withUnsafeThrowingContinuation{ continuation in
                getRequest(endPoint: endPoint).responseString { response in
                    switch response.result {
                    case .success(let value):
                        debugPrint("getpage \(endPoint), headers \(self.getHeaders())")
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
//        }
//        catch {
//            print(error)
//        }
    }
    
    func initShipUpgrade() async -> InitUpgradeProperty? {
        let graphQlReq = GraphQLRequest<InitShipUpgradePostBody, InitUpgradeProperty>(url: self.serverAdress + "pledge-store/api/upgrade/graphql", query: initShipUpgradeQuery, variables: InitShipUpgradePostBody())
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func getUpgradeFromShip(toShipId: Int?) async -> FilterShipUpgradeProperty? {
        let graphQlReq = GraphQLRequest<SearchFromShipPostBody, FilterShipUpgradeProperty>(url: self.serverAdress + "pledge-store/api/upgrade/graphql", query: filterShipQuery, variables: SearchFromShipPostBody(fromFilters: [], toFilters: [], toId: toShipId))
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func applyCartToken(jwt: String) async -> ApplyCartTokenProperty? {
        let result: ApplyCartTokenProperty? = try? await self.basicPostRequest(endPoint: "api/store/v2/cart/token", postBody: ApplyCartTokenPostBody(jwt: jwt))
        return result
    }
    
    func addUpgradeToCart(fromSkuId: Int, toSkuId: Int) async -> AddUpgradeToCartProperty? {
        let postBody = UpgradeAddToCartPostBody(from: fromSkuId, to: toSkuId)
        let graphQlReq = GraphQLRequest<UpgradeAddToCartPostBody, AddUpgradeToCartProperty>(url: self.serverAdress + "pledge-store/api/upgrade/graphql", query: UpgradeAddToCartQuery, variables: postBody)
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func getCartSummary() async -> CartSummaryProperty? {
        let graphQlReq = GraphQLRequest<CartSummaryViewMutationPostBody, CartSummaryProperty>(url: self.serverAdress + "graphql", query: CartSummaryViewMutationQuery, variables: CartSummaryViewMutationPostBody())
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func addCredit(amount: Float) async -> AddCreditProperty? {
        let graphQlReq = GraphQLRequest<AddCreditPostBody, AddCreditProperty>(url: self.serverAdress + "graphql", query: AddCreditQuery, variables: AddCreditPostBody(amount: amount))
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func clearCart() async -> ClearCartProperty? {
        let graphQlReq = GraphQLRequest<ClearCartPostBody, ClearCartProperty>(url: self.serverAdress + "graphql", query: ClearCartQuery, variables: ClearCartPostBody())
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func nextStep() async -> BasicCartProperty? {
        let graphQlReq = GraphQLRequest<NextStepPostBody, BasicCartProperty>(url: self.serverAdress + "graphql", query: NextStepQuery, variables: NextStepPostBody())
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func cartValidate() async -> BasicCartProperty? {
        let graphQlReq = GraphQLRequest<CartValidationMutationPostBody, BasicCartProperty>(url: self.serverAdress + "graphql", query: CartValidationMutationQuery, variables: CartValidationMutationPostBody(token: await RecaptchaV3().getRecaptchaToken(), mark: self.marker))
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func cartAddressQuery() async -> CartAddressProperty? {
        let graphQlReq = GraphQLRequest<AddressBookPostBody, CartAddressProperty>(url: self.serverAdress + "graphql", query: AdressBookQuery, variables: AddressBookPostBody())
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
    
    func cartAddressAssign(billing: String) async -> BasicCartProperty? {
        let graphQlReq = GraphQLRequest<CartAddressAssignMutationPostBody, BasicCartProperty>(url: self.serverAdress + "graphql", query: CartAddressAssignMutationQuery, variables: CartAddressAssignMutationPostBody(billing: billing))
        return try? await performGraphQLRequestAsync(request: graphQlReq)
    }
}
