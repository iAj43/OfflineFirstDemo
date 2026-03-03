//
//  MockSuccessAPIClient.swift
//  OfflineFirstDemo
//
//  Created by IA on 03/03/26.
//

import Foundation
@testable import OfflineFirstDemo

final class MockSuccessAPIClient: APIClientProtocol {
    
    var itemsToReturn: [Item]
    
    init(items: [Item]) {
        self.itemsToReturn = items
    }
    
    func fetchItems() async throws -> [Item] {
        return itemsToReturn
    }
}
