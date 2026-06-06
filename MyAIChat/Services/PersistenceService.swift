//
//  PersistenceService.swift
//  MyAIChat
//
//  Abstraction over local persistence of conversations. Placeholder only.
//

import Foundation

/// Defines the contract for loading and saving conversations locally.
/// TODO: Implement using FileManager / Core Data / SwiftData as appropriate.
protocol PersistenceService {
    /// Loads all persisted conversations.
    func loadConversations() throws -> [Conversation]

    /// Persists the given conversations.
    func saveConversations(_ conversations: [Conversation]) throws
}

/// Placeholder persistence service that stores nothing yet.
/// TODO: Replace with a real implementation.
final class InMemoryPersistenceService: PersistenceService {
    func loadConversations() throws -> [Conversation] {
        // TODO: Implement.
        []
    }

    func saveConversations(_ conversations: [Conversation]) throws {
        // TODO: Implement.
    }
}
