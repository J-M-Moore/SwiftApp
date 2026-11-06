import SwiftUI

// MARK: - Room model

struct BookableRoom: Identifiable {

    let id: String
    let name: String
    let capacity: Int
    let facilities: String
}

// MARK: - Booking model

struct RoomBooking: Identifiable {

    let id = UUID()

    let roomName: String
    let date: Date
    let time: String
    let bookedBy: String
    let purpose: String
}

// MARK: - Room bookings page

struct RoomBookingsPage: View {

    // Available rooms

    private let rooms = [

        BookableRoom(
            id: "room_a",
            name: "Meeting Room A",
            capacity: 8,
            facilities: "Projector, whiteboard"
        ),

        BookableRoom(
            id: "room_b",
            name: "Meeting Room B",
            capacity: 12,
            facilities: "Screen, video conferencing"
        ),

        BookableRoom(
            id: "room_c",
            name: "Conference Room",
            capacity: 20,
            facilities: "Projector, microphone, large screen"
        ),

        BookableRoom(
            id: "room_d",
            name: "Training Room",
            capacity: 15,
            facilities: "Computers, projector"
        )
    ]

    // Available hourly booking slots

    private let timeSlots = [
        "09:00 AM",
        "10:00 AM",
        "11:00 AM",
        "12:00 PM",
        "01:00 PM",
        "02:00 PM",
        "03:00 PM",
        "04:00 PM"
    ]

    // MARK: - Page state

    @State private var selectedRoomID = "room_a"

    @State private var selectedDate = Date()

    @State private var bookings: [RoomBooking] =
        RoomBooking.sampleBookings

    @State private var selectedTime: String?

    @State private var showingBookingForm = false

    @State private var showingConfirmation = false

    // Selected room

    private var selectedRoom: BookableRoom {

        rooms.first {
            $0.id == selectedRoomID
        } ?? rooms[0]
    }

    // MARK: - Main layout

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 22) {

                // Heading

                VStack(alignment: .leading, spacing: 8) {

                    Text("Room Bookings")
                        .font(.system(
                            size: 32,
                            weight: .bold
                        ))

                    Text(
                        "Find and book an available room."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                // Room selection

                roomSelector

                // Selected room information

                roomInformation

                // Date selection

                dateSelector

                // Availability legend

                availabilityLegend

                // Booking schedule

                bookingSchedule

            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Room Bookings")
        .navigationBarTitleDisplayMode(.inline)

        // Booking form

        .sheet(isPresented: $showingBookingForm) {

            BookingFormView(
                room: selectedRoom,
                date: selectedDate,
                time: selectedTime ?? "09:00 AM"
            ) { name, purpose in

                createBooking(
                    name: name,
                    purpose: purpose,
                    time: selectedTime ?? "09:00 AM"
                )
            }
        }

        // Booking confirmation

        .alert(
            "Booking successful!",
            isPresented: $showingConfirmation
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(
                "Your sample booking has been added to the schedule."
            )
        }
    }

    // MARK: - Room selector

    private var roomSelector: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Select a room")
                .font(.headline)

            Menu {

                ForEach(rooms) { room in

                    Button {

                        selectedRoomID = room.id

                    } label: {

                        if selectedRoomID == room.id {

                            Label(
                                room.name,
                                systemImage: "checkmark"
                            )

                        } else {

                            Text(room.name)
                        }
                    }
                }

            } label: {

                HStack {

                    Image(systemName: "door.left.hand.open")
                        .foregroundStyle(.teal)

                    Text(selectedRoom.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.background)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
            }
        }
    }

    // MARK: - Room information

    private var roomInformation: some View {

        HStack(spacing: 15) {

            Image(systemName: "person.3.fill")
                .font(.title2)
                .foregroundStyle(.teal)
                .frame(width: 48, height: 48)
                .background(
                    Color.teal.opacity(0.12)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )

            VStack(alignment: .leading, spacing: 5) {

                Text("Capacity: \(selectedRoom.capacity) people")
                    .font(.headline)

                Text(selectedRoom.facilities)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }

    // MARK: - Date selector

    private var dateSelector: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Select a date")
                .font(.headline)

            DatePicker(
                "Booking date",
                selection: $selectedDate,
                in: Date.distantPast...,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding()
            .background(.background)
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }

    // MARK: - Availability legend

    private var availabilityLegend: some View {

        HStack(spacing: 18) {

            HStack(spacing: 6) {

                Circle()
                    .fill(.green)
                    .frame(width: 9, height: 9)

                Text("Available")
                    .font(.caption)
            }

            HStack(spacing: 6) {

                Circle()
                    .fill(.red)
                    .frame(width: 9, height: 9)

                Text("Booked")
                    .font(.caption)
            }

            Spacer()
        }
        .foregroundStyle(.secondary)
    }

    // MARK: - Booking schedule

    private var bookingSchedule: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("Daily availability")
                .font(.title2)
                .bold()

            Text(
                selectedDate.formatted(
                    .dateTime.weekday(.wide)
                        .day()
                        .month(.wide)
                        .year()
                )
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            ForEach(timeSlots, id: \.self) { time in

                let booking = bookingFor(time: time)

                bookingSlot(
                    time: time,
                    booking: booking
                )
            }
        }
    }

    // Find an existing booking for a particular slot

    private func bookingFor(
        time: String
    ) -> RoomBooking? {

        bookings.first {

            $0.roomName == selectedRoom.id &&
            $0.time == time &&
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: selectedDate
            )
        }
    }

    // MARK: - Individual booking slot

    private func bookingSlot(
        time: String,
        booking: RoomBooking?
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: "clock")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 5) {

                Text(time)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let booking = booking {

                    Text("Booked by \(booking.bookedBy)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(booking.purpose)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                } else {

                    Text("Available")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }

            Spacer()

            if booking == nil {

                Button {

                    selectedTime = time
                    showingBookingForm = true

                } label: {

                    Text("Book")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(.teal)
                        .clipShape(Capsule())
                }

            } else {

                Image(systemName: "lock.fill")
                    .foregroundStyle(.red)
                    .padding(.trailing, 8)
            }
        }
        .padding()
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
    }

    // MARK: - Create a booking

    private func createBooking(
        name: String,
        purpose: String,
        time: String
    ) {

        // Avoid duplicate bookings for the same slot.

        guard bookingFor(time: time) == nil else {
            return
        }

        let booking = RoomBooking(
            roomName: selectedRoom.id,
            date: selectedDate,
            time: time,
            bookedBy: name,
            purpose: purpose
        )

        bookings.append(booking)

        showingBookingForm = false

        showingConfirmation = true
    }
}

// MARK: - Sample booking data

extension RoomBooking {

    static var sampleBookings: [RoomBooking] {

        let today = Calendar.current.startOfDay(
            for: Date()
        )

        return [

            RoomBooking(
                roomName: "room_a",
                date: today,
                time: "10:00 AM",
                bookedBy: "Sarah",
                purpose: "Team meeting"
            ),

            RoomBooking(
                roomName: "room_a",
                date: today,
                time: "12:00 PM",
                bookedBy: "James",
                purpose: "Project discussion"
            ),

            RoomBooking(
                roomName: "room_b",
                date: today,
                time: "09:00 AM",
                bookedBy: "Emily",
                purpose: "Client meeting"
            ),

            RoomBooking(
                roomName: "room_b",
                date: today,
                time: "02:00 PM",
                bookedBy: "David",
                purpose: "Training session"
            ),

            RoomBooking(
                roomName: "room_c",
                date: today,
                time: "11:00 AM",
                bookedBy: "Michael",
                purpose: "Department meeting"
            )
        ]
    }
}

// MARK: - Booking form

struct BookingFormView: View {

    let room: BookableRoom
    let date: Date
    let time: String

    let onSubmit: (String, String) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var purpose = ""

    var body: some View {

        NavigationStack {

            Form {

                Section("Booking details") {

                    LabeledContent(
                        "Room",
                        value: room.name
                    )

                    LabeledContent(
                        "Date",
                        value: date.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )

                    LabeledContent(
                        "Time",
                        value: time
                    )
                }

                Section("Your information") {

                    TextField(
                        "Your name",
                        text: $name
                    )

                    TextField(
                        "Purpose of booking",
                        text: $purpose,
                        axis: .vertical
                    )
                    .lineLimit(3...5)
                }

                Section {

                    Button {

                        onSubmit(
                            name.trimmingCharacters(
                                in: .whitespaces
                            ),
                            purpose.trimmingCharacters(
                                in: .whitespaces
                            )
                        )

                    } label: {

                        HStack {

                            Spacer()

                            Text("Confirm booking")
                                .bold()

                            Spacer()
                        }
                    }
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespaces
                        ).isEmpty ||
                        purpose.trimmingCharacters(
                            in: .whitespaces
                        ).isEmpty
                    )
                }
            }
            .navigationTitle("New Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {
        RoomBookingsPage()
    }
}

