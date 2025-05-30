import 'package:flutter/material.dart';
import '../theme/style.dart';
import 'layout.dart';

class Item1 extends StatelessWidget {
  final String title;
  final String description;
  final Widget? action;
  final String? image;

  Item1(
      {super.key,
      required this.title,
      required this.image,
      this.action,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Layout(
        title: "",
        subtitle: "",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    "$image", // Remplacez par le chemin de votre image
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  Text("$title",
                      style: KTypography.h2(context, color: KColors.primary)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("$description",
                      style: KTypography.h5(context, color: KColors.primary)),
                  SizedBox(
                    height: 10 * 2,
                  ),
                  action ?? Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
