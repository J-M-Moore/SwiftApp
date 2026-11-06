import SwiftUI

// MARK: - Ticket categories

enum TicketCategory: String, CaseIterable, Identifiable {

    case it = "IT Support"
    case equipment = "Equipment"
    case maintenance = "Building Maintenance"
    case facilities = "Facilities"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {

        switch self {

        case .it:
            return "desktopcomputer"

        case .equipment:
            return "printer.fill"

        case .maintenance:
            return "wrench.fill"

        case .facilities:
            return "building.2.fill"

        case .other:
            return "ellipsis.circle.fill"
        }
    }
}


// MARK: - Ticket priority

enum TicketPriority: String, CaseIterable, Identifiable {

    case low = "Low"
    case normal = "Normal"
    case high = "High"
    case urgent = "Urgent"

    var id: String { rawValue }

    var colour: Color {

        switch self {

        case .low:
            return .green

        case .normal:
            return .blue

        case .high:
            return .orange

        case .urgent:
            return .red
        }
    }
}


// MARK: - Tickets page

struct TicketsPage: View {

    @EnvironmentObject var session: AppSession

    // Form fields

    @State private var category: TicketCategory = .it

    @State private var priority: TicketPriority = .normal

    @State private var location = ""
    @State private var subject = ""
    @State private var description = ""

    // Submission state

    @State private var isSubmitting = false

    @State private var showingConfirmation = false
    @State private var showingValidationError = false
    @State private var showingSubmissionError = false

    @State private var submittedTicketNumber = ""
    @State private var submissionError = ""


    // MARK: - Main layout

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 8) {

                    Text("IT & Maintenance")
                        .font(.system(
                            size: 32,
                            weight: .bold
                        ))

                    Text(
                        "Need something fixed? Let us know."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                introBanner

                ticketForm
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Support Tickets")
        .navigationBarTitleDisplayMode(.inline)

        // Confirmation alert

        .alert(
            "Ticket submitted!",
            isPresented: $showingConfirmation
        ) {

            Button("OK") {
                clearForm()
            }

        } message: {

            Text(
                "Your ticket has been successfully recorded. Your reference number is \(submittedTicketNumber)."
            )
        }

        // Validation alert

        .alert(
            "Missing information",
            isPresented: $showingValidationError
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(
                "Please complete all required fields before submitting."
            )
        }

        // Server error alert

        .alert(
            "Unable to Submit Ticket",
            isPresented: $showingSubmissionError
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(submissionError)
        }
    }


    // MARK: - Intro banner

    private var introBanner: some View {

        HStack(spacing: 15) {

            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 35))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 5) {

                Text("We're here to help!")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(
                    "Tell us about the issue and our team will look into it."
                )
                .font(.caption)
                .foregroundStyle(.white.opacity(0.9))
            }

            Spacer()
        }
        .padding()
        .background(

            LinearGradient(
                colors: [
                    .orange,
                    .pink
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }


    // MARK: - Ticket form

    private var ticketForm: some View {

        VStack(alignment: .leading, spacing: 20) {

            // Ticket category

            VStack(alignment: .leading, spacing: 12) {

                Text("What do you need help with?")
                    .font(.title2)
                    .bold()

                Picker(
                    "Category",
                    selection: $category
                ) {

                    ForEach(TicketCategory.allCases) { item in

                        Label(
                            item.rawValue,
                            systemImage: item.icon
                        )
                        .tag(item)
                    }
                }
                .pickerStyle(.menu)
                .tint(.orange)
            }

            Divider()

            // Priority

            VStack(alignment: .leading, spacing: 12) {

                Text("Priority")
                    .font(.title2)
                    .bold()

                Text(
                    "How urgently does this need attention?"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Picker(
                    "Priority",
                    selection: $priority
                ) {

                    ForEach(TicketPriority.allCases) { item in

                        Text(item.rawValue)
                            .tag(item)
                    }
                }
                .pickerStyle(.segmented)

                HStack(spacing: 6) {

                    Circle()
                        .fill(priority.colour)
                        .frame(width: 9, height: 9)

                    Text("\(priority.rawValue) priority selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Location and subject

            VStack(alignment: .leading, spacing: 12) {

                Text("Where is the problem?")
                    .font(.title2)
                    .bold()

                TextField(
                    "Room or building location",
                    text: $location
                )
                .textFieldStyle(.roundedBorder)

                TextField(
                    "Short summary",
                    text: $subject
                )
                .textFieldStyle(.roundedBorder)
            }

            Divider()

            // Description

            VStack(alignment: .leading, spacing: 12) {

                Text("Describe the problem")
                    .font(.title2)
                    .bold()

                Text(
                    "Please provide as much detail as possible."
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                TextEditor(text: $description)
                    .frame(minHeight: 130)
                    .padding(6)
                    .background(.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .overlay {

                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .stroke(
                            Color.gray.opacity(0.2),
                            lineWidth: 1
                        )
                    }
            }

            // Submit button

            Button {

                submitTicket()

            } label: {

                HStack {

                    if isSubmitting {

                        ProgressView()
                            .tint(.white)

                        Text("Submitting...")

                    } else {

                        Image(systemName: "paperplane.fill")

                        Text("Submit Ticket")
                            .bold()
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(

                    LinearGradient(
                        colors: [
                            .orange,
                            .pink
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
            }
            .disabled(isSubmitting)
            .opacity(isSubmitting ? 0.7 : 1)

            Text(
                "Your request will be sent to the support team."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }


    // MARK: - Submit ticket

    private func submitTicket() {

        let trimmedSubject = subject.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedDescription = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedLocation = location.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Validate form

        guard
            !trimmedSubject.isEmpty,
            !trimmedDescription.isEmpty
        else {

            showingValidationError = true
            return
        }

        // Check signed-in user

        guard let user = session.currentUser else {

            submissionError = "You must be signed in to submit a ticket."

            showingSubmissionError = true

            return
        }

        guard !isSubmitting else {
            return
        }

        isSubmitting = true

        // Create ticket

        let ticket = TicketSubmission(

            title: trimmedSubject,

            description: trimmedDescription,

            location: trimmedLocation,

            category: category.rawValue,

            priority: priority.rawValue,

            submittedById: user.id,

            submittedByName: user.name
        )

        // Send to Python backend

        Task {

            do {

                let response = try await TicketAPI.submit(ticket)

                submittedTicketNumber = response.reference

                isSubmitting = false

                showingConfirmation = true

            } catch {

                isSubmitting = false

                submissionError = error.localizedDescription

                showingSubmissionError = true
            }
        }
    }


    // MARK: - Clear form

    private func clearForm() {

        category = .it
        priority = .normal
        location = ""
        subject = ""
        description = ""
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {
        TicketsPage()
            .environmentObject(AppSession())
    }
}

