//
//  MockFailingAPIClient.swift
//  OfflineFirstDemo
//
//  Created by IA on 03/03/26.
//

import Foundation
@testable import OfflineFirstDemo

final class MockFailingAPIClient: APIClientProtocol {
    
    func fetchItems() async throws -> [Item] {
        throw NetworkError.noData
    }
}
