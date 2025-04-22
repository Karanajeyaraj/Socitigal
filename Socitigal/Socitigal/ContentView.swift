/*import SwiftUI

// MARK: - Color Extension
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

// MARK: - Login Page
struct LoginPage: View {
    @State private var userType: String = "Member"
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var navigateToDashboard = false
    @State private var navigateToRegister = false
    @State private var navigateToForgot = false
    
    @State private var usernameError = false
    @State private var passwordError = false
    
    let userTypes = ["Member", "Secretary"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Circles
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
                            Image("Logo")
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
                            
                            CustomTextField(title: "Username", text: $username, isError: usernameError)
                            
                            CustomSecureField(title: "Password", text: $password, isError: passwordError)
                            
                            Button(action: {
                                if validateInputs() {
                                    let loginRequest = LoginRequest(
                                        email_address: username,
                                        password: password,
                                        ip_address: "192.168.0.101",
                                        device_info: UIDevice.current.model,
                                        login_time: ISO8601DateFormatter().string(from: Date()),
                                        login_location: "Your City",
                                        usertype: userType
                                    )
                                    
                                    APIService.shared.loginUser(data: loginRequest) { result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(_):
                                                navigateToDashboard = true
                                            case .failure(let error):
                                                alertMessage = error.localizedDescription
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
                        Group {
                            NavigationLink("", destination: DashboardPage(), isActive: $navigateToDashboard).hidden()
                            NavigationLink("", destination: RegisterPage(), isActive: $navigateToRegister).hidden()
                            NavigationLink("", destination: ForgotPasswordPage(), isActive: $navigateToForgot).hidden()
                        }
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
        let isAlphanumericWithSymbols = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z@._-]+$")
        
        usernameError = username.isEmpty || !isAlphanumericWithSymbols.evaluate(with: username)
        passwordError = password.isEmpty
        
        if usernameError {
            alertMessage = username.isEmpty ? "Username is required." : "Username must be alphanumeric (A-Z) and can include @ . _ -"
            showAlert = true
            return false
        }
        
        if passwordError {
            alertMessage = "Password is required."
            showAlert = true
            return false
        }
        
        return true
    }
}

// MARK: - Placeholder Pages
struct ForgotPasswordPage: View {
    var body: some View {
        Text("Forgot Password Page")
    }
}

struct DashboardPage: View {
    var body: some View {
        Text("Dashboard")
    }
}*/
import SwiftUI

// MARK: - Custom Fields
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var isError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-ExtraBold", size: 16))
                .foregroundColor(Color(hex: "4E4B66"))
            
            TextField("", text: $text)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .frame(height: 59)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isError ? Color.red : Color(hex: "C3BFBF"), lineWidth: 2)
                )
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    var isError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-ExtraBold", size: 16))
                .foregroundColor(Color(hex: "4E4B66"))
            
            SecureField("", text: $text)
                .textContentType(.oneTimeCode)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .frame(height: 59)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isError ? Color.red : Color(hex: "C3BFBF"), lineWidth: 2)
                )
        }
    }
}

// MARK: - Color Extension
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
    
    @State private var email_addressError = false
    @State private var passwordError = false
    
    let userTypes = ["Member", "Secretary"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Circles
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
                            Image("Logo")
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
                            CustomTextField(title: "Email Address", text: $email_address, isError: email_addressError)
                            CustomSecureField(title: "Password", text: $password, isError: passwordError)
                            
                            Button(action: {
                                if validateInputs() {
                                    let loginRequest = LoginRequest(
                                        email_address: email_address,
                                        password: password,
                                        ip_address: "192.168.0.101",  // Example IP, change as needed
                                        device_info: UIDevice.current.model,
                                        login_time: ISO8601DateFormatter().string(from: Date()),
                                        login_location: "Your City",
                                        usertype: userType
                                    )
                                    
                                    APIService.shared.loginUser(data: loginRequest) { result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let response):
                                                if response.message == "1" {
                                                    // Navigate to dashboard
                                                    navigateToDashboard = true
                                                } else {
                                                    alertMessage = "Login failed. Please check your credentials."
                                                    showAlert = true
                                                }
                                            case .failure(let error):
                                                alertMessage = error.localizedDescription
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
                        Group {
                            NavigationLink(destination: DashboardPage(), isActive: $navigateToDashboard) { EmptyView() }
                                .hidden()
                            
                            NavigationLink(destination: RegisterPage(), isActive: $navigateToRegister) { EmptyView() }
                                .hidden()
                            
                            NavigationLink(destination: ForgotPasswordPage(), isActive: $navigateToForgot) { EmptyView() }
                                .hidden()
                        }
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
        let email_addressPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9@._-]+$")
        
        email_addressError = email_address.isEmpty || !email_addressPredicate.evaluate(with: email_address)
        passwordError = password.isEmpty
        
        if email_addressError {
            alertMessage = email_address.isEmpty ? "Email address is required." : "Email address must be alphanumeric and can include @ . _ -"
            showAlert = true
        }
        
        if passwordError {
            alertMessage = "Password is required."
            showAlert = true
            return false
        }
        
        return true
    }
}

// MARK: - Placeholder Pages
struct ForgotPasswordPage: View {
    var body: some View {
        Text("Forgot Password Page")
    }
}

struct DashboardPage: View {
    var body: some View {
        Text("Dashboard")
    }
}
