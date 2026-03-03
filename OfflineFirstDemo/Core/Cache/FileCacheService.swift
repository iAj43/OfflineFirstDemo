//
//  FileCacheService.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

final class FileCacheService {
    
    private let fileURL: URL
    
    init(fileURL: URL? = nil) {
        if let fileURL = fileURL {
            self.fileURL = fileURL
        } else {
            self.fileURL = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("cached_items.json")
        }
    }
    
    func save(_ items: [Item]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func load() throws -> [Item] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([Item].self, from: data)
    }
}
