import SwiftUI

struct DashboardPage: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background blurred circles
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

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Header Section
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.9))
                                    .frame(width: 250, height: 70)
                                    .shadow(radius: 5)

                                HStack {
                                    Image(systemName: "house.fill")
                                        .foregroundColor(.blue)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)

                                    VStack(alignment: .leading) {
                                        Text("ABC")
                                            .font(.custom("Poppins-Bold", size: 20))
                                        Text("Room No. 111")
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    NavigationLink(destination: NotificationsPage()) {
                                        ZStack(alignment: .topTrailing) {
                                            Image(systemName: "bell")
                                                .font(.title2)
                                                .padding()
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 4)

                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 10, height: 10)
                                                .offset(x: 5, y: -5)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.horizontal)
                            .padding(.top, 50)

                            // Emergency Contacts
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Emergency Contacts")
                                    .font(.custom("Poppins-Bold", size: 18))
                                    .foregroundColor(Color(hex: "4E4B66"))

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<4) { _ in
                                            VStack(alignment: .leading) {
                                                Text("Secretary")
                                                    .font(.custom("Poppins-SemiBold", size: 16))
                                                Text("+91 77896 34364")
                                                    .foregroundColor(.gray)
                                                    .font(.custom("Poppins-Regular", size: 14))
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(20)
                                            .shadow(radius: 4)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)

                            // Notices Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Welcome")
                                    .font(.custom("Poppins-Bold", size: 28))

                                HStack {
                                    Text("Notices")
                                        .font(.custom("Poppins-Medium", size: 18))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    NavigationLink(destination: AllNoticesPage()) {
                                        Text("View all")
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<2) { _ in
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("Power Outage Announcement")
                                                    .font(.custom("Poppins-Bold", size: 16))
                                                Text("The Metropolitan Electricity Authority will temporarily cut off the power for…")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                                    .font(.custom("Poppins-Regular", size: 14))

                                                HStack {
                                                    Image(systemName: "person.fill")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                        .clipShape(Circle())
                                                    Text("Ralph Edwards")
                                                        .font(.custom("Poppins-Regular", size: 12))
                                                    Spacer()
                                                    Text("12 Jan, 2021")
                                                        .foregroundColor(.gray)
                                                        .font(.custom("Poppins-Regular", size: 12))
                                                }
                                            }
                                            .padding()
                                            .frame(width: 280)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(radius: 3)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)

                            // Services Grid
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Services")
                                    .font(.custom("Poppins-Bold", size: 20))

                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                                    NavigationLink(destination: VisitorsPage()) {
                                        ServiceItem(name: "Visitors", imageName: "person.crop.rectangle")
                                    }
                                    NavigationLink(destination: BillsPage()) {
                                        ServiceItem(name: "Bills", imageName: "doc.plaintext")
                                    }
                                    NavigationLink(destination: ParcelsPage()) {
                                        ServiceItem(name: "Parcels", imageName: "shippingbox")
                                    }
                                    NavigationLink(destination: ServicesPage()) {
                                        ServiceItem(name: "Services", imageName: "wrench")
                                    }
                                    NavigationLink(destination: LetterHeadsPage()) {
                                        ServiceItem(name: "Letter Heads", imageName: "doc.text")
                                    }
                                    NavigationLink(destination: RentalDetailsPage()) {
                                        ServiceItem(name: "Rental Details", imageName: "doc.text.fill")
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.top)
                    }

                    // Bottom Navigation
                    HStack {
                        NavigationLink(destination: DashboardPage()) {
                            NavItem(icon: "house.fill", label: "Home")
                        }
                        NavigationLink(destination: ComplaintsPage()) {
                            NavItem(icon: "bubble.left", label: "Complaints")
                        }
                        NavigationLink(destination: RemindersPage()) {
                            NavItem(icon: "bell.badge", label: "Reminders")
                        }
                        NavigationLink(destination: AccountPage()) {
                            NavItem(icon: "person", label: "Account")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 8)
                }
            }
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Placeholder Views for Navigation Targets
struct VisitorsPage: View { var body: some View { Text("Visitors Page") } }
struct BillsPage: View { var body: some View { Text("Bills Page") } }
struct ParcelsPage: View { var body: some View { Text("Parcels Page") } }
struct ServicesPage: View { var body: some View { Text("Services Page") } }
struct LetterHeadsPage: View { var body: some View { Text("Letter Heads Page") } }
struct RentalDetailsPage: View { var body: some View { Text("Rental Details Page") } }
struct NotificationsPage: View { var body: some View { Text("Notifications Page") } }
struct AllNoticesPage: View { var body: some View { Text("All Notices Page") } }
struct ComplaintsPage: View { var body: some View { Text("Complaints Page") } }
struct RemindersPage: View { var body: some View { Text("Reminders Page") } }
struct AccountPage: View { var body: some View { Text("Account Page") } }

struct ServiceItem: View {
    let name: String
    let imageName: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 30))
                .padding()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
            Text(name)
                .font(.custom("Poppins-Regular", size: 12))
                .multilineTextAlignment(.center)
        }
    }
}

struct NavItem: View {
    let icon: String
    let label: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.custom("Poppins-Regular", size: 10))
        }
        .foregroundColor(.blue)
        .frame(maxWidth: .infinity)
    }
}

struct DashboardPage_Previews: PreviewProvider {
    static var previews: some View {
        DashboardPage()
    }
}
