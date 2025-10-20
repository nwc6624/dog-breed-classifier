# 🐕 Flutter Dog Breed Classifier

A Flutter mobile application that uses TensorFlow Lite to classify dog breeds in real-time using the **Stanford Dogs Dataset**. The app can identify 120 different dog breeds from photos taken with your camera or selected from your gallery.

## 🎯 Features

- 📸 **Camera Integration**: Take photos directly with your device camera
- 🖼️ **Gallery Selection**: Choose images from your photo library
- 🤖 **Real-time AI Classification**: TensorFlow Lite inference on-device
- 🐕 **120 Dog Breeds**: Based on the Stanford Dogs Dataset
- 📱 **Cross-platform**: Works on Android and iOS
- ⚡ **Fast Performance**: Optimized with XNNPACK delegate
- 🎨 **Modern UI**: Beautiful Material Design interface

## 🧠 Dataset & Model

### Stanford Dogs Dataset
This project is built on the **Stanford Dogs Dataset**, which contains:
- **120 dog breed classes**
- **20,580 images** of dogs
- **High-quality annotations** with breed labels
- **Diverse breeds** from common to rare varieties

**Dataset Citation:**
```
Aditya Khosla, Nityananda Jayadevaprakash, Bangpeng Yao and Li Fei-Fei. 
Novel dataset for Fine-Grained Image Categorization. 
First Workshop on Fine-Grained Visual Categorization (FGVC), IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2011.
```

### Model Architecture
- **Base Model**: Convolutional Neural Network trained on Stanford Dogs Dataset
- **Input Size**: 350x350x3 (RGB images)
- **Output**: 120 breed classifications with confidence scores
- **Optimization**: Quantized TensorFlow Lite model for mobile deployment
- **Preprocessing**: Standardized normalization [-1, 1] for optimal performance

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / Xcode for mobile development
- Android device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/nwc6624/dog-breed-classifier.git
   cd dog-breed-classifier
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

Key packages used in this project:
- `tflite_flutter: ^0.11.0` - TensorFlow Lite integration
- `image_picker: ^1.0.4` - Camera and gallery access
- `image: ^4.1.7` - Image processing and manipulation
- `provider: ^6.1.1` - State management

## 📱 Usage

1. **Launch the app** on your mobile device
2. **Grant camera permissions** when prompted
3. **Take a photo** using the camera button or select from gallery
4. **View results** showing the top 5 breed predictions with confidence scores
5. **Try different dogs** to see the AI's classification accuracy

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point and UI
├── models/
│   ├── dog_breed_prediction.dart      # Prediction data model
│   └── model_info.dart               # Model metadata
├── services/
│   └── dog_breed_service.dart        # TensorFlow Lite inference service
└── ui/
    ├── screens/
    │   └── home_screen.dart          # Main app screen
    └── widgets/                      # Reusable UI components

assets/
└── models/
    ├── dog_breed_model.tflite       # TensorFlow Lite model file
    └── model_info.json              # Model configuration and class names
```

## 🔧 Technical Implementation

### Image Preprocessing
```dart
// Standardization normalization for optimal model performance
input[0][y][x][0] = (pixel.r - 127.5) / 127.5; // Red channel
input[0][y][x][1] = (pixel.g - 127.5) / 127.5; // Green channel
input[0][y][x][2] = (pixel.b - 127.5) / 127.5; // Blue channel
```

### TensorFlow Lite Integration
- **Model Loading**: Loads pre-trained model from assets
- **Inference**: Runs on-device for privacy and speed
- **Optimization**: Uses XNNPACK delegate for CPU acceleration
- **Output Processing**: Applies softmax for probability distribution

### Supported Breeds
The app can classify 120 dog breeds including:
- Golden Retriever, Labrador Retriever, German Shepherd
- Beagle, Bulldog, Poodle, Husky, Boxer
- And 112 more breeds from the Stanford dataset

## 🎯 Performance

- **Model Size**: Optimized for mobile deployment
- **Inference Time**: ~100-200ms on modern devices
- **Accuracy**: High accuracy on the Stanford Dogs test set
- **Memory Usage**: Efficient memory management for mobile devices

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Stanford Dogs Dataset** for providing the training data
- **TensorFlow Lite** team for mobile ML framework
- **Flutter** team for the cross-platform framework
- **Stanford Vision Lab** for the original dataset research

## 📚 References

- [Stanford Dogs Dataset](http://vision.stanford.edu/aditya86/ImageNetDogs/)
- [TensorFlow Lite Documentation](https://www.tensorflow.org/lite)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Fine-Grained Image Categorization Paper](https://arxiv.org/abs/1406.3202)

---

**Built with ❤️ using Flutter and TensorFlow Lite**