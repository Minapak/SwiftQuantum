//
//  AuthenticationView.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/18.
//  Login, Sign Up, and Password Reset Views
//

import SwiftUI

// MARK: - Authentication View
struct AuthenticationView: View {
    @ObservedObject var authService = AuthService.shared
    @Environment(\.dismiss) var dismiss

    @State private var authMode: AuthMode = .login
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false

    enum AuthMode {
        case login
        case signUp
        case forgotPassword
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Logo
                        logoSection

                        // Form
                        switch authMode {
                        case .login:
                            loginForm
                        case .signUp:
                            signUpForm
                        case .forgotPassword:
                            forgotPasswordForm
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "atom")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("SwiftQuantum")
                .font(.title.bold())
                .foregroundColor(.white)

            Text(authMode == .login ? "Welcome Back" :
                 authMode == .signUp ? "Create Account" : "Reset Password")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 40)
    }

    // MARK: - Login Form
    private var loginForm: some View {
        VStack(spacing: 20) {
            // Email Field
            AuthTextField(
                icon: "envelope",
                placeholder: "Email",
                text: $email,
                keyboardType: .emailAddress
            )

            // Password Field
            AuthSecureField(
                icon: "lock",
                placeholder: "Password",
                text: $password,
                showPassword: $showPassword
            )

            // Error/Success Messages
            messageView

            // Login Button
            Button(action: performLogin) {
                if authService.isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.cyan, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .disabled(authService.isLoading)

            // Links
            VStack(spacing: 12) {
                Button(action: { authMode = .forgotPassword }) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                }

                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.6))

                    Button(action: { withAnimation { authMode = .signUp } }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                    }
                }
                .font(.subheadline)
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Sign Up Form
    private var signUpForm: some View {
        VStack(spacing: 20) {
            // Email Field
            AuthTextField(
                icon: "envelope",
                placeholder: "Email",
                text: $email,
                keyboardType: .emailAddress
            )

            // Username Field
            AuthTextField(
                icon: "person",
                placeholder: "Username",
                text: $username
            )

            // Password Field
            AuthSecureField(
                icon: "lock",
                placeholder: "Password (min 6 characters)",
                text: $password,
                showPassword: $showPassword
            )

            // Confirm Password Field
            AuthSecureField(
                icon: "lock.fill",
                placeholder: "Confirm Password",
                text: $confirmPassword,
                showPassword: $showPassword
            )

            // Password Match Indicator
            if !confirmPassword.isEmpty {
                HStack {
                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(password == confirmPassword ? .green : .red)

                    Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                        .font(.caption)
                        .foregroundColor(password == confirmPassword ? .green : .red)

                    Spacer()
                }
            }

            // Error/Success Messages
            messageView

            // Sign Up Button
            Button(action: performSignUp) {
                if authService.isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.cyan, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .disabled(authService.isLoading || (password != confirmPassword && !confirmPassword.isEmpty))

            // Link to Login
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.white.opacity(0.6))

                Button(action: { withAnimation { authMode = .login } }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.cyan)
                }
            }
            .font(.subheadline)
            .padding(.top, 8)
        }
    }

    // MARK: - Forgot Password Form
    private var forgotPasswordForm: some View {
        VStack(spacing: 20) {
            Text("Enter your email address and we'll send you a link to reset your password.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)

            // Email Field
            AuthTextField(
                icon: "envelope",
                placeholder: "Email",
                text: $email,
                keyboardType: .emailAddress
            )

            // Error/Success Messages
            messageView

            // Reset Button
            Button(action: performPasswordReset) {
                if authService.isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text("Send Reset Link")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.cyan, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .disabled(authService.isLoading)

            // Back to Login
            Button(action: { withAnimation { authMode = .login } }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back to Login")
                }
                .font(.subheadline)
                .foregroundColor(.cyan)
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Message View
    @ViewBuilder
    private var messageView: some View {
        if let error = authService.errorMessage {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(12)
            .background(Color.red.opacity(0.15))
            .cornerRadius(8)
        }

        if let success = authService.successMessage {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text(success)
                    .font(.caption)
                    .foregroundColor(.green)
                Spacer()
            }
            .padding(12)
            .background(Color.green.opacity(0.15))
            .cornerRadius(8)
        }
    }

    // MARK: - Actions
    private func performLogin() {
        Task {
            let success = await authService.login(email: email, password: password)
            if success {
                dismiss()
            }
        }
    }

    private func performSignUp() {
        guard password == confirmPassword else {
            authService.errorMessage = "Passwords don't match"
            return
        }

        Task {
            let success = await authService.signUp(email: email, username: username, password: password)
            if success {
                dismiss()
            }
        }
    }

    private func performPasswordReset() {
        Task {
            await authService.requestPasswordReset(email: email)
        }
    }
}

// MARK: - Auth Text Field
struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Auth Secure Field
struct AuthSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20)

            if showPassword {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            } else {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            }

            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    AuthenticationView()
}
