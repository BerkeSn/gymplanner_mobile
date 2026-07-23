import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

/// Hassas olmayan yerel ayarlar (dil tercihi, tema modu vb.) için tek
/// SharedPreferences kaynağı. JWT gibi gizli veriler burada DEĞİL,
/// SecureTokenStorage'da tutulur.
@riverpod
Future<SharedPreferences> sharedPreferences(
  SharedPreferencesRef ref,
) async {
  try {
    return await SharedPreferences.getInstance();
  } catch (error, stackTrace) {
    throw Exception(
      '[sharedPreferences - provider]: ${error.toString()}\n$stackTrace',
    );
  }
}
