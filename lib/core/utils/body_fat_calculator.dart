import 'dart:math' as math;

import '../../features/auth/domain/entities/user_entity.dart';

/// ABD Donanması vücut yağ oranı hesaplama yöntemi.
/// Kaynak: doğruluğu klinik olarak kabul görmüş, sahada en yaygın kullanılan
/// çevre-ölçümü bazlı formül. BMI-tabanlı tahminlerden daha güvenilir çünkü
/// gerçek vücut kompozisyonunu (yağ/kas dağılımını) hesaba katar.
///
/// Kadınlar için `hipCm` ZORUNLUDUR — erkekler için opsiyoneldir (formülde
/// kullanılmaz, null geçilebilir).
class BodyFatCalculator {
  BodyFatCalculator._();

  /// Girdi geçersizse (ör. log10 tanım dışı değer üretecek negatif/sıfır
  /// fark) null döner — çağıran taraf bu durumda kullanıcıya manuel giriş
  /// yapmasını önermeli.
  static double? calculate({
    required Gender gender,
    required double heightCm,
    required double neckCm,
    required double waistCm,
    double? hipCm,
  }) {
    try {
      if (gender == Gender.female) {
        if (hipCm == null || hipCm <= 0)
          return null;
        final circumferenceDiff =
            waistCm + hipCm - neckCm;
        if (circumferenceDiff <= 0) return null;

        final denominator =
            1.29579 -
            0.35004 * _log10(circumferenceDiff) +
            0.22100 * _log10(heightCm);
        if (denominator <= 0) return null;

        final result = 495 / denominator - 450;
        return _clampToPlausibleRange(result);
      } else {
        // Erkek formülü — 'other' cinsiyet seçimi için de bu formülü
        // kullanıyoruz (kadına özgü hip verisi olmadığı için daha genel
        // olan erkek formülü daha az veri gerektirir).
        final circumferenceDiff =
            waistCm - neckCm;
        if (circumferenceDiff <= 0) return null;

        final denominator =
            1.0324 -
            0.19077 * _log10(circumferenceDiff) +
            0.15456 * _log10(heightCm);
        if (denominator <= 0) return null;

        final result = 495 / denominator - 450;
        return _clampToPlausibleRange(result);
      }
    } catch (error, stackTrace) {
      // ignore: avoid_print
      print(
        '[BodyFatCalculator - calculate]: $error\n$stackTrace',
      );
      return null;
    }
  }

  static double _log10(double value) =>
      math.log(value) / math.ln10;

  /// Formül matematiksel olarak geçerli ama fizyolojik olarak imkansız
  /// bir sonuç üretebilir (ör. ölçüm hatası varsa %60 gibi) — makul
  /// aralığa (2%-60%) kırpıyoruz, tamamen reddetmek yerine.
  static double _clampToPlausibleRange(
    double value,
  ) {
    return value.clamp(2.0, 60.0);
  }
}
