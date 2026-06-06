//
//  ConversationListView.swift
//  MyAIChat
//
//  Sidebar / list of conversations. Placeholder only.
//

import SwiftUI

/// Displays the list of conversations and allows creating/selecting one.
/// TODO: Implement list rows, swipe-to-delete, and navigation to `ChatView`.
struct ConversationListView: View {
    @StateObject private var viewModel = ConversationListViewModel()

    var body: some View {
        // TODO: Replace with a List bound to `viewModel.conversations`.
        List {
            Text("Conversations")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Chats")
    }
}

#Preview {
    ConversationListView()
}
