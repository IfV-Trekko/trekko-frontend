import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trekko_backend/model/trip/donation_state.dart';
import 'package:trekko_frontend/app_theme.dart';

class DonationBox extends StatelessWidget {
  final DonationState state;

  const DonationBox(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isDonated = state == DonationState.donated;
    if (state == DonationState.undefined) return Container();
    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isDonated ? AppThemeColors.green : AppThemeColors.contrast150,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isDonated ? "Gespendet" : "Nicht gespendet",
                style: AppThemeTextStyles.small.copyWith(
                  color: isDonated
                      ? AppThemeColors.contrast0
                      : AppThemeColors.contrast800,
                )),
            const SizedBox(width: 2),
            HeroIcon(
              isDonated ? HeroIcons.checkCircle : HeroIcons.xCircle,
              size: 20,
              color: isDonated
                  ? AppThemeColors.contrast0
                  : AppThemeColors.contrast700,
            ),
          ],
        ),
      ),
    );
  }
}
