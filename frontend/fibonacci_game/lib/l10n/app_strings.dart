/// Simple in-app localization without flutter_localizations / gen-l10n overhead.
/// Two supported languages: English (en) and Polish (pl).
/// Language is switched at runtime via LanguageProvider.
class AppStrings {
  final String langCode;
  const AppStrings._(this.langCode);

  static const AppStrings en = AppStrings._('en');
  static const AppStrings pl = AppStrings._('pl');

  static AppStrings of(String code) => code == 'pl' ? pl : en;

  // =====================================================================
  // APP GENERAL
  // =====================================================================
  String get appTitle => _s('Fibonacci Game', 'Gra Fibonacciego');
  String get switchToPolish => 'PL';
  String get switchToEnglish => 'EN';

  // =====================================================================
  // NAVIGATION
  // =====================================================================
  String get navGame => _s('Game', 'Gra');
  String get navLeaderboard => _s('Leaderboard', 'Wyniki');
  String get navInfo => _s('Info', 'Informacje');

  // =====================================================================
  // GAME SCREEN — nick entry
  // =====================================================================
  String get enterYourName => _s('Enter your name', 'Wpisz swoje imię');
  String get nickLabel => _s('Nick or name', 'Nick lub imię');
  String get nickHint => _s('e.g. Jasiu', 'np. Jasiu');
  String get nickValidationEmpty => _s('Please enter your name', 'Proszę podać imię lub nick');
  String get startGame => _s('Start Game', 'Rozpocznij grę');
  String get howToPlay => _s('How to play', 'Jak grać');
  String get subtitleHowFar =>
      _s('How far can you go in the sequence?', 'Jak daleko zajdziesz w ciągu?');

  // Rules
  String get ruleStartSequence =>
      _s('You start with sequence: 0, 1', 'Zaczynasz z ciągiem: 0, 1');
  String get ruleGuess =>
      _s('Guess the next Fibonacci number', 'Odgadnij kolejną liczbę Fibonacciego');
  String get ruleCorrect =>
      _s('+1 point for each correct answer', '+1 punkt za każdą poprawną odpowiedź');
  String get ruleWrong =>
      _s('3 lives — wrong answers cost you one', '3 życia — błędna odpowiedź kosztuje jedno');
  String get ruleLeaderboard =>
      _s('Top 10 results saved to leaderboard', 'TOP 10 wyników trafia na tablicę wyników');

  // =====================================================================
  // GAME SCREEN — active game
  // =====================================================================
  String get sequenceSoFar => _s('Sequence so far:', 'Dotychczasowy ciąg:');
  String get whatComesNext => _s('What comes next?', 'Co jest następne?');
  String get yourAnswer => _s('Your answer', 'Twoja odpowiedź');
  String get enterNumber => _s('Enter a number', 'Wpisz liczbę');
  String get confirm => _s('Confirm', 'Zatwierdź');
  String get keepGuessing => _s('Keep guessing!', 'Zgaduj dalej!');
  String get startingGame => _s('Starting game...', 'Rozpoczynanie gry...');
  String get invalidNumber =>
      _s('Please enter a valid number', 'Proszę podać poprawną liczbę');

  String positionLabel(int index) =>
      _s('Position: F($index)', 'Pozycja: F($index)');

  // =====================================================================
  // GAME SCREEN — game over
  // =====================================================================
  String get gameOver => _s('Game Over!', 'Koniec gry!');
  String betterLuck(String name) =>
      _s('Better luck next time, $name!', 'Następnym razem będzie lepiej, $name!');
  String get finalScore => _s('Final Score', 'Wynik końcowy');
  String get points => _s('points', 'punktów');
  String get savingScore => _s('Saving your score...', 'Zapisywanie wyniku...');
  String rankLabel(int rank) =>
      _s('Rank #$rank on leaderboard!', 'Miejsce #$rank na tablicy wyników!');
  String reachedLabel(int index) =>
      _s('Reached F($index) in the sequence', 'Dotarłeś do F($index) w ciągu');
  String get playAgain => _s('Play Again', 'Zagraj ponownie');

  // =====================================================================
  // LEADERBOARD SCREEN
  // =====================================================================
  String get leaderboardTitle => _s('Top 10 Leaderboard', 'TOP 10 Najlepszych wyników');
  String get leaderboardLoading =>
      _s('Loading leaderboard...', 'Ładowanie tablicy wyników...');
  String get leaderboardEmpty => _s('No results yet', 'Brak wyników');
  String get leaderboardEmptySub =>
      _s('Be the first to complete a game!', 'Bądź pierwszy — ukończ grę!');
  String get colPlayer => _s('Player', 'Gracz');
  String get colScore => _s('Score', 'Punkty');
  String get colDuration => _s('Duration', 'Czas');
  String get pts => _s('pts', 'pkt');

  // =====================================================================
  // INFO SCREEN
  // =====================================================================
  String get infoTitle => _s('About', 'O grze');
  String get infoAboutTitle => _s('About the Game', 'O grze');
  String get infoAboutBody => _s(
    'Fibonacci Game is a browser-based quiz game where you test your knowledge '
    'of the Fibonacci sequence. Starting from the well-known pair 0, 1, '
    'you must correctly guess each successive number in the sequence.',
    'Gra Fibonacciego to przeglądarkowa gra quizowa, w której sprawdzasz swoją wiedzę '
    'o ciągu Fibonacciego. Zaczynając od dobrze znanych liczb 0, 1, '
    'musisz poprawnie odgadnąć każdą kolejną liczbę w ciągu.',
  );
  String get infoAboutBody2 => _s(
    'The Fibonacci sequence is one of the most famous sequences in mathematics: '
    'each number is the sum of the two preceding numbers. It appears in nature, '
    'art, architecture, and computer science.',
    'Ciąg Fibonacciego to jeden z najbardziej znanych ciągów w matematyce: '
    'każda liczba jest sumą dwóch poprzednich. Pojawia się w naturze, '
    'sztuce, architekturze i informatyce.',
  );
  String get infoSequenceTitle => _s('The Fibonacci Sequence', 'Ciąg Fibonacciego');
  String get infoFormula =>
      _s('Formula: F(n) = F(n-1) + F(n-2), with F(0) = 0 and F(1) = 1',
          'Wzór: F(n) = F(n-1) + F(n-2), gdzie F(0) = 0 i F(1) = 1');
  String get infoRulesTitle => _s('Rules', 'Zasady');

  String get infoRuleStartTitle => _s('Starting', 'Start');
  String get infoRuleStartDesc => _s(
    'Enter your name and start a new game. The sequence begins with: 0, 1',
    'Podaj imię i rozpocznij nową grę. Ciąg zaczyna się od: 0, 1',
  );
  String get infoRuleCorrectTitle => _s('Correct answer', 'Poprawna odpowiedź');
  String get infoRuleCorrectDesc => _s(
    '+1 point, number added to sequence, field highlights green',
    '+1 punkt, liczba dołącza do ciągu, pole podświetla się na zielono',
  );
  String get infoRuleWrongTitle => _s('Wrong answer', 'Błędna odpowiedź');
  String get infoRuleWrongDesc => _s(
    '-1 life. You can retry the same position. The sequence does not advance.',
    '-1 życie. Możesz ponowić próbę dla tej samej pozycji. Ciąg się nie przesuwa.',
  );
  String get infoRuleLivesTitle => _s('Lives', 'Życia');
  String get infoRuleLivesDesc => _s(
    'You start with 3 lives. Losing all 3 ends the game.',
    'Zaczynasz z 3 życiami. Utrata wszystkich 3 kończy grę.',
  );
  String get infoRuleLeaderTitle => _s('Leaderboard', 'Tablica wyników');
  String get infoRuleLeaderDesc => _s(
    'Your result is automatically saved after the game ends. '
    'Top 10 scores are shown on the leaderboard.',
    'Wynik jest zapisywany automatycznie po zakończeniu gry. '
    'TOP 10 wyników widoczne jest na tablicy.',
  );

  String get infoSpecialTitle => _s('Special Note', 'Specjalna notatka');
  String get infoSpecialMessage => 'Jasiu jest super!';

  String get infoTechTitle => _s('Tech Stack', 'Technologie');
  String get infoTechFrontend => 'Flutter Web';
  String get infoTechBackend => 'ASP.NET Core 8 Web API';
  String get infoTechDb => 'SQLite + Entity Framework Core 8';
  String get infoTechState => 'Provider + ChangeNotifier';

  // =====================================================================
  // ERRORS
  // =====================================================================
  String get errConnectionTitle => _s('Connection Error', 'Błąd połączenia');
  String get errRetry => _s('Retry', 'Spróbuj ponownie');

  // =====================================================================
  // PRIVATE HELPER
  // =====================================================================
  String _s(String en, String pl) => langCode == 'pl' ? pl : en;
}
