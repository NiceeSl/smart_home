//
//  Ward.swift
//  prjct
//
//  Created by work on 30.11.2022.
//

import Foundation

struct CameraResponse: Codable {
    var data: Data
    var success: Bool
}

struct Data: Codable {
    var cameras: [Item]
    var room: [String]
}

struct Room: Codable {
}

struct Item: Codable {
    var name: String?
    var snapshot: String?
    var room: String?
    var id: Int = 0
    var favorites: Bool = false
    var rec: Bool? = false
    var lock: Bool? = true
    var hideCell: Bool? = false

}
