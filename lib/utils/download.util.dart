import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class DownloadUtil {
  static const task = 'download';

  static Future<void> start({Duration initialDelay = Duration.zero}) async {
    final permission = await Permission.storage.status;

    if (!permission.isGranted && !permission.isLimited) {
      final status = await Permission.storage.request();
      if (!status.isGranted && !status.isLimited) return;
    }

    Workmanager().registerOneOffTask(
      task,
      task,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicyDelay: const Duration(seconds: 8),
      backoffPolicy: BackoffPolicy.linear,
      initialDelay: initialDelay,
    );
  }
}
