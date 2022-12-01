//
//  Ward.swift
//  prjct
//
//  Created by work on 30.11.2022.
//

import Foundation

struct CameraResponse: Codable {                     // For segment "Cameras"
    var data: Data?
    var success: Bool
}

struct Data: Codable {
    var cameras: [Camera?]
    var room: [Room?]
    }

struct Room: Codable {
}

struct Camera: Codable {
    var name: String?
    var snapshot: String?
    var room: String?
    var id: Int?
    var favorites: Bool?
    var rec: Bool?
}
