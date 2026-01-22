import 'package:krishi_rath/features/diary/models/diary_entry_model.dart';

class DiaryEntryService {
  static final DiaryEntryService _instance = DiaryEntryService._internal();
  final List<DiaryEntry> _entries = [];
  final List<DiaryEntry> _savedEntries = [];

  factory DiaryEntryService() {
    return _instance;
  }

  DiaryEntryService._internal() {
    _initializeSampleEntries();
  }

  void _initializeSampleEntries() {
    _entries.addAll([
      DiaryEntry(
        id: '1',
        title: 'Wheat Sowing Day',
        content: 'Successfully sowed wheat seeds in field A. Weather conditions were optimal.',
        cropName: 'Wheat',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        weather: 'Sunny',
        soilMoisture: 65.0,
        tags: ['sowing', 'field-a', 'success'],
      ),
      DiaryEntry(
        id: '2',
        title: 'First Watering',
        content: 'Completed first watering cycle. Applied 50mm water through drip irrigation.',
        cropName: 'Wheat',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        weather: 'Cloudy',
        soilMoisture: 70.0,
        tags: ['irrigation', 'watering', 'drip'],
      ),
    ]);
  }

  // Create
  Future<DiaryEntry> createEntry(DiaryEntry entry) async {
    _entries.add(entry);
    return entry;
  }

  // Read
  Future<List<DiaryEntry>> getEntries() async {
    return _entries;
  }

  Future<List<DiaryEntry>> getEntriesByCrop(String cropName) async {
    return _entries.where((entry) => entry.cropName == cropName).toList();
  }

  Future<DiaryEntry?> getEntryById(String id) async {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<DiaryEntry>> getEntriesByDateRange(DateTime startDate, DateTime endDate) async {
    return _entries.where((entry) {
      return entry.createdAt.isAfter(startDate) && entry.createdAt.isBefore(endDate);
    }).toList();
  }

  // Update
  Future<bool> updateEntry(String id, DiaryEntry updatedEntry) async {
    try {
      final index = _entries.indexWhere((entry) => entry.id == id);
      if (index != -1) {
        _entries[index] = updatedEntry;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Delete
  Future<bool> deleteEntry(String id) async {
    try {
      _entries.removeWhere((entry) => entry.id == id);
      _savedEntries.removeWhere((entry) => entry.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save/Bookmark
  Future<bool> saveEntry(String entryId) async {
    try {
      final entry = await getEntryById(entryId);
      if (entry != null) {
        entry.isSaved = true;
        if (!_savedEntries.any((e) => e.id == entryId)) {
          _savedEntries.add(entry);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unsaveEntry(String entryId) async {
    try {
      final entry = await getEntryById(entryId);
      if (entry != null) {
        entry.isSaved = false;
        _savedEntries.removeWhere((e) => e.id == entryId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<DiaryEntry>> getSavedEntries() async {
    return _savedEntries;
  }

  Future<List<String>> getAvailableCrops() async {
    return _entries.map((entry) => entry.cropName).toSet().toList();
  }
}
