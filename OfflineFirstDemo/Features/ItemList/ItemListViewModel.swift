//
//  ItemListViewModel.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

@MainActor
final class ItemListViewModel: ObservableObject {
    
    @Published private(set) var state: ViewState<[Item]> = .loading
    
    private let repository: ItemRepository
    private var pollingTask: Task<Void, Never>?
    
    init(repository: ItemRepository) {
        self.repository = repository
        loadInitialData()
        startPolling()
    }
    
    func loadInitialData() {
        state = .loading
        
        Task {
            let result = await repository.fetchInitial()
            updateState(items: result.items, isOffline: result.isOffline)
        }
    }
    
    func refresh() async {
        let result = await repository.refresh()
        updateState(items: result.items, isOffline: result.isOffline)
    }
    
    private func updateState(items: [Item], isOffline: Bool) {
        if items.isEmpty {
            state = .empty
        } else if isOffline {
            state = .offline(items)
        } else {
            state = .success(items)
        }
    }
    
    private func startPolling() {
        pollingTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 sec
                let updatedItems = await repository.pollUpdates()
                
                if !updatedItems.isEmpty {
                    state = .success(updatedItems)
                }
            }
        }
    }
    
    deinit {
        pollingTask?.cancel()
    }
}
