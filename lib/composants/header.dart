import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../theme/style.dart'; // Adapte ce chemin à ton projet

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;


  const Header({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style:KTypography.h2(context,color: KColors.primary)
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

