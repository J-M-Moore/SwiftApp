
import SwiftUI

struct DiningPage: View {

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {

                    Text("Dining")
                        .font(.system(size: 32, weight: .bold))

                    Text("Explore our dining options and discover what's on the menu.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Welcome banner

                HStack(spacing: 15) {

                    Image(systemName: "fork.knife")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 5) {

                        Text("Something delicious awaits!")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Explore our dining venues and their latest menus.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.green, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Dining options

                VStack(alignment: .leading, spacing: 15) {

                    Text("Our Dining Venues")
                        .font(.title2)
                        .bold()

                    NavigationLink {
                        CafePage()
                    } label: {
                        diningCard(
                            title: "Cafe",
                            subtitle: "Coffee, snacks and daily favourites.",
                            icon: "cup.and.saucer.fill",
                            colour: .orange
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        HallPage()
                    } label: {
                        diningCard(
                            title: "Hall",
                            subtitle: "Fresh meals and everyday dining.",
                            icon: "fork.knife",
                            colour: .green
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        FormalHallPage()
                    } label: {
                        diningCard(
                            title: "Formal Hall",
                            subtitle: "Special dining experiences and weekly menus.",
                            icon: "wineglass.fill",
                            colour: .purple
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dining")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Dining card

    private func diningCard(
        title: String,
        subtitle: String,
        icon: String,
        colour: Color
    ) -> some View {

        HStack(spacing: 15) {

            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background(colour)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
    }
}

