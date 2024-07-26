import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Myinputetextfield extends StatelessWidget {
  const Myinputetextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SvgPicture.asset("Assets/Icons/search.svg"),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Search here...",
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          )
        ],
      ),
    );
  }
}
