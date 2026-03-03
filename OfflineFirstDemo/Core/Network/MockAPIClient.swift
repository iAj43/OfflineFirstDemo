//
//  MockAPIClient.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

final class MockAPIClient: APIClientProtocol {
    
    func fetchItems() async throws -> [Item] {
        try await Task.sleep(nanoseconds: 800_000_000) // simulate delay
        
        guard let url = Bundle.main.url(forResource: "items", withExtension: "json") else {
            throw NetworkError.invalidURL
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([Item].self, from: data)
    }
}
