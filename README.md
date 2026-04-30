# Haramaya University News App

A Flutter mobile application that fetches and displays the latest news from [Haramaya University](https://www.haramaya.edu.et/category/news/) using the WordPress REST API.

---

## 📱 Screenshots

> Live demo available in the Loom video below.

---

## 🚀 Features

- **Live News Feed** — Fetches real-time news from Haramaya University's official website via WordPress REST API
- **Featured News Carousel** — Horizontal scrollable cards highlighting the top 5 latest posts
- **Latest News List** — Paginated vertical list with infinite scroll and "Load More" button
- **Post Detail Screen** — Full article view with featured image, date, day of week, and HTML content
- **Reaction System** — Like 👍, Dislike 👎, Heart ❤️, Fire 🔥 reactions with Snackbar feedback
- **Share Article** — Share any news article via the device's native share sheet
- **Search** — Search posts by title or excerpt with keyword highlighting
- **YouTube Video Player** — Plays embedded YouTube videos found in posts
- **Dark Mode** — Toggle dark/light theme, preference saved and restored across app restarts
- **Onboarding Screen** — Welcome screen with notification permission request
- **Error Handling** — Snackbar with Retry button on network failure
- **Loading Indicators** — Shown while fetching data from the API

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | Cross-platform mobile framework |
| Dart | Programming language |
| WordPress REST API | News data source |
| `http` | API networking |
| `shared_preferences` | Dark mode persistence |
| `cached_network_image` | Efficient image loading |
| `flutter_widget_from_html` | Rendering HTML content |
| `share_plus` | Native share functionality |
| `permission_handler` | Runtime permission requests |
| `youtube_player_flutter` | Embedded YouTube playback |
| `url_launcher` | Opening external links |

---

## 📋 Requirements Fulfilled

| Requirement | Implementation |
|---|---|
| Flutter app with 5 screens | Onboarding, Home, Post Detail, Search, Video |
| Stateless & Stateful widgets | `OnboardingScreen` (Stateless), all others (Stateful) |
| Layout widgets | Row, Column, Stack, ListView, SingleChildScrollView |
| Form/input field | Search TextField in SearchScreen |
| Snackbar feedback | Reaction snackbar + error snackbar with Retry |
| Navigation push/pop | All screens use `Navigator.push` / back button |
| Data passing between screens | Post object passed to detail, list passed to search |
| setState() | Used in all Stateful screens |
| Data persistence | Dark mode saved/loaded via `shared_preferences` |
| API integration | WordPress REST API with JSON parsing |
| Loading indicator | `CircularProgressIndicator` during fetch |
| Error handling | try/catch with user-facing Snackbar |
| Device feature + plugin | Share via `share_plus`, notification permission via `permission_handler` |
| Permission handling | Notification permission requested on onboarding |

---

## 👥 Group Members

| Name | Student ID |
|---|---|
| Member 1 | ID001 |
| Member 2 | ID002 |
| Member 3 | ID003 |
| Member 4 | ID004 |
| Member 5 | ID005 |

> ⚠️ Replace the names and IDs above with your actual group members.

---

## 🎥 Demo Video

📹 [Watch on Loom](#) — *(Replace `#` with your actual Loom video link after recording)*

---

## 📦 APK Download

The release APK is available in the [`/apk`](./apk) folder of this repository.

> Install steps:
> 1. Download `app-release.apk` from the `/apk` folder
> 2. Enable **Install from unknown sources** on your Android phone
> 3. Open the APK file and tap Install

---

## 🔧 How to Run Locally

### Prerequisites
- Flutter SDK (3.x or higher)
- Android Studio or VS Code
- Android device or emulator

### Steps
```bash
# Clone the repository
git clone <your-repo-url>

# Navigate to project
cd News_App_Internship

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK
```bash
flutter build apk --release
```

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── post_model.dart        # Post data model with JSON parsing
├── services/
│   └── api_service.dart       # WordPress REST API calls
└── screens/
    ├── onboarding_screen.dart # Welcome + permission request
    ├── home_screen.dart       # Featured & latest news feed
    ├── post_detail_screen.dart# Full article view + reactions
    ├── search_screen.dart     # Search with keyword highlight
    └── video_screen.dart      # YouTube video player
```

---

## 🌐 API

This app uses the **WordPress REST API** from Haramaya University:

```
Base URL: https://www.haramaya.edu.et/wp-json/wp/v2/posts
Category: news
Embed:    _embed=true (for featured images)
```
