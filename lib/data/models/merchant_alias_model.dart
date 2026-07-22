class MerchantAliasModel {
  final int? id;
  final String merchantName;
  final String displayName;

  const MerchantAliasModel({
    this.id,
    required this.merchantName,
    required this.displayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchantName': merchantName,
      'displayName': displayName,
    };
  }

  factory MerchantAliasModel.fromMap(Map<String, dynamic> map) {
    return MerchantAliasModel(
      id: map['id'] as int?,
      merchantName: map['merchantName'] as String,
      displayName: map['displayName'] as String,
    );
  }
}