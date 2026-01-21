// home_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:krishi_rath/features/chatbot/screens/chatbot_screen.dart';
import 'package:krishi_rath/features/community/screens/community_forum_screen.dart';
import 'package:krishi_rath/features/crop_advisory/screens/crop_advisory_screen.dart';
import 'package:krishi_rath/features/home/widgets/feature_button.dart';
import 'package:krishi_rath/features/home/widgets/weather_card.dart';
import 'package:krishi_rath/features/market_prices/screens/market_prices_screen.dart';
import 'package:krishi_rath/features/pest_detection/screens/plant_scanner_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

// The actual Home Screen UI
class HomeScreen extends StatelessWidget {
  // Add a final variable to hold the location data
  final Position? position;

  // Update the constructor to accept the location data
  const HomeScreen({super.key, this.position});

  @override
  Widget build(BuildContext context) {
    // Helper to make calling the translate function shorter
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        // Use the translate function for the title
        title: Text(tr('welcome_title')),
        actions: [
          Chip(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.3),
            label: const Text('Online', style: TextStyle(color: Colors.white)),
            avatar: const Icon(Icons.wifi, color: Colors.white, size: 16),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, tr),
            const SizedBox(height: 16),
            // Pass the location data down to the WeatherCard widget
            WeatherCard(position: position),
            const SizedBox(height: 16),
            _buildFeatureGrid(context, tr),
            const SizedBox(height: 16),
            _buildYourFarmSection(context),
            const SizedBox(height: 80), // Space for the FAB
          ],
        ),
      ),
      // Add floating action button for chatbot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openChatbot(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(BuildContext context, String Function(String) tr) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.yellow,
              child: Icon(Icons.agriculture, size: 30, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '3 ${tr('home_active_plots')}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, String Function(String) tr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          FeatureButton(
            title: tr('home_crop_advisory'),
            icon: Icons.grass,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CropAdvisoryScreen()),
              );
            },
          ),
          FeatureButton(
            title: tr('home_pest_detection'),
            icon: Icons.bug_report,
            color: Colors.red,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlantScannerScreen()));
            },
          ),
          FeatureButton(
            title: tr('home_market_prices'),
            icon: Icons.store,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MarketPricesScreen()));
            },
          ),
          FeatureButton(
            title: tr('home_community'),
            icon: Icons.people,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunityForumScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYourFarmSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Farm',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Image.network(
            'https://images.unsplash.com/photo-1594495894542-a08dc9213158?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image, size: 50, color: Colors.grey),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Last updated: Today morning',
            ),
          ),
        ],
      ),
    );
  }

  void _openChatbot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatbotScreen()),
    );
  }
}