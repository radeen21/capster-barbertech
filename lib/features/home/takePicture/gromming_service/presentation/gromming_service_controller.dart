import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_usecase.dart';
import 'package:flutter/material.dart';

class GrommingServicesController extends ChangeNotifier {
  final GetGroomingServicesUseCase getServicesUseCase;

  GrommingServicesController(this.getServicesUseCase);

  bool isLoading = false;
  List<GrommingServiceEntity> services = [];
  String? error;

  Future<void> fetchServices() async {
    try {
      isLoading = true;
      notifyListeners();

      services = await getServicesUseCase();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool shouldOpenHairGuide(GrommingServiceEntity s) => !s.isRecommended;
  bool shouldShowAddOn(GrommingServiceEntity s) => s.hasAddons;
}
