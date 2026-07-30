import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to continue'**
  String get loginSubtitle;

  /// No description provided for @emailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Username, Email, or Phone'**
  String get emailOrUsername;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @bodyMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Measurements'**
  String get bodyMeasurementsTitle;

  /// No description provided for @logDataButton.
  ///
  /// In en, this message translates to:
  /// **'LOG DATA'**
  String get logDataButton;

  /// No description provided for @addMeasurementTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Measurement'**
  String get addMeasurementTitle;

  /// No description provided for @addMeasurementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your physical metrics to track evolution.'**
  String get addMeasurementSubtitle;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @weightLabelKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabelKg;

  /// No description provided for @heightLabelCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabelCm;

  /// No description provided for @neckLabelCm.
  ///
  /// In en, this message translates to:
  /// **'Neck (cm)'**
  String get neckLabelCm;

  /// No description provided for @waistLabelCm.
  ///
  /// In en, this message translates to:
  /// **'Waist (cm)'**
  String get waistLabelCm;

  /// No description provided for @bodyFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Percentage (%) — optional'**
  String get bodyFatLabel;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalLabel;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLoseWeight;

  /// No description provided for @goalGainMuscle.
  ///
  /// In en, this message translates to:
  /// **'Gain Muscle'**
  String get goalGainMuscle;

  /// No description provided for @goalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get goalMaintain;

  /// No description provided for @saveMeasurementButton.
  ///
  /// In en, this message translates to:
  /// **'Save Measurement'**
  String get saveMeasurementButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @noMeasurementsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added a measurement yet.'**
  String get noMeasurementsYet;

  /// No description provided for @measurementSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save measurement'**
  String get measurementSaveError;

  /// No description provided for @validationWeightHeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Weight and height are required.'**
  String get validationWeightHeightRequired;

  /// No description provided for @nutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionTitle;

  /// No description provided for @kcalLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get kcalLeftLabel;

  /// No description provided for @targetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get targetLabel;

  /// No description provided for @foodLabel.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodLabel;

  /// No description provided for @proteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteinLabel;

  /// No description provided for @carbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbsLabel;

  /// No description provided for @fatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fatsLabel;

  /// No description provided for @thirtyDayTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'30-Day Trend'**
  String get thirtyDayTrendTitle;

  /// No description provided for @recentMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Meals'**
  String get recentMealsTitle;

  /// No description provided for @addMealButton.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMealButton;

  /// No description provided for @mealNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get mealNameLabel;

  /// No description provided for @servingWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Serving Weight (g)'**
  String get servingWeightLabel;

  /// No description provided for @totalCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get totalCaloriesLabel;

  /// No description provided for @noMealsToday.
  ///
  /// In en, this message translates to:
  /// **'No meals logged today.'**
  String get noMealsToday;

  /// No description provided for @mealTypeBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealTypeBreakfast;

  /// No description provided for @mealTypeLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealTypeLunch;

  /// No description provided for @mealTypeDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealTypeDinner;

  /// No description provided for @mealTypeSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealTypeSnack;

  /// No description provided for @saveMealButton.
  ///
  /// In en, this message translates to:
  /// **'Save Meal'**
  String get saveMealButton;

  /// No description provided for @mealSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save meal'**
  String get mealSaveError;

  /// No description provided for @validationMealNameCaloriesRequired.
  ///
  /// In en, this message translates to:
  /// **'Meal name and calories are required.'**
  String get validationMealNameCaloriesRequired;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @editProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileButton;

  /// No description provided for @totalWorkoutsLabel.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get totalWorkoutsLabel;

  /// No description provided for @totalMeasurementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get totalMeasurementsLabel;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickActionsTitle;

  /// No description provided for @bodyMeasurementsMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Body Measurements'**
  String get bodyMeasurementsMenuItem;

  /// No description provided for @activeProgramMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Workout Programs'**
  String get activeProgramMenuItem;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButton;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutConfirmMessage;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @locationPreferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Preference'**
  String get locationPreferenceLabel;

  /// No description provided for @locationHome.
  ///
  /// In en, this message translates to:
  /// **'At Home'**
  String get locationHome;

  /// No description provided for @locationGym.
  ///
  /// In en, this message translates to:
  /// **'At the Gym'**
  String get locationGym;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update profile'**
  String get profileUpdateError;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdateSuccess;

  /// No description provided for @addFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friends'**
  String get addFriendsTitle;

  /// No description provided for @searchByNameHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or username'**
  String get searchByNameHint;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @requestSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSentLabel;

  /// No description provided for @pendingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequestsTitle;

  /// No description provided for @acceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptButton;

  /// No description provided for @declineButton.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineButton;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noSearchResults;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get noPendingRequests;

  /// No description provided for @searchMinCharsHint.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search.'**
  String get searchMinCharsHint;

  /// No description provided for @friendRequestError.
  ///
  /// In en, this message translates to:
  /// **'Could not send request'**
  String get friendRequestError;

  /// No description provided for @respondRequestError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete action'**
  String get respondRequestError;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @chatsTab.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsTab;

  /// No description provided for @friendsTab.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTab;

  /// No description provided for @messageButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageButtonLabel;

  /// No description provided for @typeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessageHint;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any conversations yet.'**
  String get noConversationsYet;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Send the first one!'**
  String get noMessagesYet;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any friends yet.'**
  String get noFriendsYet;

  /// No description provided for @conversationStartError.
  ///
  /// In en, this message translates to:
  /// **'Could not start conversation'**
  String get conversationStartError;

  /// No description provided for @messageSendError.
  ///
  /// In en, this message translates to:
  /// **'Could not send message'**
  String get messageSendError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
