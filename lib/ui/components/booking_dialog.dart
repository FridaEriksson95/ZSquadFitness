import 'package:flutter/material.dart';
import 'package:zsquadfitness/pages/bookings.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/bottom_nav.dart';
import 'package:zsquadfitness/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class BookingDialog extends StatefulWidget {
  const BookingDialog({super.key});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  bool _sendConfirmation = false;
  bool _repeatBooking = false;
  String _repeatDay = 'Onsdagar';
  String _repeatWeeks = '2 veckor fram';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusBig),
      backgroundColor: Colors.transparent,
      insetPadding: paddingVH,
      child: BorderCard(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        alpha: 0.62,
        boxShadow: [shadowGlass1, shadowGlass2, shadowGlass3],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: paddingOnlyLRT,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'BOKA ZUMBA PASS',
                    style: AppTextStyles.h1,
                    textAlign: TextAlign.center,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColors.darkRed),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),

            Padding(
              padding: paddingH20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 90,
                        child: Center(
                          child: Image.asset(
                            AppAssets.logoBlack,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapH10,
                              Text('Zumba', style: AppTextStyles.hT),
                              gapH5,
                              Text('Onsdag 18 februari'),
                              Text('17.40 - 18.40'),
                              Text('Sal 2', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      gapW12,

                      BorderCard(
                        padding: paddingAll8,
                        margin: EdgeInsets.zero,
                        color: AppColors.turquise.withValues(alpha: 0.2),
                        border: buttonGlassBorder,
                        boxShadow: [shadow, shadowGlass2, shadowGlass3],
                        child: Column(
                          children: [
                            Text(
                              '13/20',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '7 lediga',
                              style: AppTextStyles.hT.copyWith(
                                color: AppColors.neonGreen.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gapH20,
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: paddingOnlyTSmall,
                              child: Icon(
                                Icons.pin_drop_rounded,
                                color: AppColors.gold,
                                size: 20,
                              ),
                            ),
                            gapW5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'POP Studios, K7 Stenby',
                                  style: AppTextStyles.hT.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                gapH5,
                                Text(
                                  'Kraftlinjegatan 4, Västerås',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                          ],
                        ),

                        gapH10,

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phonelink_ring_rounded,
                              color: AppColors.gold,
                              size: 20,
                            ),
                            gapW5,
                            Text(
                              '65:- /Pass  |  585:- /10 kort',
                              style: AppTextStyles.hT.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        gapH10,

                        SizedBox(
                          width: 300,
                          child: Divider(
                            color: AppColors.neonGreen.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH5,

                  if (!_repeatBooking) ...[
                    Text(
                      '60 minuter glädjefylld dansträningspass med rytmer från hela världen. Här utlovas svett, kondition, koordination, styrka och energi!',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    gapH10,
                    Text(
                      'Inga förkunskaper krävs, du kör efter egen förmåga. Första gången alltid gratis prova på.',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    gapH15,
                  ],
                ],
              ),
            ),

            Padding(
              padding: paddingH20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bokningsbekräftelse',
                        style: AppTextStyles.hT.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapW35,
                      Switch(
                        value: _sendConfirmation,
                        onChanged: (choice) =>
                            setState(() => _sendConfirmation = choice),
                        activeThumbColor: AppColors.neonGreen,
                        inactiveThumbColor: AppColors.lightGrey,
                        inactiveTrackColor: AppColors.lightBlack,
                      ),
                    ],
                  ),
                  gapH5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upprepa bokning',
                        style: AppTextStyles.hT.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapW70,
                      Switch(
                        value: _repeatBooking,
                        onChanged: (choice) =>
                            setState(() => _repeatBooking = choice),
                        activeThumbColor: AppColors.neonGreen,
                        inactiveThumbColor: AppColors.lightGrey,
                        inactiveTrackColor: AppColors.lightBlack,
                      ),
                    ],
                  ),
                  if (_repeatBooking) ...[
                    gapH10,
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _repeatDay,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightBlack.withValues(
                                alpha: 0.6,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: borderRadiusSmall,
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: paddingVH,
                            ),
                            items: ['Onsdagar', 'Söndagar']
                                .map(
                                  (day) => DropdownMenuItem(
                                    value: day,
                                    child: Text(day),
                                  ),
                                )
                                .toList(),
                            onChanged: (choice) =>
                                setState(() => _repeatDay = choice!),
                          ),
                        ),
                        gapW10,
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _repeatWeeks,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightBlack.withValues(
                                alpha: 0.6,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: borderRadiusSmall,
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: paddingVH,
                            ),
                            items:
                                [
                                      '2 veckor fram',
                                      '3 veckor fram',
                                      '5 veckor fram',
                                    ]
                                    .map(
                                      (w) => DropdownMenuItem(
                                        value: w,
                                        child: Text(w),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (choice) =>
                                setState(() => _repeatWeeks = choice!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            gapH20,
            Padding(
              padding: paddingVH,
              child: SizedBox(
                width: 180,
                child: PrimaryButton(
                  text: 'BOKA',
                  color: AppColors.neonGreen,
                  onPressed: () {
                    //TODO bokningslogik
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        type: ConfirmationType.bookingSuccess,
                        onConfirm: () {
                          Navigator.pop(context);
                          BottomNav.globalKey.currentState?.switchToBookings();
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
