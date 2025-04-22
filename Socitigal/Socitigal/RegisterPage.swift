import SwiftUI

struct RegisterPage: View {
    @State private var full_name = ""
    @State private var email_address = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phone_number = ""
    @State private var tower = ""
    @State private var floor = ""
    @State private var flat_no = ""
    @State private var aadhar_no = ""
    @State private var usertype = ""
    @State private var mcode = "" // ✅ New field

    @State private var navigateToLogin = false
    @State private var errorMessage = ""
    @State private var fieldErrors: [String: Bool] = [:]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Image("Background_pastel")
                                .resizable()
                                .scaledToFit()

                            VStack(alignment: .leading, spacing: 0) {
                                Text("Register your Flat")
                                    .foregroundColor(Color(hex: "#4E4A66"))
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 28)

                                Group {
                                    CustomField(title: "Full name", text: $full_name, showError: fieldErrors["full_name"] ?? false)
                                    CustomField(title: "Email Address", text: $email_address, showError: fieldErrors["email_address"] ?? false)
                                    CustomField(title: "Password", text: $password, isSecure: true, showError: fieldErrors["password"] ?? false)
                                    CustomField(title: "Confirm Password", text: $confirmPassword, isSecure: true, showError: fieldErrors["confirmPassword"] ?? false)
                                    CustomField(title: "Phone Number", text: $phone_number, showError: fieldErrors["phone_number"] ?? false)
                                    CustomField(title: "Select tower", text: $tower, showError: fieldErrors["tower"] ?? false)
                                    CustomField(title: "Select Floor", text: $floor, showError: fieldErrors["floor"] ?? false)
                                    CustomField(title: "Flat No.", text: $flat_no, showError: fieldErrors["flat_no"] ?? false)
                                    CustomField(title: "Aadhar Number", text: $aadhar_no, showError: fieldErrors["aadhar_no"] ?? false)
                                    CustomField(title: "User Type", text: $usertype, showError: fieldErrors["usertype"] ?? false)
                                    CustomField(title: "M-Code", text: $mcode, showError: fieldErrors["mcode"] ?? false) // ✅ Added field
                                }
                                .padding(.horizontal, 30)

                                if !errorMessage.isEmpty {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                        .padding(.horizontal, 30)
                                        .padding(.bottom, 10)
                                }

                                Text("Verified by Digilocker")
                                    .foregroundColor(Color(hex: "#6E7191"))
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .padding(.vertical, 30)
                                    .padding(.leading, 70)

                                NavigationLink(destination: LoginPage(), isActive: $navigateToLogin) {
                                    EmptyView()
                                }

                                Button(action: {
                                    if validateFields() {
                                        let registrationData = RegistrationData(
                                            full_name: full_name,
                                            email_address: email_address,
                                            password: password,
                                            phone_number: phone_number,
                                            tower: tower,
                                            floor: floor,
                                            flat_no: flat_no,
                                            aadhar_no: aadhar_no,
                                            usertype: usertype,
                                            mcode: mcode // ✅ included in struct
                                        )

                                        APIService.shared.registerUser(data: registrationData) { result in
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(_):
                                                    navigateToLogin = true
                                                case .failure(let error):
                                                    errorMessage = error.localizedDescription
                                                }
                                            }
                                        }
                                    }
                                }) {
                                    Text("Submit")
                                        .foregroundColor(Color(hex: "#E5EBF8"))
                                        .font(.custom("Poppins-Bold", size: 16))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                stops: [
                                                    .init(color: Color(red: 0.29, green: 0.33, blue: 1).opacity(0.9), location: 0),
                                                    .init(color: Color(red: 0, green: 0.4, blue: 1).opacity(0.6), location: 1)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(54)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 54)
                                                .stroke(Color(hex: "#FCFCFC80"), lineWidth: 1)
                                        )
                                        .padding(.horizontal, 70)
                                        .padding(.bottom, 51)
                                }
                            }
                            .padding(.top, 65)
                            .padding(.bottom, 44)
                        }
                    }
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    func validateFields() -> Bool {
        errorMessage = ""
        fieldErrors = [:]
        var isValid = true

        if full_name.isEmpty || !full_name.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            fieldErrors["full_name"] = true
            isValid = false
        }

        if email_address.isEmpty || !isValidEmail(email_address) {
            fieldErrors["email_address"] = true
            isValid = false
        }

        if password.isEmpty || !isValidPassword(password) {
            fieldErrors["password"] = true
            isValid = false
        }

        if confirmPassword.isEmpty || confirmPassword != password {
            fieldErrors["confirmPassword"] = true
            isValid = false
        }

        if phone_number.isEmpty || !isNumeric(phone_number) {
            fieldErrors["phone_number"] = true
            isValid = false
        }

        if tower.isEmpty || !isAlphabetOnly(tower) {
            fieldErrors["tower"] = true
            isValid = false
        }

        if floor.isEmpty || !isNumeric(floor) {
            fieldErrors["floor"] = true
            isValid = false
        }

        if flat_no.isEmpty || !isNumeric(flat_no) {
            fieldErrors["flat_no"] = true
            isValid = false
        }

        if aadhar_no.isEmpty || !isNumeric(aadhar_no) || aadhar_no.count != 12 {
            fieldErrors["aadhar_no"] = true
            isValid = false
        }

        if usertype.isEmpty || !isAlphabetOnly(usertype) {
            fieldErrors["usertype"] = true
            isValid = false
        }

        if mcode.isEmpty || !isAlphaNumericOnly(mcode) {
            fieldErrors["mcode"] = true
            isValid = false
        }

        if !isValid {
            errorMessage = "Please correct the highlighted fields."
        }

        return isValid
    }

    func isAlphaNumericOnly(_ text: String) -> Bool {
        let allowedChars = CharacterSet.letters.union(.decimalDigits)
        return text.rangeOfCharacter(from: allowedChars.inverted) == nil
    }

    func isNumeric(_ text: String) -> Bool {
        return text.allSatisfy { $0.isNumber }
    }
}

func isAlphaNumericOnly(_ text: String) -> Bool {
    let allowedChars = CharacterSet.letters.union(.decimalDigits)
    return text.rangeOfCharacter(from: allowedChars.inverted) == nil
}

func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
}

func isAlphabetOnly(_ text: String) -> Bool {
    return text.allSatisfy { $0.isLetter }
}


// MARK: - CustomField Component
struct CustomField: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    var showError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(Color(hex: "#4E4A66"))
                .font(.custom("Poppins-Bold", size: 16))

            let borderColor = showError ? Color.red : Color(hex: "#C3BFBF")

            Group {
                if isSecure {
                    SecureField("", text: $text)
                        .textContentType(.oneTimeCode)
                } else {
                    TextField("", text: $text)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 59)
            .background(Color.white)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(borderColor, lineWidth: 2))
        }
        .padding(.bottom, 22)
    }
}

