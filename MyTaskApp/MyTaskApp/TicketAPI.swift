import Foundation

// MARK: - Ticket submission model

struct TicketSubmission: Encodable {

    let title: String
    let description: String
    let location: String
    let category: String
    let priority: String

    let submittedById: String
    let submittedByName: String

    enum CodingKeys: String, CodingKey {

        case title
        case description
        case location
        case category
        case priority

        case submittedById = "submitted_by_id"
        case submittedByName = "submitted_by_name"
    }
}


// MARK: - Ticket response model

struct TicketResponse: Codable, Identifiable {

    let id: Int
    let reference: String
    let title: String
    let description: String
    let location: String
    let category: String
    let priority: String
    let status: String

    let submittedById: String
    let submittedByName: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {

        case id
        case reference
        case title
        case description
        case location
        case category
        case priority
        case status

        case submittedById = "submitted_by_id"
        case submittedByName = "submitted_by_name"
        case createdAt = "created_at"
    }
}


// MARK: - Ticket API errors

enum TicketAPIError: LocalizedError {

    case invalidResponse
    case serverError(String)

    var errorDescription: String? {

        switch self {

        case .invalidResponse:
            return "The server returned an invalid response."

        case .serverError(let message):
            return message
        }
    }
}


// MARK: - Ticket API

struct TicketAPI {

    static let baseURL = "http://127.0.0.1:8000"


    // Submit a ticket

    static func submit(
        _ ticket: TicketSubmission
    ) async throws -> TicketResponse {

        guard let url = URL(
            string: "\(baseURL)/tickets"
        ) else {

            throw TicketAPIError.invalidResponse
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.timeoutInterval = 15

        request.httpBody = try JSONEncoder().encode(ticket)

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse else {

            throw TicketAPIError.invalidResponse
        }

        guard httpResponse.statusCode == 201 else {

            let message = String(
                data: data,
                encoding: .utf8
            ) ?? "Unable to submit ticket."

            throw TicketAPIError.serverError(message)
        }

        return try JSONDecoder().decode(
            TicketResponse.self,
            from: data
        )
    }


    // Retrieve all tickets

    static func getTickets() async throws -> [TicketResponse] {

        guard let url = URL(
            string: "\(baseURL)/tickets"
        ) else {

            throw TicketAPIError.invalidResponse
        }

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {

            throw TicketAPIError.invalidResponse
        }

        return try JSONDecoder().decode(
            [TicketResponse].self,
            from: data
        )
    }


    // Update a ticket's status

    static func updateStatus(
        ticketId: Int,
        status: String
    ) async throws -> TicketResponse {

        guard let url = URL(
            string: "\(baseURL)/tickets/\(ticketId)/status"
        ) else {

            throw TicketAPIError.invalidResponse
        }

        var request = URLRequest(url: url)

        request.httpMethod = "PATCH"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let body = [
            "status": status
        ]

        request.httpBody = try JSONSerialization.data(
            withJSONObject: body
        )

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {

            throw TicketAPIError.invalidResponse
        }

        return try JSONDecoder().decode(
            TicketResponse.self,
            from: data
        )
    }
}

