import SwiftUI

// MARK: - Available subjects

enum Subject: String, CaseIterable, Identifiable {

    case biology = "Biology"
    case chemistry = "Chemistry"
    case computerScience = "Computer Science"

    var id: String {
        rawValue
    }

    // MARK: - Subject descriptions

    var description: String {

        switch self {

        case .biology:
            return "Explore the study of living organisms, ecosystems and the natural world."

        case .chemistry:
            return "Discover the science of matter, chemical reactions and experiments."

        case .computerScience:
            return "Learn about programming, computing systems and digital technology."
        }
    }

    // MARK: - Subject icons

    var icon: String {

        switch self {

        case .biology:
            return "leaf.fill"

        case .chemistry:
            return "flask.fill"

        case .computerScience:
            return "laptopcomputer"
        }
    }

    // MARK: - Subject colours

    var colour: Color {

        switch self {

        case .biology:
            return .green

        case .chemistry:
            return .orange

        case .computerScience:
            return .blue
        }
    }
}

