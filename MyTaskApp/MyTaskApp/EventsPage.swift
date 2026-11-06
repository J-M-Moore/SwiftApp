import SwiftUI

// MARK: - Event data model

struct AppEvent: Identifiable {

    let id = UUID()

    let title: String
    let date: Date
    let time: String
    let location: String
    let description: String
    let colour: Color
    let audience: EventAudience
}

// MARK: - Events page

struct EventsPage: View {
    
    @EnvironmentObject var session: AppSession

    @State private var displayedMonth = Calendar.current
        .dateInterval(
            of: .month,
            for: Date()
        )!.start

    @State private var selectedDate = Calendar.current
        .startOfDay(for: Date())

    private let calendar = Calendar.current

    // MARK: - Sample events

    // These will eventually come from our Python backend.

    private var events: [AppEvent] {

        let start = displayedMonth

        func eventDate(_ day: Int) -> Date {

            calendar.date(
                byAdding: .day,
                value: day - 1,
                to: start
            ) ?? start
        }

        return [

            // MARK: General events

            AppEvent(
                title: "Community Meeting",
                date: eventDate(3),
                time: "10:00 AM",
                location: "Community Centre",
                description: """
                Join us for our regular community meeting.

                Meet other members, share ideas and hear
                about the latest developments.
                """,
                colour: .blue,
                audience: .general
            ),

            AppEvent(
                title: "Special Event",
                date: eventDate(8),
                time: "2:00 PM",
                location: "Main Hall",
                description: """
                An exciting special event!

                More information about this event will
                be announced shortly.
                """,
                colour: .purple,
                audience: .general
            ),

            AppEvent(
                title: "Open Day",
                date: eventDate(15),
                time: "11:00 AM",
                location: "Our Centre",
                description: """
                Come along to our open day.

                Everyone is welcome. Find out more about
                what we do and meet the team.
                """,
                colour: .orange,
                audience: .general
            ),

            // MARK: Biology events

            AppEvent(
                title: "Biology Laboratory Session",
                date: eventDate(5),
                time: "9:30 AM",
                location: "Biology Laboratory",
                description: """
                A practical biology session.

                Explore laboratory techniques and microscopy.
                """,
                colour: .green,
                audience: .subject(.biology)
            ),

            AppEvent(
                title: "Ecology Field Trip",
                date: eventDate(12),
                time: "10:00 AM",
                location: "Nature Reserve",
                description: """
                An opportunity to explore ecology
                and environmental research.
                """,
                colour: .green,
                audience: .subject(.biology)
            ),

            // MARK: Chemistry events

            AppEvent(
                title: "Chemistry Practical",
                date: eventDate(5),
                time: "1:00 PM",
                location: "Chemistry Laboratory",
                description: """
                Practical chemistry experiments
                and chemical analysis.
                """,
                colour: .orange,
                audience: .subject(.chemistry)
            ),

            AppEvent(
                title: "Chemistry Guest Lecture",
                date: eventDate(12),
                time: "2:00 PM",
                location: "Lecture Theatre 2",
                description: """
                A guest lecture exploring modern
                chemical research.
                """,
                colour: .orange,
                audience: .subject(.chemistry)
            ),

            // MARK: Computer Science events

            AppEvent(
                title: "Programming Workshop",
                date: eventDate(5),
                time: "10:00 AM",
                location: "Computer Suite",
                description: """
                An interactive programming workshop.

                Develop your coding and software skills.
                """,
                colour: .indigo,
                audience: .subject(.computerScience)
            ),

            AppEvent(
                title: "Computing Project Showcase",
                date: eventDate(18),
                time: "3:00 PM",
                location: "Technology Centre",
                description: """
                Discover software projects developed
                by students.
                """,
                colour: .indigo,
                audience: .subject(.computerScience)
            ),

            // MARK: Staff events

            AppEvent(
                title: "Staff Training",
                date: eventDate(10),
                time: "9:00 AM",
                location: "Meeting Room A",
                description: """
                Internal staff training and
                professional development.
                """,
                colour: .pink,
                audience: .staff
            ),

            // MARK: IT events

            AppEvent(
                title: "IT Systems Maintenance",
                date: eventDate(20),
                time: "6:00 PM",
                location: "IT Department",
                description: """
                Scheduled IT systems maintenance
                and infrastructure updates.
                """,
                colour: .red,
                audience: .itSupport
            )
        ]
    }

    // MARK: - Filter events for current user

    private var visibleEvents: [AppEvent] {

        guard let user = session.currentUser else {
            return []
        }

        return events.filter { event in

            switch user.role {

            case .administrator:
                return true

            case .standard:
                return event.audience == .general

            case .staff:
                return event.audience == .general ||
                       event.audience == .staff

            case .itSupport:
                return event.audience == .general ||
                       event.audience == .itSupport

            case .student:

                if event.audience == .general {
                    return true
                }

                if case .subject(let eventSubject) = event.audience {
                    return user.subject == eventSubject
                }

                return false
            }
        }
    }


    // MARK: - Calendar calculations

    private var calendarDays: [Date?] {

        guard let range = calendar.range(
            of: .day,
            in: .month,
            for: displayedMonth
        ) else {
            return []
        }

        let firstWeekday = calendar.component(
            .weekday,
            from: displayedMonth
        )

        let offset = (
            firstWeekday - calendar.firstWeekday + 7
        ) % 7

        var days: [Date?] = Array(
            repeating: nil,
            count: offset
        )

        for day in range {

            let date = calendar.date(
                byAdding: .day,
                value: day - 1,
                to: displayedMonth
            )!

            days.append(date)
        }

        return days
    }

    // Use the device's preferred first day of the week.

    private var weekdayNames: [String] {

        let symbols = calendar.veryShortStandaloneWeekdaySymbols

        let offset = calendar.firstWeekday - 1

        return Array(symbols[offset...]) +
               Array(symbols[..<offset])
    }

    // Events belonging to the selected day.

    private var selectedEvents: [AppEvent] {

        visibleEvents.filter {
            calendar.isDate(
                $0.date,
                inSameDayAs: selectedDate
            )
        }
    }

    // MARK: - Main layout

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 8) {

                    Text("Upcoming Events")
                        .font(.system(
                            size: 32,
                            weight: .bold
                        ))

                    Text(
                        "See what's happening and when."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Calendar

                calendarView

                // Selected date's events

                eventsList

            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Calendar view

    private var calendarView: some View {

        VStack(spacing: 18) {

            // Month navigation

            HStack {

                Button {
                    changeMonth(by: -1)
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .frame(width: 40, height: 40)
                }

                Spacer()

                Text(
                    displayedMonth.formatted(
                        .dateTime.month(.wide).year()
                    )
                )
                .font(.title2)
                .bold()

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {

                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .frame(width: 40, height: 40)
                }
            }

            // Weekday headings

            LazyVGrid(
                columns: sevenColumns
            ) {

                ForEach(
                    Array(weekdayNames.enumerated()),
                    id: \.offset
                ) { _, day in

                    Text(day)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar dates

            LazyVGrid(
                columns: sevenColumns,
                spacing: 10
            ) {

                ForEach(
                    Array(calendarDays.enumerated()),
                    id: \.offset
                ) { _, date in

                    if let date = date {

                        calendarDayButton(date)

                    } else {

                        Color.clear
                            .frame(height: 43)
                    }
                }
            }

            // Calendar legend

            
            HStack(spacing: 12) {

                legendItem(
                    colour: .blue,
                    title: "General"
                )

                legendItem(
                    colour: .green,
                    title: "Subject"
                )

                Spacer()

                legendItem(
                    colour: .pink,
                    title: "Staff"
                )
            }
            .padding(.top, 5)
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 8,
            y: 3
        )
    }

    private var sevenColumns: [GridItem] {

        Array(
            repeating: GridItem(.flexible()),
            count: 7
        )
    }

    // MARK: - Individual calendar day

    private func calendarDayButton(
        _ date: Date
    ) -> some View {

        let isSelected = calendar.isDate(
            date,
            inSameDayAs: selectedDate
        )

        let dayEvents = visibleEvents.filter {
            calendar.isDate(
                $0.date,
                inSameDayAs: date
            )
        }

        return Button {

            selectedDate = date

        } label: {


            VStack(spacing: 5) {

                Text(
                    date.formatted(
                        .dateTime.day()
                    )
                )
                .font(.subheadline)
                .bold()

                HStack(spacing: 3) {

                    ForEach(
                        Array(dayEvents.prefix(3).enumerated()),
                        id: \.offset
                    ) { _, event in

                        Circle()
                            .fill(event.audience.colour)
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 43)
            .background(
                isSelected
                ? Color.blue
                : Color.clear
            )
            .foregroundStyle(
                isSelected
                ? Color.white
                : Color.primary
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10
                )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Events list

    private var eventsList: some View {

        VStack(alignment: .leading, spacing: 15) {

            Text(
                selectedDate.formatted(
                    .dateTime
                        .weekday(.wide)
                        .day()
                        .month(.wide)
                )
            )
            .font(.title2)
            .bold()

            if selectedEvents.isEmpty {

                VStack(spacing: 10) {

                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 35))
                        .foregroundStyle(.secondary)

                    Text("No events scheduled")
                        .font(.headline)

                    Text(
                        "There are currently no events for this day."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

            } else {

                ForEach(selectedEvents) { event in

                    NavigationLink {

                        EventDetailPage(event: event)

                    } label: {

                        eventCard(event)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Event card

    private func eventCard(
        _ event: AppEvent
    ) -> some View {

        HStack(spacing: 14) {

            // Category colour indicator

            RoundedRectangle(cornerRadius: 4)
                .fill(event.audience.colour)
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 9) {

                // Event title

                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                // Audience badge

                HStack(spacing: 5) {

                    Image(systemName: event.audience.icon)

                    Text(event.audience.displayName)
                }
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(event.audience.colour)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    event.audience.colour.opacity(0.12)
                )
                .clipShape(Capsule())

                // Event time

                Label(
                    event.time,
                    systemImage: "clock"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                // Event location

                Label(
                    event.location,
                    systemImage: "mappin.and.ellipse"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 6,
            y: 3
        )
    }

    // MARK: - Month navigation

    private func changeMonth(by amount: Int) {

        guard let newMonth = calendar.date(
            byAdding: .month,
            value: amount,
            to: displayedMonth
        ) else {
            return
        }

        displayedMonth = newMonth

        selectedDate = newMonth
    }
}

// MARK: - Event detail page

struct EventDetailPage: View {

    let event: AppEvent

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                // Colourful event header

                ZStack {

                    LinearGradient(
                        colors: [
                            event.colour,
                            event.colour.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: "calendar")
                        .font(.system(size: 65))
                        .foregroundStyle(.white)
                }
                .frame(height: 200)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

                // Event title

                Text(event.title)
                    .font(.largeTitle)
                    .bold()

                // Event date

                Label(
                    event.date.formatted(
                        .dateTime
                            .weekday(.wide)
                            .day()
                            .month(.wide)
                            .year()
                    ),
                    systemImage: "calendar"
                )

                // Event time

                Label(
                    event.time,
                    systemImage: "clock"
                )

                // Event location

                Label(
                    event.location,
                    systemImage: "mappin.and.ellipse"
                )

                Divider()

                // Description

                Text("About this event")
                    .font(.title2)
                    .bold()

                Text(event.description)
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
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EventsPage()
    }
}

private func legendItem(
    colour: Color,
    title: String
) -> some View {

    HStack(spacing: 5) {

        Circle()
            .fill(colour)
            .frame(width: 7, height: 7)

        Text(title)
            .font(.caption2)
            .foregroundStyle(.secondary)
    }
}

