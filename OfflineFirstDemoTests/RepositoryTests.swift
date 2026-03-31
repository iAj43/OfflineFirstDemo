//
//  RepositoryTests.swift
//  OfflineFirstDemo
//
//  Created by IA on 03/03/26.
//

import XCTest
@testable import OfflineFirstDemo

final class RepositoryTests: XCTestCase {
    
    private func makeItem(
        id: String,
        title: String = "Test",
        updatedAt: Date = Date()
    ) -> Item {
        Item(
            id: id,
            title: title,
            status: "new",
            detail: "detail",
            updatedAt: updatedAt
        )
    }
    
    func test_fetchInitial_success_savesAndReturnsItems() async {
        let items = [makeItem(id: "1"), makeItem(id: "2")]
        let api = MockSuccessAPIClient(items: items)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        let result = await repository.fetchInitial()
        
        XCTAssertEqual(result.items.count, 2)
        XCTAssertFalse(result.isOffline)
        XCTAssertNil(result.error)
    }
    
    func test_fetchInitial_failure_returnsCachedItemsOffline() async {
        let cachedItems = [makeItem(id: "cached1")]
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        try? cache.save(cachedItems)
        
        let api = MockFailingAPIClient()
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        let result = await repository.fetchInitial()
        
        XCTAssertEqual(result.items.count, 1)
        XCTAssertTrue(result.isOffline)
        XCTAssertNil(result.error)
    }
    
    func test_fetchInitial_failure_returnsError_whenNoCache() async {
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        
        let api = MockFailingAPIClient()
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        let result = await repository.fetchInitial()
        
        XCTAssertTrue(result.items.isEmpty)
        XCTAssertFalse(result.isOffline)
        XCTAssertNotNil(result.error)
    }
    
    func test_merge_updatesItem_whenUpdatedAtIsNewer() async {
        
        let oldDate = Date(timeIntervalSince1970: 1000)
        let newDate = Date(timeIntervalSince1970: 2000)
        
        let oldItem = makeItem(id: "1", title: "Old", updatedAt: oldDate)
        let newItem = makeItem(id: "1", title: "New", updatedAt: newDate)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        
        let api = MockSuccessAPIClient(items: [oldItem])
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        _ = await repository.fetchInitial()
        
        let updatedAPI = MockSuccessAPIClient(items: [newItem])
        let updatedRepo = ItemRepository(apiClient: updatedAPI, cacheService: cache)
        
        let result = await updatedRepo.fetchInitial()
        
        XCTAssertEqual(result.items.first?.title, "New")
    }
}
