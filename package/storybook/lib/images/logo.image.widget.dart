part of storybook;

class LogoImage extends StatelessWidget {
  final double? size;

  const LogoImage({
    super.key,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return _buildLogo(context);
  }

  Widget _buildLogo(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ThemeApp.isDark(context)
                ? const AssetImage('assets/img/bee-white.png')
                : const AssetImage('assets/img/bee-dark.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: null,
      ),
    );
  }
}
