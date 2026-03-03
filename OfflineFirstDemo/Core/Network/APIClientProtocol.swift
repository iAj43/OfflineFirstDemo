//
//  APIClientProtocol.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

protocol APIClientProtocol {
    func fetchItems() async throws -> [Item]
}
