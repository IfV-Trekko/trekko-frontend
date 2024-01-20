import 'package:app_backend/controller/trekko.dart';
import 'package:flutter/cupertino.dart';
import '../../app_theme.dart';
import 'package:app_backend/model/profile/profile.dart';



//class Profile extends StatefulWidget {
//  const Profile({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _ProfileState();
//   }
// }

class ProfileScreen extends StatelessWidget {
  final Trekko trekko;

  const ProfileScreen(this.trekko);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
         CupertinoSliverNavigationBar(
            largeTitle: Text('Profil'),
         ),
         SliverFillRemaining(
           child: StreamBuilder<Profile>(
             stream: trekko.getProfile(),
             builder: (context, snapshot) {
               if (snapshot.hasData) {
                 Profile profile = snapshot.data!;
                 return Column(
                   children: [
                     CupertinoListSection.insetGrouped(
                       margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                       additionalDividerMargin: 4,
                       backgroundColor: AppThemeColors.contrast100,
                       children: <CupertinoListTile>[
                         CupertinoListTile.notched(
                           padding: EdgeInsets.only(left: 16, right: 16),
                           title: Text('E-Mail', style: AppThemeTextStyles.normal),
                           additionalInfo: Text(profile.email),
                         ),
                         CupertinoListTile.notched(
                           padding: EdgeInsets.only(left: 16, right: 16),
                           title: Text('Name', style: AppThemeTextStyles.normal),
                           additionalInfo: const Text("Dein Name"),
                           ),
                       ],
                     ),
                   ],
                 );
               }
                return const CupertinoActivityIndicator();
             },
           )
         ),
        ],
      ),
    );
  }
}