//
//  MessageInputView.swift
//  MyAIChat
//
//  Bottom input bar, ChatGPT-like (rounded field + circular send button).
//

import SwiftUI

/// The bottom composer: a rounded, multi-line text field with a circular
/// send button, sitting on a subtle bar with a top separator.
struct MessageInputView: View {
    @Binding var text: String

    /// Whether the send button is enabled.
    var canSend: Bool = true

    /// Invoked when the user taps send.
    var onSend: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.small) {
            inputField
            sendButton
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.vertical, Theme.Spacing.small)
        .background(
            Theme.Colors.inputBarBackground
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Theme.Colors.separator)
                        .frame(height: 0.5)
                }
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: Subviews

    private var inputField: some View {
        TextField("Message", text: $text, axis: .vertical)
            .lineLimit(1...5)
            .focused($isFocused)
            .padding(.vertical, Theme.Spacing.small + 2)
            .padding(.horizontal, Theme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large, style: .continuous)
                    .fill(Theme.Colors.inputFieldBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large, style: .continuous)
                            .stroke(Theme.Colors.separator, lineWidth: 1)
                    )
            )
    }

    private var sendButton: some View {
        Button(action: submit) {
            Image(systemName: "arrow.up")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 34, height: 34)
                .background(
                    Circle().fill(canSend
                                  ? Theme.Colors.accent
                                  : Theme.Colors.secondaryText.opacity(0.35))
                )
        }
        .disabled(!canSend)
        .animation(.easeInOut(duration: 0.15), value: canSend)
    }

    // MARK: Actions

    private func submit() {
        guard canSend else { return }
        onSend()
        isFocused = false
    }
}

#Preview {
    VStack {
        Spacer()
        MessageInputView(text: .constant("Hello"), canSend: true, onSend: {})
    }
    .background(Theme.Colors.background)
}
