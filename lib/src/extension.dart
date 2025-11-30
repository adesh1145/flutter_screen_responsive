import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as su
    hide
        SizeExtension,
        EdgeInsetsExtension,
        BorderRadiusExtension,
        RadiusExtension,
        BoxConstraintsExtension;

import 'responsive_utils.dart';

/// App-provided extensions that wrap `flutter_screenutil` so you can use
/// ergonomic helpers like `.w`, `.h`, `.sp`, spacing widgets, and adapters
/// for `EdgeInsets`, `BorderRadius`, `Radius`, and `BoxConstraints`.
///
/// We import `flutter_screenutil` as `su` and hide its own extension symbols
/// to avoid name clashes with the extensions defined here. Scaling only applies
/// when `ResponsiveUtils.isNeedScreenUtil` is true for the active breakpoint.

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
      ? su.ScreenUtil().setWidth(this)
      : toDouble();

  ///[ScreenUtil.setHeight]
  double get h => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setHeight(this)
      : toDouble();

  ///[ScreenUtil.radius]
  double get r => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().radius(this)
      : toDouble();

  ///[ScreenUtil.diagonal]
  double get dg => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().diagonal(this)
      : toDouble();

  ///[ScreenUtil.diameter]
  double get dm => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().diameter(this)
      : toDouble();

  ///[ScreenUtil.setSp]
  double get sp {
    final value = ResponsiveUtils.isNeedScreenUtil;
    if (value) {
      return su.ScreenUtil().setSp(this);
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
      ? su.ScreenUtil().screenWidth * this
      : toDouble();

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().screenHeight * this
      : toDouble();

  ///[ScreenUtil.setHeight]
  SizedBox get verticalSpace => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setVerticalSpacing(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setVerticalSpacingFromWidth(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.setWidth]
  SizedBox get horizontalSpace => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setHorizontalSpacing(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.radius]
  SizedBox get horizontalSpaceRadius => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setHorizontalSpacingRadius(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.radius]
  SizedBox get verticalSpacingRadius => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setVerticalSpacingRadius(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.diameter]
  SizedBox get horizontalSpaceDiameter => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setHorizontalSpacingDiameter(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.diameter]
  SizedBox get verticalSpacingDiameter => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setVerticalSpacingDiameter(this)
      : SizedBox(height: toDouble());

  ///[ScreenUtil.diagonal]
  SizedBox get horizontalSpaceDiagonal => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setHorizontalSpacingDiagonal(this)
      : SizedBox(width: toDouble());

  ///[ScreenUtil.diagonal]
  SizedBox get verticalSpacingDiagonal => ResponsiveUtils.isNeedScreenUtil
      ? su.ScreenUtil().setVerticalSpacingDiagonal(this)
      : SizedBox(height: toDouble());
}

extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r => copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );

  EdgeInsets get dm => copyWith(
        top: top.dm,
        bottom: bottom.dm,
        right: right.dm,
        left: left.dm,
      );

  EdgeInsets get dg => copyWith(
        top: top.dg,
        bottom: bottom.dg,
        right: right.dg,
        left: left.dg,
      );

  EdgeInsets get w => copyWith(
        top: top.w,
        bottom: bottom.w,
        right: right.w,
        left: left.w,
      );

  EdgeInsets get h => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.h,
        left: left.h,
      );
}

extension BorderRadiusExtension on BorderRadius {
  /// Creates adapt BorderRadius using r [SizeExtension].
  BorderRadius get r => copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomRight.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );

  BorderRadius get w => copyWith(
        bottomLeft: bottomLeft.w,
        bottomRight: bottomRight.w,
        topLeft: topLeft.w,
        topRight: topRight.w,
      );

  BorderRadius get h => copyWith(
        bottomLeft: bottomLeft.h,
        bottomRight: bottomRight.h,
        topLeft: topLeft.h,
        topRight: topRight.h,
      );
}

extension RadiusExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);

  Radius get dm => Radius.elliptical(x.dm, y.dm);

  Radius get dg => Radius.elliptical(x.dg, y.dg);

  Radius get w => Radius.elliptical(x.w, y.w);

  Radius get h => Radius.elliptical(x.h, y.h);
}

extension BoxConstraintsExtension on BoxConstraints {
  /// Creates adapt BoxConstraints using r [SizeExtension].
  BoxConstraints get r => copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// Creates adapt BoxConstraints using h-w [SizeExtension].
  BoxConstraints get hw => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );

  BoxConstraints get w => copyWith(
        maxHeight: maxHeight.w,
        maxWidth: maxWidth.w,
        minHeight: minHeight.w,
        minWidth: minWidth.w,
      );

  BoxConstraints get h => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.h,
        minHeight: minHeight.h,
        minWidth: minWidth.h,
      );
}
