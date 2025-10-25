//
//  LinksView.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import SwiftUI

struct LinksView: View {
    @StateObject var viewModel: LinksViewModel
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.links) { link in
                    Link(destination: link.url) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(link.title).font(.headline)
                            Text(link.url.absoluteString).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: viewModel.remove)
            }
            .navigationTitle("Links")
            .toolbar {
                NavigationLink("Neu") { LinkEditView(onSave: viewModel.addLink) }
            }
        }
    }
}
