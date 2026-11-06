import SwiftUI

// MARK: - App page model

struct AppPage: Identifiable {

    let id = UUID()

    let title: String
    let icon: String
    let description: String
    let colour: Color
}
