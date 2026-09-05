import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/auth/data/auth_local_data_source.dart';
import 'package:capster_barbertech/features/auth/data/auth_remote_data_source.dart';
import 'package:capster_barbertech/features/auth/data/auth_repository_impl.dart';
import 'package:capster_barbertech/features/auth/data/session/auth_session_repository_impl.dart';
import 'package:capster_barbertech/features/auth/domain/auth_repository.dart';
import 'package:capster_barbertech/features/auth/domain/login_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/auth/presentation/login_controller.dart';
import 'package:capster_barbertech/features/auth/presentation/logout_controller.dart';
import 'package:capster_barbertech/features/home/customerRecord/data/capster_history_remote_data_source.dart';
import 'package:capster_barbertech/features/home/customerRecord/data/capster_history_repository_impl.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_repository.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/get_capster_history_usecase.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/data/finish_service_remote_data_source.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/data/finish_service_repository_impl.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/domain/finish_service_repository.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/domain/finish_service_usecase.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/domain/upload_photo_usecase.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/presentation/finish_service_controller.dart';
import 'package:capster_barbertech/features/home/customerRecord/presentation/capster_history_controller.dart';
import 'package:capster_barbertech/features/home/history/data/history_remote_data_source.dart';
import 'package:capster_barbertech/features/home/history/data/history_repository_impl.dart';
import 'package:capster_barbertech/features/home/history/domain/get_history_usecase.dart';
import 'package:capster_barbertech/features/home/history/domain/history_repository.dart';
import 'package:capster_barbertech/features/home/history/presentation/history_controller.dart';
import 'package:capster_barbertech/features/home/starService/data/start_service_remote_data_source.dart';
import 'package:capster_barbertech/features/home/starService/data/start_service_repository.dart';
import 'package:capster_barbertech/features/home/starService/data/start_service_repository_impl.dart';
import 'package:capster_barbertech/features/home/starService/domain/start_service_usecase.dart';
import 'package:capster_barbertech/features/home/starService/presentation/start_service_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/data/photo_remote_data_source.dart';
import 'package:capster_barbertech/features/home/takePicture/data/photo_repository_impl.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_controller.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {

  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() => DioClient.create());
  }

  if (!locator.isRegistered<AuthSessionRepositoryImpl>()) {
    locator.registerLazySingleton<AuthSessionRepositoryImpl>(
      () => AuthSessionRepositoryImpl(),
    );
  }

  if (!locator.isRegistered<AuthSessionRepository>()) {
    locator.registerLazySingleton<AuthSessionRepository>(
      () => locator<AuthSessionRepositoryImpl>(),
    );
  }

  if (!locator.isRegistered<AuthRemoteDataSource>()) {
    locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(locator()),
    );
  }

  if (!locator.isRegistered<AuthLocalDataSource>()) {
    locator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );
  }

  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        locator<AuthRemoteDataSource>(),
        locator<AuthLocalDataSource>(),
      ),
    );
  }

  if (!locator.isRegistered<LoginUseCase>()) {
    locator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(
        authRepository: locator<AuthRepository>(),
        sessionRepository: locator<AuthSessionRepository>(),
      ),
    );
  }

  locator.registerFactory<LoginController>(
    () => LoginController(locator<LoginUseCase>()),
  );

  if (!locator.isRegistered<LogoutUseCase>()) {
    locator.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(locator<AuthRepository>()),
    );
  }

  locator.registerFactory<LogoutController>(
    () => LogoutController(locator<LogoutUseCase>()),
  );

  if (!locator.isRegistered<PhotoRemoteDataSource>()) {
    locator.registerLazySingleton<PhotoRemoteDataSource>(
      () => PhotoRemoteDataSource(locator()),
    );
  }

  if (!locator.isRegistered<PhotoRepository>()) {
    locator.registerLazySingleton<PhotoRepository>(
      () => PhotoRepositoryImpl(locator()),
    );
  }

  if (!locator.isRegistered<TakeAndAnalyzePhotoUseCase>()) {
    locator.registerLazySingleton<TakeAndAnalyzePhotoUseCase>(
      () => TakeAndAnalyzePhotoUseCase(locator()),
    );
  }

  locator.registerFactory<TakePhotoController>(
    () => TakePhotoController(useCase: locator(), sessionRepository: locator()),
  );

  if (!locator.isRegistered<HistoryRemoteDataSource>()) {
    locator.registerLazySingleton<HistoryRemoteDataSource>(
      () => HistoryRemoteDataSource(locator<Dio>()),
    );
  }

  if (!locator.isRegistered<HistoryRepository>()) {
    locator.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(locator<HistoryRemoteDataSource>()),
    );
  }

  if (!locator.isRegistered<GetHistoriesUseCase>()) {
    locator.registerLazySingleton<GetHistoriesUseCase>(
      () => GetHistoriesUseCase(locator<HistoryRepository>()),
    );
  }

  locator.registerFactory<HistoryController>(
    () => HistoryController(locator<GetHistoriesUseCase>()),
  );

  locator.registerLazySingleton(
    () => CapsterHistoryRemoteDataSource(locator()),
  );

  locator.registerLazySingleton<CapsterHistoryRepository>(
    () => CapsterHistoryRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => GetCapsterHistoriesUseCase(locator()));

  locator.registerFactory(() => CapsterHistoryController(locator()));

  locator.registerLazySingleton(
    () => StartServiceRemoteDataSourceImpl(locator<Dio>()),
  );

  locator.registerLazySingleton<StartServiceRepository>(
    () =>
        StartServiceRepositoryImpl(locator<StartServiceRemoteDataSourceImpl>()),
  );

  locator.registerLazySingleton(
    () => StartServiceUseCase(locator<StartServiceRepository>()),
  );

  locator.registerFactory(
    () => StartServiceController(locator<StartServiceUseCase>()),
  );

  locator.registerLazySingleton<FinishServiceRemoteDataSource>(
    () => FinishServiceRemoteDataSource(locator<Dio>()),
  );

  locator.registerLazySingleton<FinishServiceRepository>(
    () => FinishServiceRepositoryImpl(locator<FinishServiceRemoteDataSource>()),
  );

  locator.registerLazySingleton<FinishServiceUseCase>(
    () => FinishServiceUseCase(locator<FinishServiceRepository>()),
  );

  locator.registerFactory<FinishServiceController>(
    () => FinishServiceController(locator<FinishServiceUseCase>()),
  );

  locator.registerLazySingleton<UploadPhotoUseCase>(
    () => UploadPhotoUseCase(locator<PhotoRepository>()),
  );
}
