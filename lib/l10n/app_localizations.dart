import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @straight.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get straight;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @leftUp.
  ///
  /// In en, this message translates to:
  /// **'Left Up'**
  String get leftUp;

  /// No description provided for @up.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get up;

  /// No description provided for @rightUp.
  ///
  /// In en, this message translates to:
  /// **'Right Up'**
  String get rightUp;

  /// No description provided for @leftDown.
  ///
  /// In en, this message translates to:
  /// **'Left Down'**
  String get leftDown;

  /// No description provided for @down.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get down;

  /// No description provided for @rightDown.
  ///
  /// In en, this message translates to:
  /// **'Right Down'**
  String get rightDown;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings Tab'**
  String get settingsTab;

  /// No description provided for @eyeFrame.
  ///
  /// In en, this message translates to:
  /// **'Eye Frame'**
  String get eyeFrame;

  /// No description provided for @inputLog.
  ///
  /// In en, this message translates to:
  /// **'Gaze Input Log'**
  String get inputLog;

  /// No description provided for @eyePos.
  ///
  /// In en, this message translates to:
  /// **'Eye Position'**
  String get eyePos;

  /// No description provided for @eyeReg.
  ///
  /// In en, this message translates to:
  /// **'Eye Region'**
  String get eyeReg;

  /// No description provided for @calibrationBtn0.
  ///
  /// In en, this message translates to:
  /// **'Start Calibration'**
  String get calibrationBtn0;

  /// No description provided for @calibrationBtn1.
  ///
  /// In en, this message translates to:
  /// **'Look Top Left (1/2)'**
  String get calibrationBtn1;

  /// No description provided for @calibrationBtn2.
  ///
  /// In en, this message translates to:
  /// **'Look Bottom Right (2/2)'**
  String get calibrationBtn2;

  /// No description provided for @calibrationBtn3.
  ///
  /// In en, this message translates to:
  /// **'Finish Calibration'**
  String get calibrationBtn3;

  /// No description provided for @slcTime.
  ///
  /// In en, this message translates to:
  /// **'Selection Time'**
  String get slcTime;

  /// No description provided for @slcTimeOpt0.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get slcTimeOpt0;

  /// No description provided for @slcTimeOpt1.
  ///
  /// In en, this message translates to:
  /// **'Standart'**
  String get slcTimeOpt1;

  /// No description provided for @slcTimeOpt2.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slcTimeOpt2;

  /// No description provided for @slcTimeOpt3.
  ///
  /// In en, this message translates to:
  /// **'Very Slow'**
  String get slcTimeOpt3;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @genModel.
  ///
  /// In en, this message translates to:
  /// **'Generation Model'**
  String get genModel;

  /// No description provided for @genModelOpt0.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get genModelOpt0;

  /// No description provided for @genModelOpt1.
  ///
  /// In en, this message translates to:
  /// **'Local LLM'**
  String get genModelOpt1;

  /// No description provided for @debugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debugMode;

  /// No description provided for @debugModeOpt0.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get debugModeOpt0;

  /// No description provided for @debugModeOpt1.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get debugModeOpt1;

  /// No description provided for @textEntry.
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get textEntry;

  /// No description provided for @textEntryTab.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Tab'**
  String get textEntryTab;

  /// No description provided for @switchAction.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @speakAction.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speakAction;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text: {text}'**
  String text(Object text);

  /// No description provided for @addContext.
  ///
  /// In en, this message translates to:
  /// **'Add Context'**
  String get addContext;

  /// No description provided for @context.
  ///
  /// In en, this message translates to:
  /// **'Context: {context}'**
  String context(Object context);

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'No Match'**
  String get noMatch;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next Page'**
  String get nextPage;

  /// No description provided for @defaultText.
  ///
  /// In en, this message translates to:
  /// **'Until a cure found for ALS, Technology will remain our medicine.'**
  String get defaultText;

  /// No description provided for @defaultLLM.
  ///
  /// In en, this message translates to:
  /// **'To enable this feature, select the Generation Model option.'**
  String get defaultLLM;

  /// No description provided for @quickChat.
  ///
  /// In en, this message translates to:
  /// **'Visual Tab'**
  String get quickChat;

  /// No description provided for @quickChatTab.
  ///
  /// In en, this message translates to:
  /// **'Visual Tab'**
  String get quickChatTab;

  /// No description provided for @qc0.
  ///
  /// In en, this message translates to:
  /// **'Basic Needs'**
  String get qc0;

  /// No description provided for @qc0opt0.
  ///
  /// In en, this message translates to:
  /// **'I want to eat something.'**
  String get qc0opt0;

  /// No description provided for @qc0opt1.
  ///
  /// In en, this message translates to:
  /// **'I want to sleep.'**
  String get qc0opt1;

  /// No description provided for @qc0opt2.
  ///
  /// In en, this message translates to:
  /// **'I need to use the toilet.'**
  String get qc0opt2;

  /// No description provided for @qc0opt3.
  ///
  /// In en, this message translates to:
  /// **'I want to drink water.'**
  String get qc0opt3;

  /// No description provided for @qc0opt4.
  ///
  /// In en, this message translates to:
  /// **'I want to take a shower.'**
  String get qc0opt4;

  /// No description provided for @qc0opt5.
  ///
  /// In en, this message translates to:
  /// **'Please change my position.'**
  String get qc0opt5;

  /// No description provided for @qc1.
  ///
  /// In en, this message translates to:
  /// **'Frequently Used'**
  String get qc1;

  /// No description provided for @qc1opt0.
  ///
  /// In en, this message translates to:
  /// **'Yes.'**
  String get qc1opt0;

  /// No description provided for @qc1opt1.
  ///
  /// In en, this message translates to:
  /// **'I dont know.'**
  String get qc1opt1;

  /// No description provided for @qc1opt2.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get qc1opt2;

  /// No description provided for @qc1opt3.
  ///
  /// In en, this message translates to:
  /// **'Thank You.'**
  String get qc1opt3;

  /// No description provided for @qc1opt4.
  ///
  /// In en, this message translates to:
  /// **'Hello.'**
  String get qc1opt4;

  /// No description provided for @qc1opt5.
  ///
  /// In en, this message translates to:
  /// **'My apologies.'**
  String get qc1opt5;

  /// No description provided for @qc2.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get qc2;

  /// No description provided for @qc2opt0.
  ///
  /// In en, this message translates to:
  /// **'I am happy.'**
  String get qc2opt0;

  /// No description provided for @qc2opt1.
  ///
  /// In en, this message translates to:
  /// **'I am sad.'**
  String get qc2opt1;

  /// No description provided for @qc2opt2.
  ///
  /// In en, this message translates to:
  /// **'I am angry.'**
  String get qc2opt2;

  /// No description provided for @qc2opt3.
  ///
  /// In en, this message translates to:
  /// **'I am scared.'**
  String get qc2opt3;

  /// No description provided for @qc2opt4.
  ///
  /// In en, this message translates to:
  /// **'I am confused.'**
  String get qc2opt4;

  /// No description provided for @qc2opt5.
  ///
  /// In en, this message translates to:
  /// **'I feel nervous.'**
  String get qc2opt5;

  /// No description provided for @qc3.
  ///
  /// In en, this message translates to:
  /// **'Environment Control'**
  String get qc3;

  /// No description provided for @qc3opt0.
  ///
  /// In en, this message translates to:
  /// **'I feel hot.'**
  String get qc3opt0;

  /// No description provided for @qc3opt1.
  ///
  /// In en, this message translates to:
  /// **'I feel cold.'**
  String get qc3opt1;

  /// No description provided for @qc3opt2.
  ///
  /// In en, this message translates to:
  /// **'It is too noisy.'**
  String get qc3opt2;

  /// No description provided for @qc3opt3.
  ///
  /// In en, this message translates to:
  /// **'It is too bright.'**
  String get qc3opt3;

  /// No description provided for @qc3opt4.
  ///
  /// In en, this message translates to:
  /// **'It is too dark.'**
  String get qc3opt4;

  /// No description provided for @qc3opt5.
  ///
  /// In en, this message translates to:
  /// **'The air feels stuffy.'**
  String get qc3opt5;

  /// No description provided for @qc4.
  ///
  /// In en, this message translates to:
  /// **'Social Activities and Recreation'**
  String get qc4;

  /// No description provided for @qc4opt0.
  ///
  /// In en, this message translates to:
  /// **'I want to go outside.'**
  String get qc4opt0;

  /// No description provided for @qc4opt1.
  ///
  /// In en, this message translates to:
  /// **'I want to read the newspaper.'**
  String get qc4opt1;

  /// No description provided for @qc4opt2.
  ///
  /// In en, this message translates to:
  /// **'I want to listen to music.'**
  String get qc4opt2;

  /// No description provided for @qc4opt3.
  ///
  /// In en, this message translates to:
  /// **'I want to watch television.'**
  String get qc4opt3;

  /// No description provided for @qc4opt4.
  ///
  /// In en, this message translates to:
  /// **'I want to listen to the radio.'**
  String get qc4opt4;

  /// No description provided for @qc4opt5.
  ///
  /// In en, this message translates to:
  /// **'I want to play a game.'**
  String get qc4opt5;

  /// No description provided for @qc5.
  ///
  /// In en, this message translates to:
  /// **'Medical Needs'**
  String get qc5;

  /// No description provided for @qc5opt0.
  ///
  /// In en, this message translates to:
  /// **'I feel some pain.'**
  String get qc5opt0;

  /// No description provided for @qc5opt1.
  ///
  /// In en, this message translates to:
  /// **'I feel extreme pain.'**
  String get qc5opt1;

  /// No description provided for @qc5opt2.
  ///
  /// In en, this message translates to:
  /// **'I need to eat my pills.'**
  String get qc5opt2;

  /// No description provided for @qc5opt3.
  ///
  /// In en, this message translates to:
  /// **'I need to go to the hospital.'**
  String get qc5opt3;

  /// No description provided for @qc5opt4.
  ///
  /// In en, this message translates to:
  /// **'I feel fine.'**
  String get qc5opt4;

  /// No description provided for @qc5opt5.
  ///
  /// In en, this message translates to:
  /// **'I need to see a doctor.'**
  String get qc5opt5;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get profileLogin;

  /// No description provided for @profileCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get profileCreateAccount;

  /// No description provided for @profileSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get profileSignUp;

  /// No description provided for @profileLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get profileLoginSubtitle;

  /// No description provided for @profileRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your information to create a new account'**
  String get profileRegisterSubtitle;

  /// No description provided for @profileFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profileFirstName;

  /// No description provided for @profileLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profileLastName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'0555 123 45 67'**
  String get profilePhoneHint;

  /// No description provided for @profilePassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profilePassword;

  /// No description provided for @profileRoleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Who will use this app?'**
  String get profileRoleQuestion;

  /// No description provided for @profileRoleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileRoleUser;

  /// No description provided for @profileRolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get profileRolePatient;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileRegDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get profileRegDate;

  /// No description provided for @profileNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get profileNoAccount;

  /// No description provided for @profileHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get profileHaveAccount;

  /// No description provided for @profileGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in or register'**
  String get profileGuestSubtitle;

  /// No description provided for @profileUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsername;

  /// No description provided for @profileEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get profileEmailOrPhone;

  /// No description provided for @profileUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number is required'**
  String get profileUsernameRequired;

  /// No description provided for @profileUsernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email or phone number'**
  String get profileUsernameInvalid;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get profileEmailRequired;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get profileEmailInvalid;

  /// No description provided for @profilePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get profilePhoneRequired;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (e.g.: 05XX XXX XX XX)'**
  String get profilePhoneInvalid;

  /// No description provided for @profilePasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get profilePasswordRequired;

  /// No description provided for @profilePasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get profilePasswordTooShort;

  /// No description provided for @profileFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String profileFieldRequired(Object field);

  /// No description provided for @profileFieldTooShort.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least 2 characters'**
  String profileFieldTooShort(Object field);

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetworkFailed.
  ///
  /// In en, this message translates to:
  /// **'Network connection error.'**
  String get authErrorNetworkFailed;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get profileNewPassword;

  /// No description provided for @profileNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep current password'**
  String get profileNewPasswordHint;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @messagesTab.
  ///
  /// In en, this message translates to:
  /// **'Messages Tab'**
  String get messagesTab;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchUsers;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @fromContacts.
  ///
  /// In en, this message translates to:
  /// **'From Contacts'**
  String get fromContacts;

  /// No description provided for @userNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This person is not registered in the app'**
  String get userNotRegistered;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @authErrorUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken.'**
  String get authErrorUsernameTaken;

  /// No description provided for @profileUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mehmet123'**
  String get profileUsernameHint;

  /// No description provided for @profileUsernameFormatInvalid.
  ///
  /// In en, this message translates to:
  /// **'Only letters, digits and _ allowed (min. 3 chars)'**
  String get profileUsernameFormatInvalid;

  /// No description provided for @profilePhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (Optional)'**
  String get profilePhoneOptional;

  /// No description provided for @slotRemoveContact.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get slotRemoveContact;

  /// No description provided for @slotRemoveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove contact'**
  String get slotRemoveConfirmTitle;

  /// No description provided for @slotRemoveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This contact will be removed from this eye movement slot. Messages will not be deleted.'**
  String get slotRemoveConfirmBody;

  /// No description provided for @slotRemoveConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get slotRemoveConfirmYes;

  /// No description provided for @slotRemoveConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get slotRemoveConfirmNo;

  /// No description provided for @tabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get tabContacts;

  /// No description provided for @tabUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get tabUsername;

  /// No description provided for @backAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backAction;

  /// No description provided for @sendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendAction;

  /// No description provided for @aiThinking.
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get aiThinking;

  /// No description provided for @aiSuggestionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'AI sentence will appear here'**
  String get aiSuggestionPlaceholder;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'hi', 'it', 'pt', 'ru', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'it': return AppLocalizationsIt();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
