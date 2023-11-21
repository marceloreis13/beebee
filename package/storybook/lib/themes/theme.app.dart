part of storybook;

class ThemeApp extends ChangeNotifier {
  final BuildContext context;

  ThemeApp({required this.context});

  Color get primary {
    return const Color(0xFF2A6170);
  }

  Color get secondary {
    return const Color(0xFFFD5E33);
  }

  Color get grey {
    return Colors.grey.shade800;
  }

  Color get greyMedium {
    return Colors.grey.shade500;
  }

  Color get greyLight {
    return Colors.grey.shade200;
  }

  // Check the current brightness mode
  Brightness get brightness => MediaQuery.of(context).platformBrightness;

  // Check the current brightness mode
  static bool isDark(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  // Check the current brightness mode
  static ThemeData currentTheme(BuildContext context) => isDark(context)
      ? ThemeApp(context: context).darkTheme()
      : ThemeApp(context: context).lightTheme();

  ColorScheme get commomColorScheme {
    return ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: primary,

      // Customisation here
      primary: color(primary, whenDark: Colors.white),
      secondary: secondary,

      // Primary X White
      inversePrimary: color(primary, whenDark: Colors.white),

      // White X Grey
      onPrimary: color(Colors.white, whenDark: grey),

      // Grey X White
      primaryContainer: color(grey, whenDark: Colors.white),

      // GreyMedium X Grey
      onPrimaryContainer: color(greyMedium, whenDark: grey),

      // White X Black
      secondaryContainer: color(Colors.white, whenDark: Colors.black),

      // Primary X Grey
      onBackground: color(primary, whenDark: grey),

      // Secondary X White
      inverseSurface: color(secondary, whenDark: Colors.white),

      // onSurface: color(primary, whenDark: greyLight),
      error: color(Colors.red, whenDark: Colors.white),
      onError: color(
        Colors.red.withOpacity(0.4),
        whenDark: greyLight,
      ),
    );
  }

  // Define the text color based on the brightness mode
  Color color(Color anyAppereance, {Color whenDark = Colors.black}) =>
      brightness == Brightness.dark ? whenDark : anyAppereance;

  ColorScheme fromBrightness({required Brightness brightness}) {
    return commomColorScheme;
  }

  ThemeData lightTheme() {
    return ThemeData(
      // Common
      useMaterial3: true,
      fontFamily: 'Roboto',

      // Custom
      scaffoldBackgroundColor: Colors.grey.shade200,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      colorScheme: fromBrightness(
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',

      // Custom
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      colorScheme: fromBrightness(
        brightness: Brightness.dark,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
    );
  }
}
