//
//  NetworkError.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError: return "Failed to decode data"
        case .noData: return "No data available"
        }
    }
}
