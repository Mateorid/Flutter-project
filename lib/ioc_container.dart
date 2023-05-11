import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_sitting/services/ad_service.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/date_service.dart';
import 'package:pet_sitting/services/icon_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/services/storage_service.dart';
import 'package:pet_sitting/services/user_service.dart';

final get = GetIt.instance;

class IoCContainer {
  Future<void> setup() async {
    get.registerSingleton<FirebaseAuth>(
      FirebaseAuth.instance,
    );

    get.registerSingleton<StorageService>(
      StorageService(),
    );

    get.registerSingleton<AdService>(
      AdService(),
    );

    get.registerSingleton<PetService>(
      PetService(),
    );

    get.registerSingleton<AuthService>(
      AuthService(get<FirebaseAuth>()),
    );

    get.registerSingleton<UserService>(
      UserService(),
    );

    get.registerSingleton<IconService>(
      IconService(),
    );

    get.registerSingleton<DateService>(
      DateService(),
    );
  }
}
