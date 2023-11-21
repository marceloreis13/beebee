part of storybook;

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return _widget(context);
  }

  Widget _widget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ThemeApp.isDark(context)
              ? const AssetImage('assets/img/bee-white.png')
              : const AssetImage('assets/img/bee-dark.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: null,
    );
  }
}
