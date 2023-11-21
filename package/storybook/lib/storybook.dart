library storybook;

import 'package:flutter/material.dart';

import 'material_example/constants.dart';
import 'material_example/home.dart';

// Widgets created for the Storybook
part 'widgets/buttons/button.primary.dart';
part 'widgets/buttons/button.secondary.dart';
part 'widgets/buttons/button.text.dart';
part 'widgets/cards/card.form.dart';
part 'widgets/cards/card.mini.dart';
part 'images/logo.image.widget.dart';
part 'themes/theme.app.dart';

class StoryBook extends StatefulWidget {
  const StoryBook({super.key});

  @override
  State<StoryBook> createState() => _StoryBookState();
}

class _StoryBookState extends State<StoryBook> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storybook'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Components',
              icon: Icon(Icons.widgets_outlined),
            ),
            Tab(
              text: 'Typography',
              icon: Icon(Icons.text_snippet_outlined),
            ),
          ],
        ),
      ),
      // Tabs View with 2 tabs, Components and Typography
      body: TabBarView(
        controller: _tabController,
        children: [
          // Components Tab
          ListView(
            children: [
              // Buttons
              const ListTile(
                title: Text('Buttons'),
                subtitle: Text('Primary, Secondary and Text'),
              ),
              ButtonPrimary(
                label: 'Primary',
                onPressed: () {},
              ),
              ButtonSecondary(
                label: 'Secondary',
                onPressed: () {},
              ),
              ButtonText(
                label: 'Text',
                onPressed: () {},
              ),
              // CardForm(
              //   isOutside: true,
              //   title: 'Card Form',
              //   buttonPrimary: ButtonPrimary(
              //     onPressed: () {},
              //     child: const Text('Submit'),
              //   ),
              //   child: const Column(
              //     children: [
              //       TextField(
              //         decoration: InputDecoration(
              //           labelText: 'Label',
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          // Typography Tab
          ListView(
            children: [
              // Typography
              const ListTile(
                title: Text('Typography'),
                subtitle: Text('TODO: Componentize this'),
              ),
              Text('Display Large', style: textTheme.displayLarge),
              Text('Display Medium', style: textTheme.displayMedium),
              Text('Display Small', style: textTheme.displaySmall),
              Text('Headline Large', style: textTheme.headlineLarge),
              Text('Headline Medium', style: textTheme.headlineMedium),
              Text('Headline Small', style: textTheme.headlineSmall),
              Text('Title Large', style: textTheme.titleLarge),
              Text('Title Medium', style: textTheme.titleMedium),
              Text('Title Small', style: textTheme.titleSmall),
              Text('Label Large', style: textTheme.labelLarge),
              Text('Label Medium', style: textTheme.labelMedium),
              Text('Label Small', style: textTheme.labelSmall),
              Text('Body Large', style: textTheme.bodyLarge),
              Text('Body Medium', style: textTheme.bodyMedium),
              Text('Body Small', style: textTheme.bodySmall),
            ],
          ),
        ],
      ),
      // TabBar
    );
  }
}

// Example from Material 3
class MaterialExample extends StatefulWidget {
  const MaterialExample({super.key});

  @override
  State<MaterialExample> createState() => _MaterialExampleState();
}

class _MaterialExampleState extends State<MaterialExample> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material 3',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
      ),
      home: Home(
        useLightMode: useLightMode,
        useMaterial3: useMaterial3,
        colorSelected: colorSelected,
        handleBrightnessChange: handleBrightnessChange,
        handleMaterialVersionChange: handleMaterialVersionChange,
        handleColorSelect: handleColorSelect,
      ),
    );
  }
}
