import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/property_model.dart';

part 'properties_notifier.g.dart';

@Riverpod(keepAlive: true)
class PropertiesNotifier extends _$PropertiesNotifier {
  @override
  FutureOr<List<Property>> build() async {
    state = const AsyncLoading();
    return await DatabaseAPI.getProperties();
  }

  Future<void> addProperty(String propertyName) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.addProperty(propertyName);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> editProperty(Property property) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.editProperty(property);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> deleteProperty(String propertyID) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.deleteProperty(propertyID);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }
}
