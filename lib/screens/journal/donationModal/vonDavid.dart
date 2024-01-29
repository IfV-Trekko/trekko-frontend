import 'package:app_backend/controller/trekko.dart';
import 'package:flutter/cupertino.dart';

class DonationModal extends StatefulWidget {
  final Trekko trekko;

  const DonationModal(this.trekko, {Key? key}) : super(key: key);

  @override
  DonationModalState createState() => DonationModalState();

  static void showModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: 'Tagebuch',
            middle: Text('Wege'),
          ),
          child: Center(
            child: Text('Your drawer content goes here'),
          ),
        );
      },

    );
  }
}

class DonationModalState extends State<DonationModal>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DonationModal.showModal(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Return an empty container as the modal is shown automatically
  }
}
