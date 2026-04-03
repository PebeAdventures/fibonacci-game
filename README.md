# Fibonacci Game - Kompletna aplikacja MVP

Przeglądarkowa gra webowa, w której gracz odgaduje kolejne liczby ciągu Fibonacciego.

## Technologie

| Warstwa    | Technologia                              |
|------------|------------------------------------------|
| Backend    | ASP.NET Core 8 Web API + C#              |
| Frontend   | Flutter Web 3.x                          |
| Baza danych| SQLite + Entity Framework Core 8         |
| Stan gry   | Provider + ChangeNotifier (Flutter)      |
| Testy      | xUnit + FluentAssertions                 |

---

## Szybki start (TL;DR)

```bash
# Terminal 1 - Backend
cd backend/FibonacciGame.API
dotnet run

# Terminal 2 - Frontend
cd frontend/fibonacci_game
flutter run -d chrome --web-port 5555
```

Otwórz: http://localhost:5555

---

## Struktura projektu

```
fibonacci-game/
├── backend/
│   ├── FibonacciGame.sln
│   ├── FibonacciGame.API/
│   │   ├── FibonacciGame.API.csproj
│   │   ├── Program.cs                         # Entry point, DI, CORS, middleware
│   │   ├── appsettings.json
│   │   ├── appsettings.Development.json
│   │   ├── Controllers/
│   │   │   ├── GameController.cs              # POST /api/game/start, POST /api/game/answer
│   │   │   └── LeaderboardController.cs       # GET /api/leaderboard, POST /api/leaderboard/save
│   │   ├── Data/
│   │   │   └── AppDbContext.cs                # EF Core DbContext
│   │   ├── DTOs/
│   │   │   ├── GameDtos.cs                    # Request/Response DTOs
│   │   │   └── AnswerWithStateRequest.cs      # Answer + game state DTO
│   │   ├── Entities/
│   │   │   └── GameResult.cs                  # Database entity
│   │   ├── Middleware/
│   │   │   └── GlobalExceptionMiddleware.cs   # Global error handler
│   │   ├── Migrations/                        # EF Core migrations (auto-generated)
│   │   └── Services/
│   │       ├── IFibonacciService.cs
│   │       ├── FibonacciService.cs            # Pure Fibonacci math
│   │       ├── IGameService.cs
│   │       ├── GameService.cs                 # Game logic
│   │       ├── ILeaderboardService.cs
│   │       └── LeaderboardService.cs          # DB operations
│   └── FibonacciGame.Tests/
│       ├── FibonacciGame.Tests.csproj
│       ├── FibonacciServiceTests.cs           # 20 unit tests
│       └── GameServiceTests.cs                # 16 unit tests
└── frontend/
    └── fibonacci_game/
        ├── pubspec.yaml
        ├── lib/
        │   ├── main.dart                      # App entry point
        │   ├── models/
        │   │   ├── game_state.dart            # Active game state model
        │   │   ├── leaderboard_entry.dart     # Leaderboard data model
        │   │   └── save_result_response.dart  # Save result response model
        │   ├── providers/
        │   │   ├── game_provider.dart         # Game state management
        │   │   └── leaderboard_provider.dart  # Leaderboard state management
        │   ├── screens/
        │   │   ├── main_layout.dart           # Nav rail + layout wrapper
        │   │   ├── game_screen.dart           # Game UI (nick entry, active game, game over)
        │   │   ├── leaderboard_screen.dart    # Top 10 results
        │   │   └── info_screen.dart           # About + rules
        │   ├── services/
        │   │   └── api_service.dart           # HTTP client for backend
        │   ├── utils/
        │   │   └── app_theme.dart             # Theme, colors, typography
        │   └── widgets/
        │       ├── answer_feedback_banner.dart
        │       ├── error_message.dart
        │       ├── lives_display.dart
        │       ├── loading_spinner.dart
        │       ├── score_display.dart
        │       └── sequence_display.dart
        └── web/
            ├── index.html
            └── manifest.json
```

---

## Wymagania wstępne

| Narzędzie       | Minimalna wersja | Link do pobrania                                |
|-----------------|------------------|-------------------------------------------------|
| .NET SDK        | 8.0              | https://dotnet.microsoft.com/download/dotnet/8.0 |
| Flutter SDK     | 3.10             | https://docs.flutter.dev/get-started/install    |
| Chrome          | dowolna          | https://www.google.com/chrome/                  |

### Sprawdzenie wersji

```bash
dotnet --version   # Powinno być 8.0.x
flutter --version  # Powinno być 3.x.x
```

---

## Instrukcja uruchomienia krok po kroku

### KROK 1 - Uruchomienie backendu

```bash
# Przejdź do folderu API
cd fibonacci-game/backend/FibonacciGame.API

# Przywróć pakiety NuGet (przy pierwszym uruchomieniu)
dotnet restore

# Uruchom backend (migracje DB są aplikowane automatycznie przy starcie)
dotnet run
```

**Oczekiwany output:**
```
info: FibonacciGame.API.Data[0]
      Database migrations applied successfully.
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
```

Backend dostępny pod: http://localhost:5000
Swagger UI: http://localhost:5000/swagger

### KROK 2 - Uruchomienie frontendu Flutter Web

```bash
# Przejdź do folderu Flutter
cd fibonacci-game/frontend/fibonacci_game

# Zainstaluj pakiety Dart (przy pierwszym uruchomieniu)
flutter pub get

# Uruchom w Chrome na porcie 5555
flutter run -d chrome --web-port 5555
```

**Oczekiwany output:**
```
Launching lib/main.dart on Chrome in debug mode...
...
Flutter run key commands.
r Hot reload. 🔥🔥🔥
```

Aplikacja otwiera się automatycznie w Chrome pod http://localhost:5555

### KROK 3 - Graj!

1. Kliknij zakładkę **Game**
2. Wpisz swój nick
3. Kliknij **Start Game**
4. Wpisuj kolejne liczby ciągu Fibonacciego i klikaj **Confirm**

---

## Migracje bazy danych (opcjonalnie - ręczne)

Migracje są aplikowane automatycznie przy starcie (`db.Database.Migrate()`).
Jeśli chcesz zarządzać nimi ręcznie:

```bash
# Instalacja narzędzia dotnet-ef (jednorazowo)
dotnet tool install --global dotnet-ef
export PATH="$PATH:$HOME/.dotnet/tools"  # Linux/Mac

# Tworzenie nowej migracji
cd backend/FibonacciGame.API
dotnet ef migrations add NazwaMigracji

# Aplikowanie migracji
dotnet ef database update

# Cofnięcie ostatniej migracji
dotnet ef migrations remove

# Plik bazy danych
# Tworzy się automatycznie: backend/FibonacciGame.API/bin/Debug/net8.0/fibonacci_game.db
```

---

## Uruchamianie testów

```bash
cd fibonacci-game/backend
dotnet test FibonacciGame.Tests/FibonacciGame.Tests.csproj --verbosity minimal
```

Oczekiwany wynik: `Passed! - Failed: 0, Passed: 36, Skipped: 0, Total: 36`

---

## Kontrakt API

### POST /api/game/start

Rozpoczyna nową grę. Zwraca stan startowy.

**Request:**
```json
{ "playerName": "Jasiu" }
```

**Response 200:**
```json
{
  "playerName": "Jasiu",
  "initialSequence": [0, 1],
  "currentIndex": 2,
  "lives": 3,
  "score": 0
}
```

---

### POST /api/game/answer

Waliduje odpowiedź gracza. Frontend wysyła pełny stan gry.

**Request:**
```json
{
  "answer": 1,
  "currentIndex": 2,
  "currentScore": 0,
  "currentLives": 3,
  "currentSequence": [0, 1]
}
```

**Response 200 (poprawna odpowiedź):**
```json
{
  "isCorrect": true,
  "message": "Correct! Well done!",
  "correctAnswer": 1,
  "score": 1,
  "lives": 3,
  "gameOver": false,
  "currentSequence": [0, 1, 1],
  "nextIndex": 3
}
```

**Response 200 (błędna odpowiedź):**
```json
{
  "isCorrect": false,
  "message": "Wrong answer! The correct number was 1. You have 2 life/lives remaining.",
  "correctAnswer": 1,
  "score": 0,
  "lives": 2,
  "gameOver": false,
  "currentSequence": [0, 1],
  "nextIndex": 2
}
```

---

### POST /api/leaderboard/save

Zapisuje wynik do bazy. Wywoływany automatycznie gdy gra się kończy.

**Request:**
```json
{
  "playerName": "Jasiu",
  "score": 5,
  "startedAt": "2024-01-01T10:00:00Z",
  "correctAnswers": 5,
  "reachedIndex": 7
}
```

**Response 201:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "playerName": "Jasiu",
  "score": 5,
  "finishedAt": "2024-01-01T10:02:30Z",
  "rank": 3
}
```

---

### GET /api/leaderboard

Zwraca TOP 10 wyników.

**Response 200:**
```json
{
  "entries": [
    {
      "rank": 1,
      "playerName": "Jasiu",
      "score": 10,
      "reachedIndex": 12,
      "finishedAt": "2024-01-01T10:05:00Z",
      "durationSeconds": 120
    }
  ],
  "generatedAt": "2024-01-01T11:00:00Z"
}
```

---

## Pakiety i zależności

### Backend (NuGet)

| Pakiet                                      | Wersja | Cel                          |
|---------------------------------------------|--------|------------------------------|
| Microsoft.EntityFrameworkCore               | 8.0.0  | ORM                          |
| Microsoft.EntityFrameworkCore.Sqlite        | 8.0.0  | Provider SQLite              |
| Microsoft.EntityFrameworkCore.Design        | 8.0.0  | Narzędzia migracji           |
| Swashbuckle.AspNetCore                      | 6.5.0  | Swagger UI                   |
| xUnit                                       | 2.6.2  | Framework testów             |
| FluentAssertions                            | 6.12.0 | Czytelne asercje w testach   |

### Frontend (pubspec.yaml)

| Pakiet          | Wersja   | Cel                                  |
|-----------------|----------|--------------------------------------|
| http            | ^1.2.0   | Klient HTTP do backendu              |
| provider        | ^6.1.2   | State management                     |
| google_fonts    | ^6.2.1   | Typografia (Poppins)                 |
| intl            | ^0.19.0  | Formatowanie dat                     |

---

## Decyzje architektoniczne

### 1. Stan gry po stronie frontendu (stateless backend)

**Decyzja:** Frontend jest właścicielem stanu gry (sequence, lives, score). Stan jest wysyłany z każdym requestem do backendu.

**Uzasadnienie:** Dla lokalnego MVP nie ma sensu trzymać sesji w Redis/DB. Backend waliduje matematykę i zapisuje końcowy wynik.

**Kompromis:** Możliwe jest "oszukiwanie" przez edycję requestów. Akceptowalne dla lokalnej gry.

### 2. Brak Repository Pattern

**Decyzja:** Serwisy używają bezpośrednio `AppDbContext` zamiast przez Repository.

**Uzasadnienie:** Jedna encja (`GameResult`), 2 proste zapytania. Repository Pattern dodałby 2 interfejsy i 2 klasy bez żadnej wartości. DbContext sam w sobie jest abstrakcją nad bazą.

### 3. Provider zamiast Bloc/Riverpod

**Decyzja:** `ChangeNotifier` + `Provider` dla state management we Flutterze.

**Uzasadnienie:** 3 ekrany, prosty flow. Provider jest wystarczający i czytelniejszy niż Bloc. Riverpod byłby over-engineering dla MVP.

### 4. SQLite zamiast PostgreSQL/SQL Server

**Decyzja:** SQLite (plik .db).

**Uzasadnienie:** Zerowa konfiguracja dla lokalnego uruchomienia. Baza tworzy się automatycznie. Wystarczy dla lokalnego MVP z kilkudziesięcioma wynikami.

---

## Ograniczenia MVP

1. **Brak autentykacji** - każdy może wysłać wynik z dowolnym nickiem
2. **Brak limitu requestów** - API nie ma rate limitingu
3. **Stan po stronie klienta** - technicznie możliwe zmanipulowanie wyniku przez modyfikację requestów
4. **SQLite** - nie nadaje się do środowiska produkcyjnego z wieloma użytkownikami
5. **Brak paginacji** w leaderboardzie (tylko TOP 10)
6. **Brak obsługi `long` overflow** dla bardzo dużych indeksów (> F(92) przekracza `long`)

---

## Co warto dodać w wersji 2.0

1. **Autentykacja** - konta użytkowników, JWT
2. **Walidacja wyniku po stronie serwera** - replay logiki gry na backendzie
3. **PostgreSQL** - produkcyjna baza danych
4. **Animacje** - płynniejsze przejścia między odpowiedziami
5. **Tryb czasowy** - licznik odliczający czas na odpowiedź
6. **Kategorie trudności** - więcej lub mniej czasu/żyć
7. **Historia gier gracza** - przechowywanie wszystkich rozgrywek
8. **Testy integracyjne** - WebApplicationFactory dla API endpoints
9. **Widget testy** - Flutter widget tests dla ekranów gry
10. **Docker** - docker-compose do uruchomienia całości jedną komendą
