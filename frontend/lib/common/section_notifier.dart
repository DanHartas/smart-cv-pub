import 'package:flutter/material.dart';

class SectionNotifier extends ChangeNotifier {
  final Map<int, bool> _expandedSections = {};
  final Map<int, bool> _highlightedSections = {};
  final Map<int, List<int>> _topLevel = {};

  bool isExpanded(int cID) => _expandedSections[cID] ?? false;
  bool isHighlighted(int cID) => _highlightedSections[cID] ?? false;

  void expandSection(int cID) {
    _expandedSections[cID] = true;
    notifyListeners();
  }

  void collapseSection(int cID) {
    _expandedSections[cID] = false;
    _highlightedSections[cID] = false;
    if (_topLevel.containsKey(cID)) {
      for (var childID in _topLevel[cID]!) {
        collapseSection(childID);
      }
    }
    notifyListeners();
  }

  void toggleSection(int cID) {
    _expandedSections[cID] = !(_expandedSections[cID] ?? false);
    notifyListeners();
  }

  void highlightSection(int cID) {
    _highlightedSections[cID] = true;
    notifyListeners();
  }

  void removeHighlight(int cID) {
    _highlightedSections[cID] = false;
    notifyListeners();
  }

  void expandParents(List<int>? parentIDs) {
    if (parentIDs != null) {
      for (var id in parentIDs) {
        _expandedSections[id] = true;
      }
      notifyListeners();
    }
  }

  void collapseParents(List<int>? parentIDs) {
    if (parentIDs != null) {
      for (var id in parentIDs) {
        _expandedSections[id] = false;
        _highlightedSections[id] = false;
      }
      notifyListeners();
    }
  }

  void initialise(Map<int, List<int>> collapsibleParents) {
    collapsibleParents.forEach((key, parents) {
      _expandedSections[key] = key == 0;
      if (parents.isEmpty) {
        _topLevel[key] = collapsibleParents.entries
            .where((entry) => entry.value.contains(key))
            .map((entry) => entry.key)
            .toList();
      }
    });
    notifyListeners();
  }

  void expandAll() {
    for (var key in _topLevel.keys) {
      _expandedSections[key] = true;
    }
    notifyListeners();
  }

  void collapseAll() {
    _expandedSections.updateAll((key, value) => false);
    _highlightedSections.clear();
    notifyListeners();
  }

  bool allExpanded() {
    return _topLevel.keys.every((key) => _expandedSections[key] ?? false);
  }

  bool allCollapsed() {
    return _expandedSections.values.every((expanded) => !expanded);
  }
}
