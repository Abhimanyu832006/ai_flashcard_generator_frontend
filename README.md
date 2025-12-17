# 📚 AI Flashcard Generator

A full-stack mobile application that automatically converts PDF study materials into interactive flashcards using Google's Gemini AI.

## 🚀 Features

### ✅ Authentication
- **User Accounts:** Secure Signup and Login.
- **Session Management:** Token-based authentication with auto-login persistence using `SharedPreferences`.

### 📄 Flashcard Generation
- **PDF Upload:** Upload notes directly from your device.
- **AI Processing:** backend extracts text and uses **Google Gemini 1.5 Flash** to generate Q&A pairs.
- **Intelligent Parsers:** Handles PDF text extraction and JSON formatting automatically.

### 💾 Study & History
- **Dashboard:** View a history of all generated flashcard sets.
- **Study Mode:** Interactive "Flip Card" UI to study questions and answers.
- **Persistence:** All data is stored in a MySQL database.

---

## 🛠️ Tech Stack

### Frontend (Mobile App)
- **Framework:** Flutter (Dart)
- **State Management:** `setState` / `FutureBuilder`
- **Networking:** `http` package
- **Storage:** `shared_preferences`
- **File Picker:** `file_picker`

### Backend (API & Logic)
- **Server:** Apache (XAMPP)
- **Language:** PHP (Native REST API)
- **Database:** MySQL / MariaDB
- **AI Model:** Google Gemini API (`gemini-1.5-flash`)
- **Text Engine:** Xpdf (`pdftotext`)

---

## 📂 Project Structure

This repository is a **Monorepo** containing both the Flutter frontend and the PHP backend code.

```text
flutter_ai_app/
├── backend/            # PHP Backend Code (Source)
│   ├── api/            # API Endpoints (auth, flashcards)
│   ├── config/         # Database & API Key configs
│   └── utils/          # Helper functions
│
├── lib/                # Flutter Frontend Code
│   ├── models/         # Data models (User, Flashcard)
│   ├── screens/        # UI Screens (Login, Dashboard, Upload)
│   ├── services/       # API integration logic
│   └── main.dart       # Entry point
│
└── README.md
________________________________________
⚙️ Setup & Installation
1. Backend Setup (Local Server)
Since the backend runs on PHP, it must be hosted on a server (like XAMPP).
1.	Copy Files: Copy the contents of the backend/ folder from this repo to your server's public folder (e.g., C:\xampp\htdocs\ai_flashcard_backend).
2.	Database:
o	Import the SQL schema into phpMyAdmin (Database name: ai_flashcard_db).
3.	Configuration:
o	Rename config/gemini.example.php to gemini.php and add your Gemini API Key.
o	Ensure config/database.php has the correct MySQL credentials.
4.	Dependencies:
o	Ensure pdftotext.exe is installed and the path in generate.php is correct.
2. Frontend Setup (Flutter)
1.	Install Dependencies:
Bash
flutter pub get
2.	Configure API URL:
o	Open lib/services/api_service.dart.
o	Update baseUrl to match your local server IP:
	Android Emulator: http://10.0.2.2/ai_flashcard_backend/api
	Physical Device: http://YOUR_PC_IP/ai_flashcard_backend/api
3.	Run the App:
Bash
flutter run
________________________________________
🔌 API Endpoints
Method	Endpoint	Description
POST	/auth/signup.php	Register a new user
POST	/auth/login.php	Login and receive Auth Token
POST	/flashcards/generate.php	Upload PDF and generate cards
GET	/flashcards/sets.php	Get list of user's saved sets
GET	/flashcards/get.php	Get Q&A pairs for a specific set
________________________________________
⚠️ Important Notes
•	Security: The backend/config/ folder containing API keys is excluded from version control via .gitignore. You must create these files manually on your server.
•	PDF Support: Currently supports digital PDFs (selectable text). Scanned image PDFs are not yet supported.
________________________________________
👤 Author
Abhimanyu Singh
Full Stack Developer (Flutter & PHP)

