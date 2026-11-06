import SwiftUI

// MARK: - Main application entry view

struct ContentView: View {

    @StateObject private var session = AppSession()

    var body: some View {

        Group {

            if session.isLoggedIn {

                HomeView()

            } else {

                LoginPage()
            }
        }
        .environmentObject(session)
    }
}

// MARK: - Home screen

struct HomeView: View {

    @EnvironmentObject var session: AppSession

    @State private var showingProfile = false

    // MARK: - Home page items

    private let pages: [AppPage] = [

        AppPage(
            title: "Events",
            icon: "calendar",
            description: "Upcoming events.",
            colour: .orange
        ),

        AppPage(
            title: "Updates",
            icon: "bell.badge.fill",
            description: "Latest announcements.",
            colour: .pink
        ),

        AppPage(
            title: "Room Bookings",
            icon: "door.left.hand.open",
            description: "Book a room.",
            colour: .teal
        ),

        AppPage(
            title: "IT & Maintenance",
            icon: "wrench.and.screwdriver.fill",
            description: "Report an issue.",
            colour: .orange
        ),

        AppPage(
            title: "Dining",
            icon: "fork.knife",
            description: "Explore dining options.",
            colour: .green
        ),

        AppPage(
            title: "Staff Resources",
            icon: "person.2.fill",
            description: "Internal staff resources.",
            colour: .teal
        ),

        AppPage(
            title: "Booking Management",
            icon: "calendar.badge.clock",
            description: "Manage room bookings.",
            colour: .purple
        ),

        AppPage(
            title: "User Management",
            icon: "person.3.fill",
            description: "Manage user accounts.",
            colour: .indigo
        ),

        AppPage(
            title: "Ticket Management",
            icon: "ticket.fill",
            description: "Manage support tickets.",
            colour: .red
        ),

        AppPage(
            title: "Subject Information",
            icon: "graduationcap.fill",
            description: "Your subject resources.",
            colour: .green
        )
    ]

    // MARK: - Filter pages by role

    private var visiblePages: [AppPage] {

        pages.filter {
            session.canAccess($0.title)
        }
    }

    // MARK: - Main layout

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    // Welcome message

                    VStack(alignment: .leading, spacing: 6) {

                        Text(
                            "Welcome, \(session.currentUser?.name ?? "User")!"
                        )
                        .font(.system(
                            size: 29,
                            weight: .bold
                        ))

                        Text("What would you like to do today?")
                            .foregroundStyle(.secondary)
                    }

                    // User role indicator

                    if let role = session.userRole {

                        HStack(spacing: 10) {

                            Image(systemName: role.icon)
                                .foregroundStyle(role.colour)

                            VStack(alignment: .leading, spacing: 2) {

                                Text(role.rawValue)
                                    .font(.headline)

                                Text("Your personalised app")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(role.colour.opacity(0.10))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                    }

                    // Page grid

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {

                        ForEach(visiblePages) { page in

                            NavigationLink {

                                destination(for: page)

                            } label: {

                                AppButton(page: page)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                }
                .padding()
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationTitle("Home")
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showingProfile = true

                    } label: {

                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {

                ProfilePage()
            }
        }
    }


    // MARK: - Page navigation

    @ViewBuilder
    private func destination(for page: AppPage) -> some View {

        switch page.title {

        case "Updates":
            UpdatesPage()

        case "Events":
            EventsPage()

        case "Room Bookings":
            RoomBookingsPage()

        case "IT & Maintenance":
            TicketsPage()

        case "Ticket Management":
            ITDashboard()

        case "Subject Information":
            SubjectPage()
            
        case "Dining":
            DiningPage()

        default:
            InformationPage(page: page)
        }
    }
}

// MARK: - Home page button

struct AppButton: View {

    let page: AppPage

    var body: some View {

        VStack(spacing: 12) {

            Image(systemName: page.icon)
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .frame(height: 45)

            Text(page.title)
                .font(.system(
                    size: 12,
                    weight: .bold
                ))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

        }
        .frame(maxWidth: .infinity)
        .frame(height: 115)
        .background(

            LinearGradient(
                colors: [
                    page.colour,
                    page.colour.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: page.colour.opacity(0.20),
            radius: 6,
            y: 4
        )
    }
}

// MARK: - User profile

struct ProfilePage: View {

    @EnvironmentObject var session: AppSession

    @Environment(\.dismiss) private var dismiss

    @State private var showingSignOutConfirmation = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 24) {

                Spacer()

                if let user = session.currentUser {

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 85))
                        .foregroundStyle(user.role.colour)

                    Text(user.name)
                        .font(.title)
                        .bold()

                    Text(user.email)
                        .foregroundStyle(.secondary)

                    Label(
                        user.role.rawValue,
                        systemImage: user.role.icon
                    )
                    .font(.headline)
                    .foregroundStyle(user.role.colour)
                    .padding()
                    .background(user.role.colour.opacity(0.10))
                    .clipShape(Capsule())
                }

                Spacer()

                Button(role: .destructive) {

                    showingSignOutConfirmation = true

                } label: {

                    Label(
                        "Sign Out",
                        systemImage: "rectangle.portrait.and.arrow.right"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

            }
            .padding()
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(
                "Are you sure you want to sign out?",
                isPresented: $showingSignOutConfirmation,
                titleVisibility: .visible
            ) {

                Button("Sign Out", role: .destructive) {

                    dismiss()
                    session.signOut()
                }

                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

