import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dog_breed_classifier/models/dog_breed_prediction.dart';

class PredictionResultsWidget extends StatelessWidget {
  final List<DogBreedPrediction> predictions;

  const PredictionResultsWidget({
    super.key,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No predictions available'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top prediction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Top Prediction',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    predictions.first.formattedBreedName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    predictions.first.formattedConfidence,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    width: double.infinity,
                    lineHeight: 8,
                    percent: predictions.first.confidence,
                    backgroundColor: Colors.grey.shade300,
                    progressColor: Colors.green,
                    barRadius: const Radius.circular(4),
                    animation: true,
                    animationDuration: 1000,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // All predictions
            Text(
              'All Predictions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...predictions.asMap().entries.map((entry) {
              final index = entry.key;
              final prediction = entry.value;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.blue.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: index == 0 ? Colors.blue.shade200 : Colors.grey.shade300,
                    width: index == 0 ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank indicator
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _getRankColor(index),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Breed name
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.formattedBreedName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prediction.formattedConfidence,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Progress bar
                    Expanded(
                      flex: 2,
                      child: LinearPercentIndicator(
                        width: double.infinity,
                        lineHeight: 6,
                        percent: prediction.confidence,
                        backgroundColor: Colors.grey.shade300,
                        progressColor: _getRankColor(index),
                        barRadius: const Radius.circular(3),
                        animation: true,
                        animationDuration: 1000 + (index * 200),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.green; // Gold
      case 1:
        return Colors.orange; // Silver
      case 2:
        return Colors.brown; // Bronze
      default:
        return Colors.blue; // Default
    }
  }
}
