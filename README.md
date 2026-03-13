![Logga](assets/images/LogoBlack.PNG)

En Flutter-app för att boka Zumba- och träningspass. Byggd med ❤️ för Z Squad fitness i Västerås.

## 📋 Projektplanering
Projektets uppgifter, roadmap och planering finns på Trello:

**[→ Öppna ZSquad Fitness på Trello](https://trello.com/b/tYig1N1V/zsquadfitness)**

## ✨ Funktioner

- Boka och avboka Zumba- och andra träningspass
- Veckokalender med tydlig överblick över kommande pass
- Personlig profil med namn, telefon, e-post + bokningsstatistik
- Inloggning med e-post/lösenord eller Google
- Realtidsuppdateringar via **Firebase Firestore**
- Mörkt neon-tema (grönt/pink/turkos)

- ![App Mockup](assets/images/screenshot.png)

## 🛠 Teknikstack

- **Flutter** (Dart)
- **Firebase**  
  - Authentication (Email + Google Sign-In)
  - Firestore (pass, bokningar, användardata)
- intl för svensk datumformatering
- PageView + GestureDetector för smidig kalender

## 🚀 Kom igång

### Förutsättningar

- [Flutter SDK](https://flutter.dev) (3.24+ rekommenderas 2025/2026)
- Dart SDK (ingår i Flutter)
- Android Studio / Xcode / VS Code
- Firebase-projekt (med Authentication och Firestore aktiverat)

### Steg-för-steg

1. Klona repot

   ```bash
   git clone https://github.com/din-användare/zsquad-fitness.git
   cd zsquad-fitness
   flutter pub get
   dart pub global activate flutterfire_cli
   flutterfire configure --project=(projekt namn)
   flutter run

### Konfigurera Firebase
- Gå till Firebase Console
- Skapa nytt projekt (eller använd befintligt)
- Lägg till Android- och/eller iOS-app
- Ladda ner google-services.json (Android) → placera i android/app/
- Ladda ner GoogleService-Info.plist (iOS) → placera i ios/Runner/
- Aktivera Email/Password och Google i Authentication
- Skapa Firestore-databas (startläge: testläge under utveckling)

 ## ZSquad Fitness – Boka pass, svettas loss, ha kul! 💃🔥🕺
