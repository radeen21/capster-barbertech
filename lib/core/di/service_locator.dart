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
  // =====================
  // CORE
  // =====================
  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() => DioClient.create());
  }

  // =====================
  // AUTH SESSION (🔥 FIXED)
  // =====================
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

  // =====================
  // AUTH DATA
  // =====================
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

  // =====================
  // AUTH USECASES
  // =====================
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

  // =====================
  // PHOTO FEATURE
  // =====================
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

  // // =====================
  // // REGISTER FEATURE
  // // =====================
  // if (!locator.isRegistered<RegisterRemoteDataSource>()) {
  //   locator.registerLazySingleton<RegisterRemoteDataSource>(
  //     () => RegisterRemoteDataSource(),
  //   );
  // }

  // if (!locator.isRegistered<RegisterRepository>()) {
  //   locator.registerLazySingleton<RegisterRepository>(
  //     () => RegisterRepositoryImpl(locator()),
  //   );
  // }

  // if (!locator.isRegistered<RegisterUseCase>()) {
  //   locator.registerLazySingleton<RegisterUseCase>(
  //     () => RegisterUseCase(locator()),
  //   );
  // }

  // locator.registerFactory<RegisterController>(
  //   () => RegisterController(registerUseCase: locator()),
  // );

  // // =====================
  // // POINTS FEATURE
  // // =====================
  // if (!locator.isRegistered<PointsRemoteDataSource>()) {
  //   locator.registerLazySingleton<PointsRemoteDataSource>(
  //     () => PointsRemoteDataSource(locator()),
  //   );
  // }

  // if (!locator.isRegistered<PointsRepository>()) {
  //   locator.registerLazySingleton<PointsRepository>(
  //     () => PointsRepositoryImpl(locator()),
  //   );
  // }

  // if (!locator.isRegistered<GetPointsUseCase>()) {
  //   locator.registerLazySingleton<GetPointsUseCase>(
  //     () => GetPointsUseCase(locator()),
  //   );
  // }

  // locator.registerFactory<PointsController>(() => PointsController(locator()));

  // =====================
  // CAPSTER FEATURE ✅ FINAL
  // =====================

  // locator.registerLazySingleton<CapsterRemoteDataSource>(
  //   () => CapsterRemoteDataSource(locator()),
  // );

  // locator.registerLazySingleton<CapsterRepository>(
  //   () => CapsterRepositoryImpl(locator()),
  // );

  // locator.registerLazySingleton<GetCapstersUseCase>(
  //   () => GetCapstersUseCase(locator()),
  // );

  // locator.registerFactory<CapsterController>(
  //   () => CapsterController(locator()),
  // );

  // locator.registerFactory(() => TakeAddOnPictureController(locator()));

  // locator.registerLazySingleton(() => TakeAndGenerateAddOnUseCase(locator()));

  // locator.registerLazySingleton<AddOnPhotoRepository>(
  //   () => AddOnPhotoRepositoryImpl(locator()),
  // );

  // locator.registerLazySingleton(() => AddOnPhotoApi(locator<Dio>()));

  // =====================
  // HISTORY FEATURE 🕘
  // =====================

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

  // =====================
  // CAPSTER HISTORY
  // =====================
  locator.registerLazySingleton(
    () => CapsterHistoryRemoteDataSource(locator()),
  );

  locator.registerLazySingleton<CapsterHistoryRepository>(
    () => CapsterHistoryRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => GetCapsterHistoriesUseCase(locator()));

  locator.registerFactory(() => CapsterHistoryController(locator()));

  // Start Service
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

  // // VOUCHER
  // locator.registerLazySingleton<VoucherRemoteDataSource>(
  //   () => VoucherRemoteDataSourceImpl(locator<Dio>()),
  // );

  // locator.registerLazySingleton<VoucherRepository>(
  //   () => VoucherRepositoryImpl(locator()),
  // );

  // locator.registerLazySingleton(() => GetVouchersUseCase(locator()));

  // locator.registerFactory(() => VoucherController(locator()));

  // locator.registerLazySingleton<RedeemVoucherUseCase>(
  //   () => RedeemVoucherUseCaseImpl(locator()),
  // );

  // locator.registerLazySingleton(() => QrRemoteDataSource(locator<Dio>()));
  // locator.registerLazySingleton<QrRepository>(
  //   () => QrRepositoryImpl(locator()),
  // );
  // locator.registerLazySingleton(() => ScanQrUseCase(locator()));
  // locator.registerFactory(() => ScanController(locator()));

  // // REVIEW FEATURE
  // locator.registerLazySingleton(() => ReviewRemoteDataSource(locator<Dio>()));

  // locator.registerLazySingleton<ReviewRepository>(
  //   () => ReviewRepositoryImpl(locator()),
  // );

  // locator.registerLazySingleton(() => SubmitReviewUseCase(locator()));

  // locator.registerFactory(() => ReviewController(locator()));

  // =====================
  // FINISH SERVICE FEATURE ✅
  // =====================

  // remote
  locator.registerLazySingleton<FinishServiceRemoteDataSource>(
    () => FinishServiceRemoteDataSource(locator<Dio>()),
  );

  // repository
  locator.registerLazySingleton<FinishServiceRepository>(
    () => FinishServiceRepositoryImpl(locator<FinishServiceRemoteDataSource>()),
  );

  // usecase
  locator.registerLazySingleton<FinishServiceUseCase>(
    () => FinishServiceUseCase(locator<FinishServiceRepository>()),
  );

  // controller (⚠️ factory, bukan singleton)
  locator.registerFactory<FinishServiceController>(
    () => FinishServiceController(locator<FinishServiceUseCase>()),
  );

  // =====================
  // UPLOAD PHOTO USECASE (REUSED)
  // =====================
  locator.registerLazySingleton<UploadPhotoUseCase>(
    () => UploadPhotoUseCase(locator<PhotoRepository>()),
  );
}
