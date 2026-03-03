//
//  ItemDetailViewModel.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import Foundation

@MainActor
final class ItemDetailViewModel: ObservableObject {
    
    @Published var item: Item
    
    init(item: Item) {
        self.item = item
    }
}
