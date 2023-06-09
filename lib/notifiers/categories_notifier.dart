import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../models/category_model.dart';

part 'categories_notifier.g.dart';

@Riverpod(keepAlive: true)
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  FutureOr<List<ItemCategory>> build() async {
    return await DatabaseAPI.getCategories();
  }

  Future<void> addCategory(String categoryName) async {
    state = const AsyncValue.loading();

    AsyncValue.guard(() async {
      await DatabaseAPI.addCategory(categoryName);
    });

    ref.invalidateSelf();
  }

  Future<void> editCategory(ItemCategory category) async {
    state = const AsyncValue.loading();

    AsyncValue.guard(() async {
      await DatabaseAPI.editCategory(category);
    });

    ref.invalidateSelf();
  }

  Future<void> deleteCategory(String categoryID) async {
    state = const AsyncValue.loading();

    AsyncValue.guard(() async {
      await DatabaseAPI.deleteCategory(categoryID);
    });

    ref.invalidateSelf();
  }
}
