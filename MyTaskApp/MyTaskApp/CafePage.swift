
import SwiftUI

// MARK: - Cafe menu item

struct CafeMenuItem: Identifiable {

    let id = UUID()
    let name: String
    let description: String
    let price: String
    let icon: String
}

// MARK: - Cafe page

struct CafePage: View {

    private let sections: [(title: String, icon: String, items: [CafeMenuItem])] = [

        (
            "Breakfast",
            "sunrise.fill",
            [
                CafeMenuItem(
                    name: "Full English Breakfast",
                    description: "Eggs, bacon, sausage, beans, mushrooms and toast.",
                    price: "£8.50",
                    icon: "sun.max.fill"
                ),
                CafeMenuItem(
                    name: "Avocado Toast",
                    description: "Smashed avocado on toasted sourdough.",
                    price: "£5.50",
                    icon: "leaf.fill"
                ),
                CafeMenuItem(
                    name: "Porridge",
                    description: "Warm oats with honey and seasonal fruit.",
                    price: "£3.50",
                    icon: "bowl.fill"
                )
            ]
        ),

        (
            "Sandwiches & Light Meals",
            "sandwich.fill",
            [
                CafeMenuItem(
                    name: "Chicken & Bacon Sandwich",
                    description: "Roast chicken, crispy bacon and salad.",
                    price: "£5.95",
                    icon: "fork.knife"
                ),
                CafeMenuItem(
                    name: "Mozzarella & Tomato Panini",
                    description: "Mozzarella, fresh tomato and basil.",
                    price: "£5.50",
                    icon: "leaf.fill"
                ),
                CafeMenuItem(
                    name: "Tuna Mayo Jacket Potato",
                    description: "Baked potato with tuna mayonnaise.",
                    price: "£5.95",
                    icon: "takeoutbag.and.cup.and.straw.fill"
                )
            ]
        ),

        (
            "Snacks & Treats",
            "birthday.cake.fill",
            [
                CafeMenuItem(
                    name: "Chocolate Brownie",
                    description: "Rich chocolate brownie.",
                    price: "£2.50",
                    icon: "birthday.cake.fill"
                ),
                CafeMenuItem(
                    name: "Blueberry Muffin",
                    description: "Freshly baked blueberry muffin.",
                    price: "£2.25",
                    icon: "cupcake"
                ),
                CafeMenuItem(
                    name: "Fresh Fruit Pot",
                    description: "A selection of seasonal fruit.",
                    price: "£2.75",
                    icon: "apple.logo"
                )
            ]
        ),

        (
            "Drinks",
            "cup.and.saucer.fill",
            [
                CafeMenuItem(
                    name: "Americano",
                    description: "Freshly prepared espresso and hot water.",
                    price: "£2.50",
                    icon: "cup.and.saucer.fill"
                ),
                CafeMenuItem(
                    name: "Cappuccino",
                    description: "Espresso with steamed milk and foam.",
                    price: "£3.20",
                    icon: "cup.and.saucer.fill"
                ),
                CafeMenuItem(
                    name: "Tea",
                    description: "Traditional English breakfast tea.",
                    price: "£1.80",
                    icon: "mug.fill"
                ),
                CafeMenuItem(
                    name: "Fresh Orange Juice",
                    description: "A refreshing glass of orange juice.",
                    price: "£2.50",
                    icon: "waterbottle.fill"
                )
            ]
        )
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                // Heading

                VStack(alignment: .leading, spacing: 6) {

                    Text("Welcome to the Cafe")
                        .font(.system(size: 30, weight: .bold))

                    Text("Good food, great coffee and something for everyone.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Banner

                HStack(spacing: 15) {

                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 5) {

                        Text("Our Cafe Menu")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Our regular selection of food and drinks.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.orange, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Menu sections

                ForEach(sections, id: \.title) { section in

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            section.title,
                            systemImage: section.icon
                        )
                        .font(.title2)
                        .bold()

                        ForEach(section.items) { item in

                            cafeItemCard(item)
                        }
                    }
                }

                Text("All prices are sample prices and subject to change.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 5)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Cafe")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Menu item card

    private func cafeItemCard(
        _ item: CafeMenuItem
    ) -> some View {

        HStack(spacing: 13) {

            Image(systemName: item.icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 42, height: 42)
                .background(Color.orange.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {

                Text(item.name)
                    .font(.headline)

                Text(item.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 5)

            Text(item.price)
                .font(.headline)
                .foregroundStyle(.orange)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CafePage()
    }
}

