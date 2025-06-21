import 'screening_list_model.dart';

class ScreeningDataModel {
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
  final String? keterangan;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScreeningDataModel({
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
    this.keterangan,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ScreeningDataModel.fromJson(Map<String, dynamic> json) {
    return ScreeningDataModel(
      idSkriningKankerPayudara: json['id_skrining_kanker_payudara'],
      status: json['status'],
      respondenId: json['responden_id'] ?? '',
      umurMenstruasiPertamaDiBawah12:
          json['umur_menstruasi_pertama_di_bawah_12'] ?? false,
      belumPernahMelahirkan: json['belum_pernah_melahirkan'] ?? false,
      belumPernahMenyusui: json['belum_pernah_menyusui'] ?? false,
      menyusuiKurangDari6: json['menyusui_kurang_dari_6'] ?? false,
      melahirkanAnakPertamaDiAtas35:
          json['melahirkan_anak_pertama_di_atas_35'] ?? false,
      menggunakanKb: json['menggunakan_kb'] ?? '',
      menopauseDiAtas50: json['menopause_di_atas_50'] ?? false,
      pernahTumorJinak: json['pernah_tumor_jinak'] ?? false,
      riwayatKeluargaKankerPayudara:
          json['riwayat_keluarga_kanker_payudara'] ?? false,
      consumeAlcohol: json['consume_alcohol'] ?? false,
      smoking: json['smoking'] ?? false,
      obesitas: json['obesitas'] ?? false,
      keterangan: json['keterangan'],
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
    if (keterangan != null) {
      json['keterangan'] = keterangan;
    }
    if (deletedAt != null) {
      json['deletedAt'] = deletedAt!.toIso8601String();
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      json['updatedAt'] = updatedAt!.toIso8601String();
    }

    return json;
  }

  /// Create a copy with updated fields
  ScreeningDataModel copyWith({
    String? idSkriningKankerPayudara,
    String? status,
    String? respondenId,
    bool? umurMenstruasiPertamaDiBawah12,
    bool? belumPernahMelahirkan,
    bool? belumPernahMenyusui,
    bool? menyusuiKurangDari6,
    bool? melahirkanAnakPertamaDiAtas35,
    String? menggunakanKb,
    bool? menopauseDiAtas50,
    bool? pernahTumorJinak,
    bool? riwayatKeluargaKankerPayudara,
    bool? consumeAlcohol,
    bool? smoking,
    bool? obesitas,
    String? keterangan,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScreeningDataModel(
      idSkriningKankerPayudara:
          idSkriningKankerPayudara ?? this.idSkriningKankerPayudara,
      status: status ?? this.status,
      respondenId: respondenId ?? this.respondenId,
      umurMenstruasiPertamaDiBawah12:
          umurMenstruasiPertamaDiBawah12 ?? this.umurMenstruasiPertamaDiBawah12,
      belumPernahMelahirkan:
          belumPernahMelahirkan ?? this.belumPernahMelahirkan,
      belumPernahMenyusui: belumPernahMenyusui ?? this.belumPernahMenyusui,
      menyusuiKurangDari6: menyusuiKurangDari6 ?? this.menyusuiKurangDari6,
      melahirkanAnakPertamaDiAtas35:
          melahirkanAnakPertamaDiAtas35 ?? this.melahirkanAnakPertamaDiAtas35,
      menggunakanKb: menggunakanKb ?? this.menggunakanKb,
      menopauseDiAtas50: menopauseDiAtas50 ?? this.menopauseDiAtas50,
      pernahTumorJinak: pernahTumorJinak ?? this.pernahTumorJinak,
      riwayatKeluargaKankerPayudara:
          riwayatKeluargaKankerPayudara ?? this.riwayatKeluargaKankerPayudara,
      consumeAlcohol: consumeAlcohol ?? this.consumeAlcohol,
      smoking: smoking ?? this.smoking,
      obesitas: obesitas ?? this.obesitas,
      keterangan: keterangan ?? this.keterangan,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert from ScreeningItemWithResponden to ScreeningDataModel
  factory ScreeningDataModel.fromScreeningItem(
    ScreeningItemWithResponden item,
  ) {
    return ScreeningDataModel(
      idSkriningKankerPayudara: item.idSkriningKankerPayudara,
      status: item.status,
      respondenId: item.respondenId,
      umurMenstruasiPertamaDiBawah12: item.umurMenstruasiPertamaDiBawah12,
      belumPernahMelahirkan: item.belumPernahMelahirkan,
      belumPernahMenyusui: item.belumPernahMenyusui,
      menyusuiKurangDari6: item.menyusuiKurangDari6,
      melahirkanAnakPertamaDiAtas35: item.melahirkanAnakPertamaDiAtas35,
      menggunakanKb: item.menggunakanKb,
      menopauseDiAtas50: item.menopauseDiAtas50,
      pernahTumorJinak: item.pernahTumorJinak,
      riwayatKeluargaKankerPayudara: item.riwayatKeluargaKankerPayudara,
      consumeAlcohol: item.consumeAlcohol ?? false,
      smoking: item.smoking ?? false,
      obesitas: item.obesitas ?? false,
      keterangan: item.keterangan,
      deletedAt: item.deletedAt,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
