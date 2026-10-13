import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource_factory.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/repositories/auth_repository_impl.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/repositories/firestore_donation_processor.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/repositories/post_repository_impl.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/repositories/profile_repository_impl.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/auth_repository.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/donation_processor.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/post_repository.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/profile_repository.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/authenticate_biometric.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/create_post.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_device_info.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_posts.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_profile.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/send_donation.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_in.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_out.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_up.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/update_profile_photo.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/watch_auth_state.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/post_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/profile_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/auth_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/biometric_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/device_info_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/storage_service.dart';
import 'package:get_it/get_it.dart';

/// Service locator for repositories, use cases, and cubits.
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<FirestoreService>(FirestoreService.new);
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(firebaseAuth: FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<BiometricService>(BiometricService.new);
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(storage: FirebaseStorage.instance),
  );
  getIt.registerLazySingleton<DeviceInfoService>(DeviceInfoService.new);
  getIt.registerLazySingleton<PostDataSourceFactory>(
    () => PostDataSourceFactory(getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: getIt(), firestoreService: getIt()),
  );
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(factory: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      firestoreService: getIt(),
      storageService: getIt(),
      deviceInfoService: getIt(),
    ),
  );
  getIt.registerLazySingleton<DonationProcessor>(
    () => FirestoreDonationProcessor(getIt()),
  );

  getIt.registerLazySingleton(() => SignIn(getIt()));
  getIt.registerLazySingleton(() => SignUp(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => WatchAuthState(getIt()));
  getIt.registerLazySingleton(() => GetPosts(getIt()));
  getIt.registerLazySingleton(() => CreatePost(getIt()));
  getIt.registerLazySingleton(() => GetProfile(getIt()));
  getIt.registerLazySingleton(() => UpdateProfilePhoto(getIt()));
  getIt.registerLazySingleton(() => GetDeviceInfo(getIt()));
  getIt.registerLazySingleton(() => SendDonation(getIt()));
  getIt.registerLazySingleton(() => AuthenticateBiometric(getIt()));

  getIt.registerLazySingleton(
    () => AuthCubit(
      signIn: getIt(),
      signUp: getIt(),
      signOut: getIt(),
      watchAuthState: getIt(),
    ),
  );
  getIt.registerFactory(
    () => PostCubit(getPosts: getIt(), createPost: getIt()),
  );
  getIt.registerFactory(
    () => ProfileCubit(
      getProfile: getIt(),
      updateProfilePhoto: getIt(),
      getDeviceInfo: getIt(),
      sendDonation: getIt(),
    ),
  );
}
