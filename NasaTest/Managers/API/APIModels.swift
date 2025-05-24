//
//  APIModels.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

public struct SpaceResponse: Codable {
    let links: Links?
    let rocket: String?
    let details: String?
    let name: String?
    let dateUnix: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case links
        case rocket
        case details
        case name
        case dateUnix = "date_unix"
        case id
    }
}

// MARK: - Links
public struct Links: Codable {
    let patch: Patch?
    let flickr: Flickr?
    let youtubeID: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, flickr
        case youtubeID = "youtube_id"
        case wikipedia
    }
}

// MARK: - Flickr
public struct Flickr: Codable {
    let small, original: [String]?
}

// MARK: - Patch
public struct Patch: Codable {
    let small, large: String?
}

import Foundation

// MARK: - SpaceResponse
struct RocketResponse: Codable {
    let payloadWeights: [PayloadWeight]?
    let name: String?
    let wikipedia: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case payloadWeights = "payload_weights"
        case name
        case id, wikipedia
    }
}

// MARK: - PayloadWeight
struct PayloadWeight: Codable {
    let id, name: String?
    let kg, lb: Int?
}

extension LaunchEntity {
    func toModel() -> SpaceResponse {
        let decoder = JSONDecoder()
        if let linksData = self.links as? Data {
            let links = try? decoder.decode(Links.self, from: linksData)
            return SpaceResponse(links: links, rocket: self.rocket, details: self.details, name: self.name, dateUnix: Int(self.date), id: self.id)
        } else {
            return SpaceResponse(links: nil, rocket: self.rocket, details: self.details, name: self.name, dateUnix: Int(self.date), id: self.id)
        }
    }
}
