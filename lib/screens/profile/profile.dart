import 'package:flutter/cupertino.dart';

import '../../app_theme.dart';

//class Profile extends StatefulWidget {
//  const Profile({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _ProfileState();
//   }
// }

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
         CupertinoSliverNavigationBar(
            largeTitle: Text('Profil'),
         ),
         SliverFillRemaining(
           child: Column(
             children: [
               CupertinoListSection.insetGrouped(
                 margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                 additionalDividerMargin: 4,
                 backgroundColor: AppThemeColors.contrast100,
                 children: <CupertinoListTile>[
                   CupertinoListTile.notched(
                     padding: EdgeInsets.only(left: 16, right: 16),
                     title: Text('Name', style: AppThemeTextStyles.normal),
                     additionalInfo: const Text('Dein Name'),
                   ),
                   CupertinoListTile.notched(
                     padding: EdgeInsets.only(left: 16, right: 16),
                     title: Text('Name', style: AppThemeTextStyles.normal),
                     additionalInfo: const Text('Dein Name'),
                   ),
                 ],
               ),
               CupertinoListSection.insetGrouped(
                 margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                 additionalDividerMargin: 4,
                 backgroundColor: AppThemeColors.contrast100,
                 children: <CupertinoListTile>[
                   CupertinoListTile.notched(
                     padding: EdgeInsets.only(left: 16, right: 16),
                     title: Text('Name', style: AppThemeTextStyles.normal),
                     additionalInfo: const Text('Dein Name'),
                   ),
                   CupertinoListTile.notched(
                     padding: EdgeInsets.only(left: 16, right: 16),
                     title: const Text('Name'),
                     additionalInfo: const Text('Dein Name'),
                   ),
                 ],
               ),
             ],
           ),
         ),
        ],
      ),
    );
  }
}