// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get loginTitle => 'Tekrar Hoş Geldin';

  @override
  String get loginSubtitle => 'Devam etmek için bilgilerini gir';

  @override
  String get emailOrUsername => 'Kullanıcı Adı, E-posta veya Telefon';

  @override
  String get password => 'Şifre';

  @override
  String get bodyMeasurementsTitle => 'Vücut Ölçümleri';

  @override
  String get logDataButton => 'ÖLÇÜM EKLE';

  @override
  String get addMeasurementTitle => 'Ölçüm Ekle';

  @override
  String get addMeasurementSubtitle =>
      'Gelişimini takip etmek için fiziksel ölçülerini güncelle.';

  @override
  String get dateLabel => 'Tarih';

  @override
  String get weightLabelKg => 'Kilo (kg)';

  @override
  String get heightLabelCm => 'Boy (cm)';

  @override
  String get neckLabelCm => 'Boyun (cm)';

  @override
  String get waistLabelCm => 'Bel (cm)';

  @override
  String get bodyFatLabel => 'Vücut Yağ Oranı (%) — opsiyonel';

  @override
  String get goalLabel => 'Hedef';

  @override
  String get goalLoseWeight => 'Kilo Ver';

  @override
  String get goalGainMuscle => 'Kas Kazan';

  @override
  String get goalMaintain => 'Koru';

  @override
  String get saveMeasurementButton => 'Ölçümü Kaydet';

  @override
  String get cancelButton => 'Vazgeç';

  @override
  String get noMeasurementsYet => 'Henüz bir ölçüm eklemedin.';

  @override
  String get measurementSaveError => 'Ölçüm kaydedilemedi';

  @override
  String get validationWeightHeightRequired => 'Boy ve kilo zorunludur.';
}
