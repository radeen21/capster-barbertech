enum ServiceStatus {
  processing,
  done,
}

ServiceStatus parseStatus(dynamic value) {
  final v = value?.toString().toUpperCase();

  if (v == "DONE" || v == "COMPLETED") {
    return ServiceStatus.done;
  }

  return ServiceStatus.processing;
}
