import SwiftUI

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Custom Components

struct CustomTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-ExtraBold", size: 16))
                .foregroundColor(Color(hex: "4E4B66"))

            TextField("", text: $text)
                .frame(height: 59)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "C3BFBF"), lineWidth: 2)
                )
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-ExtraBold", size: 16))
                .foregroundColor(Color(hex: "4E4B66"))

            SecureField("", text: $text)
                .frame(height: 59)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "C3BFBF"), lineWidth: 2)
                )
        }
    }
}

struct CustomPickerField: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-ExtraBold", size: 16))
                .foregroundColor(Color(hex: "4E4B66"))

            Picker(selection: $selection, label: Text("")) {
                ForEach(options, id: \.self) {
                    Text($0).tag($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .frame(height: 59)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(hex: "C3BFBF"), lineWidth: 2)
            )
        }
    }
}

// MARK: - Dummy Pages





struct ForgotPasswordPage: View {
    var body: some View {
        Text("Forgot Password Page")
    }
}

// MARK: - Login Page

struct LoginPage: View {
    @State private var userType: String = "Member"
    @State private var email_address: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var navigateToDashboard = false
    @State private var navigateToRegister = false
    @State private var navigateToForgot = false

    let userTypes = ["Member", "Secretary"]

    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    Circle()
                        .fill(Color(hex: "FFE285"))
                        .frame(width: 151, height: 151)
                        .blur(radius: 80)
                        .position(x: 75, y: 75)

                    Circle()
                        .fill(Color(hex: "FFC5D2"))
                        .frame(width: 151, height: 151)
                        .blur(radius: 80)
                        .position(x: 320, y: 200)

                    Circle()
                        .fill(Color(hex: "8567FD").opacity(0.2))
                        .frame(width: 172, height: 172)
                        .blur(radius: 80)
                        .position(x: 130, y: 550)

                    Circle()
                        .fill(Color(hex: "00D1E1").opacity(0.4))
                        .frame(width: 245, height: 245)
                        .blur(radius: 100)
                        .position(x: 300, y: 650)
                }

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 57, height: 57)

                            Text("Sociyaan")
                                .font(.custom("Poppins-Bold", size: 24))
                                .foregroundColor(Color(hex: "14142B"))

                            Text("Society's digital helper")
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(Color(hex: "6E7191"))

                            Text("Powered by AI")
                                .font(.custom("Poppins-SemiBold", size: 12))
                                .foregroundColor(Color(hex: "A0A3BD"))
                        }
                        .padding(.top, 64)

                        VStack(spacing: 24) {
                            CustomPickerField(title: "User Type", selection: $userType, options: userTypes)
                            CustomTextField(title: "Email Address", text: $email_address)
                            CustomSecureField(title: "Password", text: $password)

                            Button(action: {
                                if validateInputs() {
                                    // Construct LoginRequest
                                    let loginData = LoginRequest(
                                        email_address: email_address.trimmingCharacters(in: .whitespacesAndNewlines),
                                        password: password.trimmingCharacters(in: .whitespacesAndNewlines),
                                        ip_address: "192.168.0.101",
                                        device_info: UIDevice.current.name,
                                        login_time: ISO8601DateFormatter().string(from: Date()),
                                        login_location: "Your location here",
                                        usertype: userType
                                    )


                                    APIService.shared.loginUser(data: loginData) { result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let message):
                                                print("Login Success: \(message)")
                                                navigateToDashboard = true
                                            case .failure(let error):
                                                alertMessage = "Login Failed: \(error.localizedDescription)"
                                                showAlert = true
                                            }
                                        }
                                    }
                                }
                            }) {
                                Text("Log in")
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .foregroundColor(Color(hex: "466FFF"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.9),
                                                Color.white.opacity(0.7)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(27)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 27)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: Color(hex: "A0A3BD").opacity(0.16), radius: 12, x: 0, y: 8)
                            }

                            HStack {
                                Text("Not yet registered")
                                    .font(.custom("Poppins-ExtraBold", size: 16))
                                    .foregroundColor(Color(hex: "6E7191"))

                                Button("Sign Up") {
                                    navigateToRegister = true
                                }
                                .font(.custom("Inter-ThinItalic", size: 16))
                                .foregroundColor(Color(hex: "2A59FF"))
                                .underline()
                            }

                            HStack {
                                Text("Forgot Password?")
                                    .font(.custom("Poppins-ExtraBold", size: 16))
                                    .foregroundColor(Color(hex: "6E7191"))

                                Button("Click here") {
                                    navigateToForgot = true
                                }
                                .font(.custom("Inter-ThinItalic", size: 16))
                                .foregroundColor(Color(hex: "2A59FF"))
                                .underline()
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: 414)
                    .background(
                        NavigationLink("", destination: DashboardPage(), isActive: $navigateToDashboard).hidden()
                    )
                    .background(
                        NavigationLink("", destination: RegisterPage(), isActive: $navigateToRegister).hidden()
                    )
                    .background(
                        NavigationLink("", destination: ForgotPasswordPage(), isActive: $navigateToForgot).hidden()
                    )
                }
            }
            .background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func validateInputs() -> Bool {
        if email_address.isEmpty || password.isEmpty {
            alertMessage = "All fields must be filled."
            showAlert = true
            return false
        }
        if !isValidEmail(email_address) {
                alertMessage = "Please enter a valid email address."
                showAlert = true
                return false
            }

            return true
        }

        private func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "(?:[a-zA-Z0-9._%+-]+)@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPredicate.evaluate(with: email)
        }

}


