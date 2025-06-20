class ScreeningListRequest {
  final int page;
  final int pageSize;
  final ScreeningFilter filter;

  ScreeningListRequest({
    required this.page,
    required this.pageSize,
    required this.filter,
  });

  Map<String, dynamic> toJson() {
    return {'page': page, 'pageSize': pageSize, 'filter': filter.toJson()};
  }
}

class ScreeningFilter {
  final String idUser;

  ScreeningFilter({required this.idUser});

  Map<String, dynamic> toJson() {
    return {'id_user': idUser};
  }
}

class ScreeningListResponse {
  final bool success;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final List<ScreeningItemWithResponden> data;

  ScreeningListResponse({
    required this.success,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.data,
  });

  factory ScreeningListResponse.fromJson(Map<String, dynamic> json) {
    return ScreeningListResponse(
      success: json['success'] ?? false,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ScreeningItemWithResponden.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ScreeningItemWithResponden {
  final String idSkriningKankerPayudara;
  final String respondenId;
  final bool umurMenstruasiPertamaDiBawah12;
  final bool belumPernahMelahirkan;
  final bool belumPernahMenyusui;
  final bool melahirkanAnakPertamaDiAtas35;
  final String menggunakanKb;
  final bool menopauseDiAtas50;
  final bool pernahTumorJinak;
  final bool riwayatKeluargaKankerPayudara;
  final bool? consumeAlcohol;
  final bool? smoking;
  final bool? obesitas;
  final String? keterangan;
  final String status;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RespondenInfo responden;

  ScreeningItemWithResponden({
    required this.idSkriningKankerPayudara,
    required this.respondenId,
    required this.umurMenstruasiPertamaDiBawah12,
    required this.belumPernahMelahirkan,
    required this.belumPernahMenyusui,
    required this.melahirkanAnakPertamaDiAtas35,
    required this.menggunakanKb,
    required this.menopauseDiAtas50,
    required this.pernahTumorJinak,
    required this.riwayatKeluargaKankerPayudara,
    this.consumeAlcohol,
    this.smoking,
    this.obesitas,
    this.keterangan,
    required this.status,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.responden,
  });

  factory ScreeningItemWithResponden.fromJson(Map<String, dynamic> json) {
    return ScreeningItemWithResponden(
      idSkriningKankerPayudara: json['id_skrining_kanker_payudara'] ?? '',
      respondenId: json['responden_id'] ?? '',
      umurMenstruasiPertamaDiBawah12:
          json['umur_menstruasi_pertama_di_bawah_12'] ?? false,
      belumPernahMelahirkan: json['belum_pernah_melahirkan'] ?? false,
      belumPernahMenyusui: json['belum_pernah_menyusui'] ?? false,
      melahirkanAnakPertamaDiAtas35:
          json['melahirkan_anak_pertama_di_atas_35'] ?? false,
      menggunakanKb: json['menggunakan_kb'] ?? '',
      menopauseDiAtas50: json['menopause_di_atas_50'] ?? false,
      pernahTumorJinak: json['pernah_tumor_jinak'] ?? false,
      riwayatKeluargaKankerPayudara:
          json['riwayat_keluarga_kanker_payudara'] ?? false,
      consumeAlcohol: json['consume_alcohol'],
      smoking: json['smoking'],
      obesitas: json['obesitas'],
      keterangan: json['keterangan'],
      status: json['status'] ?? '',
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      responden: RespondenInfo.fromJson(json['responden']),
    );
  }
}

class RespondenInfo {
  final String idUser;
  final String name;
  final String status;

  RespondenInfo({
    required this.idUser,
    required this.name,
    required this.status,
  });

  factory RespondenInfo.fromJson(Map<String, dynamic> json) {
    return RespondenInfo(
      idUser: json['id_user'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
