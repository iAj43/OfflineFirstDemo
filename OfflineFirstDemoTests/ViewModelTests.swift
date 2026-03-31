//
//  ViewModelTests.swift
//  OfflineFirstDemo
//
//  Created by IA on 03/03/26.
//

import XCTest
@testable import OfflineFirstDemo

@MainActor
final class ViewModelTests: XCTestCase {
    
    private func makeItem(id: String) -> Item {
        Item(
            id: id,
            title: "VM Item",
            status: "new",
            detail: "detail",
            updatedAt: Date()
        )
    }
    
    func test_viewModel_loadingToSuccessState() async {
        // given
        let items = [makeItem(id: "1")]
        let api = MockSuccessAPIClient(items: items)
        let repo = ItemRepository(apiClient: api, cacheService: FileCacheService())
        
        // when
        let viewModel = ItemListViewModel(repository: repo)
        
        // allow async task to complete
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // then
        if case .success(let loadedItems) = viewModel.state {
            XCTAssertEqual(loadedItems.count, 1)
        } else {
            XCTFail("Expected success state")
        }
    }
    
    func test_viewModel_emptyState_whenNoItems() async {
        // given
        let api = MockSuccessAPIClient(items: [])
        let repo = ItemRepository(apiClient: api, cacheService: FileCacheService())
        
        // when
        let viewModel = ItemListViewModel(repository: repo)
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // then
        if case .empty = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected empty state")
        }
    }
    
    func test_viewModel_offlineState_whenNetworkFails_butCacheExists() async {
        // given cached data
        let cachedItem = makeItem(id: "cached1")
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        try? cache.save([cachedItem])
        
        let api = MockFailingAPIClient()
        let repo = ItemRepository(apiClient: api, cacheService: cache)
        
        // when
        let viewModel = ItemListViewModel(repository: repo)
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // then
        if case .offline(let items) = viewModel.state {
            XCTAssertEqual(items.count, 1)
        } else {
            XCTFail("Expected offline state")
        }
    }
    
    func test_viewModel_errorState_whenNetworkFails_andNoCache() async {
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let cache = FileCacheService(fileURL: tempURL)
        
        let api = MockFailingAPIClient()
        let repo = ItemRepository(apiClient: api, cacheService: cache)
        
        let viewModel = ItemListViewModel(repository: repo)
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        if case .error = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected error state")
        }
    }
}
