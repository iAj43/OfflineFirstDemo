//
//  ViewState.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

enum ViewState<T> {
    case loading
    case success(T)
    case empty
    case error(String)
    case offline(T)
}
