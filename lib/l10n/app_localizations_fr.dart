// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get straight => 'Droit';

  @override
  String get closed => 'Fermé';

  @override
  String get leftUp => 'Haut Gauche';

  @override
  String get up => 'Haut';

  @override
  String get rightUp => 'Haut Droite';

  @override
  String get leftDown => 'Bas Gauche';

  @override
  String get down => 'Bas';

  @override
  String get rightDown => 'Bas Droite';

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsTab => 'Onglet Paramètres';

  @override
  String get eyeFrame => 'Cadre Oculaire';

  @override
  String get inputLog => 'Journal du Regard';

  @override
  String get eyePos => 'Position de l\'Œil';

  @override
  String get eyeReg => 'Région de l\'Œil';

  @override
  String get calibrationBtn0 => 'Démarrer l\'Étalonnage';

  @override
  String get calibrationBtn1 => 'Regardez en Haut à Gauche (1/2)';

  @override
  String get calibrationBtn2 => 'Regardez en Bas à Droite (2/2)';

  @override
  String get calibrationBtn3 => 'Terminer l\'Étalonnage';

  @override
  String get slcTime => 'Temps de Sélection';

  @override
  String get slcTimeOpt0 => 'Rapide';

  @override
  String get slcTimeOpt1 => 'Standard';

  @override
  String get slcTimeOpt2 => 'Lent';

  @override
  String get slcTimeOpt3 => 'Très Lent';

  @override
  String get language => 'Langue';

  @override
  String get genModel => 'Modèle de Génération';

  @override
  String get genModelOpt0 => 'Aucun';

  @override
  String get genModelOpt1 => 'LLM Local';

  @override
  String get debugMode => 'Mode Débogage';

  @override
  String get debugModeOpt0 => 'Désactivé';

  @override
  String get debugModeOpt1 => 'Activé';

  @override
  String get textEntry => 'Clavier';

  @override
  String get textEntryTab => 'Onglet Clavier';

  @override
  String get switchAction => 'Changer';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get speakAction => 'Parler';

  @override
  String text(Object text) {
    return 'Texte : $text';
  }

  @override
  String get addContext => 'Ajouter un Contexte';

  @override
  String context(Object context) {
    return 'Contexte : $context';
  }

  @override
  String get noMatch => 'Aucune Correspondance';

  @override
  String get nextPage => 'Page Suivante';

  @override
  String get defaultText => 'Jusqu\'à ce qu\'un remède soit trouvé contre la SLA, la technologie restera notre médecine.';

  @override
  String get defaultLLM => 'Pour activer cette fonction, sélectionnez l\'option Modèle de Génération.';

  @override
  String get quickChat => 'Onglet Visuel';

  @override
  String get quickChatTab => 'Onglet Visuel';

  @override
  String get qc0 => 'Besoins Fondamentaux';

  @override
  String get qc0opt0 => 'Je veux manger quelque chose.';

  @override
  String get qc0opt1 => 'Je veux dormir.';

  @override
  String get qc0opt2 => 'J\'ai besoin d\'aller aux toilettes.';

  @override
  String get qc0opt3 => 'Je veux boire de l\'eau.';

  @override
  String get qc0opt4 => 'Je veux prendre une douche.';

  @override
  String get qc0opt5 => 'Veuillez changer ma position.';

  @override
  String get qc1 => 'Fréquemment Utilisé';

  @override
  String get qc1opt0 => 'Oui.';

  @override
  String get qc1opt1 => 'Je ne sais pas.';

  @override
  String get qc1opt2 => 'Non.';

  @override
  String get qc1opt3 => 'Merci.';

  @override
  String get qc1opt4 => 'Bonjour.';

  @override
  String get qc1opt5 => 'Mes excuses.';

  @override
  String get qc2 => 'Émotions';

  @override
  String get qc2opt0 => 'Je suis heureux.';

  @override
  String get qc2opt1 => 'Je suis triste.';

  @override
  String get qc2opt2 => 'Je suis en colère.';

  @override
  String get qc2opt3 => 'J\'ai peur.';

  @override
  String get qc2opt4 => 'Je suis confus.';

  @override
  String get qc2opt5 => 'Je me sens nerveux.';

  @override
  String get qc3 => 'Contrôle de l\'Environnement';

  @override
  String get qc3opt0 => 'J\'ai chaud.';

  @override
  String get qc3opt1 => 'J\'ai froid.';

  @override
  String get qc3opt2 => 'Il y a trop de bruit.';

  @override
  String get qc3opt3 => 'Il y a trop de lumière.';

  @override
  String get qc3opt4 => 'Il fait trop sombre.';

  @override
  String get qc3opt5 => 'L\'air est étouffant.';

  @override
  String get qc4 => 'Activités Sociales et Loisirs';

  @override
  String get qc4opt0 => 'Je veux aller dehors.';

  @override
  String get qc4opt1 => 'Je veux lire le journal.';

  @override
  String get qc4opt2 => 'Je veux écouter de la musique.';

  @override
  String get qc4opt3 => 'Je veux regarder la télévision.';

  @override
  String get qc4opt4 => 'Je veux écouter la radio.';

  @override
  String get qc4opt5 => 'Je veux jouer à un jeu.';

  @override
  String get qc5 => 'Besoins Médicaux';

  @override
  String get qc5opt0 => 'Je ressens un peu de douleur.';

  @override
  String get qc5opt1 => 'Je ressens une douleur extrême.';

  @override
  String get qc5opt2 => 'Je dois prendre mes médicaments.';

  @override
  String get qc5opt3 => 'Je dois aller à l\'hôpital.';

  @override
  String get qc5opt4 => 'Je me sens bien.';

  @override
  String get qc5opt5 => 'J\'ai besoin de voir un médecin.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileLogin => 'Se connecter';

  @override
  String get profileCreateAccount => 'Créer un compte';

  @override
  String get profileSignUp => 'S\'inscrire';

  @override
  String get profileLoginSubtitle => 'Connectez-vous à votre compte';

  @override
  String get profileRegisterSubtitle => 'Entrez vos informations pour créer un nouveau compte';

  @override
  String get profileFirstName => 'Prénom';

  @override
  String get profileLastName => 'Nom de famille';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profilePhone => 'Téléphone';

  @override
  String get profilePhoneHint => '0555 123 45 67';

  @override
  String get profilePassword => 'Mot de passe';

  @override
  String get profileRoleQuestion => 'Qui va utiliser cette application ?';

  @override
  String get profileRoleUser => 'Utilisateur';

  @override
  String get profileRolePatient => 'Patient';

  @override
  String get profileLogout => 'Se déconnecter';

  @override
  String get profileFullName => 'Nom complet';

  @override
  String get profileRegDate => 'Date d\'inscription';

  @override
  String get profileNoAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get profileHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get profileGuestSubtitle => 'Se connecter ou s\'inscrire';

  @override
  String get profileUsername => 'Nom d\'utilisateur';

  @override
  String get profileEmailOrPhone => 'E-mail ou numéro de téléphone';

  @override
  String get profileUsernameRequired => 'L\'e-mail ou le numéro de téléphone est requis';

  @override
  String get profileUsernameInvalid => 'Entrez un e-mail ou un numéro de téléphone valide';

  @override
  String get profileEmailRequired => 'L\'e-mail est requis';

  @override
  String get profileEmailInvalid => 'Format d\'e-mail invalide';

  @override
  String get profilePhoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get profilePhoneInvalid => 'Format invalide (ex : 05XX XXX XX XX)';

  @override
  String get profilePasswordRequired => 'Le mot de passe est requis';

  @override
  String get profilePasswordTooShort => 'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String profileFieldRequired(Object field) {
    return '$field est requis';
  }

  @override
  String profileFieldTooShort(Object field) {
    return '$field doit comporter au moins 2 caractères';
  }

  @override
  String get authErrorEmailInUse => 'Cette adresse e-mail est déjà utilisée.';

  @override
  String get authErrorInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get authErrorWeakPassword => 'Le mot de passe est trop faible. Il doit comporter au moins 6 caractères.';

  @override
  String get authErrorUserNotFound => 'Aucun utilisateur trouvé avec cet e-mail.';

  @override
  String get authErrorWrongPassword => 'Mot de passe incorrect.';

  @override
  String get authErrorInvalidCredential => 'E-mail ou mot de passe incorrect.';

  @override
  String get authErrorTooManyRequests => 'Trop de tentatives. Veuillez patienter un instant.';

  @override
  String get authErrorNetworkFailed => 'Erreur de connexion réseau.';

  @override
  String get authErrorUnknown => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get profileEdit => 'Modifier';

  @override
  String get profileSave => 'Enregistrer';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get profileNewPassword => 'Nouveau mot de passe';

  @override
  String get profileNewPasswordHint => 'Laissez vide pour conserver le mot de passe actuel';

  @override
  String get messages => 'Messages';

  @override
  String get messagesTab => 'Onglet Messages';

  @override
  String get newMessage => 'Nouveau Message';

  @override
  String get searchUsers => 'Rechercher par nom';

  @override
  String get noConversations => 'Aucune conversation pour l\'instant';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get fromContacts => 'Depuis les Contacts';

  @override
  String get userNotRegistered => 'Cette personne n\'est pas inscrite sur l\'application';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé';

  @override
  String get authErrorUsernameTaken => 'Ce nom d\'utilisateur est déjà pris.';

  @override
  String get profileUsernameHint => 'ex. mehmet123';

  @override
  String get profileUsernameFormatInvalid => 'Seuls les lettres, chiffres et _ sont autorisés (min. 3 caractères)';

  @override
  String get profilePhoneOptional => 'Téléphone (Facultatif)';

  @override
  String get slotRemoveContact => 'Retirer';

  @override
  String get slotRemoveConfirmTitle => 'Retirer le contact';

  @override
  String get slotRemoveConfirmBody => 'Ce contact sera retiré de cet emplacement de mouvement oculaire. Les messages ne seront pas supprimés.';

  @override
  String get slotRemoveConfirmYes => 'Retirer';

  @override
  String get slotRemoveConfirmNo => 'Annuler';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabUsername => 'Nom d\'utilisateur';

  @override
  String get backAction => 'Retour';

  @override
  String get sendAction => 'Envoyer';

  @override
  String get aiThinking => 'L\'IA réfléchit...';

  @override
  String get aiSuggestionPlaceholder => 'La phrase de l\'IA apparaîtra ici';
}
