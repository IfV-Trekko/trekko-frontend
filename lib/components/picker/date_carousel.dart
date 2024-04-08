import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/components/picker/date_picker.dart';

class DateCarousel extends StatefulWidget {
  final DateTime initialTime;
  final Widget Function(DateTime) childBuilder;

  const DateCarousel(
      {Key? key, required this.initialTime, required this.childBuilder})
      : super(key: key);

  @override
  State<DateCarousel> createState() => _DateCarouselState();
}

class _DateCarouselState extends State<DateCarousel> {
  static const int crazyHighNumberSoWeCanScroll = 30000;

  late PageController _pageController;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialTime;
    _pageController = PageController(initialPage: crazyHighNumberSoWeCanScroll);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height * 0.8,
        child: PageView.builder(
          controller: _pageController,
          allowImplicitScrolling: false,
          itemBuilder: (context, index) {
            DateTime date = _currentDate
                .add(Duration(days: index - _pageController.initialPage));
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: DatePicker(
                    time: date,
                    mode: CupertinoDatePickerMode.date,
                    onDateChanged: (newDate) {
                      setState(() {
                        _currentDate = newDate;
                        _pageController.jumpToPage(crazyHighNumberSoWeCanScroll);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: widget.childBuilder(date),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
