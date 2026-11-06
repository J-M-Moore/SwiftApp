import SwiftUI

struct InformationPage: View {

    let page: AppPage

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                // Large colourful icon

                Image(systemName: page.icon)
                    .font(.system(size: 55))
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 120)
                    .background(

                        LinearGradient(
                            colors: [
                                page.colour,
                                page.colour.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 30)
                    )
                    .shadow(
                        color: page.colour.opacity(0.25),
                        radius: 12,
                        y: 6
                    )

                // Page title

                Text(page.title)
                    .font(.system(
                        size: 30,
                        weight: .bold
                    ))

                // Description

                Text(page.description)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                // Sample content

                VStack(alignment: .leading, spacing: 16) {

                    Text("Welcome!")
                        .font(.title2)
                        .bold()

                    Text(
                        "This is your \(page.title) page. "
                        + "We'll be adding more useful information "
                        + "and features here as the application develops."
                    )
                    .foregroundStyle(.secondary)

                    Divider()

                    Label(
                        "More information coming soon",
                        systemImage: "sparkles"
                    )
                    .foregroundStyle(page.colour)
                    .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle(page.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        InformationPage(
            page: AppPage(
                title: "About",
                icon: "info.circle.fill",
                description: "Learn more about us.",
                colour: .blue
            )
        )
    }
}
