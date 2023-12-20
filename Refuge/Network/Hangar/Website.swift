//
//  Website.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation


func getCsrfTokenByPage(page: String) -> String? {
    if page.components(separatedBy: "csrf-token\" content=\"").count == 0 {
        return nil
    }
    let csrf_token = page.components(separatedBy: "csrf-token\" content=\"")[1].components(separatedBy: "\"")[0]
    return csrf_token
}
