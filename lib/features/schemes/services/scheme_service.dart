import 'package:krishi_rath/features/schemes/models/scheme_model.dart';

class SchemeService {
  static final SchemeService _instance = SchemeService._internal();
  final List<Scheme> _schemes = [];
  final List<Scheme> _savedSchemes = [];

  factory SchemeService() {
    return _instance;
  }

  SchemeService._internal() {
    _initializeSampleSchemes();
  }

  void _initializeSampleSchemes() {
    _schemes.addAll([
      Scheme(
        id: '1',
        name: 'PM-KISAN',
        description: 'Pradhan Mantri Kisan Samman Nidhi - Direct income support to farmers',
        provider: 'Government of India',
        category: 'Income Support',
        eligibility: 'All farmers irrespective of holding size',
        benefits: '₹6000 per year in 3 installments',
        deadline: '31-12-2024',
      ),
      Scheme(
        id: '2',
        name: 'Soil Health Card Scheme',
        description: 'Promotes soil testing and nutrient management',
        provider: 'Ministry of Agriculture',
        category: 'Soil Management',
        eligibility: 'All farmers with land holdings',
        benefits: 'Free soil testing and recommendations',
        deadline: 'Ongoing',
      ),
      Scheme(
        id: '3',
        name: 'Pradhan Mantri Fasal Bima Yojana',
        description: 'Crop insurance scheme for farmers',
        provider: 'Government of India',
        category: 'Insurance',
        eligibility: 'All farmers including share croppers',
        benefits: 'Crop loss compensation up to ₹1,50,000',
        deadline: 'Season specific',
      ),
    ]);
  }

  // Read
  Future<List<Scheme>> getSchemes() async {
    return _schemes;
  }

  Future<List<Scheme>> getSchemesByCategory(String category) async {
    return _schemes.where((scheme) => scheme.category == category).toList();
  }

  Future<Scheme?> getSchemeById(String id) async {
    try {
      return _schemes.firstWhere((scheme) => scheme.id == id);
    } catch (e) {
      return null;
    }
  }

  // Save/Bookmark
  Future<bool> saveScheme(String schemeId) async {
    try {
      final scheme = await getSchemeById(schemeId);
      if (scheme != null) {
        scheme.isSaved = true;
        if (!_savedSchemes.any((s) => s.id == schemeId)) {
          _savedSchemes.add(scheme);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unsaveScheme(String schemeId) async {
    try {
      final scheme = await getSchemeById(schemeId);
      if (scheme != null) {
        scheme.isSaved = false;
        _savedSchemes.removeWhere((s) => s.id == schemeId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Scheme>> getSavedSchemes() async {
    return _savedSchemes;
  }

  Future<List<String>> getAvailableCategories() async {
    return _schemes.map((scheme) => scheme.category).toSet().toList();
  }
}
