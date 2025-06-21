class ScreeningApiModel {
  final String? idSkriningKankerPayudara;
  final String? status;
  final String respondenId;
  final bool umurMenstruasiPertamaDiBawah12;
  final bool belumPernahMelahirkan;
  final bool belumPernahMenyusui;
  final bool menyusuiKurangDari6;
  final bool melahirkanAnakPertamaDiAtas35;
  final String menggunakanKb;
  final bool menopauseDiAtas50;
  final bool pernahTumorJinak;
  final bool riwayatKeluargaKankerPayudara;
  final bool consumeAlcohol;
  final bool smoking;
  final bool obesitas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScreeningApiModel({
    this.idSkriningKankerPayudara,
    this.status,
    required this.respondenId,
    required this.umurMenstruasiPertamaDiBawah12,
    required this.belumPernahMelahirkan,
    required this.belumPernahMenyusui,
    required this.menyusuiKurangDari6,
    required this.melahirkanAnakPertamaDiAtas35,
    required this.menggunakanKb,
    required this.menopauseDiAtas50,
    required this.pernahTumorJinak,
    required this.riwayatKeluargaKankerPayudara,
    required this.consumeAlcohol,
    required this.smoking,
    required this.obesitas,
    this.createdAt,
    this.updatedAt,
  });

  factory ScreeningApiModel.fromJson(Map<String, dynamic> json) {
    return ScreeningApiModel(
      idSkriningKankerPayudara: json['id_skrining_kanker_payudara'],
      status: json['status'],
      respondenId: json['responden_id'] ?? '',
      umurMenstruasiPertamaDiBawah12: json['umur_menstruasi_pertama_di_bawah_12'] ?? false,
      belumPernahMelahirkan: json['belum_pernah_melahirkan'] ?? false,
      belumPernahMenyusui: json['belum_pernah_menyusui'] ?? false,
      menyusuiKurangDari6: json['menyusui_kurang_dari_6'] ?? false,
      melahirkanAnakPertamaDiAtas35: json['melahirkan_anak_pertama_di_atas_35'] ?? false,
      menggunakanKb: json['menggunakan_kb'] ?? '',
      menopauseDiAtas50: json['menopause_di_atas_50'] ?? false,
      pernahTumorJinak: json['pernah_tumor_jinak'] ?? false,
      riwayatKeluargaKankerPayudara: json['riwayat_keluarga_kanker_payudara'] ?? false,
      consumeAlcohol: json['consume_alcohol'] ?? false,
      smoking: json['smoking'] ?? false,
      obesitas: json['obesitas'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'responden_id': respondenId,
      'umur_menstruasi_pertama_di_bawah_12': umurMenstruasiPertamaDiBawah12,
      'belum_pernah_melahirkan': belumPernahMelahirkan,
      'belum_pernah_menyusui': belumPernahMenyusui,
      'menyusui_kurang_dari_6': menyusuiKurangDari6,
      'melahirkan_anak_pertama_di_atas_35': melahirkanAnakPertamaDiAtas35,
      'menggunakan_kb': menggunakanKb,
      'menopause_di_atas_50': menopauseDiAtas50,
      'pernah_tumor_jinak': pernahTumorJinak,
      'riwayat_keluarga_kanker_payudara': riwayatKeluargaKankerPayudara,
      'consume_alcohol': consumeAlcohol,
      'smoking': smoking,
      'obesitas': obesitas,
    };

    if (idSkriningKankerPayudara != null) {
      json['id_skrining_kanker_payudara'] = idSkriningKankerPayudara;
    }
    if (status != null) {
      json['status'] = status;
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      json['updatedAt'] = updatedAt!.toIso8601String();
    }

    return json;
  }
}
