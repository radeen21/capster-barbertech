import 'package:capster_barbertech/features/auth/domain/auth_repository.dart';

class GetRoleUseCase {
  final AuthRepository repository;

  GetRoleUseCase(this.repository);

  Future<String?> call() {
    return repository.getRole();
  }
}
