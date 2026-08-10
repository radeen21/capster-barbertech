String extractHaircutNameFromUrl(String url) {
  try {
    final fileName = url.split("/").last;

    // buang suffix timestamp
    final nameWithoutTimestamp =
        fileName.split(RegExp(r'_\d+_result')).first;

    // replace underscore → spasi
    final withSpaces = nameWithoutTimestamp.replaceAll("_", " ");

    return withSpaces.trim();
  } catch (_) {
    return "-";
  }
}
