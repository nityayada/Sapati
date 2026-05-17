# Sapati Community Ledger

Welcome to the **Sapati Community Ledger**, a comprehensive neighborhood resource-sharing platform. Sapati allows community members to borrow, lend, and manage shared resources while maintaining collective trust and accountability.

## 🚀 Key Features

- **User Authentication**: Secure registration, login, and password recovery with OTP verification.
- **Resource Sharing**: Browse, request, and list items for borrowing within the community.
- **Borrowing & Tracking**: Keep track of your borrowed items, return dates, and request statuses.
- **Admin Controls**: Comprehensive administrative dashboard for managing users, items, and system operations.
- **Fine System**: Automated late fine tracking and a mock payment gateway for settling dues.
- **Modern UI**: A clean, responsive interface utilizing modern typography (Inter) and Material Symbols.

## 🛠️ Technology Stack

- **Backend**: Java (Servlets, JSP)
- **Database**: MySQL (`sapati_db`)
- **Frontend**: HTML5, CSS3, JSTL
- **Server Environment**: Apache Tomcat

## ⚙️ Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nityayada/Sapati
   ```

2. **Database Configuration:**
   - Create a MySQL database named `sapati_db`.
   - Update the database credentials in `src/main/java/com/sapati/config/DBConfig.java` to match your local setup.

3. **Run the Application:**
   - Import the project into your preferred Java IDE (e.g., Eclipse).
   - Configure an Apache Tomcat server and deploy the project.
   - Access the application at `http://localhost:8080/Sapati`.

## 🎓 About

This project was developed as part of university coursework, focusing on robust web application architecture using Java Servlets, Database integration, and modern UI implementation.
