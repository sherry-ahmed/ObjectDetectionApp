# ObjectDetectionApp
Flutter object detection app made using python api running in background realtime communication using wifi

Here's a README section that describes your app and its setup:

---

## Plant Disease Detection App

This app is developed using Flutter for the frontend and Python for the backend API. It aims to detect plant diseases in the Solanaceae family. The app provides disease causes and remedies based on data from PlantVillage, nutrient deficiency, and insect infestation datasets. Firebase Realtime Database is used for data storage, Firebase Storage for image storage, and Firebase RecyclerView to display data.

### Features
- Real-time plant disease detection using images
- Detailed causes and remedies for detected diseases
- Firebase integration for data storage and retrieval

### Setup and Requirements
1. **Flutter Setup**
   - Ensure you have Flutter installed. Follow the instructions [here](https://flutter.dev/docs/get-started/install).
   - Clone the repository and navigate to the project folder:
     ```sh
     git clone <repository_url>
     cd <project_folder>
     ```
   - Install dependencies:
     ```sh
     flutter pub get
     ```

3. **IP Address Configuration**
   - Both the app and the Python backend must be connected to the same WiFi network for real-time communication.
   - Update the IP address in both the Flutter app and the Python backend to match the IP address assigned to your machine by the WiFi network.
     - In the Flutter app, update the IP address in the relevant file (e.g., `lib/main.dart`).
     - In the Python backend, update the IP address in the relevant configuration file or directly in the `python_server.py` file.

### Running the App
1. Ensure the Python backend is running.
2. Connect your device (or emulator) to the same WiFi network as your development machine.
3. Run the Flutter app:
   ```sh
   flutter run
   ```
---

Feel free to modify the instructions to fit your specific project setup.




