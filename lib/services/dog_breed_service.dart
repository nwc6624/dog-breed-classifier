import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:dog_breed_classifier/models/dog_breed_prediction.dart';
import 'package:dog_breed_classifier/models/model_info.dart';

class DogBreedService extends ChangeNotifier {
  Interpreter? _interpreter;
  ModelInfo? _modelInfo;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isModelLoaded => _interpreter != null;

  /// Initialize the TensorFlow Lite model
  Future<void> initializeModel() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load model info
      await _loadModelInfo();
      
      // Load TensorFlow Lite model
      await _loadTFLiteModel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load model information from JSON
  Future<void> _loadModelInfo() async {
    try {
      final String modelInfoJson = await rootBundle.loadString('assets/models/model_info.json');
      final Map<String, dynamic> modelInfoMap = json.decode(modelInfoJson);
      _modelInfo = ModelInfo.fromJson(modelInfoMap);
    } catch (e) {
      throw Exception('Failed to load model info: $e');
    }
  }

  /// Load TensorFlow Lite model
  Future<void> _loadTFLiteModel() async {
    try {
      final options = InterpreterOptions();
      
      // Enable XNNPACK delegate for better performance
      options.addDelegate(XNNPackDelegate());
      
      _interpreter = await Interpreter.fromAsset('assets/models/dog_breed_model.tflite', options: options);
      
      // Verify model input/output shapes
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      
      print('Model loaded successfully!');
      print('Input shape: $inputShape');
      print('Output shape: $outputShape');
    } catch (e) {
      throw Exception('Failed to load TensorFlow Lite model: $e');
    }
  }

  /// Preprocess image for model input
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize image to model input size (350x350)
    final resizedImage = img.copyResize(image, width: 350, height: 350);
    
    // Create 4D tensor with shape [1, 350, 350, 3]
    final input = List.generate(1, (batch) => 
      List.generate(350, (height) => 
        List.generate(350, (width) => 
          List.generate(3, (channel) => 0.0))));
    
    // Fill the tensor with normalized pixel values
    for (int y = 0; y < 350; y++) {
      for (int x = 0; x < 350; x++) {
        final pixel = resizedImage.getPixel(x, y);
        
        // Try standardization [-1, 1] which is common for many models
        input[0][y][x][0] = (pixel.r - 127.5) / 127.5; // Red channel
        input[0][y][x][1] = (pixel.g - 127.5) / 127.5; // Green channel
        input[0][y][x][2] = (pixel.b - 127.5) / 127.5; // Blue channel
        
        // Alternative: Simple normalization [0, 1] (comment out above to try)
        // input[0][y][x][0] = pixel.r / 255.0; // Red channel
        // input[0][y][x][1] = pixel.g / 255.0; // Green channel
        // input[0][y][x][2] = pixel.b / 255.0; // Blue channel
      }
    }
    
    return input;
  }

  /// Apply softmax to convert logits to probabilities
  List<double> _applySoftmax(List<double> logits) {
    // Find max for numerical stability
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    
    // Compute exponentials and sum
    final exponentials = logits.map((logit) => math.exp(logit - maxLogit)).toList();
    final sum = exponentials.reduce((a, b) => a + b);
    
    // Normalize to get probabilities
    return exponentials.map((exp) => exp / sum).toList();
  }

  /// Run inference on image file
  Future<List<DogBreedPrediction>> predictBreed(File imageFile) async {
    if (_interpreter == null || _modelInfo == null) {
      throw Exception('Model not initialized');
    }

    try {
      // Load and decode image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Preprocess image
      final inputData = _preprocessImage(image);
      
      // Prepare output tensor
      final output = List.filled(1 * 120, 0.0).reshape([1, 120]);
      
      // Run inference
      _interpreter!.run(inputData, output);
      
      // Get predictions
      final predictions = output[0] as List<double>;
      
      // Create prediction objects with class names
      final List<DogBreedPrediction> breedPredictions = [];
      
      for (int i = 0; i < predictions.length; i++) {
        breedPredictions.add(DogBreedPrediction(
          breedName: _modelInfo!.classNames[i],
          confidence: predictions[i],
        ));
      }
      
      // Sort by confidence (descending)
      breedPredictions.sort((a, b) => b.confidence.compareTo(a.confidence));
      
      return breedPredictions;
    } catch (e) {
      throw Exception('Prediction failed: $e');
    }
  }

  /// Run inference on image bytes
  Future<List<DogBreedPrediction>> predictBreedFromBytes(Uint8List imageBytes) async {
    if (_interpreter == null || _modelInfo == null) {
      throw Exception('Model not initialized');
    }

    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Preprocess image
      final inputData = _preprocessImage(image);
      
      // Prepare output tensor
      final output = List.filled(1 * 120, 0.0).reshape([1, 120]);
      
      // Run inference
      _interpreter!.run(inputData, output);
      
      // Get predictions
      final predictions = output[0] as List<double>;
      
      // Create prediction objects with class names
      final List<DogBreedPrediction> breedPredictions = [];
      
      for (int i = 0; i < predictions.length; i++) {
        breedPredictions.add(DogBreedPrediction(
          breedName: _modelInfo!.classNames[i],
          confidence: predictions[i],
        ));
      }
      
      // Sort by confidence (descending)
      breedPredictions.sort((a, b) => b.confidence.compareTo(a.confidence));
      
      return breedPredictions;
    } catch (e) {
      throw Exception('Prediction failed: $e');
    }
  }

  /// Get top N predictions
  List<DogBreedPrediction> getTopPredictions(List<DogBreedPrediction> predictions, int n) {
    return predictions.take(n).toList();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
