//
//  UnsplashTopic.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:

import Foundation

// MARK: - UnsplashTopic
struct UnsplashTopic: Codable, Identifiable {
    let id, slug, title, description: String
    let coverPhoto: CoverPhoto

    enum CodingKeys: String, CodingKey {
        case id, slug, title, description
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhoto: Codable {
    let id, slug: String
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id, slug, urls
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}
