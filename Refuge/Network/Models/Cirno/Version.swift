//
//  Version.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation

struct Version: Identifiable, Codable {
    public var id: Int
    public var version: String
    public var url: String
}

struct Translation: Identifiable, Codable {
    public var id: Int
    public var english_title: String
    public var title: String
}
