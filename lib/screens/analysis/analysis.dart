import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';

class Analysis extends StatefulWidget {
  final Trekko trekko;

  const Analysis(this.trekko, {Key? key}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      child: CustomScrollView (
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Statistik'),
          ),
          SliverToBoxAdapter(

          )
        ],
      )
    );
  }
}