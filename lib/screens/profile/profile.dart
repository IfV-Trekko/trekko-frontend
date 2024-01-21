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
                    List<CupertinoListTile> questionTiles = [];
                    for (var question in profile.preferences.onboardingQuestions) {
                      if (question.value != null && question.value!.isNotEmpty) { // Only add a ListTile for answered questions
                        questionTiles.add(CupertinoListTile.notched(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          title: Text(question.title,
                          style: AppThemeTextStyles.normal),
                          additionalInfo: Text(question.value!),
                        ));
                      }
                    }
                return Column(
                  children: [
                    CupertinoListSection.insetGrouped(
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      additionalDividerMargin: 4,
                      backgroundColor: AppThemeColors.contrast100,
                      children: [
                        CupertinoListTile.notched(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          title:
                              Text('E-Mail', style: AppThemeTextStyles.normal),
                          additionalInfo: Text(profile.email),
                        ),
                        CupertinoListTile.notched(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          title: Text('Projekt-URL',
                              style: AppThemeTextStyles.normal),
                          additionalInfo: Text(profile.projectUrl),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      additionalDividerMargin: 4,
                      backgroundColor: AppThemeColors.contrast100,
                      children: questionTiles,
                    ),
                  ],
                );
              }
              return const CupertinoActivityIndicator();
            },
          )),
        ],
      ),
    );
  }
}
