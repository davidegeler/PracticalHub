//
//  LinkEditView.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import SwiftUI

struct LinkEditView: View {
    var onSave: (QuickLink) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var urlString = ""

    var body: some View {
        Form {
            TextField("Titel", text: $title)
            TextField("URL", text: $urlString).textInputAutocapitalization(.never)
        }
        .navigationTitle("Link hinzufügen")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Speichern") {
                    if let url = URL(string: urlString), !title.isEmpty {
                        onSave(.init(title: title, url: url))
                        dismiss()
                    }
                }
            }
        }
    }
}
