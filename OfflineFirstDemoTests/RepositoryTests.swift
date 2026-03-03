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
        // given
        let items = [makeItem(id: "1"), makeItem(id: "2")]
        let api = MockSuccessAPIClient(items: items)
        let cache = FileCacheService()
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        // when
        let result = await repository.fetchInitial()
        
        // then
        XCTAssertEqual(result.items.count, 2)
        XCTAssertFalse(result.isOffline)
    }
    
    func test_fetchInitial_failure_returnsCachedItemsOffline() async {
        // given
        let cachedItems = [makeItem(id: "cached1")]
        let cache = FileCacheService()
        try? cache.save(cachedItems)
        
        let api = MockFailingAPIClient()
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        // when
        let result = await repository.fetchInitial()
        
        // then
        XCTAssertEqual(result.items.count, 1)
        XCTAssertTrue(result.isOffline)
    }
    
    func test_merge_updatesItem_whenUpdatedAtIsNewer() async {
        // given
        let oldDate = Date(timeIntervalSince1970: 1000)
        let newDate = Date(timeIntervalSince1970: 2000)
        
        let oldItem = makeItem(id: "1", title: "Old", updatedAt: oldDate)
        let newItem = makeItem(id: "1", title: "New", updatedAt: newDate)
        
        let api = MockSuccessAPIClient(items: [oldItem])
        let cache = FileCacheService()
        let repository = ItemRepository(apiClient: api, cacheService: cache)
        
        _ = await repository.fetchInitial()
        
        // update with newer data
        let updatedAPI = MockSuccessAPIClient(items: [newItem])
        let updatedRepository = ItemRepository(apiClient: updatedAPI, cacheService: cache)
        
        let result = await updatedRepository.fetchInitial()
        
        // then
        XCTAssertEqual(result.items.first?.title, "New")
    }
}
