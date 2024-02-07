import 'package:app_backend/model/trip/donation_state.dart';
import 'package:app_frontend/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';

class JournalDetailBoxDonation extends StatelessWidget {
  final DonationState state;

  JournalDetailBoxDonation(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    if (state == DonationState.donated) {
      return Container(
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: AppThemeColors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 2.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Gespendet",
                  style: AppThemeTextStyles.small.copyWith(
                    color: AppThemeColors.contrast0,
                  )),
              const SizedBox(width: 2),
              const HeroIcon(
                HeroIcons.checkCircle,
                size: 20,
                color: AppThemeColors.contrast0,
              ),
            ],
          ),
        ),
      );
    } else if (state == DonationState.notDonated) {
      return Container(
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppThemeColors.contrast150,
          ),
          child: Padding(
              padding: const EdgeInsets.only(right: 2.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Nicht gespendet",
                      style: AppThemeTextStyles.small.copyWith(
                        color: AppThemeColors.contrast800,
                      )),
                  const SizedBox(width: 2),
                  const HeroIcon(
                    HeroIcons.checkCircle,
                    size: 20,
                    color: AppThemeColors.contrast700,
                  ),
                ],
              )));
    } else {
      return Container();
    }
  }
}
