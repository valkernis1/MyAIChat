//
//  ConversationListViewModel.swift
//  MyAIChat
//
//  View model driving the conversation list / sidebar (MVVM).
//

import Foundation
import Combine

/// Observable state and intent for the list of conversations.
///
/// Holds the in-memory list and the current selection. Persistence is left to
/// a future `PersistenceService` integration. Contains no UI code.
@MainActor
final class ConversationListViewModel: ObservableObject {

    /// All conversations, newest first.
    @Published private(set) var conversations: [Conversation]

    /// The id of the currently selected conversation, if any.
    @Published var selectedConversationID: Conversation.ID?

    init(conversations: [Conversation] = []) {
        self.conversations = conversations
        self.selectedConversationID = conversations.first?.id
    }

    // MARK: Derived state

    /// The currently selected conversation, if any.
    var selectedConversation: Conversation? {
        guard let id = selectedConversationID else { return nil }
        return conversations.first { $0.id == id }
    }

    /// `true` when there are no conversations.
    var isEmpty: Bool { conversations.isEmpty }

    // MARK: Intents

    /// Creates a new conversation, inserts it at the top, and selects it.
    @discardableResult
    func createConversation() -> Conversation {
        let conversation = Conversation()
        conversations.insert(conversation, at: 0)
        selectedConversationID = conversation.id
        return conversation
    }

    /// Selects the given conversation.
    func select(_ conversation: Conversation) {
        selectedConversationID = conversation.id
    }

    /// Deletes the conversations at the given offsets (e.g. from `onDelete`).
    func deleteConversations(at offsets: IndexSet) {
        let removedIDs = Set(offsets.map { conversations[$0].id })

        // Remove in descending order so indices remain valid.
        for index in offsets.sorted(by: >) {
            conversations.remove(at: index)
        }

        if let selected = selectedConversationID, removedIDs.contains(selected) {
            selectedConversationID = conversations.first?.id
        }
    }
}
