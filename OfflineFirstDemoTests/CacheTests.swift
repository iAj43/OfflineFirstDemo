//
//  CacheTests.swift
//  OfflineFirstDemo
//
//  Created by IA on 03/03/26.
//

import XCTest
@testable import OfflineFirstDemo

final class CacheTests: XCTestCase {
    
    private func makeItem(id: String) -> Item {
        Item(
            id: id,
            title: "Cache Item",
            status: "new",
            detail: "detail",
            updatedAt: Date()
        )
    }
    
    private func makeTempURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
    }
    
    func test_saveAndLoad_cachePersistsItems() throws {
        let tempURL = makeTempURL()
        let cache = FileCacheService(fileURL: tempURL)
        
        let items = [makeItem(id: "1"), makeItem(id: "2")]
        
        try cache.save(items)
        let loaded = try cache.load()
        
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded.first?.id, "1")
    }
    
    func test_load_returnsEmpty_whenNoCacheExists() throws {
        let tempURL = makeTempURL()
        let cache = FileCacheService(fileURL: tempURL)
        
        let loaded = try cache.load()
        
        XCTAssertTrue(loaded.isEmpty)
    }
}
