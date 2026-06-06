//
//  ChatViewModel.swift
//  MyAIChat
//
//  View model driving a single chat screen (MVVM).
//

import Foundation
import Combine

/// Observable state and intent for the chat screen.
///
/// Owns a `Conversation`, exposes the user's `draft` input, and talks to an
/// injected `AIService` to produce assistant replies. Contains no UI code.
@MainActor
final class ChatViewModel: ObservableObject {

    /// The conversation being displayed/edited.
    @Published var conversation: Conversation

    /// The text currently being composed by the user.
    @Published var draft: String = ""

    /// `true` while an assistant reply is being generated.
    @Published private(set) var isSending: Bool = false

    /// A user-facing error message, if the last send failed.
    @Published var errorMessage: String?

    /// Backend used to generate replies (mock by default).
    private let aiService: AIService

    init(conversation: Conversation = Conversation(),
         aiService: AIService = MockAIService()) {
        self.conversation = conversation
        self.aiService = aiService
    }

    // MARK: Derived state

    /// Convenience accessor for the conversation's messages.
    var messages: [ChatMessage] { conversation.messages }

    /// `true` when the current draft can be sent.
    var canSend: Bool {
        !isSending && !trimmedDraft.isEmpty
    }

    private var trimmedDraft: String {
        draft.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: Intents

    /// Sends the current draft as a user message and requests a reply.
    func send() {
        guard canSend else { return }

        let text = trimmedDraft
        draft = ""
        conversation.append(.user(text))

        Task { await generateReply() }
    }

    /// Clears all messages from the conversation.
    func clearConversation() {
        conversation.clearMessages()
        errorMessage = nil
    }

    // MARK: Private

    private func generateReply() async {
        isSending = true
        errorMessage = nil
        defer { isSending = false }

        do {
            let reply = try await aiService.sendMessage(conversation.messages)
            conversation.append(reply)
        } catch is CancellationError {
            // Ignore cancellations (e.g. the view went away).
        } catch let error as AIServiceError {
            errorMessage = Self.message(for: error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private static func message(for error: AIServiceError) -> String {
        switch error {
        case .emptyConversation:
            return "There's nothing to send yet."
        case .requestFailed(let reason):
            return reason
        }
    }
}
