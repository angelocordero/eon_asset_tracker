// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifiers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$advancedInventoryNotifierHash() =>
    r'd3323c48dd06eb577fb0b8a29df9ab409243c78d';

/// See also [AdvancedInventoryNotifier].
@ProviderFor(AdvancedInventoryNotifier)
final advancedInventoryNotifierProvider =
    AsyncNotifierProvider<AdvancedInventoryNotifier, Inventory>.internal(
  AdvancedInventoryNotifier.new,
  name: r'advancedInventoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advancedInventoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdvancedInventoryNotifier = AsyncNotifier<Inventory>;
String _$activeSearchFiltersNotifierHash() =>
    r'03fadd43066164d29b4c24bb13c7a855f6daaa81';

/// See also [ActiveSearchFiltersNotifier].
@ProviderFor(ActiveSearchFiltersNotifier)
final activeSearchFiltersNotifierProvider = AutoDisposeNotifierProvider<
    ActiveSearchFiltersNotifier, List<InventorySearchFilter>>.internal(
  ActiveSearchFiltersNotifier.new,
  name: r'activeSearchFiltersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeSearchFiltersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveSearchFiltersNotifier
    = AutoDisposeNotifier<List<InventorySearchFilter>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
