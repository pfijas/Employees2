import 'dart:convert';

class Reorder{
  String tableName;
  String chairIdList;

  Reorder({
    required this.tableName,
    required this.chairIdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'tableName':tableName,
      'ChairIdList':chairIdList,
    };
  }

  factory Reorder.fromJson(Map<String, dynamic> json) {
    return Reorder(
      tableName: json['TableName'],
      chairIdList: json['ChairIdList'],
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
class ReOrderItems {
  String mode;
  String? deviceId;
  int issueCode;
  int vno;
  int ledCode;
  String vType;
  int tableId;
  String tableSeat;
  int employeeId;
  double totalAmount;
  String extraNote;
  List<KotItem> kotItems;

  ReOrderItems({
    required this.mode,
    this.deviceId,
    required this.issueCode,
    required this.vno,
    required this.ledCode,
    required this.vType,
    required this.tableId,
    required this.tableSeat,
    required this.employeeId,
    required this.totalAmount,
    required this.extraNote,
    required this.kotItems,
  });

  factory ReOrderItems.fromJson(Map<String, dynamic> json) {
    var list = json['KotItems'] as List;
    List<KotItem> kotItemList = list.map((i) => KotItem.fromJson(i)).toList();

    return ReOrderItems(
      mode: json['Mode'],
      deviceId: json['DeviceId'],
      issueCode: json['IssueCode'],
      vno: json['Vno'],
      ledCode: json['LedCode'],
      vType: json['VType'],
      tableId: json['TableId'],
      tableSeat: json['TableSeat'],
      employeeId: json['EmployeeId'],
      totalAmount: json['TotalAmount'].toDouble(),
      extraNote: json['ExtraNote'],
      kotItems: kotItemList,
    );
  }
}

class KotItem {
  int slNo;
  int itemId;
  String name;
  double sRate;
  String? printer;
  double qty;
  double netAmount;
  double taxAmount;
  double taxPerc;
  double taxable;
  String notes;
  String? itemModifiedStatus;
  List<dynamic> addonItems;

  KotItem({
    required this.slNo,
    required this.itemId,
    required this.name,
    required this.sRate,
    this.printer,
    required this.qty,
    required this.netAmount,
    required this.taxAmount,
    required this.taxPerc,
    required this.taxable,
    required this.notes,
    this.itemModifiedStatus,
    required this.addonItems,
  });

  factory KotItem.fromJson(Map<String, dynamic> json) {
    return KotItem(
      slNo: json['SlNo'] ?? 0,
      itemId: json['ItemId'] ?? 0,
      name: json['Name'] ?? '',
      sRate: (json['SRate'] ?? 0).toDouble(),
      printer: json['Printer'],
      qty: (json['Qty'] ?? 0).toDouble(),
      netAmount: (json['NetAmount'] ?? 0).toDouble(),
      taxAmount: (json['TaxAmount'] ?? 0).toDouble(),
      taxPerc: (json['TaxPerc'] ?? 0).toDouble(),
      taxable: (json['Taxable'] ?? 0).toDouble(),
      notes: json['Notes'] ?? '',
      itemModifiedStatus: json['ItemModifiedStatus'],
      addonItems: json['AddonItems'] ?? [],
    );
  }
}
