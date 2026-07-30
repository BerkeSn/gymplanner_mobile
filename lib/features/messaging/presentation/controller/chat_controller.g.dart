// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatControllerHash() => r'afe6d9b1b16127e5f65448da4975df62be3fa9c1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ChatController
    extends BuildlessAutoDisposeAsyncNotifier<List<MessageEntity>> {
  late final int conversationId;

  FutureOr<List<MessageEntity>> build(int conversationId);
}

/// family: her conversationId için bağımsız state, autoDispose (varsayılan
/// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
///
/// Copied from [ChatController].
@ProviderFor(ChatController)
const chatControllerProvider = ChatControllerFamily();

/// family: her conversationId için bağımsız state, autoDispose (varsayılan
/// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
///
/// Copied from [ChatController].
class ChatControllerFamily extends Family<AsyncValue<List<MessageEntity>>> {
  /// family: her conversationId için bağımsız state, autoDispose (varsayılan
  /// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
  ///
  /// Copied from [ChatController].
  const ChatControllerFamily();

  /// family: her conversationId için bağımsız state, autoDispose (varsayılan
  /// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
  ///
  /// Copied from [ChatController].
  ChatControllerProvider call(int conversationId) {
    return ChatControllerProvider(conversationId);
  }

  @override
  ChatControllerProvider getProviderOverride(
    covariant ChatControllerProvider provider,
  ) {
    return call(provider.conversationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatControllerProvider';
}

/// family: her conversationId için bağımsız state, autoDispose (varsayılan
/// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
///
/// Copied from [ChatController].
class ChatControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ChatController,
          List<MessageEntity>
        > {
  /// family: her conversationId için bağımsız state, autoDispose (varsayılan
  /// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
  ///
  /// Copied from [ChatController].
  ChatControllerProvider(int conversationId)
    : this._internal(
        () => ChatController()..conversationId = conversationId,
        from: chatControllerProvider,
        name: r'chatControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chatControllerHash,
        dependencies: ChatControllerFamily._dependencies,
        allTransitiveDependencies:
            ChatControllerFamily._allTransitiveDependencies,
        conversationId: conversationId,
      );

  ChatControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final int conversationId;

  @override
  FutureOr<List<MessageEntity>> runNotifierBuild(
    covariant ChatController notifier,
  ) {
    return notifier.build(conversationId);
  }

  @override
  Override overrideWith(ChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatControllerProvider._internal(
        () => create()..conversationId = conversationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatController, List<MessageEntity>>
  createElement() {
    return _ChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<MessageEntity>> {
  /// The parameter `conversationId` of this provider.
  int get conversationId;
}

class _ChatControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ChatController,
          List<MessageEntity>
        >
    with ChatControllerRef {
  _ChatControllerProviderElement(super.provider);

  @override
  int get conversationId => (origin as ChatControllerProvider).conversationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
