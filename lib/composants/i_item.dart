import 'package:flutter/material.dart';
import '../theme/style.dart';
import 'layout.dart';
class IItem extends StatelessWidget {
  final String title;
  final String description;
  final String? image;
  final Widget? action;

  IItem(
      {super.key,
        required this.title,
        required this.image,
        this.action,
        required this.description});

  @override
  Widget build(BuildContext context) {
    return Layout(

      title: "",
      subtitle: "",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(

            children: [
              Text("$title",
                  style:KTypography.h1(context,color: KColors.primary)),
              SizedBox(
                height:18 ,
              ),
              Text("$description",
                  style:KTypography.h3(context,color: KColors.primary)),
              SizedBox(
                height: 10,
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
              const SizedBox(height: 50),
              action ?? Container(),
            ],
          )
        ],
      ),);
  }
}
