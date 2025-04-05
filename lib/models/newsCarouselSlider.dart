import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/link.dart';

import 'package:grad_project/models/newsItem.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders =
        News.map(
          (item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(46.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              child: Stack(
                children: <Widget>[
                  Link(
                    target: LinkTarget.self,
                    uri: Uri.parse(item.link),
                    builder:
                        (context, followLink) => InkWell(
                          onTap: followLink,
                          child: Image.network(
                            item.ImgUrl,
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                        ),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.Category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '${item.author} • ${item.Time}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            item.Title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).toList();
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              News.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: _current == entry.key ? 25.0 : 12.0,
                    height: 12.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          _current == entry.key
                              ? BorderRadius.circular(8.0)
                              : null,
                      shape:
                          _current == entry.key
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                      color:
                          _current == entry.key
                              ? Theme.of(context).colorScheme.secondary
                              : const Color.fromARGB(255, 129, 129, 129),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
