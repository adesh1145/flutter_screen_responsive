import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screenUtil;

import 'responsive_utils.dart';

/// Extension methods on `num` providing ScreenUtil-powered scaling and spacing
/// helpers. These return scaled values only when
/// [ResponsiveUtils.isNeedScreenUtil] is true; otherwise they return the raw
/// numeric value for predictable behavior across breakpoints.
///
/// Examples:
/// - `16.w`, `24.h`, `14.sp`
/// - `8.w.horizontalSpace`, `12.h.verticalSpace`
extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setWidth(this)
      : toDouble();

  ///[ScreenUtil.setHeight]
  double get h => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setHeight(this)
      : toDouble();

  ///[ScreenUtil.radius]
  double get r => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().radius(this)
      : toDouble();

  ///[ScreenUtil.diagonal]
  double get dg => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().diagonal(this)
      : toDouble();

  ///[ScreenUtil.diameter]
  double get dm => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().diameter(this)
      : toDouble();

  ///[ScreenUtil.setSp]
  double get sp {
    final value = ResponsiveUtils.isNeedScreenUtil;
    print("isNeedScreenUtil: $value");
    if (value) {
      return screenUtil.ScreenUtil().setSp(this);
    }
    return toDouble();
  }

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get spMin => min(toDouble(), sp);

  @Deprecated('use spMin instead')
  double get sm => min(toDouble(), sp);

  /// Largest of the raw value and its scaled font size counterpart.
  /// Useful to avoid text getting smaller than a specified minimum.
  double get spMax => max(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().screenWidth * this
      : toDouble();

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().screenHeight * this
      : toDouble();

  ///[ScreenUtil.setHeight]
  SizedBox get verticalSpace => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setVerticalSpacing(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setVerticalSpacingFromWidth(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.setWidth]
  SizedBox get horizontalSpace => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setHorizontalSpacing(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.radius]
  SizedBox get horizontalSpaceRadius => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setHorizontalSpacingRadius(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.radius]
  SizedBox get verticalSpacingRadius => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setVerticalSpacingRadius(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.diameter]
  SizedBox get horizontalSpaceDiameter => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setHorizontalSpacingDiameter(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.diameter]
  SizedBox get verticalSpacingDiameter => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setVerticalSpacingDiameter(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.diagonal]
  SizedBox get horizontalSpaceDiagonal => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setHorizontalSpacingDiagonal(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.diagonal]
  SizedBox get verticalSpacingDiagonal => ResponsiveUtils.isNeedScreenUtil
      ? screenUtil.ScreenUtil().setVerticalSpacingDiagonal(this)
      : SizedBox(height: toDouble());
}
