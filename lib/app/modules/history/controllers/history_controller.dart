import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/screening_service.dart';
import '../../screening/models/screening_list_model.dart';

class HistoryController extends GetxController {
  late final AuthService _authService;
  late final ScreeningService _screeningService;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<ScreeningItemWithResponden> screeningHistory =
      <ScreeningItemWithResponden>[].obs;

  int currentPage = 1;
  int totalPages = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _screeningService = Get.find<ScreeningService>();
    loadHistory();
  }

  Future<void> loadHistory({bool refresh = false}) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    try {
      if (refresh) {
        currentPage = 1;
        isLoading.value = true;
      } else if (currentPage == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _screeningService.getScreeningHistory(
        userId: currentUser.id,
        page: currentPage,
        pageSize: pageSize,
      );

      if (kDebugMode) {
        print('Load history result: ${response.success}');
        print('Load history message: ${response.message}');
      }

      if (response.success && response.data != null) {
        final historyResponse = response.data!;

        if (historyResponse.success) {
          totalPages = historyResponse.totalPages;

          if (refresh || currentPage == 1) {
            screeningHistory.value = historyResponse.data;
          } else {
            screeningHistory.addAll(historyResponse.data);
          }

          if (kDebugMode) {
            print('Loaded ${historyResponse.data.length} history items');
            print('Current page: $currentPage, Total pages: $totalPages');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error loading history: ${response.message}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in loadHistory: $e');
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreHistory() async {
    if (isLoadingMore.value || currentPage >= totalPages) return;

    currentPage++;
    await loadHistory();
  }

  Future<void> refreshHistory() async {
    await loadHistory(refresh: true);
  }

  String getRiskLevel(ScreeningItemWithResponden item) {
    // Check if any major risk factors are true
    final majorRisks = [
      item.menopauseDiAtas50,
      item.pernahTumorJinak,
      item.riwayatKeluargaKankerPayudara,
    ];

    // Check if any other risk factors are true
    final minorRisks = [
      item.umurMenstruasiPertamaDiBawah12,
      item.belumPernahMelahirkan,
      item.belumPernahMenyusui,
      item.menyusuiKurangDari6,
      item.melahirkanAnakPertamaDiAtas35,
      item.menggunakanKb == "PIL",
      item.consumeAlcohol ?? false,
      item.smoking ?? false,
      item.obesitas ?? false,
    ];

    final hasAnyRisk =
        majorRisks.any((risk) => risk) || minorRisks.any((risk) => risk);

    return hasAnyRisk
        ? 'Berisiko Terkena Kanker Payudara'
        : 'Tidak Berisiko Terkena Kanker Payudara';
  }

  bool get hasMoreData => currentPage < totalPages;
}
