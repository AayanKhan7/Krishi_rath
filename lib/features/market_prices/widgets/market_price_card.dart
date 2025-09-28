import 'package:flutter/material.dart';
import 'package:krishi_rath/common/widgets/bilingual_text.dart';
import 'package:krishi_rath/services/localization_service.dart';

class MarketPriceCard extends StatelessWidget {
  final String cropName;
  final String hindiCropName;
  final String price;
  final double percentageChange;
  final String marketInfo;
  final IconData cropIcon;

  const MarketPriceCard({
    super.key,
    required this.cropName,
    required this.hindiCropName,
    required this.price,
    required this.percentageChange,
    required this.marketInfo,
    required this.cropIcon,
  });

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final isPositive = percentageChange >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(cropIcon, color: Colors.black54),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BilingualText(
                    englishText: cropName,
                    hindiText: hindiCropName,
                    englishStyle:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: changeColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${percentageChange.abs()}% ${tr('market_prices_vs_yesterday')}',
                        style: TextStyle(
                            color: changeColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    marketInfo,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$price',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  tr('market_prices_per_quintal'),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _showPredictionDialog(context, cropName, price),
                  child: const Text('1-Month Forecast'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPredictionDialog(BuildContext context, String cropName, String currentPrice) {
    // Dummy predicted price calculation
    final currentPriceDouble = double.tryParse(currentPrice) ?? 0.0;
    // Simulate a 5% price increase for demonstration
    final predictedPriceValue = currentPriceDouble * 1.05;
    final priceChange = predictedPriceValue - currentPriceDouble;
    final isPredictedPositive = priceChange >= 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forecast for $cropName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: _PricePredictionChart(isPositive: isPredictedPositive),
              ),
              const SizedBox(height: 20),
              const Text(
                'Predicted Price (30 days):',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                '₹${predictedPriceValue.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'This is a sample AI prediction. Market conditions may vary.',
                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _PricePredictionChart extends StatelessWidget {
  final bool isPositive;
  const _PricePredictionChart({required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: _LineChartPainter(isPositive: isPositive),
        size: Size.infinite,
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final bool isPositive;
  _LineChartPainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if(isPositive) {
      // Dummy path representing an upward trend.
      path.moveTo(0, size.height * 0.8);
      path.cubicTo(
        size.width * 0.25, size.height * 0.7,
        size.width * 0.5, size.height * 0.4,
        size.width, size.height * 0.1,
      );
    } else {
      // Dummy path representing a downward trend.
      path.moveTo(0, size.height * 0.2);
       path.cubicTo(
        size.width * 0.25, size.height * 0.3,
        size.width * 0.5, size.height * 0.6,
        size.width, size.height * 0.9,
      );
    }


    canvas.drawPath(path, paint);

    // Draw axes for context
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    // Y-axis
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);
    // X-axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
