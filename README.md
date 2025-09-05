Syrian Society for Social Development - Mobile App
This is the Syrian Society for Social Development's (SSSD) pilot app, designed to serve as a digital bridge between the organization and its beneficiaries. The app provides an easy-to-use and efficient platform that allows users to access services, stay informed, and engage with the society.
Built with Flutter and GetX, the application ensures a high-performance, responsive, and native experience on both Android and iOS devices from a single codebase.
✨ Key Features
This application is packed with features designed to empower beneficiaries and streamline operations:
👤 Full User Authentication:
Secure user registration and OTP email confirmation.
Robust login/logout functionality.
Password recovery via email OTP.
Automated token management with Access & Refresh Tokens for persistent sessions.
📋 Beneficiary Profile & Data Management:
A comprehensive multi-tab form for users to submit and update their personal and social information.
Smart Profile screen to view and edit personal data, including profile picture upload.
🛠️ Service Request Management:
A dedicated services portal allowing users to apply for different types of aid.
Material Aid: Request essential items.
Medical Aid: Submit requests for medical assistance, complete with medical report uploads.
Small Projects: Apply for support to start small-scale projects.
Each service has a smart interface that shows the current request status (Pending, Approved, etc.) or a form to create a new one. Users can also delete pending requests.
📰 News & Activities Feed:
A dynamic home screen displaying the latest news and activities from the SSSD.
Users can tap on any item to view full details, including descriptions and images.
⭐ User Feedback System:
An integrated feedback module where users can rate the services on a scale and provide written comments.
📱 Modern & Responsive UI:
A clean, intuitive, and user-friendly interface based on the professional design from Behance.
Fully responsive layout that adapts to various screen sizes.
Support for both Arabic (RTL) and English languages.
⚙️ Technical Stack
Framework: Flutter (for cross-platform development)
State Management: GetX (for reactive state management, dependency injection, and navigation)
Networking: dio (for powerful and efficient API requests)
Local Storage: flutter_secure_storage (for securely storing auth tokens)
Image Handling: image_picker (for selecting images from the gallery/camera)
Architecture: The project follows a clean architecture, separating UI (Views), business logic (Controllers), and data services (ApiService, Models).
🚀 Getting Started
To get a local copy up and running, follow these simple steps.
Prerequisites:
Flutter SDK installed.
An editor like VS Code or Android Studio.
Installation:
Clone the repo:
code
Sh

download

content_copy

expand_less
git clone https://github.com/khaderhash/Services-and-news-application.git
Install dependencies:
code
Sh

download

content_copy

expand_less
flutter pub get
Run the app:
code
Sh

download

content_copy

expand_less
flutter run
🎨 Design
The application's UI/UX is based on the high-fidelity mockups available on Behance.
View the Design on Behance
