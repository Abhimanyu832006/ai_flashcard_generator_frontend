📚 AI Flashcard Generator
A full-stack mobile application that automatically converts PDF study materials into interactive flashcards using Google's Gemini AI.
🚀 Features
•	User Authentication: Secure Signup and Login system with Token-based auth.
•	PDF Processing: Upload PDF documents directly from your device.
•	AI Generation: Extracts text and uses Gemini 1.5 Flash to generate Q&A pairs.
•	Study Mode: Flip-card interface to study generated content.
•	History: Saves all generated sets to the database for future access.
•	Cross-Platform: Built with Flutter for Android & iOS.
________________________________________
🛠️ Tech Stack
Frontend
•	Framework: Flutter (Dart)
•	State Management: setState / FutureBuilder
•	Packages: http, file_picker, shared_preferences
Backend
•	Server: Apache (via XAMPP)
•	Language: PHP (Native/Vanilla)
•	Database: MySQL / MariaDB
•	AI Model: Google Gemini API (gemini-1.5-flash)
•	Tools: Xpdf (pdftotext) for text extraction
________________________________________
📂 Project Structure
Plaintext
flutter_ai_app/
├── backend/            # PHP Backend Code (Copy of htdocs files)
│   ├── api/            # REST API Endpoints
│   ├── config/         # Database & API Key configuration
│   └── utils/          # Helper functions
├── lib/                # Flutter Frontend Code
│   ├── models/         # Data models
│   ├── screens/        # UI Screens (Login, Upload, Dashboard)
│   ├── services/       # API integration logic
│   └── main.dart       # Entry point
└── README.md
________________________________________
⚙️ Setup & Installation
1. Backend Setup (XAMPP)
1.	Move Files: Copy the contents of the backend/ folder to C:\xampp\htdocs\ai_flashcard_backend\.
2.	Database:
o	Open phpMyAdmin (http://localhost/phpmyadmin).
o	Create a database named ai_flashcard_db.
o	Import the SQL schema (tables: users, flashcard_sets, flashcards, flashcard_files).
3.	Configuration:
o	Edit config/database.php with your MySQL credentials.
o	Edit config/gemini.php and add your Gemini API Key.
4.	Xpdf Tool:
o	Download and extract Xpdf tools.
o	Ensure pdftotext.exe is at C:/xpdf/bin64/pdftotext.exe (or update the path in generate.php).
2. Frontend Setup (Flutter)
1.	Install Dependencies:
Bash
flutter pub get
2.	Configure API URL:
o	Open lib/services/api_service.dart.
o	Ensure the baseUrl points to your XAMPP server:
	Android Emulator: http://10.0.2.2/ai_flashcard_backend/api
	Physical Device: http://YOUR_PC_IP_ADDRESS/ai_flashcard_backend/api
3.	Run App:
Bash
flutter run
________________________________________
🔌 API Endpoints
Method	Endpoint	Description
POST	/auth/signup.php	Register a new user
POST	/auth/login.php	Login and receive Auth Token
POST	/flashcards/generate.php	Upload PDF and generate cards
GET	/flashcards/sets.php	Get list of saved flashcard sets
GET	/flashcards/get.php	Get specific cards for a set ID
________________________________________
⚠️ Common Troubleshooting
•	Error 401 Unauthorized: Ensure you are passing the Authorization header. If using Apache, you may need to add a .htaccess file to enable header passing.
•	"Text extraction failed": Verify the path to pdftotext.exe in generate.php.
•	"Model not found": Update the Gemini model name in generate.php to the latest version (e.g., gemini-1.5-flash).
________________________________________
🔒 Security Note
The backend/config/ folder contains sensitive API keys. This folder is included in .gitignore to prevent accidental commits of secrets. Do not upload gemini.php to public repositories.

