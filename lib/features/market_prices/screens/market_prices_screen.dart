import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalSpacing = screenHeight * 0.01;
    final double searchHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('market_prices_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
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
            padding: EdgeInsets.fromLTRB(horizontalPadding, verticalSpacing * 2, horizontalPadding, verticalSpacing),
            child: SizedBox(
              height: searchHeight,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: _tr('market_search_hint'),
                  prefixIcon: Icon(Icons.search, size: searchHeight * 0.5),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic, size: searchHeight * 0.5),
                    onPressed: _startVoiceSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2, vertical: verticalSpacing),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, verticalSpacing),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedMarket,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2, vertical: verticalSpacing),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              items: _marketList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: screenWidth * 0.04)),
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _filteredMarketData.length,
                itemBuilder: (context, index) {
                  final marketData = _filteredMarketData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: verticalSpacing),
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
