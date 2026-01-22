import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/market_prices/widgets/market_price_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredMarketData = [];
  late String _selectedMarket;

  String _tr(String key) => localizationService.translate(key);

  final List<String> _marketListKeys = [
    'market_all_markets',
    'market_mandi',
    'market_market_yard',
    'market_bazaar',
  ];

  List<String> get _marketList => _marketListKeys.map((key) => _tr(key)).toList();

  final List<Map<String, dynamic>> _allMarketData = [
    // Your existing market data here...
  ];

  @override
  void initState() {
    super.initState();
    _selectedMarket = _tr('market_all_markets');
    _filteredMarketData = _getTranslatedMarketData();
    _searchController.addListener(_filterMarkets);
  }

  List<Map<String, dynamic>> _getTranslatedMarketData() {
    return _allMarketData.map((market) {
      return {...market, 'marketType': _tr(market['marketTypeKey'])};
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMarkets);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMarkets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMarketData = _getTranslatedMarketData().where((market) {
        final marketName = market['mandiName'].toString().toLowerCase();
        final cropName = market['cropName'].toString().toLowerCase();
        final marketType = market['marketType'].toString();

        final dropdownMatch =
            _selectedMarket == _tr('market_all_markets') || marketType == _selectedMarket;

        final searchMatch = query.isEmpty || marketName.contains(query) || cropName.contains(query);

        return dropdownMatch && searchMatch;
      }).toList();
    });
  }

  void _startVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search would be activated here.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('market_prices_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Chip(
              label: Text(_tr('market_prices_live')),
              backgroundColor: Colors.red,
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: SizedBox(
              height: 56.h,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: _tr('market_search_hint'),
                  prefixIcon: Icon(Icons.search, size: 28.sp),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic, size: 28.sp),
                    onPressed: _startVoiceSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedMarket,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              items: _marketList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 15.sp)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMarket = newValue!;
                  _filterMarkets();
                });
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _filteredMarketData.length,
                itemBuilder: (context, index) {
                  final marketData = _filteredMarketData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: MarketPriceCard(
                      cropName: marketData['cropName'],
                      hindiCropName: marketData['hindiCropName'],
                      marathiCropName: marketData['marathiCropName'],
                      price: marketData['price'],
                      percentageChange: marketData['percentageChange'],
                      marketInfo: "${marketData['mandiName']} • ${marketData['timestamp']}",
                      cropIcon: marketData['cropIcon'],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
