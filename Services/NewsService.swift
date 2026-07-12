//
//  NewsService.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 13.07.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class NewsService {
    private let apiKey = "881cfdd29a944ca6951da6fcf4b2a395"
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    func fetchTopHeadlines(country: String = "us") async throws -> [Article] {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
            return decoded.articles
        } catch {
            throw NetworkError.decodingError
        }
    }
}
