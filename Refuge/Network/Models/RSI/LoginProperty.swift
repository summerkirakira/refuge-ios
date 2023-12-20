//
//  LoginProperty.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation


struct LoginProperty: Decodable {
    var errors: [Error]?
    var data: Data?

    struct Data: Decodable {
        var account_signin: Login?

        struct Login: Decodable {
            var displayname: String
            var id: Int
        }
    }

    struct Error: Decodable {
        var message: String
        var extensions: Extensions
        var code: String

        struct Extensions: Decodable {
            var details: Details

            struct Details: Decodable {
                var session_id: String?
                var device_id: String?
            }
        }
    }
}

struct LoginBody: Encodable {
    let captcha: String
    let email: String
    let password: String
    let remember: Bool = true
}


let LoginQuery = """
mutation signin($email: String!, $password: String!, $captcha: String, $remember: Boolean) {
account_signin(email: $email, password: $password, captcha: $captcha, remember: $remember) {
  displayname
  id
  __typename
}
}
"""

let MultiStepLoginQuery = """
mutation multistep($code: String!, $deviceType: String!, $deviceName: String!, $duration: String!) {
  account_multistep(code: $code, device_type: $deviceType, device_name: $deviceName, duration: $duration) {
    displayname
    id
    __typename
  }
}
"""

struct MultiStepLoginBody: Encodable {
    let code: String
    let deviceName: String = "StarRefuge"
    let deviceType: String = "computer"
    let duration: String = "year"
}

struct MultiStepLoginProperty: Decodable {
    var errors: [Error]?
    var data: Data

    struct Data: Decodable {
        var account_multistep: Login?

        struct Login: Decodable {
            var displayname: String
            var id: Int
        }
    }

    struct Error: Decodable {
        var message: String
        var code: String
    }
}
