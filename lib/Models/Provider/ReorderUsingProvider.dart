import 'package:flutter/foundation.dart';
import '../Itemname.dart';

class SelectedItemsProvider with ChangeNotifier {
  final List<SelectedItems> _selectedItemsList = [];
  List<SelectedItems> get selectedItemsList => _selectedItemsList;
  String? selectedTableName;
  String? selectedChairIdList;
  Map<String, Set<String>> selectedSeats = {};

  // Getter method to expose the computed value of test1
  String get DisplayTbSc {
    // Generate a string representation of selectedSeats
    return selectedSeats.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value.join(", ")}')
        .join(", ");
  }

  void RunningTabTbCh(String tableName, String chairIdList) {
    selectedTableName = tableName;
    selectedChairIdList = chairIdList;
    notifyListeners();
  }

  void UpdateselectedSeatIntoRunningTabTbCh() {
    // Check if selectedTableName and selectedChairIdList are not null
    if (selectedTableName != null && selectedChairIdList != null) {
      // Clear existing selectedSeats and add the new entry
      selectedSeats.clear();
      selectedSeats[selectedTableName!] = {selectedChairIdList!};
      notifyListeners(); // Notify listeners to update widgets consuming this provider
    }
  }

  void updateSelectedSeatsMap(Map<String, Set<String>> newSeatsMap) {
    selectedSeats = newSeatsMap;
    notifyListeners(); // Notify listeners to update widgets consuming this provider
  }

  void addItem(SelectedItems newItem) {
    _selectedItemsList.add(newItem);
    notifyListeners();
  }

  void clearSelectedSeats() {
    selectedSeats.clear();
    notifyListeners(); // Notify listeners to update widgets consuming this provider
  }

}
