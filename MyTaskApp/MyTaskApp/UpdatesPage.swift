
import SwiftUI

// MARK: - Update data model

struct UpdateItem: Identifiable {

    let id = UUID()

    let title: String
    let date: String
    let category: String
    let description: String
    let icon: String
    let colour: Color
}

// MARK: - Updates page

struct UpdatesPage: View {

    // Sample updates.
    // Later, these will come from our Python backend.

    let updates = [

        UpdateItem(
            title: "Welcome to our app!",
            date: "Latest announcement",
            category: "Announcement",
            description: """
            Welcome! We're excited to have you here.

            This is where you'll find the latest news,
            announcements and important information.
            """,
            icon: "sparkles",
            colour: .purple
        ),

        UpdateItem(
            title: "Something exciting is coming",
            date: "Coming soon",
            category: "News",
            description: """
            We're working on some exciting new features.

            Keep checking this page to find out what's
            coming next!
            """,
            icon: "megaphone.fill",
            colour: .pink
        ),

        UpdateItem(
            title: "Stay connected",
            date: "Information",
            category: "Information",
            description: """
            We'll use this page to keep you informed
            about important news and developments.

            Make sure you check back regularly.
            """,
            icon: "bell.fill",
            colour: .blue
        ),

        UpdateItem(
            title: "Discover more",
            date: "Explore",
            category: "Feature",
            description: """
            There is plenty to discover in the app.

            Explore the different sections to find
            useful information and upcoming events.
            """,
            icon: "star.fill",
            colour: .orange
        )
    ]

    // MARK: - Page layout

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 8) {

                    Text("What's New?")
                        .font(.system(
                            size: 32,
                            weight: .bold
                        ))

                    Text(
                        "The latest news, announcements and updates."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Featured banner

                featuredBanner

                // Updates heading

                HStack {

                    Text("Latest Updates")
                        .font(.title2)
                        .bold()

                    Spacer()

                    Text("\(updates.count) posts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Individual update cards

                VStack(spacing: 16) {

                    ForEach(updates) { update in

                        NavigationLink {

                            UpdateDetailPage(update: update)

                        } label: {

                            updateCard(update)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Footer

                Text("You're all caught up!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Updates")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Featured banner

    private var featuredBanner: some View {

        ZStack(alignment: .bottomLeading) {

            LinearGradient(
                colors: [
                    .purple,
                    .pink,
                    .orange
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.white.opacity(0.12))
                .frame(width: 180, height: 180)
                .offset(x: 200, y: -40)

            Circle()
                .fill(.white.opacity(0.10))
                .frame(width: 120, height: 120)
                .offset(x: 260, y: 50)

            VStack(alignment: .leading, spacing: 10) {

                Image(systemName: "sparkles")
                    .font(.system(size: 32))

                Text("Stay in the loop")
                    .font(.title)
                    .bold()

                Text(
                    "All the latest news and information, right here."
                )
                .font(.subheadline)
                .opacity(0.9)
            }
            .foregroundStyle(.white)
            .padding(22)
        }
        .frame(height: 185)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }

    // MARK: - Update card

    private func updateCard(
        _ update: UpdateItem
    ) -> some View {

        VStack(alignment: .leading, spacing: 14) {

            // Icon and category

            HStack {

                Image(systemName: update.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(update.colour)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )

                VStack(alignment: .leading, spacing: 4) {

                    Text(update.category.uppercased())
                        .font(.caption)
                        .bold()
                        .foregroundStyle(update.colour)

                    Text(update.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            // Title

            Text(update.title)
                .font(.headline)
                .foregroundStyle(.primary)

            // Description

            Text(update.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            Divider()

            HStack {

                Text("Read more")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(update.colour)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(update.colour)
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 8,
            y: 3
        )
    }
}

// MARK: - Individual update detail page

struct UpdateDetailPage: View {

    let update: UpdateItem

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                // Colourful header

                ZStack {

                    LinearGradient(
                        colors: [
                            update.colour,
                            update.colour.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: update.icon)
                        .font(.system(size: 65))
                        .foregroundStyle(.white)
                }
                .frame(height: 200)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // Article category and date

                Text(update.category.uppercased())
                    .font(.caption)
                    .bold()
                    .foregroundStyle(update.colour)

                Text(update.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Article title

                Text(update.title)
                    .font(.largeTitle)
                    .bold()

                Divider()

                // Full article text

                Text(update.description)
                    .font(.body)
                    .lineSpacing(6)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Update")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        UpdatesPage()
    }
}
