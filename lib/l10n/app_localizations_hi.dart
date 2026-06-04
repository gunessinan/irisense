// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get straight => 'सीधा';

  @override
  String get closed => 'बंद';

  @override
  String get leftUp => 'बायां ऊपर';

  @override
  String get up => 'ऊपर';

  @override
  String get rightUp => 'दायां ऊपर';

  @override
  String get leftDown => 'बायां नीचे';

  @override
  String get down => 'नीचे';

  @override
  String get rightDown => 'दायां नीचे';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settingsTab => 'सेटिंग्स टैब';

  @override
  String get eyeFrame => 'नेत्र फ्रेम';

  @override
  String get inputLog => 'गेज़ इनपुट लॉग';

  @override
  String get eyePos => 'आंख की स्थिति';

  @override
  String get eyeReg => 'आंख का क्षेत्र';

  @override
  String get calibrationBtn0 => 'अंशांकन शुरू करें';

  @override
  String get calibrationBtn1 => 'ऊपर बायीं ओर देखें (1/2)';

  @override
  String get calibrationBtn2 => 'नीचे दायीं ओर देखें (2/2)';

  @override
  String get calibrationBtn3 => 'अंशांकन समाप्त करें';

  @override
  String get slcTime => 'चयन का समय';

  @override
  String get slcTimeOpt0 => 'तेज';

  @override
  String get slcTimeOpt1 => 'मानक';

  @override
  String get slcTimeOpt2 => 'धीमा';

  @override
  String get slcTimeOpt3 => 'बहुत धीमा';

  @override
  String get language => 'भाषा';

  @override
  String get genModel => 'जेनरेशन मॉडल';

  @override
  String get genModelOpt0 => 'कोई नहीं';

  @override
  String get genModelOpt1 => 'स्थानीय एलएलएम (LLM)';

  @override
  String get debugMode => 'डिबग मोड';

  @override
  String get debugModeOpt0 => 'अक्षम';

  @override
  String get debugModeOpt1 => 'सक्षम';

  @override
  String get textEntry => 'कीबोर्ड';

  @override
  String get textEntryTab => 'कीबोर्ड टैब';

  @override
  String get switchAction => 'बदलें';

  @override
  String get deleteAction => 'हटाएं';

  @override
  String get speakAction => 'बोलें';

  @override
  String text(Object text) {
    return 'पाठ: $text';
  }

  @override
  String get addContext => 'संदर्भ जोड़ें';

  @override
  String context(Object context) {
    return 'संदर्भ: $context';
  }

  @override
  String get noMatch => 'कोई मेल नहीं';

  @override
  String get nextPage => 'अगला पृष्ठ';

  @override
  String get defaultText => 'जब तक एएलएस (ALS) का इलाज नहीं मिल जाता, तकनीक ही हमारी दवा रहेगी।';

  @override
  String get defaultLLM => 'इस सुविधा को सक्षम करने के लिए, जेनरेशन मॉडल विकल्प चुनें।';

  @override
  String get quickChat => 'विज़ुअल टैब';

  @override
  String get quickChatTab => 'विज़ुअल टैब';

  @override
  String get qc0 => 'बुनियादी जरूरतें';

  @override
  String get qc0opt0 => 'मैं कुछ खाना चाहता हूँ।';

  @override
  String get qc0opt1 => 'मैं सोना चाहता हूँ।';

  @override
  String get qc0opt2 => 'मुझे शौचालय का उपयोग करना है।';

  @override
  String get qc0opt3 => 'मैं पानी पीना चाहता हूँ।';

  @override
  String get qc0opt4 => 'मैं नहाना चाहता हूँ।';

  @override
  String get qc0opt5 => 'कृपया मेरी स्थिति बदलें।';

  @override
  String get qc1 => 'अक्सर उपयोग किए जाने वाले';

  @override
  String get qc1opt0 => 'हाँ।';

  @override
  String get qc1opt1 => 'मुझे नहीं पता।';

  @override
  String get qc1opt2 => 'नहीं।';

  @override
  String get qc1opt3 => 'धन्यवाद।';

  @override
  String get qc1opt4 => 'नमस्ते।';

  @override
  String get qc1opt5 => 'क्षमा करें।';

  @override
  String get qc2 => 'भावनाएं';

  @override
  String get qc2opt0 => 'मैं खुश हूँ।';

  @override
  String get qc2opt1 => 'मैं दुखी हूँ।';

  @override
  String get qc2opt2 => 'मैं क्रोधित हूँ।';

  @override
  String get qc2opt3 => 'मुझे डर लग रहा है।';

  @override
  String get qc2opt4 => 'मैं भ्रमित हूँ।';

  @override
  String get qc2opt5 => 'मैं घबरा रहा हूँ।';

  @override
  String get qc3 => 'पर्यावरण नियंत्रण';

  @override
  String get qc3opt0 => 'मुझे गर्मी लग रही है।';

  @override
  String get qc3opt1 => 'मुझे ठंड लग रही है।';

  @override
  String get qc3opt2 => 'बहुत शोर है।';

  @override
  String get qc3opt3 => 'बहुत रोशनी है।';

  @override
  String get qc3opt4 => 'बहुत अंधेरा है।';

  @override
  String get qc3opt5 => 'हवा घुटन भरी है।';

  @override
  String get qc4 => 'सामाजिक गतिविधियाँ और मनोरंजन';

  @override
  String get qc4opt0 => 'मैं बाहर जाना चाहता हूँ।';

  @override
  String get qc4opt1 => 'मैं अखबार पढ़ना चाहता हूँ।';

  @override
  String get qc4opt2 => 'मैं संगीत सुनना चाहता हूँ।';

  @override
  String get qc4opt3 => 'मैं टेलीविजन देखना चाहता हूँ।';

  @override
  String get qc4opt4 => 'मैं रेडियो सुनना चाहता हूँ।';

  @override
  String get qc4opt5 => 'मैं कोई खेल खेलना चाहता हूँ।';

  @override
  String get qc5 => 'चिकित्सीय जरूरतें';

  @override
  String get qc5opt0 => 'मुझे कुछ दर्द महसूस हो रहा है।';

  @override
  String get qc5opt1 => 'मुझे अत्यधिक दर्द महसूस हो रहा है।';

  @override
  String get qc5opt2 => 'मुझे अपनी दवाएं खानी हैं।';

  @override
  String get qc5opt3 => 'मुझे अस्पताल जाना है।';

  @override
  String get qc5opt4 => 'मैं ठीक महसूस कर रहा हूँ।';

  @override
  String get qc5opt5 => 'मुझे डॉक्टर से मिलना है।';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileLogin => 'लॉग इन करें';

  @override
  String get profileCreateAccount => 'खाता बनाएं';

  @override
  String get profileSignUp => 'साइन अप करें';

  @override
  String get profileLoginSubtitle => 'अपने खाते में लॉग इन करें';

  @override
  String get profileRegisterSubtitle => 'नया खाता बनाने के लिए अपनी जानकारी दर्ज करें';

  @override
  String get profileFirstName => 'पहला नाम';

  @override
  String get profileLastName => 'अंतिम नाम';

  @override
  String get profileEmail => 'ईमेल';

  @override
  String get profilePhone => 'फ़ोन';

  @override
  String get profilePhoneHint => '0555 123 45 67';

  @override
  String get profilePassword => 'पासवर्ड';

  @override
  String get profileRoleQuestion => 'इस ऐप का उपयोग कौन करेगा?';

  @override
  String get profileRoleUser => 'उपयोगकर्ता';

  @override
  String get profileRolePatient => 'रोगी';

  @override
  String get profileLogout => 'लॉग आउट करें';

  @override
  String get profileFullName => 'पूरा नाम';

  @override
  String get profileRegDate => 'पंजीकरण की तिथि';

  @override
  String get profileNoAccount => 'क्या आपके पास खाता नहीं है? ';

  @override
  String get profileHaveAccount => 'क्या आपके पास पहले से खाता है? ';

  @override
  String get profileGuestSubtitle => 'लॉग इन करें या पंजीकरण करें';

  @override
  String get profileUsername => 'उपयोगकर्ता नाम';

  @override
  String get profileEmailOrPhone => 'ईमेल या फोन नंबर';

  @override
  String get profileUsernameRequired => 'ईमेल या फोन नंबर आवश्यक है';

  @override
  String get profileUsernameInvalid => 'एक वैध ईमेल या फोन नंबर दर्ज करें';

  @override
  String get profileEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get profileEmailInvalid => 'अमान्य ईमेल प्रारूप';

  @override
  String get profilePhoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get profilePhoneInvalid => 'अमान्य प्रारूप (उदा: 05XX XXX XX XX)';

  @override
  String get profilePasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get profilePasswordTooShort => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String profileFieldRequired(Object field) {
    return '$field आवश्यक है';
  }

  @override
  String profileFieldTooShort(Object field) {
    return '$field कम से कम 2 अक्षरों का होना चाहिए';
  }

  @override
  String get authErrorEmailInUse => 'यह ईमेल पता पहले से ही उपयोग में है।';

  @override
  String get authErrorInvalidEmail => 'अमान्य ईमेल पता।';

  @override
  String get authErrorWeakPassword => 'पासवर्ड बहुत कमज़ोर है। कम से कम 6 अक्षरों का होना चाहिए।';

  @override
  String get authErrorUserNotFound => 'इस ईमेल से कोई उपयोगकर्ता नहीं मिला।';

  @override
  String get authErrorWrongPassword => 'गलत पासवर्ड।';

  @override
  String get authErrorInvalidCredential => 'गलत ईमेल या पासवर्ड।';

  @override
  String get authErrorTooManyRequests => 'बहुत सारे प्रयास। कृपया थोड़ी देर प्रतीक्षा करें।';

  @override
  String get authErrorNetworkFailed => 'नेटवर्क कनेक्शन त्रुटि।';

  @override
  String get authErrorUnknown => 'एक त्रुटि हुई। कृपया पुन: प्रयास करें।';

  @override
  String get profileEdit => 'संपादित करें';

  @override
  String get profileSave => 'सहेजें';

  @override
  String get profileCancel => 'रद्द करें';

  @override
  String get profileNewPassword => 'नया पासवर्ड';

  @override
  String get profileNewPasswordHint => 'वर्तमान पासवर्ड रखने के लिए खाली छोड़ दें';

  @override
  String get messages => 'संदेश';

  @override
  String get messagesTab => 'संदेश टैब';

  @override
  String get newMessage => 'नया संदेश';

  @override
  String get searchUsers => 'नाम से खोजें';

  @override
  String get noConversations => 'अभी तक कोई बातचीत नहीं';

  @override
  String get typeMessage => 'एक संदेश टाइप करें...';

  @override
  String get fromContacts => 'संपर्कों से';

  @override
  String get userNotRegistered => 'यह व्यक्ति ऐप पर पंजीकृत नहीं है';

  @override
  String get noUsersFound => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get authErrorUsernameTaken => 'यह उपयोगकर्ता नाम पहले ही लिया जा चुका है।';

  @override
  String get profileUsernameHint => 'उदा. mehmet123';

  @override
  String get profileUsernameFormatInvalid => 'केवल अक्षर, अंक और _ की अनुमति है (न्यूनतम 3 वर्ण)';

  @override
  String get profilePhoneOptional => 'फोन (वैकल्पिक)';

  @override
  String get slotRemoveContact => 'हटाएं';

  @override
  String get slotRemoveConfirmTitle => 'संपर्क हटाएं';

  @override
  String get slotRemoveConfirmBody => 'इस संपर्क को इस आंखों की गति वाले स्लॉट से हटा दिया जाएगा। संदेश नहीं हटाए जाएंगे।';

  @override
  String get slotRemoveConfirmYes => 'हटाएं';

  @override
  String get slotRemoveConfirmNo => 'रद्द करें';

  @override
  String get tabContacts => 'संपर्क';

  @override
  String get tabUsername => 'उपयोगकर्ता नाम';

  @override
  String get backAction => 'वापस';

  @override
  String get sendAction => 'भेजें';

  @override
  String get aiThinking => 'AI सोच रहा है...';

  @override
  String get aiSuggestionPlaceholder => 'AI वाक्य यहां दिखाई देगा';
}
