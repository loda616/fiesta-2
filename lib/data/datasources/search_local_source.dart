
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalSource {
  final SharedPreferences _prefs;
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  SearchLocalSource(this._prefs);

  Future<void> addSearchQuery(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > _maxHistoryItems) {
        history.removeLast();
      }
      await _prefs.setStringList(_searchHistoryKey, history);
    }
  }

  List<String> getSearchHistory() {
    return _prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove(_searchHistoryKey);
  }
}