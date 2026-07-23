// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Enter your details to continue';

  @override
  String get emailOrUsername => 'Username, Email, or Phone';

  @override
  String get password => 'Password';

  @override
  String get bodyMeasurementsTitle => 'Body Measurements';

  @override
  String get logDataButton => 'LOG DATA';

  @override
  String get addMeasurementTitle => 'Add Measurement';

  @override
  String get addMeasurementSubtitle =>
      'Update your physical metrics to track evolution.';

  @override
  String get dateLabel => 'Date';

  @override
  String get weightLabelKg => 'Weight (kg)';

  @override
  String get heightLabelCm => 'Height (cm)';

  @override
  String get neckLabelCm => 'Neck (cm)';

  @override
  String get waistLabelCm => 'Waist (cm)';

  @override
  String get bodyFatLabel => 'Body Fat Percentage (%) — optional';

  @override
  String get goalLabel => 'Goal';

  @override
  String get goalLoseWeight => 'Lose Weight';

  @override
  String get goalGainMuscle => 'Gain Muscle';

  @override
  String get goalMaintain => 'Maintain';

  @override
  String get saveMeasurementButton => 'Save Measurement';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get noMeasurementsYet => 'You haven\'t added a measurement yet.';

  @override
  String get measurementSaveError => 'Could not save measurement';

  @override
  String get validationWeightHeightRequired =>
      'Weight and height are required.';
}
