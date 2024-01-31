import 'dart:convert';
import 'package:employees/Models/SettingsSave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../Models/Settings.dart';
import '../Utils/GlobalFn.dart';

class logsettings extends StatefulWidget {
  const logsettings({Key? key}) : super(key: key);

  @override
  State<logsettings> createState() => _logsettingsState();
}

class _logsettingsState extends State<logsettings> {
  String? DeviceId = "";
  SQLMessage? sqlMessage;
  List<TableClass>? tableClass;
  List<KOTVoucher>? kotVoucher;
  List<TAVoucher>? taVoucher;
  List<PrintArea>? printArea;
  late List<SavedSettings> savedsettings;


  //single dropdown items
  TableClass? selTableClass;
  KOTVoucher? selKOTVoucher;
  TAVoucher? selTAVoucher;
  PrintArea? selFirstprint;
  PrintArea? selSecondprint;
  PrintArea? selThirdprint;
  PrintArea? selFourthprint;
  PrintArea? selFifthprint;

  final ipController1 = TextEditingController();
  final ipController2 = TextEditingController();
  final ipController3 = TextEditingController();
  final ipController4 = TextEditingController();
  final ipController5 = TextEditingController();

  @override
  void initState() {
    fetchData();
    LoadSettings();
    super.initState();
  }

  Future<void> SaveSettings() async {
    SettingsSave settingsSave = SettingsSave();
    settingsSave.devideInfo = DeviceInfo(deviceId: await fnGetDeviceId());
    List<SettingsList> settingsLists = [];

    if (selTableClass != null) {
      settingsLists.add(SettingsList(
        identifierKey: "SETT_TAB_AREA",
        identifierValue: selTableClass?.className,
      ));
    }
    if (selKOTVoucher != null) {
      var settings = SettingsList(
        identifierKey: "SETT_TAB_KOT_LID",
        identifierValue: selKOTVoucher?.ledId.toString(),
      );
      settingsLists.add(settings);
    }
    if (selTAVoucher != null) {
      settingsLists.add(SettingsList(
        identifierKey: "SETT_TAB_TA_LID",
        identifierValue: selTAVoucher?.ledId.toString(),
      ));
    }
    if (selFirstprint != null) {
      settingsLists.add(SettingsList(
        identifierValue: selFirstprint?.printAreaId.toString(),
        identifierKey: "SETT_TAB_PA1",
      ));
    }
    if (selSecondprint != null) {
      settingsLists.add(SettingsList(
        identifierValue: selSecondprint?.printAreaName,
        identifierKey: "SETT_TAB_PA2",
      ));
    }

    if (selThirdprint != null) {
      settingsLists.add(SettingsList(
        identifierValue: selThirdprint?.printAreaName,
        identifierKey: "SETT_TAB_PA3",
      ));
    }
    if (selFourthprint != null) {
      settingsLists.add(SettingsList(
        identifierValue: selFourthprint?.printAreaName,
        identifierKey: "SETT_TAB_PA4",
      ));
    }
    if (selFifthprint != null) {
      settingsLists.add(SettingsList(
        identifierValue: selFifthprint?.printAreaName,
        identifierKey: "SETT_TAB_PA5",
      ));
    }
    if (ipController1 != null) {
      settingsLists.add(SettingsList(
        identifierValue: ipController1.text,
        identifierKey: "SETT_TAB_IP1",
      ));
    }
    if (ipController2 != null) {
      settingsLists.add(SettingsList(
        identifierValue: ipController2.text,
        identifierKey: "SETT_TAB_IP2",
      ));
    }
    if (ipController3 != null) {
      settingsLists.add(SettingsList(
        identifierValue: ipController3.text,
        identifierKey: "SETT_TAB_IP3",
      ));
    }
    if (ipController4 != null) {
      settingsLists.add(SettingsList(
        identifierValue: ipController4.text,
        identifierKey: "SETT_TAB_IP4",
      ));
    }
    if (ipController5 != null) {
      settingsLists.add(SettingsList(
        identifierValue: ipController5.text,
        identifierKey: "SETT_TAB_IP5",
      ));
    }

    settingsSave.settingsList = settingsLists;

    var settingsSaveJson = settingsSave.toJson();
    print("Settings List Save JSON: $settingsSaveJson");

    var jsonData = jsonEncode({
      "DevideInfo": settingsSave.devideInfo?.toJson(),
      "Settings": settingsSave.settingsList
    });

    final String? baseUrl = await fnGetBaseUrl();
    final String apiUrl = '${baseUrl}api/Settings/save';
    print("Complete JSON Payloadddddd: $jsonData");

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
   // print("Complete JSON Payload sent to API: $jsonData");
    if (response.statusCode == 200) {
     json.decode(response.body);
    }
  }

  Future<void> LoadSettings() async {
    await fetchData();

    if (savedsettings != null && savedsettings.isNotEmpty) {
      SavedSettings? ipController1Settings = savedsettings
          .firstWhere((element) => element.identifierKey == "SETT_TAB_IP1",
          orElse: () => SavedSettings());
      SavedSettings? ipController2Settings = savedsettings
          .firstWhere((element) => element.identifierKey == "SETT_TAB_IP2",
          orElse: () => SavedSettings());
      SavedSettings? ipController3Settings = savedsettings
          .firstWhere((element) => element.identifierKey == "SETT_TAB_IP3",
          orElse: () => SavedSettings());
      SavedSettings? ipController4Settings = savedsettings
          .firstWhere((element) => element.identifierKey == "SETT_TAB_IP4",
          orElse: () => SavedSettings());
      SavedSettings? ipController5Settings = savedsettings
          .firstWhere((element) => element.identifierKey == "SETT_TAB_IP5",
          orElse: () => SavedSettings());


      setState(() {
        ipController1.text = ipController1Settings?.identifierValue ?? "";
        ipController2.text = ipController2Settings?.identifierValue ?? "";
        ipController3.text = ipController3Settings?.identifierValue ?? "";
        ipController4.text = ipController4Settings?.identifierValue ?? "";
        ipController5.text = ipController5Settings?.identifierValue ?? "";
      });
    }
  }


  Future<void> fetchData() async {
    DeviceId = await fnGetDeviceId();
    final String? baseUrl = await fnGetBaseUrl();
    String apiUrl = '${baseUrl}api/Settings/data';

    try {
      apiUrl = '$apiUrl?DeviceId=$DeviceId';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Settings settings = Settings.fromJson(json.decode(response.body));

        sqlMessage = settings.data?.sQLMessage;

        if (sqlMessage?.code == "200") {
          setState(() {
            tableClass = settings.data?.tableClass;
            kotVoucher = settings.data?.kOTVoucher;
            taVoucher = settings.data?.tAVoucher;
            printArea = settings.data?.printArea;
            savedsettings =settings.data!.savedSettings!;

            // Set initial values for dropdowns based on fetched data
            if (tableClass != null && tableClass!.isNotEmpty) {
              selTableClass = tableClass!.first;
            }
            if (kotVoucher != null && kotVoucher!.isNotEmpty) {
              selKOTVoucher = kotVoucher!.first;
            }
            if (taVoucher != null && taVoucher!.isNotEmpty) {
              selTAVoucher = taVoucher!.first;
            }
            if (printArea != null && printArea!.isNotEmpty) {
              selFirstprint = printArea!.first;
              selSecondprint = printArea!.first;
              selThirdprint = printArea!.first;
              selFourthprint = printArea!.first;
              selFifthprint = printArea!.first;
            }
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 50, bottom: 10, left: 10, right: 10),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Table Class",
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "   KOT Voucher",
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "  T A Voucher",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 36,
                            ),
                            Column(
                              children: [
                                DropdownButton<TableClass>(
                                  value: selTableClass,
                                  onChanged: (TableClass? newArea) {
                                    setState(() {
                                      selTableClass = newArea;
                                    });
                                  },
                                  items: tableClass
                                      ?.map<DropdownMenuItem<TableClass>>(
                                          (TableClass tableArea) {
                                    return DropdownMenuItem<TableClass>(
                                      value: tableArea,
                                      child:
                                          Text(tableArea.className.toString()),
                                    );
                                  }).toList(),
                                ),
                                DropdownButton<KOTVoucher>(
                                  value: selKOTVoucher,
                                  onChanged: (KOTVoucher? newArea) {
                                    setState(() {
                                      selKOTVoucher = newArea;
                                    });
                                  },
                                  items: kotVoucher
                                      ?.map<DropdownMenuItem<KOTVoucher>>(
                                          (KOTVoucher kotArea) {
                                    return DropdownMenuItem<KOTVoucher>(
                                      value: kotArea,
                                      child:
                                          Text(kotArea.ledgerName.toString()),
                                    );
                                  }).toList(),
                                ),
                                DropdownButton<TAVoucher>(
                                  value: selTAVoucher,
                                  onChanged: (TAVoucher? newArea) {
                                    setState(() {
                                      selTAVoucher = newArea;
                                    });
                                  },
                                  items: taVoucher
                                      ?.map<DropdownMenuItem<TAVoucher>>(
                                          (TAVoucher tavArea) {
                                    return DropdownMenuItem<TAVoucher>(
                                      value: tavArea,
                                      child:
                                          Text(tavArea.ledgerName.toString()),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            Container(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Center(
                        child: Text(
                          "Print Settings",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Text("Print  Area", style: TextStyle(fontSize: 21)),
                            SizedBox(height: 20),
                            DropdownButton<PrintArea>(
                              value: selFirstprint,
                              onChanged: (PrintArea? newArea) {
                                setState(() {
                                  selFirstprint = newArea;
                                });
                              },
                              items: printArea
                                  ?.map<DropdownMenuItem<PrintArea>>(
                                      (PrintArea tavArea) {
                                return DropdownMenuItem<PrintArea>(
                                  value: tavArea,
                                  child: Text(tavArea.printAreaName.toString()),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton<PrintArea>(
                              value: selSecondprint,
                              onChanged: (PrintArea? newArea) {
                                setState(() {
                                  selSecondprint = newArea;
                                });
                              },
                              items: printArea
                                  ?.map<DropdownMenuItem<PrintArea>>(
                                      (PrintArea tavArea) {
                                return DropdownMenuItem<PrintArea>(
                                  value: tavArea,
                                  child: Text(tavArea.printAreaName.toString()),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton<PrintArea>(
                              value: selThirdprint,
                              onChanged: (PrintArea? newArea) {
                                setState(() {
                                  selThirdprint = newArea;
                                });
                              },
                              items: printArea
                                  ?.map<DropdownMenuItem<PrintArea>>(
                                      (PrintArea tavArea) {
                                return DropdownMenuItem<PrintArea>(
                                  value: tavArea,
                                  child: Text(tavArea.printAreaName.toString()),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton<PrintArea>(
                              value: selFourthprint,
                              onChanged: (PrintArea? newArea) {
                                setState(() {
                                  selFourthprint = newArea;
                                });
                              },
                              items: printArea
                                  ?.map<DropdownMenuItem<PrintArea>>(
                                      (PrintArea tavArea) {
                                return DropdownMenuItem<PrintArea>(
                                  value: tavArea,
                                  child: Text(tavArea.printAreaName.toString()),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButton<PrintArea>(
                              value: selFifthprint,
                              onChanged: (PrintArea? newArea) {
                                setState(() {
                                  selFifthprint = newArea;
                                });
                              },
                              items: printArea
                                  ?.map<DropdownMenuItem<PrintArea>>(
                                      (PrintArea tavArea) {
                                return DropdownMenuItem<PrintArea>(
                                  value: tavArea,
                                  child: Text(tavArea.printAreaName.toString()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 200,
                        ),
                        Column(
                          children: [
                            Text("Print  IP", style: TextStyle(fontSize: 21)),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: ipController1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the value as needed
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: ipController2,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the value as needed
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: ipController3,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the value as needed
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: ipController4,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the value as needed
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: ipController5,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the value as needed
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                    Container(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        SaveSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              3.0), // Set the radius to 0 for square edges
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
