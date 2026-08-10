abstract class TakePhotoState {}

class TakePhotoInitial extends TakePhotoState {}

class TakePhotoLoading extends TakePhotoState {}

class TakePhotoSuccess extends TakePhotoState {
  final Map<String, dynamic> uploadResponse;
  final Map<String, dynamic> analyzeResponse;
  final Map<String, dynamic> generateResponse;

  TakePhotoSuccess({
    required this.uploadResponse,
    required this.analyzeResponse,
    required this.generateResponse,
  });
}

class TakePhotoError extends TakePhotoState {
  final String message;
  TakePhotoError(this.message);
}
