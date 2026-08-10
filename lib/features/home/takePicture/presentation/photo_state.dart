class PhotoState {
  final bool isLoading;
  final String? uploadedPhotoId;
  final String? error;

  const PhotoState({
    this.isLoading = false,
    this.uploadedPhotoId,
    this.error,
  });

  PhotoState copyWith({
    bool? isLoading,
    String? uploadedPhotoId,
    String? error,
  }) {
    return PhotoState(
      isLoading: isLoading ?? this.isLoading,
      uploadedPhotoId: uploadedPhotoId ?? this.uploadedPhotoId,
      error: error,
    );
  }
}
