import 'dart:convert';

import 'Itemname.dart';

class KOT {
  String deviceId;
  String Mode;
  String IssueCode;
  String Vno;
  String LedCode;
  String Vtype;
  String TableId;
  String TableSeat;
  String EmployeeId;
  double TotalAmount;
  String ExtraNote;
  List<SelectedItems>? Kotitems;

  KOT({
    required this.Mode,
    required this.IssueCode,
    required this.LedCode,
    required this.Vtype,
    required this.EmployeeId,
    required this.ExtraNote,
    required this.TableId,
    required this.TableSeat,
    required this.TotalAmount,
    required this.deviceId,
    required this.Vno,
    this.Kotitems,
  });

  Map<String, dynamic> toJson() {
    return {
      'DeviceId': deviceId,
      'Mode': Mode,
      'IssueCode': IssueCode,
      'Vno': Vno,
      'LedCode': LedCode,
      'VType': Vtype,
      'TableId': TableId,
      'TableSeat': TableSeat,
      'EmployeeId': EmployeeId,
      'TotalAmount': TotalAmount.toString(), // Convert double to string directly
      'ExtraNote': ExtraNote,
      'KotItems': Kotitems?.map((item) => item.toJson()).toList(),
    };
  }

  factory KOT.fromJson(Map<String, dynamic> json) {
    var kotList = json['Kot'] as List<dynamic>?;

    return KOT(
      TotalAmount: double.parse(json['TotalAmount'] ?? "0"),
      TableSeat: json['TableSeat'] ?? "",
      TableId: json['TableId'] ?? "1",
      Vno: json['Vno'] ?? "",
      ExtraNote: json['ExtraNote'] ?? "",
      EmployeeId: json['EmployeeId'] ?? "",
      IssueCode: json['IssueCode'] ?? "",
      LedCode: json['LedCode'] ?? "",
      deviceId: json['DeviceId'] ?? "",
      Mode: json['Mode'] ?? "",
      Vtype: json['VType'] ?? "",
      Kotitems: kotList != null
          ? kotList.map((v) => SelectedItems.fromJson(v)).toList()
          : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

