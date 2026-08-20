import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateServices {
  Future<bool> checkForUpdate() async {
    if (!Platform.isAndroid) {
      debugPrint(
        'In-app update is only supported on Android.',
      );
      return false;
    }

    try {
      debugPrint('Checking for app update...');

      final AppUpdateInfo updateInfo =
          await InAppUpdate.checkForUpdate();

      debugPrint(
        'Update availability: '
        '${updateInfo.updateAvailability}',
      );

      debugPrint(
        'Available version code: '
        '${updateInfo.availableVersionCode}',
      );

      debugPrint(
        'Immediate update allowed: '
        '${updateInfo.immediateUpdateAllowed}',
      );

      debugPrint(
        'Flexible update allowed: '
        '${updateInfo.flexibleUpdateAllowed}',
      );

      if (updateInfo.updateAvailability !=
          UpdateAvailability.updateAvailable) {
        debugPrint('No update available.');
        return false;
      }

      if (!updateInfo.immediateUpdateAllowed) {
        debugPrint(
          'Immediate update is not allowed by Google Play.',
        );
        return false;
      }

      debugPrint('Update is available.');

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'App update check failed: $e',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );
      return false;
    }
  }

  Future<bool> startImmediateUpdate() async {
    if (!Platform.isAndroid) {
      return false;
    }
    try {
      debugPrint(
        'Starting Google Play immediate update...',
      );

      await InAppUpdate.performImmediateUpdate();

      debugPrint(
        'Immediate update completed.',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'Immediate update cancelled/failed: $e',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );
      return false;
    }
  }
}
