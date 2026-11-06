import SwiftUI

// MARK: - Available user roles

enum UserRole: String, CaseIterable, Identifiable {

    case standard = "Standard User"
    case staff = "Staff Member"
    case administrator = "Administrator"
    case itSupport = "IT Support"
    case student = "Student User"

    var id: String { rawValue }

    // MARK: - Role descriptions

    var description: String {

        switch self {

        case .standard:
            return "Access general information, events and bookings."

        case .staff:
            return "Access general information and internal staff resources."

        case .administrator:
            return "Full access to application management and administration."

        case .itSupport:
            return "Access support tools and manage IT tickets."
            
        case .student:
            return "Access general information and subject-specific resources."
        }
    }

    // MARK: - Role colours

    var colour: Color {

        switch self {

        case .standard:
            return .blue

        case .staff:
            return .teal

        case .administrator:
            return .purple

        case .itSupport:
            return .orange
            
        case .student:
            return .green
        }
    }

    // MARK: - Role icons

    var icon: String {

        switch self {

        case .standard:
            return "person.fill"

        case .staff:
            return "person.2.fill"

        case .administrator:
            return "shield.lefthalf.filled"

        case .itSupport:
            return "desktopcomputer"
            
        case .student:
            return "graduationcap.fill"
        }
    }

    // MARK: - Accessible pages

    var accessiblePages: [String] {

        switch self {

        case .standard:

            return [
                "About",
                "Guides",
                "Events",
                "Explore",
                "Updates",
                "Favourites",
                "Help",
                "Room Bookings",
                "IT & Maintenance",
                "Contact",
                "Dining"
            ]

        case .staff:

            return [
                "About",
                "Guides",
                "Events",
                "Explore",
                "Updates",
                "Favourites",
                "Help",
                "Room Bookings",
                "IT & Maintenance",
                "Contact",
                "Staff Resources",
                "Dining"
            ]

        case .administrator:

            return [
                "About",
                "Guides",
                "Events",
                "Explore",
                "Updates",
                "Favourites",
                "Help",
                "Room Bookings",
                "IT & Maintenance",
                "Contact",
                "Staff Resources",
                "Booking Management",
                "User Management",
                "Ticket Management",
                "Dining"
            ]

        case .itSupport:

            return [
                "About",
                "Guides",
                "Events",
                "Explore",
                "Updates",
                "Favourites",
                "Help",
                "Room Bookings",
                "IT & Maintenance",
                "Contact",
                "Ticket Management",
                "Dining"
            ]
            
        case .student:

            return [
                "About",
                "Guides",
                "Events",
                "Explore",
                "Updates",
                "Favourites",
                "Help",
                "Room Bookings",
                "IT & Maintenance",
                "Contact",
                "Subject Information",
                "Dining"
            ]
        }
    }

    // MARK: - Permission checking

    func canAccess(_ page: String) -> Bool {

        accessiblePages.contains(page)
    }
}
