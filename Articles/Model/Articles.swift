//
//  Articles.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

// To parse the JSON, add this file to your project and do:
//   let articles = try? JSONDecoder().decode(Articles.self, from: jsonData)

import Foundation

// MARK: - Articles
struct Articles: Codable {
    let sections: [Section]?
}

// MARK: - Section
struct Section: Codable {
    let id, header: String?
    let itemsTotal, itemsToShow: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let id: String?
    let image: Image?
    let title: String?
}

// MARK: - Image
struct Image: Codable {
    let the1X, the2X, the3X: String?
    let aspectRatio: Int?
    let loopAnimation: Bool?

    enum CodingKeys: String, CodingKey {
        case the1X = "1x"
        case the2X = "2x"
        case the3X = "3x"
        case aspectRatio, loopAnimation
    }
}

