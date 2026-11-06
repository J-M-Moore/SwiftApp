import SwiftUI

struct SubjectPage: View {

    @EnvironmentObject var session: AppSession

    var body: some View {

        Group {

            if let subject = session.userSubject {

                subjectContent(subject)

            } else {

                ContentUnavailableView(
                    "No Subject Assigned",
                    systemImage: "book.closed",
                    description: Text(
                        "There is no subject associated with your account."
                    )
                )
            }
        }
        .navigationTitle("My Subject")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subject content

    @ViewBuilder
    private func subjectContent(_ subject: Subject) -> some View {

        ScrollView {

            VStack(spacing: 22) {

                // Subject banner

                VStack(spacing: 15) {

                    Image(systemName: subject.icon)
                        .font(.system(size: 55))
                        .foregroundStyle(.white)

                    Text(subject.rawValue)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Your subject information")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 35)
                .background(

                    LinearGradient(
                        colors: [
                            subject.colour,
                            subject.colour.opacity(0.65)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // Subject description

                VStack(alignment: .leading, spacing: 12) {

                    Label(
                        "About your subject",
                        systemImage: "info.circle.fill"
                    )
                    .font(.headline)
                    .foregroundStyle(subject.colour)

                    Text(subject.description)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

                // Subject-specific information

                VStack(alignment: .leading, spacing: 15) {

                    Text("Your resources")
                        .font(.title2)
                        .bold()

                    resourceContent(for: subject)

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

                // Notice

                HStack(spacing: 10) {

                    Image(systemName: "bell.badge.fill")
                        .foregroundStyle(subject.colour)

                    Text(
                        "Subject announcements and updates will appear here."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(subject.colour.opacity(0.10))
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }

    // MARK: - Subject resources

    @ViewBuilder
    private func resourceContent(for subject: Subject) -> some View {

        switch subject {

        case .biology:

            resourceRow(
                icon: "leaf.fill",
                title: "Biology Study Materials",
                description: "Notes, diagrams and study resources."
            )

            resourceRow(
                icon: "microscope",
                title: "Laboratory Information",
                description: "Practical sessions and laboratory guidance."
            )

            resourceRow(
                icon: "tree.fill",
                title: "Field Studies",
                description: "Information about upcoming field activities."
            )

        case .chemistry:

            resourceRow(
                icon: "flask.fill",
                title: "Chemistry Study Materials",
                description: "Notes, formulas and revision resources."
            )

            resourceRow(
                icon: "testtube.2",
                title: "Laboratory Information",
                description: "Practical sessions and laboratory guidance."
            )

            resourceRow(
                icon: "atom",
                title: "Experiments",
                description: "Information about chemistry experiments."
            )

        case .computerScience:

            resourceRow(
                icon: "laptopcomputer",
                title: "Programming Resources",
                description: "Programming guides and learning materials."
            )

            resourceRow(
                icon: "desktopcomputer",
                title: "Computing Facilities",
                description: "Information about computer facilities."
            )

            resourceRow(
                icon: "chevron.left.forwardslash.chevron.right",
                title: "Development Projects",
                description: "Course projects and coding resources."
            )
        }
    }

    // MARK: - Resource row

    private func resourceRow(
        icon: String,
        title: String,
        description: String
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue.gradient)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}
