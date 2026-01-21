import 'package:flutter/material.dart';
import 'package:krishi_rath/services/localization_service.dart';

class MarketPriceCard extends StatelessWidget {
  final String cropName;
  final String hindiCropName;
  final String marathiCropName;
  final String price;
  final double percentageChange;
  final String marketInfo;
  final IconData cropIcon;

  const MarketPriceCard({
    super.key,
    required this.cropName,
    required this.hindiCropName,
    required this.marathiCropName,
    required this.price,
    required this.percentageChange,
    required this.marketInfo,
    required this.cropIcon,
  });

  String _tr(String key) => localizationService.translate(key);

  String _getLocalizedCropName() {
    final currentLocale = localizationService.locale.languageCode;
    if (currentLocale == 'hi') return hindiCropName;
    if (currentLocale == 'mr') return marathiCropName;
    return cropName;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double padding = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.08;
    final double titleFontSize = screenWidth * 0.045;
    final double subtitleFontSize = screenWidth * 0.035;
    final double priceFontSize = screenWidth * 0.05;
    final double buttonFontSize = screenWidth * 0.035;
    final double spacing = screenHeight * 0.008;

    final isPositive = percentageChange >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: spacing),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: iconSize,
              backgroundColor: Colors.grey[200],
              child: Icon(cropIcon, color: Colors.black54, size: iconSize),
            ),
            SizedBox(width: padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLocalizedCropName(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                  ),
                  SizedBox(height: spacing),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: changeColor,
                        size: iconSize * 0.6,
                      ),
                      SizedBox(width: spacing / 2),
                      Text(
                        '${percentageChange.abs()}% ${_tr('market_prices_vs_yesterday')}',
                        style: TextStyle(
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing / 2),
                  Text(
                    marketInfo,
                    style: TextStyle(color: Colors.grey, fontSize: subtitleFontSize),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$price',
                  style: TextStyle(
                    fontSize: priceFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _tr('market_prices_per_quintal'),
                  style: TextStyle(color: Colors.grey, fontSize: subtitleFontSize),
                ),
                SizedBox(height: spacing),
                TextButton(
                  onPressed: () => _showPredictionDialog(context, _getLocalizedCropName(), price),
                  child: Text(
                    _tr('market_forecast_button'),
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPredictionDialog(BuildContext context, String cropName, String currentPrice) {
    final currentPriceDouble = double.tryParse(currentPrice) ?? 0.0;
    final predictedPriceValue = currentPriceDouble * 1.05;
    final priceChange = predictedPriceValue - currentPriceDouble;
    final isPredictedPositive = priceChange >= 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final chartHeight = screenWidth * 0.4;

        return AlertDialog(
          title: Text(_tr('market_prediction_title').replaceFirst('{crop}', cropName)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: chartHeight,
                width: double.infinity,
                child: _PricePredictionChart(isPositive: isPredictedPositive),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                _tr('market_predicted_price'),
                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
              ),
              Text(
                '₹${predictedPriceValue.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenWidth * 0.02),
              Text(
                _tr('market_prediction_note'),
                style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(_tr('market_close')),
              onPressed: () => Navigator.of(context).pop(),
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

    if (isPositive) {
      path.moveTo(0, size.height * 0.8);
      path.cubicTo(
        size.width * 0.25, size.height * 0.7,
        size.width * 0.5, size.height * 0.4,
        size.width, size.height * 0.1,
      );
    } else {
      path.moveTo(0, size.height * 0.2);
      path.cubicTo(
        size.width * 0.25, size.height * 0.3,
        size.width * 0.5, size.height * 0.6,
        size.width, size.height * 0.9,
      );
    }

    canvas.drawPath(path, paint);

    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
