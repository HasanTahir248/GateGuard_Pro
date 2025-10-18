# Smart Visitor Management System 📱

A cross-platform visitor management app built with Flutter. This project is a comprehensive example of how to build a scalable and maintainable application using a clean **MVVM architecture**, **Riverpod** for state management, and a **Feature-First** folder structure.

---

## ✨ Features

* **Dual Visitor Modes:** Register walk-in visitors or check-in pre-approved guests from a JSON-based list.
* **Photo Capture:** Uses `image_picker` to capture a visitor's photo from the camera during registration.
* **QR Code Pass:** Generates a unique visitor pass with a scannable QR code (`qr_flutter`) upon successful check-in.
* **Visitor Logging:** Maintains a persistent log of all checked-in visitors and their check-in/check-out times.
* **Clean State Management:** All app state is managed by Riverpod `Notifiers`, providing a single, reliable source of truth.

---

## 🏗️ Architecture & Tech Stack

This app was built to demonstrate modern Flutter development practices. The architecture is the main focus.

* **Flutter:** Cross-platform UI toolkit for building natively compiled applications.
* **Riverpod:** A modern, compile-safe state management library that's independent of the widget tree.
* **MVVM (Model-View-ViewModel):**
    * **Model:** The data layer (`visitor_model.dart`), responsible for data structure and JSON parsing.
    * **View:** The UI (`home_screen.dart`, etc.), converted to `ConsumerWidgets` that react to state changes.
    * **ViewModel:** The logic layer, implemented as Riverpod `Notifiers` (`visitor_provider.dart`), which manages the state and business logic.
* **Feature-First Structure:** Code is organized by feature (e.g., `features/visitors`) rather than by type (e.g., `views/`, `models/`), making the project easier to scale.
* **Repository Pattern:** A `VisitorRepository` class is used to abstract the data source. This makes it easy to swap the local JSON data for a real backend API in the future.
* **JSON Data:** The app simulates fetching data from a remote server by loading and parsing local `.json` files from the `assets` folder.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* An installed version of the **Flutter SDK**.
* An IDE like **VS Code** or **Android Studio**.
* **Developer Mode** enabled on your Windows machine (for symlink support).

### Installation

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git)
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd YOUR_REPOSITORY_NAME
    ```
3.  **Get dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

---

## 📁 Project Structure

The code is organized into a clean, feature-first directory structure: