class DogBreedPrediction {
  final String breedName;
  final double confidence;

  DogBreedPrediction({
    required this.breedName,
    required this.confidence,
  });

  /// Get formatted breed name (capitalize and replace underscores)
  String get formattedBreedName {
    return breedName
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get confidence as percentage
  double get confidencePercentage {
    return confidence * 100;
  }

  /// Get formatted confidence string
  String get formattedConfidence {
    return '${confidencePercentage.toStringAsFixed(1)}%';
  }

  @override
  String toString() {
    return 'DogBreedPrediction(breedName: $breedName, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DogBreedPrediction &&
        other.breedName == breedName &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return breedName.hashCode ^ confidence.hashCode;
  }
}
