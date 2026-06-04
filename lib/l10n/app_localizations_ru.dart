// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get straight => 'Прямо';

  @override
  String get closed => 'Закрыто';

  @override
  String get leftUp => 'Влево вверх';

  @override
  String get up => 'Вверх';

  @override
  String get rightUp => 'Вправо вверх';

  @override
  String get leftDown => 'Влево вниз';

  @override
  String get down => 'Вниз';

  @override
  String get rightDown => 'Вправо вниз';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsTab => 'Вкладка настроек';

  @override
  String get eyeFrame => 'Рамка глаз';

  @override
  String get inputLog => 'Журнал взгляда';

  @override
  String get eyePos => 'Положение глаз';

  @override
  String get eyeReg => 'Область глаз';

  @override
  String get calibrationBtn0 => 'Начать калибровку';

  @override
  String get calibrationBtn1 => 'Посмотрите влево вверх (1/2)';

  @override
  String get calibrationBtn2 => 'Посмотрите вправо вниз (2/2)';

  @override
  String get calibrationBtn3 => 'Завершить калибровку';

  @override
  String get slcTime => 'Время выбора';

  @override
  String get slcTimeOpt0 => 'Быстро';

  @override
  String get slcTimeOpt1 => 'Стандартно';

  @override
  String get slcTimeOpt2 => 'Медленно';

  @override
  String get slcTimeOpt3 => 'Очень медленно';

  @override
  String get language => 'Язык';

  @override
  String get genModel => 'Модель генерации';

  @override
  String get genModelOpt0 => 'Нет';

  @override
  String get genModelOpt1 => 'Локальная LLM';

  @override
  String get debugMode => 'Режим отладки';

  @override
  String get debugModeOpt0 => 'Отключен';

  @override
  String get debugModeOpt1 => 'Включен';

  @override
  String get textEntry => 'Клавиатура';

  @override
  String get textEntryTab => 'Вкладка клавиатуры';

  @override
  String get switchAction => 'Переключить';

  @override
  String get deleteAction => 'Удалить';

  @override
  String get speakAction => 'Сказать';

  @override
  String text(Object text) {
    return 'Текст: $text';
  }

  @override
  String get addContext => 'Добавить контекст';

  @override
  String context(Object context) {
    return 'Контекст: $context';
  }

  @override
  String get noMatch => 'Нет совпадений';

  @override
  String get nextPage => 'Следующая страница';

  @override
  String get defaultText => 'Пока не будет найдено лекарство от БАС, технологии останутся нашим лекарством.';

  @override
  String get defaultLLM => 'Чтобы включить эту функцию, выберите опцию «Модель генерации».';

  @override
  String get quickChat => 'Визуальная вкладка';

  @override
  String get quickChatTab => 'Визуальная вкладка';

  @override
  String get qc0 => 'Базовые потребности';

  @override
  String get qc0opt0 => 'Я хочу что-нибудь съесть.';

  @override
  String get qc0opt1 => 'Я хочу спать.';

  @override
  String get qc0opt2 => 'Мне нужно в туалет.';

  @override
  String get qc0opt3 => 'Я хочу попить воды.';

  @override
  String get qc0opt4 => 'Я хочу принять душ.';

  @override
  String get qc0opt5 => 'Пожалуйста, измените мое положение.';

  @override
  String get qc1 => 'Часто используемые';

  @override
  String get qc1opt0 => 'Да.';

  @override
  String get qc1opt1 => 'Я не знаю.';

  @override
  String get qc1opt2 => 'Нет.';

  @override
  String get qc1opt3 => 'Спасибо.';

  @override
  String get qc1opt4 => 'Привет.';

  @override
  String get qc1opt5 => 'Мои извинения.';

  @override
  String get qc2 => 'Эмоции';

  @override
  String get qc2opt0 => 'Я счастлив.';

  @override
  String get qc2opt1 => 'Мне грустно.';

  @override
  String get qc2opt2 => 'Я зол.';

  @override
  String get qc2opt3 => 'Мне страшно.';

  @override
  String get qc2opt4 => 'Я запутался.';

  @override
  String get qc2opt5 => 'Я нервничаю.';

  @override
  String get qc3 => 'Контроль окружения';

  @override
  String get qc3opt0 => 'Мне жарко.';

  @override
  String get qc3opt1 => 'Мне холодно.';

  @override
  String get qc3opt2 => 'Слишком шумно.';

  @override
  String get qc3opt3 => 'Слишком светло.';

  @override
  String get qc3opt4 => 'Слишком темно.';

  @override
  String get qc3opt5 => 'Воздух спертый.';

  @override
  String get qc4 => 'Социальная активность и отдых';

  @override
  String get qc4opt0 => 'Я хочу выйти на улицу.';

  @override
  String get qc4opt1 => 'Я хочу почитать газету.';

  @override
  String get qc4opt2 => 'Я хочу послушать музыку.';

  @override
  String get qc4opt3 => 'Я хочу посмотреть телевизор.';

  @override
  String get qc4opt4 => 'Я хочу послушать радио.';

  @override
  String get qc4opt5 => 'Я хочу поиграть в игру.';

  @override
  String get qc5 => 'Медицинские нужды';

  @override
  String get qc5opt0 => 'Я чувствую небольшую боль.';

  @override
  String get qc5opt1 => 'Я чувствую сильную боль.';

  @override
  String get qc5opt2 => 'Мне нужно принять таблетки.';

  @override
  String get qc5opt3 => 'Мне нужно в больницу.';

  @override
  String get qc5opt4 => 'Я чувствую себя хорошо.';

  @override
  String get qc5opt5 => 'Мне нужно к врачу.';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileLogin => 'Войти';

  @override
  String get profileCreateAccount => 'Создать аккаунт';

  @override
  String get profileSignUp => 'Зарегистрироваться';

  @override
  String get profileLoginSubtitle => 'Войдите в свой аккаунт';

  @override
  String get profileRegisterSubtitle => 'Введите свои данные для создания нового аккаунта';

  @override
  String get profileFirstName => 'Имя';

  @override
  String get profileLastName => 'Фамилия';

  @override
  String get profileEmail => 'Эл. почта';

  @override
  String get profilePhone => 'Телефон';

  @override
  String get profilePhoneHint => '0555 123 45 67';

  @override
  String get profilePassword => 'Пароль';

  @override
  String get profileRoleQuestion => 'Кто будет использовать это приложение?';

  @override
  String get profileRoleUser => 'Пользователь';

  @override
  String get profileRolePatient => 'Пациент';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileFullName => 'Полное имя';

  @override
  String get profileRegDate => 'Дата регистрации';

  @override
  String get profileNoAccount => 'Нет аккаунта? ';

  @override
  String get profileHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get profileGuestSubtitle => 'Войти или зарегистрироваться';

  @override
  String get profileUsername => 'Имя пользователя';

  @override
  String get profileEmailOrPhone => 'Эл. почта или номер телефона';

  @override
  String get profileUsernameRequired => 'Требуется эл. почта или номер телефона';

  @override
  String get profileUsernameInvalid => 'Введите действительный адрес эл. почты или номер телефона';

  @override
  String get profileEmailRequired => 'Требуется эл. почта';

  @override
  String get profileEmailInvalid => 'Неверный формат эл. почты';

  @override
  String get profilePhoneRequired => 'Требуется номер телефона';

  @override
  String get profilePhoneInvalid => 'Неверный формат (напр.: 05XX XXX XX XX)';

  @override
  String get profilePasswordRequired => 'Требуется пароль';

  @override
  String get profilePasswordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String profileFieldRequired(Object field) {
    return 'Поле $field обязательно';
  }

  @override
  String profileFieldTooShort(Object field) {
    return '$field должно содержать не менее 2 символов';
  }

  @override
  String get authErrorEmailInUse => 'Этот адрес эл. почты уже используется.';

  @override
  String get authErrorInvalidEmail => 'Недействительный адрес эл. почты.';

  @override
  String get authErrorWeakPassword => 'Слишком слабый пароль. Должен содержать не менее 6 символов.';

  @override
  String get authErrorUserNotFound => 'Пользователь с такой эл. почтой не найден.';

  @override
  String get authErrorWrongPassword => 'Неверный пароль.';

  @override
  String get authErrorInvalidCredential => 'Неверная эл. почта или пароль.';

  @override
  String get authErrorTooManyRequests => 'Слишком много попыток. Пожалуйста, подождите немного.';

  @override
  String get authErrorNetworkFailed => 'Ошибка сетевого подключения.';

  @override
  String get authErrorUnknown => 'Произошла ошибка. Пожалуйста, попробуйте еще раз.';

  @override
  String get profileEdit => 'Редактировать';

  @override
  String get profileSave => 'Сохранить';

  @override
  String get profileCancel => 'Отмена';

  @override
  String get profileNewPassword => 'Новый пароль';

  @override
  String get profileNewPasswordHint => 'Оставьте пустым, чтобы сохранить текущий пароль';

  @override
  String get messages => 'Сообщения';

  @override
  String get messagesTab => 'Вкладка сообщений';

  @override
  String get newMessage => 'Новое сообщение';

  @override
  String get searchUsers => 'Поиск по имени';

  @override
  String get noConversations => 'Пока нет бесед';

  @override
  String get typeMessage => 'Введите сообщение...';

  @override
  String get fromContacts => 'Из контактов';

  @override
  String get userNotRegistered => 'Этот человек не зарегистрирован в приложении';

  @override
  String get noUsersFound => 'Пользователи не найдены';

  @override
  String get authErrorUsernameTaken => 'Это имя пользователя уже занято.';

  @override
  String get profileUsernameHint => 'напр. mehmet123';

  @override
  String get profileUsernameFormatInvalid => 'Разрешены только буквы, цифры и _ (мин. 3 символа)';

  @override
  String get profilePhoneOptional => 'Телефон (Необязательно)';

  @override
  String get slotRemoveContact => 'Удалить';

  @override
  String get slotRemoveConfirmTitle => 'Удалить контакт';

  @override
  String get slotRemoveConfirmBody => 'Этот контакт будет удален из этого слота движения глаз. Сообщения не будут удалены.';

  @override
  String get slotRemoveConfirmYes => 'Удалить';

  @override
  String get slotRemoveConfirmNo => 'Отмена';

  @override
  String get tabContacts => 'Контакты';

  @override
  String get tabUsername => 'Имя пользователя';

  @override
  String get backAction => 'Назад';

  @override
  String get sendAction => 'Отправить';

  @override
  String get aiThinking => 'ИИ думает...';

  @override
  String get aiSuggestionPlaceholder => 'Здесь появится предложение ИИ';
}
