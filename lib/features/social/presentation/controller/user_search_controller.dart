// presentation/controllers/user_search_controller.dart

import 'dart:async';

import 'package:gymplanner_mobile/features/social/domain/entites/user_summary_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/friend_providers.dart';

part 'user_search_controller.g.dart';

class UserSearchState {
  final String query;
  final List<UserSummaryEntity> results;
  final bool isSearching;

  /// Bu oturumda istek gönderilmiş kullanıcı ID'leri — buton anında
  /// "İstek Gönderildi" durumuna geçsin diye lokal takip ediyoruz.
  /// Backend searchUsers zaten ilişki durumunu döndürmüyor.
  final Set<int> requestedUserIds;

  const UserSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.requestedUserIds = const {},
  });

  UserSearchState copyWith({
    String? query,
    List<UserSummaryEntity>? results,
    bool? isSearching,
    Set<int>? requestedUserIds,
  }) {
    return UserSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching:
          isSearching ?? this.isSearching,
      requestedUserIds:
          requestedUserIds ??
          this.requestedUserIds,
    );
  }
}

@riverpod
class UserSearchController
    extends _$UserSearchController {
  Timer? _debounce;

  @override
  UserSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const UserSearchState();
  }

  void updateQuery(String query) {
    state = state.copyWith(
      query: query,
      results: query.trim().length < 2
          ? []
          : null,
    );

    _debounce?.cancel();
    if (query.trim().length < 2) return;

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _search(query.trim()),
    );
  }

  Future<void> _search(String query) async {
    state = state.copyWith(isSearching: true);
    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository.searchUsers(
        query,
      );
      if (result
          is Failure<List<UserSummaryEntity>>) {
        throw result.exception;
      }
      state = state.copyWith(
        results:
            (result
                    as Success<
                      List<UserSummaryEntity>
                    >)
                .data,
        isSearching: false,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'UserSearchController - _search',
        error,
        stackTrace,
      );
      state = state.copyWith(
        isSearching: false,
        results: [],
      );
    }
  }

  Future<bool> sendRequest(int receiverId) async {
    // Optimistic: butonu anında "Gönderildi" yap.
    final optimisticIds = Set<int>.from(
      state.requestedUserIds,
    )..add(receiverId);
    state = state.copyWith(
      requestedUserIds: optimisticIds,
    );

    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .sendFriendRequest(receiverId);
      if (result is Failure<void>) {
        throw result.exception;
      }
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'UserSearchController - sendRequest',
        error,
        stackTrace,
      );
      // Geri al.
      final revertedIds = Set<int>.from(
        state.requestedUserIds,
      )..remove(receiverId);
      state = state.copyWith(
        requestedUserIds: revertedIds,
      );
      return false;
    }
  }
}
