import 'package:flutter/material.dart';
import 'package:loge_app/theme/style.dart';
import '../../composants/logo.dart';

class Layout extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget child;

  const Layout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
     
      Expanded(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$title",
                  style:KTypography.h3(context,color: KColors.primary),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$subtitle",
                  style: KTypography.h4(context,color:KColors.primary),
                ),
                SizedBox(
                  height: 10 * 2,
                ),
                child,
              ],
            ),
          ],
        ),
      ),
    ];

   return Row(
  children: widgets,
);
  }
}
