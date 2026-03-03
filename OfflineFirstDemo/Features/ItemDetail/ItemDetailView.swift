//
//  ItemDetailView.swift
//  OfflineFirstDemo
//
//  Created by IA on 02/03/26.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject var viewModel: ItemDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text(viewModel.item.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                Text("Status:")
                    .fontWeight(.semibold)
                Text(viewModel.item.status)
            }
            
            Text("Detail")
                .font(.headline)
            
            Text(viewModel.item.detail)
                .font(.body)
            
            Divider()
            
            Text("Last Updated:")
                .font(.headline)
            
            Text(viewModel.item.updatedAt.formatted())
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Item Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
