import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_util;

import 'responsive_scope.dart';

/// Extension methods on [num] providing ScreenUtil-powered scaling and
/// spacing helpers.
///
/// Unlike the old v1 extensions, these delegate directly to
/// `flutter_screenutil` without additional `isNeedScreenUtil` checks -
/// the `ScreenUtilInit` wrapper in [ResponsiveScope.overrideBreakpoints]
/// and [ResponsiveInit] already control `enableScaleWH`/`enableScaleText`
/// per subtree, so the scaling is automatically correct for each scope.
extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => screen_util.ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => screen_util.ScreenUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => screen_util.ScreenUtil().radius(this);

  ///[ScreenUtil.diagonal]
  double get dg => screen_util.ScreenUtil().diagonal(this);

  ///[ScreenUtil.diameter]
  double get dm => screen_util.ScreenUtil().diameter(this);

  ///[ScreenUtil.setSp]
  double get sp => screen_util.ScreenUtil().setSp(this);

  /// Smart size: uses sp but caps at raw value to avoid oversized text
  /// on large screens.
  double get spMin => min(toDouble(), sp);

  @Deprecated('use spMin instead')
  double get sm => min(toDouble(), sp);

  double get spMax => max(toDouble(), sp);

  /// Multiple of screen width
  double get sw => screen_util.ScreenUtil().screenWidth * this;

  /// Multiple of screen height
  double get sh => screen_util.ScreenUtil().screenHeight * this;

  ///[ScreenUtil.setHeight]
  SizedBox get verticalSpace =>
      screen_util.ScreenUtil().setVerticalSpacing(this);

  ///[ScreenUtil.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth =>
      screen_util.ScreenUtil().setVerticalSpacingFromWidth(this);

  ///[ScreenUtil.setWidth]
  SizedBox get horizontalSpace =>
      screen_util.ScreenUtil().setHorizontalSpacing(this);

  ///[ScreenUtil.radius]
  SizedBox get horizontalSpaceRadius =>
      screen_util.ScreenUtil().setHorizontalSpacingRadius(this);

  ///[ScreenUtil.radius]
  SizedBox get verticalSpacingRadius =>
      screen_util.ScreenUtil().setVerticalSpacingRadius(this);

  ///[ScreenUtil.diameter]
  SizedBox get horizontalSpaceDiameter =>
      screen_util.ScreenUtil().setHorizontalSpacingDiameter(this);

  ///[ScreenUtil.diameter]
  SizedBox get verticalSpacingDiameter =>
      screen_util.ScreenUtil().setVerticalSpacingDiameter(this);

  ///[ScreenUtil.diagonal]
  SizedBox get horizontalSpaceDiagonal =>
      screen_util.ScreenUtil().setHorizontalSpacingDiagonal(this);

  ///[ScreenUtil.diagonal]
  SizedBox get verticalSpacingDiagonal =>
      screen_util.ScreenUtil().setVerticalSpacingDiagonal(this);
}

/// Convenience accessor for [ResponsiveScope] from a [BuildContext].
///
/// ```dart
/// final scope = context.responsive;
/// if (scope.isMobile) { ... }
/// ```
extension ResponsiveScopeExtension on BuildContext {
  ResponsiveScope get responsive => ResponsiveScope.of(this);
}
