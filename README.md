# Irisense: Accessible AI Eye-Tracking AAC Application

## 1. About the Project
Irisense is a hardware-free, AI-powered Assistive and Augmentative Communication (AAC) platform. It empowers users to navigate a communication interface and generate text-to-speech output using only their eye movements, utilizing standard built-in device cameras.

## 2. The Challenge of SSMI
Individuals living with Severe Speech and Motor Impairments (SSMI)—such as those affected by ALS, stroke, cerebral palsy, or locked-in syndrome—often lose the physical ability to speak or interact with traditional touch screens. Traditional eye-tracking communication devices are prohibitively expensive, require bulky external infrared hardware, and lack portability, leaving millions of patients isolated from daily social interaction.

## 3. Our Solution: Irisense
Irisense democratizes accessibility by transforming any standard smartphone or tablet into a highly precise gaze-tracking communication device. By continuously analyzing the user's eye movements, Irisense maps gaze coordinates to an intuitive, grid-based smart interface. Users can effortlessly select words, express immediate needs, or type custom messages that are instantly converted to speech. By completely eliminating the need for external calibration hardware, Irisense provides a seamless, cost-effective, and highly portable lifeline that restores independence and voice to SSMI patients.

## 4. Technical Infrastructure
Irisense is engineered for high performance, cross-platform stability, and strict user privacy:
*   **Core Framework:** Built with Flutter (Dart) using a highly structured MVVM (Model-View-ViewModel) architecture.
*   **Computer Vision Pipeline:** Powered by MediaPipe and OpenCV for real-time, lightweight 3D facial landmark detection and iris positioning.
*   **On-Device AI:** To ensure zero-latency responsiveness and absolute privacy, all Machine Learning models and mathematical algorithms (including Perspective-n-Point solvers for head pose estimation) run entirely locally on the device. No biometric or gaze data is transmitted over the internet.

---

## ⚙️ Setup and Installation

Follow these steps to run Irisense on your local machine.

### Prerequisites
*   Flutter SDK installed on your system.
*   A physical device or emulator with camera access.

### 1. Clone and Install Dependencies
Clone the repository and fetch the required Flutter packages:
```bash
git clone [https://github.com/gunessinan/irisense.git](https://github.com/gunessinan/irisense.git)
cd irisense
flutter pub get

```

### 2. Environment Variables (.env)

Irisense uses an environment file to manage sensitive configurations.

1. Create a file named `.env` in the root directory of the project.
2. Add your necessary API keys or configurations inside the file. *(Example format: `API_KEY=your_api_key_here`)*.

### 3. Firebase Configuration

For security reasons, the Firebase configuration files are excluded from this repository. To enable database and backend features, you must link your own Firebase project:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Register your Android and/or iOS apps.
3. Download the `google-services.json` file and place it inside `android/app/`.
4. Download the `GoogleService-Info.plist` file and place it inside `ios/Runner/`.
5. Generate the `firebase_options.dart` file using the FlutterFire CLI and place it inside the `lib/` directory:

```bash
flutterfire configure

```

### 4. Run the App

Once the setup is complete, you can launch the application:

```bash
flutter run

```

---

**Copyright (c) 2026 Sinan Güneş. All Rights Reserved.**
Please see the [LICENSE](https://github.com/gunessinan/irisense/blob/main/LICENSE) file for detailed terms regarding the personal use, review, and strict prohibitions against the distribution or commercialization of this software.