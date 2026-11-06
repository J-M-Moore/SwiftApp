import SwiftUI

// MARK: - Event audience

enum EventAudience: Equatable {

    case general
    case staff
    case itSupport
    case subject(Subject)

    // MARK: - Display name

    var displayName: String {

        switch self {

        case .general:
            return "General Event"

        case .staff:
            return "Staff Event"

        case .itSupport:
            return "IT Event"

        case .subject(let subject):
            return subject.rawValue
        }
    }

    // MARK: - Display colour

    var colour: Color {

        switch self {

        case .general:
            return .blue

        case .staff:
            return .pink

        case .itSupport:
            return .red

        case .subject(let subject):
            return subject.colour
        }
    }

    // MARK: - Display icon

    var icon: String {

        switch self {

        case .general:
            return "calendar"

        case .staff:
            return "person.2.fill"

        case .itSupport:
            return "wrench.and.screwdriver.fill"

        case .subject(let subject):
            return subject.icon
        }
    }
}

