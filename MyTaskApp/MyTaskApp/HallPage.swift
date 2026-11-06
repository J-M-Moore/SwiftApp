
import SwiftUI

// MARK: - Meal model

struct HallMeal {

    let title: String
    let description: String
    let price: String
    let icon: String
}

// MARK: - Daily menu model

struct HallDay: Identifiable {

    let id = UUID()
    let day: String
    let lunch: HallMeal
    let dinner: HallMeal
}

// MARK: - Hall page

struct HallPage: View {

    private let weeklyMenu: [HallDay] = [

        HallDay(
            day: "Monday",
            lunch: HallMeal(
                title: "Roast Chicken",
                description: "Roast chicken served with seasonal vegetables, roast potatoes and gravy.",
                price: "£7.50",
                icon: "fork.knife"
            ),
            dinner: HallMeal(
                title: "Vegetable Pasta",
                description: "Penne pasta with roasted vegetables in a tomato and basil sauce.",
                price: "£6.50",
                icon: "leaf.fill"
            )
        ),

        HallDay(
            day: "Tuesday",
            lunch: HallMeal(
                title: "Beef Lasagne",
                description: "Homemade beef lasagne served with garlic bread and salad.",
                price: "£7.25",
                icon: "fork.knife"
            ),
            dinner: HallMeal(
                title: "Fish and Chips",
                description: "Battered fish served with chips, mushy peas and tartare sauce.",
                price: "£8.00",
                icon: "fish.fill"
            )
        ),

        HallDay(
            day: "Wednesday",
            lunch: HallMeal(
                title: "Chicken Curry",
                description: "Mild chicken curry served with basmati rice and naan bread.",
                price: "£7.50",
                icon: "fork.knife"
            ),
            dinner: HallMeal(
                title: "Shepherd's Pie",
                description: "Traditional minced lamb topped with creamy mashed potato and vegetables.",
                price: "£7.00",
                icon: "house.fill"
            )
        ),

        HallDay(
            day: "Thursday",
            lunch: HallMeal(
                title: "Sausage and Mash",
                description: "Pork sausages with creamy mashed potatoes, peas and onion gravy.",
                price: "£7.25",
                icon: "fork.knife"
            ),
            dinner: HallMeal(
                title: "Thai Green Curry",
                description: "Aromatic green curry with vegetables, coconut milk and jasmine rice.",
                price: "£7.50",
                icon: "leaf.fill"
            )
        ),

        HallDay(
            day: "Friday",
            lunch: HallMeal(
                title: "Fish Pie",
                description: "Creamy fish pie topped with mashed potato and served with vegetables.",
                price: "£7.50",
                icon: "fish.fill"
            ),
            dinner: HallMeal(
                title: "Roast Pork",
                description: "Roast pork with apple sauce, seasonal vegetables and roast potatoes.",
                price: "£8.00",
                icon: "fork.knife"
            )
        )
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 6) {

                    Text("Hall Dining")
                        .font(.system(size: 30, weight: .bold))

                    Text("Your weekly lunch and dinner menu.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Banner

                HStack(spacing: 15) {

                    Image(systemName: "fork.knife")
                        .font(.system(size: 42))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 5) {

                        Text("This Week's Menu")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Fresh meals served every weekday.")
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

                // Daily menus

                ForEach(weeklyMenu) { day in

                    VStack(alignment: .leading, spacing: 12) {

                        Text(day.day)
                            .font(.title2)
                            .bold()

                        mealCard(
                            title: "Lunch",
                            meal: day.lunch,
                            colour: .orange
                        )

                        mealCard(
                            title: "Dinner",
                            meal: day.dinner,
                            colour: .purple
                        )
                    }
                }

                Text("All prices are sample prices. Menus and availability may change.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hall")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Meal card

    private func mealCard(
        title: String,
        meal: HallMeal,
        colour: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Label(title, systemImage: "clock.fill")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(colour)

                Spacer()

                Text(meal.price)
                    .font(.headline)
                    .foregroundStyle(colour)
            }

            HStack(spacing: 12) {

                Image(systemName: meal.icon)
                    .font(.title2)
                    .foregroundStyle(colour)
                    .frame(width: 42, height: 42)
                    .background(colour.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 5) {

                    Text(meal.title)
                        .font(.headline)

                    Text(meal.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HallPage()
    }
}

