import 'package:flutter/material.dart';
import '../theme/style.dart';
import 'layout.dart';

class Item extends StatelessWidget {
  final String title;
  final String description;
  final Widget? action;
  final String? image;

  Item(
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
            Center(
              child: Column(
                children: [
                  Text("$title",
                      style:KTypography.h2(context,color: KColors.primary)),
                  SizedBox(
                    height:5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "$image", // Remplacez par le chemin de votre image
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:40,),
                  Text("$description",
                      style:KTypography.h4(context,color: KColors.primary)),
                  SizedBox(
                    height: 10,
                  ),
                  action ?? Container(),
                ],
              ),
            )
          ],
        ),),
    );
  }
}
