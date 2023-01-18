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
struct Section: Codable, Hashable {
    let id, header: String?
    let itemsTotal, itemsToShow: Int?
    let items: [Article]?
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Article
struct Article: Codable, Hashable {
    let id: String?
    let image: Image?
    let title: String?
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
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

extension Article {
    static let defaultArticle = Article(
                                id: "12345",
                                image: Image(
                                        the1X: DataSources.noImage.rawValue,
                                        the2X: DataSources.noImage.rawValue,
                                        the3X: DataSources.noImage.rawValue,
                                        aspectRatio: 1,
                                        loopAnimation: false),
                                title: "Untitled")
}
