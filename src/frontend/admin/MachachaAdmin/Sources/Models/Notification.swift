//
//  Notification.swift
//  MachachaAdmin
//
//  Created by Park Jungwoo on 2023/02/14.
//

import Foundation

// MARK: - Notification
struct Notification: Codable {
    let multicastID: Double
    let success, failure, canonicalIDS: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case multicastID = "multicast_id"
        case success, failure
        case canonicalIDS = "canonical_ids"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let messageID: String

    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
    }
}
