import SwiftUI

struct LoginPage: View {

    @EnvironmentObject var session: AppSession

    @State private var email = ""
    @State private var password = ""

    @State private var showingError = false
    @State private var errorMessage = ""

    @State private var showingTestAccounts = false

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 28) {

                    Spacer(minLength: 35)

                    // MARK: - App branding

                    VStack(spacing: 15) {

                        ZStack {

                            RoundedRectangle(
                                cornerRadius: 25
                            )
                            .fill(

                                LinearGradient(
                                    colors: [
                                        .blue,
                                        .purple,
                                        .pink
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                            Image(systemName: "sparkles")
                                .font(.system(size: 55))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 105, height: 105)
                        .shadow(
                            color: .purple.opacity(0.25),
                            radius: 15,
                            y: 8
                        )

                        Text("Welcome Back")
                            .font(.system(
                                size: 32,
                                weight: .bold
                            ))

                        Text("Sign in to access your account")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // MARK: - Login form

                    VStack(alignment: .leading, spacing: 18) {

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Email Address")
                                .font(.headline)

                            TextField(
                                "Enter your email",
                                text: $email
                            )
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Password")
                                .font(.headline)

                            SecureField(
                                "Enter your password",
                                text: $password
                            )
                            .textContentType(.password)
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }

                        // MARK: - Sign in button

                        Button {

                            signIn()

                        } label: {

                            Text("Sign In")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(

                                    LinearGradient(
                                        colors: [
                                            .blue,
                                            .purple
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )
                        }
                        .padding(.top, 5)
                    }
                    .padding(22)
                    .background(.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 12,
                        y: 5
                    )

                    // MARK: - Test accounts

                    Button {

                        showingTestAccounts = true

                    } label: {

                        HStack(spacing: 8) {

                            Image(systemName: "person.2.fill")

                            Text("View Demo Accounts")
                                .font(.subheadline)
                                .bold()
                        }
                        .foregroundStyle(.purple)
                    }

                    Text("Your account gives you access to the features available for your role.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Spacer(minLength: 25)
                }
                .padding()
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)

            // MARK: - Error alert

            .alert(
                "Unable to sign in",
                isPresented: $showingError
            ) {

                Button("OK", role: .cancel) {}

            } message: {

                Text(errorMessage)
            }

            // MARK: - Demo account selector

            .sheet(isPresented: $showingTestAccounts) {

                demoAccountSheet
            }
        }
    }

    // MARK: - Sign in function

    private func signIn() {

        let enteredEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Temporary demo authentication

        guard let user = AppUser.testAccounts.first(
            where: {
                $0.email.caseInsensitiveCompare(
                    enteredEmail
                ) == .orderedSame
            }
        ) else {

            errorMessage = "We couldn't find that demo account."
            showingError = true
            return
        }

        // Demo-only password

        guard password == "demo123" else {

            errorMessage = "Incorrect demo password. Please try again."
            showingError = true
            return
        }

        // Sign in

        session.signIn(user: user)
    }

    // MARK: - Demo accounts sheet

    private var demoAccountSheet: some View {

        NavigationStack {

            List {

                Section {

                    Text(
                        "Choose an account to test different user permissions and subjects."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                }

                Section("Available demo accounts") {

                    ForEach(AppUser.testAccounts) { user in

                        Button {

                            email = user.email
                            password = "demo123"

                            showingTestAccounts = false

                        } label: {

                            HStack(spacing: 12) {

                                Image(systemName: user.subject?.icon ?? user.role.icon)
                                    .font(.title2)
                                    .foregroundStyle(
                                        user.subject?.colour ?? user.role.colour
                                    )
                                    .frame(width: 42)

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(user.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(user.role.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(user.role.colour)

                                    if let subject = user.subject {

                                        Text("Subject: \(subject.rawValue)")
                                            .font(.caption)
                                            .foregroundStyle(subject.colour)

                                    }

                                    Text(user.email)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

                Section("Demo password") {

                    HStack {

                        Text("Password")

                        Spacer()

                        Text("demo123")
                            .font(.monospaced(.body)())
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Demo Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Done") {
                        showingTestAccounts = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

}

// MARK: - Preview

#Preview {

    LoginPage()
        .environmentObject(AppSession())
}

