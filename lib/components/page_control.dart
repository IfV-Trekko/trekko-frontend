import 'package:flutter/cupertino.dart';

class CustomPageControl extends StatefulWidget {
  final List<Widget> pages;
  final double pageHeights;

  const CustomPageControl(
      {Key? key, required this.pages, required this.pageHeights})
      : super(key: key);

  @override
  CustomPageControlState createState() => CustomPageControlState();
}

class CustomPageControlState extends State<CustomPageControl> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentPageHeight = widget.pageHeights;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          height: currentPageHeight,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: widget.pages.map((Widget page) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: page,
              );
            }).toList(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 14.0),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xffDDDDDD).withOpacity(0.75),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: _buildPageIndicator(),
        )
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        widget.pages.length,
        (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? CupertinoColors.darkBackgroundGray
                : CupertinoColors.inactiveGray,
          ),
        ),
      ),
    );
  }
}
