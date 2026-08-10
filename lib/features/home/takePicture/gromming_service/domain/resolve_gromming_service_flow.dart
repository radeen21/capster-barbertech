import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_flow.dart';


/// ⭐ NEW USECASE
class ResolveServiceFlowUseCase {
  ServiceFlow call(GrommingServiceEntity service) {
    if (!service.isAllowPhoto) {
      return ServiceFlow.noPhoto;
    }

    final name = service.name.toLowerCase();

    if (name.contains("color")) {
      return ServiceFlow.colorPaletteThenPhoto;
    }

    if (name.contains("tattoo")) {
      return ServiceFlow.tattooPickerThenPhoto;
    }

    return ServiceFlow.directPhoto;
  }
}

