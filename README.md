# GuardWell 🛡️

*A Smart India Hackathon (SIH) Project for Tourist Safety*

GuardWell is a comprehensive, real-time tourist safety application designed to ensure users are protected and informed during their travels. Built with Flutter, the app continuously monitors location, assesses travel patterns to generate safety scores, and integrates seamlessly with a centralized web portal for rapid emergency response.

## ✨ Key Features

* **Real-Time Location Tracking & Streaming**: Continuously monitors the user's location and streams location updates to the server every time a 10-meter movement is detected, ensuring highly accurate tracking.
* **Dual SOS Emergency System**:
  * **Offline/SMS**: Instantly sends an SOS message with current location coordinates via SMS to the user's designated emergency contacts.
  * **Online/Web Portal**: Transmits live SOS alerts directly to the companion Web Portal.
* **Live Web Portal Integration**: Connects to a robust dashboard (developed by the team) that displays live alerts, manages emergency protocols, and instantly relays critical distress information directly to the police.
* **Multilingual Support**: Fully accessible with built-in availability in **10 languages**, catering to a diverse range of domestic and international tourists.
* **Government Advisories**: Receives and displays push notifications for danger alerts, security updates, and official notices directly from the Government of India.
* **Dynamic Safety Score**: Analyzes the user's travel patterns and current location factors to calculate and display an intuitive safety score.

## 🏗️ Architecture Overview

GuardWell follows a modular, feature-first architecture tailored for scalable mobile applications, ensuring smooth performance even while handling continuous background location streams:

* **Presentation Layer (UI)**: Built with reactive Flutter widgets. It manages dynamic multi-language switching and provides a clean, accessible interface optimized for high-stress situations.
* **State Management**: Utilizes robust state management techniques to handle continuous data streams efficiently, ensuring that frequent location updates and UI changes do not block the main thread.
* **Core Services Layer**:
  * `LocationService`: Interfaces with native GPS hardware to track movement, applying a strict 10-meter distance filter to optimize battery life while maintaining accurate streaming.
  * `SMSService`: Manages native SMS intents and permissions to ensure SOS messages can bypass mobile data network outages.
  * `NotificationService`: Listens for background alerts and broadcasts from the Govt. of India.
  * `Network/ApiService`: Handles bidirectional communication with the external Web Portal to push live telemetry and SOS states.
* **Data & Analytics**: Processes local travel patterns to compute the dynamic safety score based on predefined risk heuristics.

## 🚀 Getting Started

### Installation

1. Clone the repository:
```bash
   git clone [https://github.com/AbeerPanwar/guardwell.git](https://github.com/AbeerPanwar/guardwell.git)
   ```
2. Navigate into the project directory:
```bash
   cd guardwell
   ```
3. Fetch dependencies:
```bash
   flutter pub get
   ```
4. Run the application:
```bash
   flutter run
   ```

---
*Developed by Abeer Panwar & Team for the Smart India Hackathon.*
