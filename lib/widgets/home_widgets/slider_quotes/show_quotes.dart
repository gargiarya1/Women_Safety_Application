import 'dart:math';

import 'package:flutter/material.dart';
import 'package:safe/data/quotes.dart';

class ShowQuotes extends StatefulWidget {
  const ShowQuotes({super.key});

  @override
  State<ShowQuotes> createState() => _ShowQuotesState();
}

class _ShowQuotesState extends State<ShowQuotes> {
  //* Random Number Generatre
  int? quoteIndex;
  Random ran = Random();

  void randomNum() {
    setState(() {
      quoteIndex = ran.nextInt(20);
    });
  }

  @override
  void initState() {
    super.initState();
    randomNum();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        randomNum();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        //
        child: Text(
          quotes[quoteIndex!],
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
