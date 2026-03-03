//
//  Item.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

struct Item: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let status: String
    let detail: String
    let updatedAt: Date
}
