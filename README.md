# Academix

Academix is an Android application designed to help users explore universities in different countries. The app provides a seamless authentication system and allows users to browse a list of universities based on their selected country.

## Features

- **User Authentication**
  * Register using email, password, and name.
  * Log in using email and password.
  * Logout option available.

- **University Exploration**
  * Select a country to view available universities.
  * Click on a university to visit its official website.
  * Change the selected country at any time.

## Getting Started

### Prerequisites
* Android Studio (latest version recommended)
* Java/Kotlin development environment
* Android SDK

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/academix.git
   ```
2. **Open the project in Android Studio**
   * Go to **File > Open** and select the project folder.
   * Wait for Gradle sync to complete.
3. **Run the application**
   * Connect an Android device or use an emulator.
   * Click on **Run > Run 'app'**.

## Build Instructions

### Generate Debug APK
1. Open **Android Studio**.
2. Navigate to **Build > Build Bundle(s) / APK(s) > Build APK(s)**.
3. Once the build is complete, find the APK at:
   ```
   app/build/outputs/apk/debug/app-debug.apk
   ```

### Generate Signed Release APK
1. Go to **Build > Generate Signed Bundle / APK...**.
2. Choose **APK** and click **Next**.
3. Create or select an existing **keystore**, enter credentials.
4. Select **release** and sign with V1 and V2 signatures.
5. The signed APK will be generated at:
   ```
   app/release/app-release.apk
   ```

## Contributing
Contributions are welcome! Feel free to fork the project and submit a pull request with improvements or bug fixes.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
For any inquiries or support:
* **Developer:** Your Name
* **Email:** dilanabkanov@gmail.com
* **GitHub:** [wAnekz](https://github.com/wAnekz)

---
Happy coding!

