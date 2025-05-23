import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:safe/data/image_slider.dart';
import 'package:safe/widgets/home_widgets/slider_quotes/show_webview.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CarouselSlider(
        //
        options: CarouselOptions(
          aspectRatio: 2,
          height: 400,
          autoPlay: true,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          scrollDirection: Axis.vertical,
        ),
        //
        items: List.generate(heading.length, (index) {
          return InkWell(
            //* Load WebView
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return WebviewScreen(url: imageUrl[index]);
              }));
            },
            //
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                //* background image
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(imagePath[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                //
                //* Heading
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    heading[index],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
