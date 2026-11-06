import SwiftUI

// MARK: - IT Dashboard

struct ITDashboard: View {

    @State private var tickets: [TicketResponse] = []

    @State private var isLoading = false

    @State private var errorMessage = ""

    @State private var showingError = false
    
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    
    private let filters = [
        "All",
        "Open",
        "In Progress",
        "Resolved",
        "Closed"
    ]

    // MARK: - Ticket statistics

    private var openCount: Int {
        tickets.filter { $0.status == "Open" }.count
    }

    private var progressCount: Int {
        tickets.filter { $0.status == "In Progress" }.count
    }

    private var resolvedCount: Int {
        tickets.filter { $0.status == "Resolved" }.count
    }
    
    private var filteredTickets: [TicketResponse] {

        tickets.filter { ticket in

            let matchesStatus =
                selectedFilter == "All" ||
                ticket.status == selectedFilter

            let query = searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            let matchesSearch =
                query.isEmpty ||
                ticket.reference.localizedCaseInsensitiveContains(query) ||
                ticket.title.localizedCaseInsensitiveContains(query) ||
                ticket.submittedByName.localizedCaseInsensitiveContains(query) ||
                ticket.category.localizedCaseInsensitiveContains(query)

            return matchesStatus && matchesSearch
        }
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 8) {

                    Text("IT Support")
                        .font(.system(
                            size: 32,
                            weight: .bold
                        ))

                    Text("Manage and monitor support requests.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Statistics

                statisticsGrid
                
                searchBar

                filterSection

                // Tickets

                if isLoading && tickets.isEmpty {

                    ProgressView("Loading tickets...")
                        .frame(maxWidth: .infinity)
                        .padding()

                } else if filteredTickets.isEmpty {

                    emptyState

                } else {

                    VStack(spacing: 12) {
                        
                        HStack {

                            Text("Support Tickets")
                                .font(.title2)
                                .bold()

                            Spacer()

                            Text("\(filteredTickets.count) found")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button {

                                Task {
                                    await loadTickets()
                                }

                            } label: {

                                Image(systemName: "arrow.clockwise")
                                    .foregroundStyle(.blue)
                            }
                            .padding(.leading, 5)
                        }

                        ForEach(filteredTickets) { ticket in

                            NavigationLink {

                                TicketDetailPage(
                                    ticket: ticket
                                ) {

                                    await loadTickets()
                                }

                            } label: {

                                ticketCard(ticket)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("IT Dashboard")
        .navigationBarTitleDisplayMode(.inline)

        .task {
            await loadTickets()
        }

        .refreshable {
            await loadTickets()
        }

        .alert(
            "Unable to Load Tickets",
            isPresented: $showingError
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(errorMessage)
        }
    }
    
    
    // MARK: - Search bar

    private var searchBar: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search tickets, users or references...",
                text: $searchText
            )
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if !searchText.isEmpty {

                Button {

                    searchText = ""

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    

    // MARK: - Status filters

    private var filterSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Filter by status")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 8) {

                    ForEach(filters, id: \.self) { filter in

                        Button {

                            selectedFilter = filter

                        } label: {

                            Text(filter)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 9)
                                .foregroundStyle(
                                    selectedFilter == filter
                                    ? .white
                                    : .primary
                                )
                                .background(
                                    selectedFilter == filter
                                    ? Color.blue
                                    : Color(.secondarySystemBackground)
                                )
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }


    // MARK: - Statistics grid

    private var statisticsGrid: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {

            statisticCard(
                title: "Total Tickets",
                value: tickets.count,
                icon: "tray.full.fill",
                colour: .blue
            )

            statisticCard(
                title: "Open",
                value: openCount,
                icon: "exclamationmark.circle.fill",
                colour: .orange
            )

            statisticCard(
                title: "In Progress",
                value: progressCount,
                icon: "clock.fill",
                colour: .purple
            )

            statisticCard(
                title: "Resolved",
                value: resolvedCount,
                icon: "checkmark.circle.fill",
                colour: .green
            )
        }
    }


    // MARK: - Individual statistic card

    private func statisticCard(
        title: String,
        value: Int,
        icon: String,
        colour: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(colour)

            Text("\(value)")
                .font(.system(
                    size: 30,
                    weight: .bold
                ))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }


    // MARK: - Ticket card

    private func ticketCard(
        _ ticket: TicketResponse
    ) -> some View {

        HStack(spacing: 12) {

            RoundedRectangle(cornerRadius: 4)
                .fill(statusColour(ticket.status))
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 7) {

                Text(ticket.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(
                    "\(ticket.reference) · \(ticket.submittedByName)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(ticket.category)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {

                statusBadge(ticket.status)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 5,
            y: 2
        )
    }


    // MARK: - Status badge

    private func statusBadge(
        _ status: String
    ) -> some View {

        Text(status)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(statusColour(status))
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(
                statusColour(status).opacity(0.12)
            )
            .clipShape(Capsule())
    }


    // MARK: - Status colours

    private func statusColour(
        _ status: String
    ) -> Color {

        switch status {

        case "Open":
            return .orange

        case "In Progress":
            return .purple

        case "Awaiting Response":
            return .blue

        case "Resolved", "Closed":
            return .green

        default:
            return .gray
        }
    }


    // MARK: - Empty state

    private var emptyState: some View {

        VStack(spacing: 12) {

            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(
                searchText.isEmpty && selectedFilter == "All"
                ? "No tickets yet"
                : "No matching tickets"
            )
            .font(.headline)

            Text(
                searchText.isEmpty && selectedFilter == "All"
                ? "New support requests will appear here."
                : "Try changing your search or status filter."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 35)
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }


    // MARK: - Load tickets

    @MainActor
    private func loadTickets() async {

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            tickets = try await TicketAPI.getTickets()

        } catch {

            errorMessage = error.localizedDescription

            showingError = true
        }
    }
}


// MARK: - Ticket detail page

struct TicketDetailPage: View {

    let ticket: TicketResponse

    let onUpdate: () async -> Void

    @State private var selectedStatus = ""

    @State private var isUpdating = false

    @State private var showingError = false

    @State private var errorMessage = ""

    private let statuses = [
        "Open",
        "In Progress",
        "Awaiting Response",
        "Resolved",
        "Closed"
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Ticket heading

                VStack(alignment: .leading, spacing: 8) {

                    Text(ticket.title)
                        .font(.largeTitle)
                        .bold()

                    Text(ticket.reference)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Current status

                VStack(alignment: .leading, spacing: 10) {

                    Text("Current Status")
                        .font(.headline)

                    Text(ticket.status)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

                // Ticket information

                VStack(alignment: .leading, spacing: 15) {

                    Text("Ticket Information")
                        .font(.title2)
                        .bold()

                    detailRow(
                        "Category",
                        value: ticket.category,
                        icon: "folder"
                    )

                    detailRow(
                        "Priority",
                        value: ticket.priority,
                        icon: "flag"
                    )

                    detailRow(
                        "Location",
                        value: ticket.location.isEmpty
                            ? "Not specified"
                            : ticket.location,
                        icon: "mappin.and.ellipse"
                    )

                    Divider()

                    Text("Submitted By")
                        .font(.headline)

                    detailRow(
                        "Name",
                        value: ticket.submittedByName,
                        icon: "person"
                    )

                    detailRow(
                        "User ID",
                        value: ticket.submittedById,
                        icon: "person.text.rectangle"
                    )
                }
                .padding()
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

                // Description

                VStack(alignment: .leading, spacing: 12) {

                    Text("Description")
                        .font(.title2)
                        .bold()

                    Text(ticket.description)
                        .lineSpacing(5)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

                // Update status

                VStack(alignment: .leading, spacing: 12) {

                    Text("Update Ticket Status")
                        .font(.title2)
                        .bold()

                    Picker(
                        "Status",
                        selection: $selectedStatus
                    ) {

                        ForEach(statuses, id: \.self) { status in

                            Text(status)
                                .tag(status)
                        }
                    }
                    .pickerStyle(.menu)

                    Button {

                        Task {
                            await updateStatus()
                        }

                    } label: {

                        HStack {

                            if isUpdating {

                                ProgressView()
                                    .tint(.white)

                            } else {

                                Image(systemName: "checkmark.circle.fill")
                            }

                            Text("Save Status")
                                .bold()
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .disabled(
                        isUpdating ||
                        selectedStatus == ticket.status
                    )
                }
                .padding()
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(ticket.reference)
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            selectedStatus = ticket.status
        }

        .alert(
            "Unable to Update Ticket",
            isPresented: $showingError
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(errorMessage)
        }
    }


    // MARK: - Detail row

    private func detailRow(
        _ title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack(spacing: 10) {

            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline)
            }
        }
    }


    // MARK: - Update status

    @MainActor
    private func updateStatus() async {

        isUpdating = true

        defer {
            isUpdating = false
        }

        do {

            _ = try await TicketAPI.updateStatus(
                ticketId: ticket.id,
                status: selectedStatus
            )

            await onUpdate()

        } catch {

            errorMessage = error.localizedDescription

            showingError = true
        }
    }
}

