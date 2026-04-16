import 'package:flutter/material.dart';
import '../../data/models/campaign_history.dart';

class CampaignsViewModel extends ChangeNotifier {
  final searchController = TextEditingController();

  // TODO: Replace with real data from backend
  final List<CampaignHistory> _campaigns = [];
  String _searchQuery = '';

  List<CampaignHistory> get campaigns {
    if (_searchQuery.isEmpty) return _campaigns;
    final q = _searchQuery.toLowerCase();
    return _campaigns.where((c) {
      return c.topic.toLowerCase().contains(q) ||
          c.country.toLowerCase().contains(q) ||
          c.language.toLowerCase().contains(q) ||
          c.type.label.toLowerCase().contains(q);
    }).toList();
  }

  int get totalCount => _campaigns.length;

  void onSearchChanged(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
