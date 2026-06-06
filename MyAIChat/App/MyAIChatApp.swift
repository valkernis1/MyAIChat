//
//  MyAIChatApp.swift
//  MyAIChat
//
//  App entry point.
//

import SwiftUI

@main
struct MyAIChatApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatView()
            }
        }
    }
}
