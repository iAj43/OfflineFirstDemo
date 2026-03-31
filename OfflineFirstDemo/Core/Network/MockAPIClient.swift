//
//  MockAPIClient.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

final class MockAPIClient: APIClientProtocol {
    
    private static var counter = 0
    
    func fetchItems() async throws -> [Item] {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        let isConnected = await NetworkMonitor.shared.isConnected

        if !isConnected {
            throw NetworkError.noData
        }
        
        guard let url = Bundle.main.url(
            forResource: "items",
            withExtension: "json"
        ) else {
            throw NetworkError.invalidURL
        }
        
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var items = try decoder.decode([Item].self, from: data)
        
        // Simulate live updates
        Self.counter += 1
        
        if Self.counter % 2 == 0, !items.isEmpty {
            items[0] = Item(
                id: items[0].id,
                title: "Updated \(Self.counter)",
                status: "in_progress",
                detail: items[0].detail,
                updatedAt: Date()
            )
        }
        
        return items
    }
}
