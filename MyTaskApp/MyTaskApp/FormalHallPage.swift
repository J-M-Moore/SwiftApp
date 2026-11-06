
import SwiftUI

// MARK: - Formal Hall course

struct FormalHallCourse {

    let name: String
    let description: String
    let icon: String
}

// MARK: - Formal Hall dinner

struct FormalHallDinner: Identifiable {

    let id = UUID()
    let day: String
    let dateDescription: String
    let starter: FormalHallCourse
    let main: FormalHallCourse
    let dessert: FormalHallCourse
    let price: String
}

// MARK: - Formal Hall page

struct FormalHallPage: View {

    private let dinners: [FormalHallDinner] = [

        FormalHallDinner(
            day: "Thursday",
            dateDescription: "Thursday Evening",

            starter: FormalHallCourse(
                name: "Roasted Tomato Soup",
                description: "Slow-roasted tomato and basil soup served with fresh sourdough bread.",
                icon: "soup"
            ),

            main: FormalHallCourse(
                name: "Roast Beef",
                description: "Slow-roasted British beef with Yorkshire pudding, roast potatoes, seasonal vegetables and red wine gravy.",
                icon: "fork.knife"
            ),

            dessert: FormalHallCourse(
                name: "Sticky Toffee Pudding",
                description: "Warm sticky toffee sponge served with vanilla ice cream and butterscotch sauce.",
                icon: "birthday.cake.fill"
            ),

            price: "£22.50"
        ),

        FormalHallDinner(
            day: "Friday",
            dateDescription: "Friday Evening",

            starter: FormalHallCourse(
                name: "Smoked Salmon",
                description: "Smoked salmon with lemon, dill, cucumber and toasted brown bread.",
                icon: "fish.fill"
            ),

            main: FormalHallCourse(
                name: "Chicken Supreme",
                description: "Pan-roasted chicken supreme with creamy mashed potatoes, seasonal vegetables and mushroom sauce.",
                icon: "fork.knife"
            ),

            dessert: FormalHallCourse(
                name: "Chocolate Fondant",
                description: "Warm chocolate fondant with a rich molten centre, served with vanilla ice cream.",
                icon: "birthday.cake.fill"
            ),

            price: "£24.50"
        )
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                // Heading

                VStack(alignment: .leading, spacing: 7) {

                    Text("Formal Hall")
                        .font(.system(size: 32, weight: .bold))

                    Text("An evening of excellent food and company.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Elegant banner

                ZStack {

                    LinearGradient(
                        colors: [
                            Color(red: 0.25, green: 0.16, blue: 0.38),
                            Color(red: 0.48, green: 0.30, blue: 0.62)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    VStack(spacing: 12) {

                        Image(systemName: "wineglass.fill")
                            .font(.system(size: 45))

                        Text("Formal Dining")
                            .font(.title)
                            .bold()

                        Text("Thursday & Friday Evenings")
                            .font(.subheadline)
                            .opacity(0.9)
                    }
                    .foregroundStyle(.white)
                    .padding(.vertical, 28)
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 22))

                // Weekly dinners

                VStack(alignment: .leading, spacing: 18) {

                    Text("This Week's Dinners")
                        .font(.title2)
                        .bold()

                    ForEach(dinners) { dinner in

                        dinnerCard(dinner)
                    }
                }

                Text("Sample menus and prices. Please check current availability with the catering team.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Formal Hall")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Dinner card

    private func dinnerCard(
        _ dinner: FormalHallDinner
    ) -> some View {

        VStack(alignment: .leading, spacing: 18) {

            // Dinner heading

            HStack {

                VStack(alignment: .leading, spacing: 5) {

                    Text(dinner.day)
                        .font(.title2)
                        .bold()

                    Text(dinner.dateDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(dinner.price)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.purple)
            }

            Divider()

            courseRow(
                label: "STARTER",
                course: dinner.starter
            )

            courseRow(
                label: "MAIN COURSE",
                course: dinner.main
            )

            courseRow(
                label: "DESSERT",
                course: dinner.dessert
            )

            Divider()

            HStack {

                Image(systemName: "sparkles")
                    .foregroundStyle(.purple)

                Text("Three-course formal dinner")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.04),
            radius: 6,
            y: 3
        )
    }

    // MARK: - Individual course

    private func courseRow(
        label: String,
        course: FormalHallCourse
    ) -> some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: course.icon == "soup"
                  ? "cup.and.saucer.fill"
                  : course.icon)
                .font(.title2)
                .foregroundStyle(.purple)
                .frame(width: 38)

            VStack(alignment: .leading, spacing: 5) {

                Text(label)
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(.purple)

                Text(course.name)
                    .font(.headline)

                Text(course.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FormalHallPage()
    }
}

