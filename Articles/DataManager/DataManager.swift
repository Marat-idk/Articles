//
//  DataManager.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import Foundation

/// тут была бы работа с сетью с помощью URLSession или Alamofire
/// но json локальный поэтому так


enum DataManagerError: Error {
    case invalidURL
    case invalidData
    case canNotProcessData
}

enum DataSources: String {
    case articles = "jsonviewer"
    case noImage = "https://www.aepint.nl/wp-content/uploads/2014/12/No_image_available.jpg"
}

class DataManager {
    private init() {}
    
    static let shared = DataManager()
    
    // запрос за данными (статьями)
    // MARK: работаю так
    public func getArticles(complition: @escaping (Result<Articles, DataManagerError>) -> Void ) {
        guard let url = Bundle.main.url(forResource: DataSources.articles.rawValue, withExtension: "json") else {
            complition(.failure(.invalidURL))
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            complition(.failure(.invalidData))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let articles = try decoder.decode(Articles.self, from: data)
            complition(.success(articles))
        } catch {
            complition(.failure(.canNotProcessData))
        }
    }
}
