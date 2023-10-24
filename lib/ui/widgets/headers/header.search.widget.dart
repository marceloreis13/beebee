import 'package:flutter/material.dart';

class HeaderSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearchTextChanged;

  const HeaderSearch({
    super.key,
    required this.controller,
    required this.onSearchTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.zero,
          child: Material(
            elevation: 2.0,
            // borderRadius: BorderRadius.all(Radius.circular(Env.radiusDefault)),
            child: TextField(
              onChanged: onSearchTextChanged,
              controller: controller,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: "Busca",
                hintStyle: Theme.of(context).textTheme.titleMedium,
                prefixIcon: const Material(
                  elevation: 0.0,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Icon(Icons.search),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
