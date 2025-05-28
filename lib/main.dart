import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:yatharthageeta/widgets/common/app_error_widget.dart';
import 'package:yatharthageeta/firebase_options.dart';
import 'package:yatharthageeta/route_observer_service.dart';
import 'package:yatharthageeta/routes/app_route.dart';
import 'package:yatharthageeta/services/download/download_service.dart';
import 'const/colors/colors.dart';
import 'localization/languages.dart';
import 'routes/app_pages.dart';
import 'services/firebase/firebase_cloud_messaging.dart';
import 'services/language/language_service.dart';
import 'services/network/network_service.dart';
import 'views/splash_screen/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails error) {
    return AppErrorWidget(error: error.exceptionAsString());
  };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Future<void> firebaseMessagingBackgroundHandler(
        RemoteMessage messagexx) async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // await initializeService();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    // final _appAttestationPlugin = AppDeviceIntegrity();
    // String sessionId = '550e8400-e29b-41d4-a716-446655440000';
    // int gpc = 1074079544187;
    // String? tokenReceived;

    // if (Platform.isAndroid) {
    //   tokenReceived = await _appAttestationPlugin.getAttestationServiceSupport(
    //       challengeString: sessionId, gcp: gpc);
    // }

    // tokenReceived = await _appAttestationPlugin.getAttestationServiceSupport(
    //     challengeString: sessionId);
    // log(tokenReceived.toString() + " is the token received");

    // await FirebaseMessaging.instance.requestPermission();
    await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/launcher_icon',
        androidBrowsableRootExtras: {},
        androidNotificationClickStartsActivity: true

        // androidShowNotificationBadge: true,
        );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // await JustAudioBackground.init();
    // await FirebaseCloudMessaging().initNotifications();
    FirebaseCloudMessaging firebaseCloudMessaging = FirebaseCloudMessaging();
    // DynamicLinkService dynamicLinkService = DynamicLinkService.instance;
    // final PendingDynamicLinkData? initialLink =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // if (initialLink != null) {
    //   dynamicLinkService.handleDynamicLink();
    // }
    // dynamicLinkService.handleDynamicLink();
    await FirebaseAppCheck.instance.activate(
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:

      // 1. Debug provider
      // 2. Safety Net provider
      // 3. Play Integrity provider
      androidProvider: AndroidProvider.playIntegrity,
      // Default provider for iOS/macOS is the Device Check provider. Yo u can use the "AppleProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Device Check provider
      // 3. App Attest provider
      // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
      appleProvider: AppleProvider.appAttest,
    );
    // DynamicLinkService dynamicLinkService = DynamicLinkService.instance;
    // final PendingDynamicLinkData? initialLink =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // if (initialLink != null) {
    //   dynamicLinkService.handleDynamicLink();
    // }
    // dynamicLinkService.handleDynamicLink();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await firebaseCloudMessaging.setupFlutterNotifications();
    await firebaseCloudMessaging.getFirebaseNotification();

    // await GetStorage.init();

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logAppOpen();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // firebaseCloudMessaging.setupInteractedMessage();
    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(NetworkService());
    Get.put(LangaugeService());
    Get.put(DownloadService());
    WidgetsFlutterBinding.ensureInitialized();
    return ScreenUtilInit(
        designSize: const Size(430, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorObservers: [RouteObserverService()],
            title: 'Yatharth Geeta',
            supportedLocales: [
              const Locale('en'),
            ],
            localizationsDelegates: [
              CountryLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'EN'),
            theme: ThemeData(
              // canvasColor: Colors.transparent,
              colorScheme: ColorScheme.fromSeed(seedColor: kColorPrimary),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
            unknownRoute: GetPage(name: '/splash', page: () => SplashScreen()),
            home: const SplashScreen(),
            //dummy comment
          );
        });
  }
}
