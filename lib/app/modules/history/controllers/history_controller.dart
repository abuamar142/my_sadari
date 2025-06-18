import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../screening/models/screening_model.dart';

class HistoryController extends GetxController {
  final storage = GetStorage();
  final results = <ScreeningResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Muat semua riwayat saat init
    final List stored = storage.read<List>('riwayat') ?? <dynamic>[];
    results.value =
        stored
            .map((e) => ScreeningResult.fromJson(Map<String, dynamic>.from(e)))
            .toList();
  }

  /// Hapus satu entry dari riwayat (dipanggil dari View)
  void deleteResult(ScreeningResult result) {
    // 1. Hapus dari storage
    final List<dynamic> list = storage.read<List>('riwayat') ?? <dynamic>[];
    list.removeWhere(
      (e) =>
          (e as Map<String, dynamic>)['timestamp'] == result.timestamp.toIso8601String(),
    );
    storage.write('riwayat', list);

    // 2. Update Observable list sehingga UI ter-refresh
    results.remove(result);
  }
}
