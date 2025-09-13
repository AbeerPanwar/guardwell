import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/data/repositories/contact_repository_impl.dart';
import 'package:guardwell/data/repositories/location_repository_impl.dart';
import 'package:guardwell/data/services/contact_service.dart';
import 'package:guardwell/data/services/hive_service.dart';
import 'package:guardwell/data/services/location_service.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';
import 'package:guardwell/domain/usecases/location/get_current_location.dart';
import 'package:guardwell/domain/usecases/contacts/get_emergency_contacts.dart';
import 'package:guardwell/domain/usecases/send_sos_message.dart';
import 'package:guardwell/injection_container.dart' as di;
import 'package:guardwell/presentation/bloc/contacts/contacts_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/sos/sos_cubit.dart';
import 'package:guardwell/presentation/bloc/system_contacts/system_contacts_cubit.dart';
import 'package:guardwell/presentation/screens/auth/splash_screen.dart';
import 'package:guardwell/presentation/screens/home_screen.dart';
import 'package:guardwell/presentation/screens/setup_screens/setup_contact_screen.dart';
import 'package:guardwell/presentation/screens/setup_screens/setup_language_screen.dart';
import 'package:guardwell/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveService.init();
  await dotenv.load();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('bn'),
        Locale('ta'),
        Locale('te'),
        Locale('mr'),
        Locale('gu'),
        Locale('kn'),
        Locale('ml'),
        Locale('pa'),
        Locale('ur'),
      ],
      path: 'assets/translations', // <-- translations folder
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final contactRepository = ContactRepositoryImpl(ContactService());
    final locationRepository = LocationRepositoryImpl(
      LocationService(baseUrl: dotenv.env['NODE_JS_BACKEND_URI']!, token: ''),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ContactRepository>.value(value: contactRepository),
        RepositoryProvider<LocationRepositoryImpl>.value(
          value: locationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(
            create: (context) => LocationBloc(
              getCurrentLocation: GetCurrentLocation(locationRepository),
              locationRepository,
            )..add(const LoadLocation()),
          ),
          BlocProvider<ContactsBloc>(
            create: (context) => ContactsBloc(repository: contactRepository),
          ),
          BlocProvider<SystemContactsCubit>(
            create: (context) =>
                SystemContactsCubit(repository: contactRepository),
          ),
          BlocProvider<SosCubit>(
            create: (context) => SosCubit(
              LocationBloc(
                locationRepository,
                getCurrentLocation: GetCurrentLocation(locationRepository),
              ),
              getEmergencyContacts: GetEmergencyContacts(contactRepository),
              sendSosMessage: SendSosMessage(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: lightTheme,
              // darkTheme: darkTheme,
              // themeMode: ThemeMode.system,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _hasEmergencyContacts = false;

  @override
  void initState() {
    super.initState();
    _checkInitialSetup();
  }

  Future<void> _checkInitialSetup() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLanguage = prefs.getBool('languageSelected') ?? false;

    if (!hasLanguage) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
        );
      }
      return;
    }
    try {
      final repository = RepositoryProvider.of<ContactRepository>(context);
      final hasContacts = await repository.hasEmergencyContactsConfigured();
      if (mounted) {
        setState(() {
          _hasEmergencyContacts = hasContacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasEmergencyContacts = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Initializing app...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    return _hasEmergencyContacts
        ? const HomeScreen()
        : const SetupContactScreen();
  }
}
