//
//  MessageBubbleView.swift
//  MyAIChat
//
//  A single, modern chat message bubble (ChatGPT-like).
//

import SwiftUI

/// Renders a single `ChatMessage` as a rounded bubble, aligned by role,
/// with a small role avatar and a subtle shadow.
struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.small) {
            if message.isFromUser {
                Spacer(minLength: Theme.Spacing.xLarge)
            } else {
                avatar
            }

            Text(message.text)
                .textSelection(.enabled)
                .foregroundColor(textColor)
                .padding(.vertical, Theme.Spacing.small + 2)
                .padding(.horizontal, Theme.Spacing.medium)
                .background(bubbleBackground)
                .shadow(color: Theme.Shadow.color,
                        radius: Theme.Shadow.radius,
                        x: 0,
                        y: Theme.Shadow.y)

            if message.isFromUser {
                avatar
            } else {
                Spacer(minLength: Theme.Spacing.xLarge)
            }
        }
        .frame(maxWidth: .infinity,
               alignment: message.isFromUser ? .trailing : .leading)
    }

    // MARK: Subviews

    private var bubbleBackground: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.bubble, style: .continuous)
            .fill(message.isFromUser ? Theme.Colors.userBubble : Theme.Colors.assistantBubble)
    }

    private var avatar: some View {
        Image(systemName: message.isFromUser ? "person.fill" : "sparkles")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(message.isFromUser ? Theme.Colors.userText : Theme.Colors.accent)
            .frame(width: 28, height: 28)
            .background(
                Circle().fill(message.isFromUser
                              ? Theme.Colors.accent
                              : Theme.Colors.assistantBubble)
            )
    }

    private var textColor: Color {
        message.isFromUser ? Theme.Colors.userText : Theme.Colors.assistantText
    }
}

#Preview {
    ScrollView {
        VStack(spacing: Theme.Spacing.medium) {
            MessageBubbleView(message: .assistant("Hello! How can I help you today?"))
            MessageBubbleView(message: .user("Explain quantum computing in one sentence."))
            MessageBubbleView(message: .assistant("Quantum computing uses quantum bits that can be 0 and 1 at once, enabling certain problems to be solved far faster than classical computers."))
        }
        .padding()
    }
    .background(Theme.Colors.background)
}
