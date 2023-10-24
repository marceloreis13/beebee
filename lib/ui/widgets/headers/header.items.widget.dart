import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/helpers/forms.helper.dart';
import 'package:app/app/routes/route.dart';

class HeaderItem extends StatelessWidget {
  final Routes? route;
  final Color? color;
  final Widget? item;
  final Function? onTap;
  final Function? completion;

  const HeaderItem({
    super.key,
    this.route,
    this.color,
    this.item,
    this.onTap,
    this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primaryContainer;

    Forms forms = Provider.of<Forms>(context);
    bool isBusy = forms.isBusy();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: color.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(32.0),
        ),
        onTap: isBusy
            ? null
            : () {
                if (route != null) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pushNamed(context, route!.value).then((value) {
                    if (completion != null) {
                      completion!();
                    }
                  });
                } else if (onTap != null) {
                  onTap!();
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: item ??
              Icon(
                Icons.add,
                color: color,
              ),
        ),
      ),
    );
  }
}
