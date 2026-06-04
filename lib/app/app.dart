import 'package:flutter/material.dart';
import 'package:irisense/core/services/AI/local_llm.dart';
import 'package:provider/provider.dart';
import 'package:irisense/l10n/app_localizations.dart';
// App - ViewModel
import 'app_viewmodel.dart';
// App - Design !!! Bunlar App klasöründen ortak widgets klasörüne taşınacak.
import 'package:irisense/app/borders.dart';
import 'package:irisense/app/cursor.dart';
// Core - Services
import 'package:irisense/core/services/native_service.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/core/services/user_data_manager.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/services/messaging_service.dart';
// Core - Design
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/widgets/navbar.dart';
import 'package:irisense/core/widgets/blackout.dart'; // !!! Bununla uğraşılacak ama şuan değil
// Pages - Tabs - Features
import 'package:irisense/features/settings/views/settings_view.dart';
import 'package:irisense/features/textentry/views/textentry_view.dart';
import 'package:irisense/features/quickchat/views/quickchat_view.dart';
import 'package:irisense/features/messaging/views/gaze_messaging_view.dart';

class IrisenseApp extends StatelessWidget {
  final bool hasPermission;
  const IrisenseApp({super.key, required this.hasPermission});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserDataManager()..init()
        ),

        ChangeNotifierProvider(
            create: (_) => AuthService()..init()
        ),

        ChangeNotifierProxyProvider<AuthService, MessagingService>(
          create: (_) => MessagingService(),
          update: (_, auth, messaging) {
            if (auth.isLoggedIn && auth.currentUser != null) {
              messaging!.init(auth.currentUser!.uid);
            } else {
              messaging!.stopListening();
            }
            return messaging;
          },
        ),

        ChangeNotifierProxyProvider<UserDataManager, AppViewModel>(
          create: (_) => AppViewModel(),
          update: (_, userData, appViewModel) {
            return appViewModel!..soundService.updateLanguage(userData.language);
          },
        ),
      ],
      child: Consumer<UserDataManager>(
        builder: (context, userData, child) {
          return MaterialApp(
            title: 'Irisense',
            debugShowCheckedModeBanner: false,
            locale: userData.language.contains('-') 
              ? Locale(userData.language.split('-')[0], userData.language.split('-')[1])
              : Locale(userData.language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ServiceWrapper(), 
          );
        }
      ),
    );
  }
}

class ServiceWrapper extends StatelessWidget {
  const ServiceWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    LocalLLM.initialize();
    return ChangeNotifierProvider(
      create: (_) => TrackingService(screenSize: screenSize, appViewModel: appViewModel, nativeService: NativeService()),
      
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final trackingService = Provider.of<TrackingService>(context);
    final userDataManager = Provider.of<UserDataManager>(context);

    final bool debugMode = userDataManager.debugMode == "Enabled" ? true : false;
    final auth = Provider.of<AuthService>(context);
    final isPatient = auth.isLoggedIn && auth.currentUser?.role == 'patient';

    final pages = [
      const SettingsTab(),
      const TextEntryPage(),
      const QuickChatPage(),
      if (isPatient) const GazeMessagingPage(),
    ];
    
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [    
          PageView(
            controller: viewModel.pageController,
            onPageChanged: viewModel.onPageChanged,
            children: pages,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Notch(),
          ),
          if (debugMode)
            Borders(),
          if (debugMode)
            Positioned(
              left: trackingService.gazeData.corX, 
              top: trackingService.gazeData.corY,
              child: IgnorePointer(
                child: Cursor(),
              ),
            ),
        ],
      ),
    );
  }
}
