import 'package:flutter/material.dart';
import 'package:safe/widgets/home_widgets/slider_quotes/show_quotes.dart';
import 'package:safe/widgets/home_widgets/slider_quotes/image_slider.dart';
import 'package:safe/widgets/home_widgets/slider_quotes/show_webview.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Quote Card
                Text(
                  'Quote for you',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Card(
                  color: Color(0xFFf5557f),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        ShowQuotes(),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                //* Image Slider with Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'News for you',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    const ImageSlider(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}