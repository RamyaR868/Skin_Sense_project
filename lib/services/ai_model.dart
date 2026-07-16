// import 'dart:io';
// import 'dart:typed_data';
// import 'package:pytorch_lite/pytorch_lite.dart';
// import 'package:flutter/foundation.dart';
//
// class AiModelService {
//   ModelObjectDetection? _customModel;
//
//   ClassificationModel? _classifier;
//   bool _isLoaded = false;
//
// // Load the model from assets
//
//   Future<void> loadModel() async {
//     try {
//       print(
//           "🔍 AI Debug: Attempting to load model from assets/ai/resnet50_skin_cancer.pte...");
//
//       _classifier = await PytorchLite.loadClassificationModel(
//         "assets/ai/resnet50_model.pte",
//         224,
//         224,
//         3,
//         labelPath: "assets/ai/labels.txt",
//       );
//
//       _isLoaded = true;
//       print("✅ SUCCESS: PyTorch Model is loaded and ready!");
//     } catch (e) {
//       _isLoaded = false;
//       // THIS IS THE LINE YOU NEED:
//       print("❌ FATAL ERROR DURING LOAD: $e");
//
//       // If the error is long, this helps see the whole thing:
//       debugPrint("Detailed StackTrace: $e");
//     }
//   }
//
// // Run inference on a picked image
//
//   // Update this in your AiModelService.dart
//   Future<String> predictImage(File image) async {
//     if (!_isLoaded) return "Model not loaded";
//
//     try {
//       Uint8List imageBytes = await image.readAsBytes();
//       // --- NEW BRAIN SCAN CODE STARTS HERE ---
//       // This asks the model for the raw percentages instead of just the name
//       // List<dynamic>? scores = await _classifier!.getImagePredictionList(
//       //   imageBytes,
//       //   mean: [0.485, 0.456, 0.406],
//       //   std: [0.229, 0.224, 0.225],
//       // );
//       // Adding 'Probabilities' at the end of the method name
//       List<dynamic>? scores =
//           await _classifier!.getImagePredictionListProbabilities(
//         imageBytes,
//         mean: [0.485, 0.456, 0.406],
//         std: [0.229, 0.224, 0.225],
//       );
//
//       print("--- 🧠 AI BRAIN SCAN RESULTS ---");
//       if (scores != null && scores.length >= 3) {
//         print("Index 0 (BCC):      ${(scores[0] * 100).toStringAsFixed(2)}%");
//         print("Index 1 (Melanoma): ${(scores[1] * 100).toStringAsFixed(2)}%");
//         print("Index 2 (None):     ${(scores[2] * 100).toStringAsFixed(2)}%");
//       } else {
//         print("Could not retrieve scores. Scores was: $scores");
//       }
//       print("---------------------------------");
//       // --- END OF BRAIN SCAN CODE ---
//       String prediction = await _classifier!.getImagePrediction(
//         imageBytes,
//         // ResNet50 standard ImageNet normalization
//         mean: [0.485, 0.456, 0.406],
//         std: [0.229, 0.224, 0.225],
//       );
//
//       return prediction;
//     } catch (e) {
//       return "AI Error: $e";
//     }
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:pytorch_lite/pytorch_lite.dart';

class AiModelService {
  ClassificationModel? _classifier;
  bool _isLoaded = false;

  Future<void> loadModel() async {
    try {
      _classifier = await PytorchLite.loadClassificationModel(
        "assets/ai/skin_model_FINAL_CPU_ONLY.ptl", // Double check this filename!
        224, 224, 3,
        labelPath: "assets/ai/labels.txt",
      );
      _isLoaded = true;
      print("✅ AI Engine Online");
    } catch (e) {
      print("❌ Load Error: $e");
    }
  }

  // THE NEW TOP 2 LOGIC
  Future<List<Map<String, dynamic>>> getTopPredictions(File image) async {
    if (!_isLoaded || _classifier == null) return [];

    try {
      Uint8List imageBytes = await image.readAsBytes();
      // //--- NEW BRAIN SCAN CODE STARTS HERE ---
      // // This asks the model for the raw percentages instead of just the name
      // List<dynamic>? scores = await _classifier!.getImagePredictionList(
      //   imageBytes,
      //   mean: [0.485, 0.456, 0.406],
      //   std: [0.229, 0.224, 0.225],
      // );
      // //Adding 'Probabilities' at the end of the method name
      // List<dynamic>? scores =
      //     await _classifier!.getImagePredictionListProbabilities(
      //   imageBytes,
      //   mean: [0.485, 0.456, 0.406],
      //   std: [0.229, 0.224, 0.225],
      // );
      //
      // print("--- 🧠 AI BRAIN SCAN RESULTS ---");
      // if (scores != null && scores.length >= 3) {
      //   print("Index 0 (BCC):      ${(scores[0] * 100).toStringAsFixed(2)}%");
      //   print("Index 1 (Melanoma): ${(scores[1] * 100).toStringAsFixed(2)}%");
      //   print("Index 2 (None):     ${(scores[2] * 100).toStringAsFixed(2)}%");
      // } else {
      //   print("Could not retrieve scores. Scores was: $scores");
      // }
      // print("---------------------------------");
      // // --- END OF BRAIN SCAN CODE ---

      // Get all probabilities (0.0 to 1.0)
      List<dynamic>? scores =
          await _classifier!.getImagePredictionListProbabilities(
        imageBytes,
        mean: [0.485, 0.456, 0.406],
        std: [0.229, 0.224, 0.225],
      );

      if (scores == null || scores.isEmpty) return [];

      // MUST MATCH YOUR labels.txt ORDER EXACTLY
      List<String> labels = ['bcc', 'melanoma', 'none'];

      // Combine labels and scores
      List<Map<String, dynamic>> results = [];
      for (int i = 0; i < scores.length; i++) {
        results.add({
          'label': labels[i].toUpperCase(), // Makes it look cleaner
          'confidence': (scores[i] * 100)
        });
      }

      // Sort: Highest confidence first
      results.sort((a, b) => b['confidence'].compareTo(a['confidence']));

      // Return Top 2
      return results.take(2).toList();
    } catch (e) {
      print("❌ Inference Error: $e");
      return [];
    }
  }
}
