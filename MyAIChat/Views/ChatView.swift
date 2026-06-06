//
//  ChatView.swift
//  MyAIChat
//
//  Main chat screen (ChatGPT-like): empty state, message list, input bar.
//

import SwiftUI

/// The main chat screen showing the message list and the input bar.
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack(spacing: 0) {
            content
            MessageInputView(
                text: $viewModel.draft,
                canSend: viewModel.canSend,
                onSend: viewModel.send
            )
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("MyAIChat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.clearConversation) {
                    Image(systemName: "square.and.pencil")
                }
                .disabled(viewModel.messages.isEmpty)
                .accessibilityLabel("New chat")
            }
        }
        .alert("Something went wrong",
               isPresented: errorAlertPresented,
               actions: { Button("OK", role: .cancel) {} },
               message: { Text(viewModel.errorMessage ?? "") })
    }

    // MARK: Content

    @ViewBuilder
    private var content: some View {
        if viewModel.messages.isEmpty && !viewModel.isSending {
            emptyState
        } else {
            messageList
        }
    }

    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 52, weight: .semibold))
                .foregroundColor(Theme.Colors.accent)
            Text("How can I help you today?")
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            Text("Ask me anything to get started.")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.secondaryText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Theme.Spacing.xLarge)
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.medium) {
                    ForEach(viewModel.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }

                    if viewModel.isSending {
                        TypingIndicatorView()
                            .id(typingIndicatorID)
                    }
                }
                .padding(.horizontal, Theme.Spacing.medium)
                .padding(.vertical, Theme.Spacing.large)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(proxy)
            }
            .onChange(of: viewModel.isSending) { _ in
                scrollToBottom(proxy)
            }
        }
    }

    // MARK: Helpers

    private let typingIndicatorID = "typing-indicator"

    private var errorAlertPresented: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { presented in if !presented { viewModel.errorMessage = nil } }
        )
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if viewModel.isSending {
                proxy.scrollTo(typingIndicatorID, anchor: .bottom)
            } else if let lastID = viewModel.messages.last?.id {
                proxy.scrollTo(lastID, anchor: .bottom)
            }
        }
    }
}

/// A small "assistant is typing" bubble with animated dots.
private struct TypingIndicatorView: View {
    @State private var animating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.small) {
            Image(systemName: "sparkles")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.Colors.accent)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Theme.Colors.assistantBubble))

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Theme.Colors.secondaryText)
                        .frame(width: 7, height: 7)
                        .opacity(animating ? 1 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animating
                        )
                }
            }
            .padding(.vertical, Theme.Spacing.small + 2)
            .padding(.horizontal, Theme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.bubble, style: .continuous)
                    .fill(Theme.Colors.assistantBubble)
            )

            Spacer(minLength: Theme.Spacing.xLarge)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { animating = true }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
