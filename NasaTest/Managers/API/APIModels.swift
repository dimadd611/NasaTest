//
//  APIModels.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation

struct SpaceResponse: Codable {
    let links: Links?
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool?
    let window: Int?
    let rocket: String?
    let success: Bool?
    let details: String?
    let payloads: [String]?
    let launchpad: String?
    let flightNumber: Int?
    let name, dateUTC: String?
    let dateUnix: Int?
    let dateLocal: Date?
    let datePrecision: String?
    let upcoming: Bool?
    let cores: [Core]?
    let autoUpdate, tbd: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case links
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
        case net, window, rocket, success, details, payloads, launchpad
        case flightNumber = "flight_number"
        case name
        case dateUTC = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming, cores
        case autoUpdate = "auto_update"
        case tbd
        case id
    }
}

struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused, landingAttempt: Bool?

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
    }
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch?
    let flickr: Flickr?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, flickr, webcast
        case youtubeID = "youtube_id"
        case article, wikipedia
    }
}

// MARK: - Flickr
struct Flickr: Codable {
    let small, original: [String]?
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String?
}
