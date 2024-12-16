import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:skill_check_project/core/consts/style_res.dart';

import '../../features/main/data/repository_impl/storage_repository_impl.dart';
import '../../features/main/domain/repository/storage_repository.dart';
import 'color_res.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerSingleton<StorageRepository>(StorageRepositoryImpl());
}

final storageRepository = serviceLocator.get<StorageRepository>();

class AppRes {
  static final logger = Logger();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _currentSnackBar;

  static void showSnackBar(BuildContext context, String title) {
    // _currentSnackBar?.close();
    final snackBar = SnackBar(
      content: Text(
        title,
        style: golosMedium.copyWith(
            fontSize: 16, color: AppColors.primaryTextColor),
      ),
      backgroundColor: AppColors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      elevation: 30,
    );
    _currentSnackBar = ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
