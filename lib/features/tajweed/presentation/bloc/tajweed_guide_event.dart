part of 'tajweed_guide_bloc.dart';

abstract class TajweedGuideEvent {
  const TajweedGuideEvent();
}

class TajweedGuideStarted extends TajweedGuideEvent {
  const TajweedGuideStarted();
}
