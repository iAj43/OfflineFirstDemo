//
//  OfflineFirstDemoApp.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import SwiftUI

@main
struct OfflineFirstDemoApp: App {
    
    private let repository = ItemRepository(
        apiClient: MockAPIClient(),
        cacheService: FileCacheService()
    )

    var body: some Scene {
        WindowGroup {
            ItemListView(
                viewModel: ItemListViewModel(repository: repository)
            )
        }
    }
}
