//
//  ItemListView.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import SwiftUI

struct ItemListView: View {
    
    @StateObject var viewModel: ItemListViewModel
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("OfflineFirstDemo")
                .toolbar {
                    Button("Refresh") {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading Items...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            VStack {
                Image(systemName: "tray")
                    .font(.largeTitle)
                Text("No items available")
                    .foregroundColor(.gray)
            }
            
        case .error(let message):
            VStack(spacing: 12) {
                Text(message)
                    .foregroundColor(.red)
                Button("Retry") {
                    Task {
                        await viewModel.refresh()
                    }
                }
            }
            
        case .offline(let items):
            listView(items: items, isOffline: true)
            
        case .success(let items):
            listView(items: items, isOffline: false)
        }
    }
    
    private func listView(items: [Item], isOffline: Bool) -> some View {
        List(items) { item in
            NavigationLink {
                ItemDetailView(
                    viewModel: ItemDetailViewModel(item: item)
                )
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    
                    Text("Status: \(item.status)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Updated: \(item.updatedAt.formatted())")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .overlay(alignment: .top) {
            if isOffline {
                Text("Offline Mode - Showing Cached Data")
                    .font(.caption)
                    .padding(8)
                    .background(Color.orange.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.top, 8)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}
