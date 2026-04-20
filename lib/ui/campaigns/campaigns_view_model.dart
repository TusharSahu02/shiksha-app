import 'package:flutter/material.dart';
import '../../data/models/campaign_history.dart';
import '../../services/history_service.dart';

class CampaignsViewModel extends ChangeNotifier {
  final searchController = TextEditingController();

  List<CampaignHistory> _campaigns = [];
  String _searchQuery = '';

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  CampaignsViewModel() {
    _load();
  }

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

  Future<void> _load() async {
    try {
      _campaigns = await HistoryService.fetchHistory();
    } catch (e) {
      debugPrint('[CampaignsVM] Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }

  Future<void> delete(String id) async {
    await HistoryService.delete(id);
    _campaigns.removeWhere((c) => c.id == id);
    notifyListeners();
  }

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
