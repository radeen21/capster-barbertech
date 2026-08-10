abstract class TakeAddOnPictureState {}

class TakeAddOnInitial extends TakeAddOnPictureState {}

class TakeAddOnLoading extends TakeAddOnPictureState {}

class TakeAddOnSuccess extends TakeAddOnPictureState {
  final Map<String, dynamic> uploadResponse;
  final Map<String, dynamic> generateResponse;

  TakeAddOnSuccess({
    required this.uploadResponse,
    required this.generateResponse,
  });
}

class TakeAddOnError extends TakeAddOnPictureState {
  final String message;
  TakeAddOnError(this.message);
}
