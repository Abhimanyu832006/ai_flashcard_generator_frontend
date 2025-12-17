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
⚙️ Setup & Installation1. Backend Setup (Local Server)Since the backend runs on PHP, it must be hosted on a server (like XAMPP).Copy Files: Copy the contents of the backend/ folder from this repo to your server's public folder (e.g., C:\xampp\htdocs\ai_flashcard_backend).Database:Import the SQL schema into phpMyAdmin (Database name: ai_flashcard_db).Configuration:Rename config/gemini.example.php to gemini.php and add your Gemini API Key.Ensure config/database.php has the correct MySQL credentials.Dependencies:Ensure pdftotext.exe is installed and the path in generate.php is correct.2. Frontend Setup (Flutter)Install Dependencies:Bashflutter pub get
Configure API URL:Open lib/services/api_service.dart.Update baseUrl to match your local server IP:Android Emulator: http://10.0.2.2/ai_flashcard_backend/apiPhysical Device: http://YOUR_PC_IP/ai_flashcard_backend/apiRun the App:Bashflutter run
🔌 API EndpointsMethodEndpointDescriptionPOST/auth/signup.phpRegister a new userPOST/auth/login.phpLogin and receive Auth TokenPOST/flashcards/generate.phpUpload PDF and generate cardsGET/flashcards/sets.phpGet list of user's saved setsGET/flashcards/get.phpGet Q&A pairs for a specific set⚠️ Important NotesSecurity: The backend/config/ folder containing API keys is excluded from version control via .gitignore. You must create these files manually on your server.PDF Support: Currently supports digital PDFs (selectable text). Scanned image PDFs are not yet supported.👤 AuthorAbhimanyu SinghFull Stack Developer (Flutter & PHP)