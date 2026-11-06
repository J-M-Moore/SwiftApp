import SwiftUI
import Combine

// MARK: - User account model

struct AppUser: Identifiable {

    let id: String
    let name: String
    let email: String
    let role: UserRole

    // Subject is only required for student accounts

    let subject: Subject?
}

// MARK: - App session manager

@MainActor
final class AppSession: ObservableObject {

    // Currently signed-in user

    @Published private(set) var currentUser: AppUser?

    // Is somebody signed in?

    var isLoggedIn: Bool {
        currentUser != nil
    }

    // Current user's role

    var userRole: UserRole? {
        currentUser?.role
    }

    // Current user's subject

    var userSubject: Subject? {
        currentUser?.subject
    }

    // MARK: - Sign in

    func signIn(user: AppUser) {

        currentUser = user
    }

    // MARK: - Sign out

    func signOut() {

        currentUser = nil
    }

    // MARK: - Page permissions

    func canAccess(_ page: String) -> Bool {

        guard let role = currentUser?.role else {
            return false
        }

        return role.canAccess(page)
    }
}

// MARK: - Temporary test accounts

extension AppUser {

    static let testAccounts: [AppUser] = [

        // Standard User

        AppUser(
            id: "user001",
            name: "Alex Morgan",
            email: "alex@example.com",
            role: .standard,
            subject: nil
        ),

        // Staff Member

        AppUser(
            id: "user002",
            name: "Sarah Williams",
            email: "sarah@example.com",
            role: .staff,
            subject: nil
        ),

        // Administrator

        AppUser(
            id: "user003",
            name: "Admin User",
            email: "admin@example.com",
            role: .administrator,
            subject: nil
        ),

        // IT Support

        AppUser(
            id: "user004",
            name: "James IT",
            email: "it@example.com",
            role: .itSupport,
            subject: nil
        ),

        // Biology Student

        AppUser(
            id: "student001",
            name: "Emma Taylor",
            email: "emma@example.com",
            role: .student,
            subject: .biology
        ),

        // Chemistry Student

        AppUser(
            id: "student002",
            name: "Oliver Smith",
            email: "oliver@example.com",
            role: .student,
            subject: .chemistry
        ),

        // Computer Science Student

        AppUser(
            id: "student003",
            name: "Sophie Brown",
            email: "sophie@example.com",
            role: .student,
            subject: .computerScience
        )
    ]
}

