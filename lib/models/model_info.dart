class ModelInfo {
  final String modelName;
  final String version;
  final List<int> inputShape;
  final List<int> outputShape;
  final List<String> classNames;
  final Map<String, dynamic> preprocessing;
  final String description;

  ModelInfo({
    required this.modelName,
    required this.version,
    required this.inputShape,
    required this.outputShape,
    required this.classNames,
    required this.preprocessing,
    required this.description,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      modelName: json['model_name'] as String,
      version: json['version'] as String,
      inputShape: List<int>.from(json['input_shape'] as List),
      outputShape: List<int>.from(json['output_shape'] as List),
      classNames: List<String>.from(json['class_names'] as List),
      preprocessing: Map<String, dynamic>.from(json['preprocessing'] as Map),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_name': modelName,
      'version': version,
      'input_shape': inputShape,
      'output_shape': outputShape,
      'class_names': classNames,
      'preprocessing': preprocessing,
      'description': description,
    };
  }

  /// Get number of classes
  int get numClasses => classNames.length;

  /// Get input image size
  List<int> get inputImageSize {
    return [inputShape[1], inputShape[2]]; // [width, height]
  }

  @override
  String toString() {
    return 'ModelInfo(modelName: $modelName, version: $version, numClasses: $numClasses)';
  }
}
