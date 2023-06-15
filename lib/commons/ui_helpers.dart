import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final double _tinySizeheight     = 5.h;
final double _smallSizeheight    = 10.h;
final double _mediumSizeheight   = 25.h;
final double _largeSizeheight    = 50.h;
final double _massiveSizeheight  = 120.h;
final double _regularheight      = 18.h;

final double _tinySizewidth     = 5.w;
final double _smallSizewidth    = 10.w;
final double _mediumSizewidth   = 25.w;
final double _largeSizewidth    = 50.w;
final double _massiveSizewidth  = 120.w;
final double _regularwidth      = 18.w;


final Widget horizontalSpaceTiny     = SizedBox(width: _tinySizewidth);
final Widget horizontalSpaceSmall    = SizedBox(width: _smallSizewidth);
final Widget horizontalSpaceRegular  = SizedBox(width: _regularwidth);
final Widget horizontalSpaceMedium   = SizedBox(width: _mediumSizewidth);
final Widget horizontalSpaceLarge    = SizedBox(width: _largeSizewidth);
final Widget horizontalSpaceMassive  = SizedBox(height: _massiveSizewidth);

final Widget verticalSpaceTiny     = SizedBox(height: _tinySizeheight);
final Widget verticalSpaceSmall    = SizedBox(height: _smallSizeheight);
final Widget verticalSpaceRegular  = SizedBox(height: _regularheight);
final Widget verticalSpaceMedium   = SizedBox(height: _mediumSizeheight);
final Widget verticalSpaceLarge    = SizedBox(height: _largeSizeheight);
final Widget verticalSpaceMassive  = SizedBox(height: _massiveSizeheight);

Widget spacedDivider = Column(
  children:  <Widget>[
    verticalSpaceMedium,
    Divider(color: Colors.blueGrey, height: 5.h),
    verticalSpaceMedium,
  ],
);

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;


Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double quarterScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 4);

double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 10);
double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 14, max: 15);

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 16, max: 17);

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 21, max: 31);

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 25);

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 30);

double getResponsiveFontSize(BuildContext context,
    {double? fontSize, double? max}) {
  max ??= 100;

  var responsiveSize = min(
      screenWidthFraction(context, dividedBy: 10) * ((fontSize ?? 100) / 100),
      max);
  
  return responsiveSize;
}

