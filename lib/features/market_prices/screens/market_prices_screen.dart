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
  String _selectedMarket = 'All Markets';
  final List<String> _marketList = ['All Markets', 'Mandi', 'Market Yard', 'Bazaar'];

  // In a real app, this list would be generated from API data
  final List<Map<String, dynamic>> _allMarketData = [
    {
      'cropName': 'Rice',
      'hindiCropName': 'चावल',
      'price': '2650',
      'percentageChange': 2.7,
      'mandiName': 'Nashik APMC',
      'marketType': 'Market Yard',
      'timestamp': '2 hours ago',
      'cropIcon': Icons.grass,
    },
    {
      'cropName': 'Wheat',
      'hindiCropName': 'गेहूं',
      'price': '2150',
      'percentageChange': -2.3,
      'mandiName': 'Delhi Mandi',
      'marketType': 'Mandi',
      'timestamp': '1 hour ago',
      'cropIcon': Icons.grain,
    },
    {
      'cropName': 'Tomato',
      'hindiCropName': 'टमाटर',
      'price': '4500',
      'percentageChange': 18.4,
      'mandiName': 'Pune Market',
      'marketType': 'Market Yard',
      'timestamp': '30 min ago',
      'cropIcon': Icons.local_florist,
    },
    {
      'cropName': 'Wheat',
      'hindiCropName': 'गेहूं',
      'price': '2250',
      'percentageChange': 1.5,
      'mandiName': 'Punjab Mandi',
      'marketType': 'Mandi',
      'timestamp': '45 min ago',
      'cropIcon': Icons.grain,
    },
    {
      'cropName': 'Onion',
      'hindiCropName': 'प्याज',
      'price': '1800',
      'percentageChange': -5.0,
      'mandiName': 'Nashik APMC',
      'marketType': 'Market Yard',
      'timestamp': '1 hour ago',
      'cropIcon': Icons.spa,
    },
    {
      'cropName': 'Soybean',
      'hindiCropName': 'सोयाबीन',
      'price': '4200',
      'percentageChange': 3.1,
      'mandiName': 'Indore Mandi',
      'marketType': 'Mandi',
      'timestamp': '3 hours ago',
      'cropIcon': Icons.eco,
    },
    {
      'cropName': 'Cotton',
      'hindiCropName': 'कपास',
      'price': '7500',
      'percentageChange': -1.2,
      'mandiName': 'Nagpur Bazaar',
      'marketType': 'Bazaar',
      'timestamp': '5 hours ago',
      'cropIcon': Icons.ac_unit,
    },
     {
      'cropName': 'Sugarcane',
      'hindiCropName': 'गन्ना',
      'price': '350',
      'percentageChange': 0.5,
      'mandiName': 'Kolhapur Market',
      'marketType': 'Market Yard',
      'timestamp': '4 hours ago',
      'cropIcon': Icons.energy_savings_leaf,
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredMarketData = _allMarketData;
    _searchController.addListener(_filterMarkets);
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
      _filteredMarketData = _allMarketData.where((market) {
        final marketName = market['mandiName'].toString().toLowerCase();
        final cropName = market['cropName'].toString().toLowerCase();
        final marketType = market['marketType'].toString();

        // Filter by selected market type in dropdown
        final dropdownMatch =
            _selectedMarket == 'All Markets' || marketType == _selectedMarket;

        // Filter by search query (can be crop or market name)
        final searchMatch = query.isEmpty || marketName.contains(query) || cropName.contains(query);

        return dropdownMatch && searchMatch;
      }).toList();
    });
  }

  void _startVoiceSearch() {
    // In a real app, you would integrate a speech-to-text package here.
    // For now, we'll just show a confirmation message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search would be activated here.'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('market_prices_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               // In a real app, you would fetch fresh data here
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(tr('market_prices_live')),
              backgroundColor: Colors.red,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Crop or Mandi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _startVoiceSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedMarket,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              items: _marketList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMarket = newValue!;
                  _filterMarkets(); // Re-apply filters when dropdown changes
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredMarketData.length,
              itemBuilder: (context, index) {
                final marketData = _filteredMarketData[index];
                return MarketPriceCard(
                  cropName: marketData['cropName'],
                  hindiCropName: marketData['hindiCropName'],
                  price: marketData['price'],
                  percentageChange: marketData['percentageChange'],
                  marketInfo: "${marketData['mandiName']} • ${marketData['timestamp']}",
                  cropIcon: marketData['cropIcon'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

