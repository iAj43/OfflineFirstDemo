//
//  ItemRepository.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

actor ItemRepository {
    
    private let apiClient: APIClientProtocol
    private let cacheService: FileCacheService
    private var items: [Item] = []
    
    init(apiClient: APIClientProtocol,
         cacheService: FileCacheService) {
        self.apiClient = apiClient
        self.cacheService = cacheService
    }
    
    func fetchInitial() async -> (items: [Item], isOffline: Bool) {
        do {
            let remote = try await apiClient.fetchItems()
            let merged = merge(new: remote, existing: items)
            items = merged
            try? cacheService.save(merged)
            return (merged, false)
        } catch {
            let cached = (try? cacheService.load()) ?? []
            items = cached
            return (cached, true)
        }
    }
    
    func refresh() async -> (items: [Item], isOffline: Bool) {
        await fetchInitial()
    }
    
    func pollUpdates() async -> [Item] {
        do {
            let remote = try await apiClient.fetchItems()
            let merged = merge(new: remote, existing: items)
            items = merged
            try? cacheService.save(merged)
            return merged
        } catch {
            return items
        }
    }
    
    private func merge(new: [Item], existing: [Item]) -> [Item] {
        var dict = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
        
        for item in new {
            if let old = dict[item.id] {
                if item.updatedAt > old.updatedAt {
                    dict[item.id] = item
                }
            } else {
                dict[item.id] = item
            }
        }
        
        return Array(dict.values).sorted { $0.updatedAt > $1.updatedAt }
    }
}
