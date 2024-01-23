import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class journalDetailBoxDonation extends StatelessWidget {
  final DonationState state;

  journalDetailBoxDonation(this.state);

  @override
  Widget build(BuildContext context) {
    if (state == DonationState.donated) {
      return Container(
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: AppThemeColors.green,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Gespendet",
                style: AppThemeTextStyles.small.copyWith(
                  color: AppThemeColors.contrast0,
                )),
            const HeroIcon(
              HeroIcons.checkCircle,
              size: 20,
              color: AppThemeColors.contrast0,
            ),
          ],
        ),
      );
    } else if (state == DonationState.notDonated) {
      return Container(
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppThemeColors.contrast150,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nicht gespendet",
                  style: AppThemeTextStyles.small.copyWith(
                    color: AppThemeColors.contrast800,
                  )),
              const HeroIcon(
                HeroIcons.checkCircle,
                size: 20,
                color: AppThemeColors.contrast700,
              ),
            ],
          ));
    } else {
      return Container();
    }
  }
}
