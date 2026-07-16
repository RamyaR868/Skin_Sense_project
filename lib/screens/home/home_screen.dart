// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../widgets/stat_card.dart';
// import '../../services/ai_model.dart';
// import '../chat/chat_screen.dart'; // Navigation link
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final AiModelService _aiService = AiModelService();
//   File? _selectedImage;
//   String _result = "No scan performed yet";
//
//   // Add this at the top of your class
//   List<Map<String, dynamic>> _topResults = [];
//
//   // DYNAMIC STATS: These will now update in real-time
//   int _scanCount = 0;
//   int _alertCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Pre-load the model to keep inference snappy
//     Future.microtask(() => _aiService.loadModel());
//   }
//
//   Future<void> _pickAndScan() async {
//     final picker = ImagePicker();
//
//     // 1. SELECT IMAGE SOURCE (Gallery or Camera)
//     final ImageSource? source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Select Image Source",
//                 style: GoogleFonts.poppins(
//                     fontSize: 18, fontWeight: FontWeight.w600)),
//             const SizedBox(height: 10),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
//               title: const Text("Take a Photo"),
//               onTap: () => Navigator.pop(context, ImageSource.camera),
//             ),
//             ListTile(
//               leading:
//                   const Icon(Icons.photo_library, color: Colors.blueAccent),
//               title: const Text("Choose from Gallery"),
//               onTap: () => Navigator.pop(context, ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     // 2. PROCESS IMAGE AND UPDATE STATS
//     if (source != null) {
//       final pickedFile = await picker.pickImage(source: source);
//
//       if (pickedFile != null) {
//         File imageFile = File(pickedFile.path);
//         setState(() => _selectedImage = imageFile);
//
//         // Get the Top 2 list from your service
//         final results = await _aiService.getTopPredictions(imageFile);
//
//         setState(() {
//           _topResults = results; // Store the list here
//
//           if (_topResults.isNotEmpty) {
//             // We still set _result for your scan history/stats logic
//             _result =
//                 "${_topResults[0]['label']} (${_topResults[0]['confidence'].toStringAsFixed(1)}%)";
//             _scanCount++;
//             if (_topResults[0]['label'] != 'NONE') _alertCount++;
//           }
//         });
//
//         // 3. PASS THE LIST to the bottom sheet, NOT the string
//         _showResultSheet(_topResults);
//       }
//     }
//   }
//
//   // Change the parameter from (String prediction) to (List<Map<String, dynamic>> results)
//   void _showResultSheet(List<Map<String, dynamic>> results) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10))),
//             const SizedBox(height: 20),
//             Text("Analysis Result",
//                 style: GoogleFonts.poppins(
//                     fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//
//             // --- NEW TOP 2 BARS LOGIC ---
//             ...results.map((res) {
//               String label = res['label'].toString().toUpperCase();
//               double confidence = res['confidence'];
//
//               // Logic: Green for 'NONE', Blue/Red for potential issues
//               Color themeColor =
//                   label.contains("NONE") ? Colors.green : Colors.blueAccent;
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(label,
//                             style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 color: themeColor,
//                                 fontWeight: FontWeight.w600)),
//                         Text("${confidence.toStringAsFixed(1)}%",
//                             style: GoogleFonts.poppins(
//                                 fontSize: 16, fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: confidence / 100,
//                         minHeight: 10,
//                         backgroundColor: Colors.grey[200],
//                         color: themeColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//             // --- END OF BARS ---
//
//             const SizedBox(height: 10),
//             const Text(
//                 "Note: This is an AI assessment. Please consult a dermatologist for a professional diagnosis.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12, color: Colors.grey)),
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12))),
//                 onPressed: () => Navigator.pop(context),
//                 child:
//                     const Text("CLOSE", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart'; // Ensure this is imported
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../widgets/stat_card.dart';
// import '../chat/chat_screen.dart';

// class _HomeScreenState extends State<HomeScreen> {
//   File? _selectedImage;
//   String _result = "No scan yet";
//   int _scanCount = 0;
//   int _alertCount = 0;
//
//   // This stores our Top 2 results
//   List<Map<String, dynamic>> _topResults = [];
//   final AiModelService _aiService = AiModelService();
//
//   @override
//   void initState() {
//     super.initState();
//     _aiService.loadModel(); // 🧠 This "wakes up" the ResNet50 model
//   }
//
//   // --- UPDATED PICK IMAGE LOGIC ---
//   Future<void> _pickAndScan(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       // 1. OPEN THE CROPPER IMMEDIATELY
//       File? croppedFile = await _cropImage(pickedFile.path);
//
//       // 2. ONLY PROCEED IF CROPPED (User didn't hit back/cancel)
//       if (croppedFile != null) {
//         setState(() {
//           _selectedImage = croppedFile;
//         });
//
//         // 3. RUN AI ON THE SQUARE IMAGE
//         // Note: Assuming your service is named _aiService
//         final results = await _aiService.getTopPredictions(croppedFile);
//
//         setState(() {
//           _topResults = results;
//           if (_topResults.isNotEmpty) {
//             _result =
//                 "${_topResults[0]['label']} (${_topResults[0]['confidence'].toStringAsFixed(1)}%)";
//             _scanCount++;
//             if (_topResults[0]['label'].toString().toUpperCase() != 'NONE') {
//               _alertCount++;
//             }
//           }
//         });
//
//         // 4. SHOW THE UPDATED BOTTOM SHEET
//         _showResultSheet(_topResults);
//       }
//     }
//   }
//
//   // --- NEW CROPPER HELPER FUNCTION ---
//   Future<File?> _cropImage(String filePath) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: filePath,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square 1:1
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Center the Lesion',
//           toolbarColor: Colors.blueAccent,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.square,
//           lockAspectRatio: true, // Forces the user to keep it square
//         ),
//         IOSUiSettings(title: 'Center the Lesion'),
//       ],
//     );
//
//     if (croppedFile != null) {
//       return File(croppedFile.path);
//     }
//     return null;
//   }
//
//   void _showPickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading:
//                   const Icon(Icons.photo_library, color: Colors.blueAccent),
//               title: const Text('Photo Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickAndScan(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickAndScan(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- UPDATED RESULT SHEET (With Bars) ---
//   void _showResultSheet(List<Map<String, dynamic>> results) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10))),
//             const SizedBox(height: 20),
//             Text("Analysis Results",
//                 style: GoogleFonts.poppins(
//                     fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//
//             // Loop through Top 2 results
//             ...results.map((res) {
//               String label = res['label'].toString().toUpperCase();
//               double confidence = res['confidence'];
//               Color themeColor =
//                   label.contains("NONE") ? Colors.green : Colors.blueAccent;
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(label,
//                             style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: themeColor)),
//                         Text("${confidence.toStringAsFixed(1)}%",
//                             style: GoogleFonts.poppins(fontSize: 14)),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     LinearProgressIndicator(
//                       value: confidence / 100,
//                       backgroundColor: Colors.grey[200],
//                       color: themeColor,
//                       minHeight: 8,
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//
//             const SizedBox(height: 10),
//             const Text(
//                 "Note: This is an AI assessment. Please consult a dermatologist for a professional diagnosis.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12, color: Colors.grey)),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent),
//                 onPressed: () => Navigator.pop(context),
//                 child:
//                     const Text("CLOSE", style: TextStyle(color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
// // ... your build method and other widgets ...
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF),
//       // CHATBOT FEATURE: Floating Button
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ChatScreen()),
//           );
//         },
//         backgroundColor: Colors.blueAccent,
//         icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
//         label: const Text("Ask AI",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hello, User!",
//                           style: GoogleFonts.poppins(
//                               fontSize: 16, color: Colors.grey)),
//                       Text("Skin Health",
//                           style: GoogleFonts.poppins(
//                               fontSize: 28, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const CircleAvatar(
//                       radius: 25,
//                       backgroundColor: Colors.blueAccent,
//                       child: Icon(Icons.person, color: Colors.white)),
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               // DYNAMIC STATS ROW
//               Row(
//                 children: [
//                   Expanded(
//                       child: StatCard(
//                           title: "Scans",
//                           value: _scanCount.toString(),
//                           icon: Icons.history,
//                           color: Colors.blue)),
//                   const SizedBox(width: 15),
//                   Expanded(
//                       child: StatCard(
//                           title: "Alerts",
//                           value: _alertCount.toString(),
//                           icon: Icons.warning_amber,
//                           color: Colors.orange)),
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               // MAIN ACTION CARD
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Colors.blueAccent, Colors.blue]),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Column(
//                   children: [
//                     const Icon(Icons.qr_code_scanner,
//                         size: 60, color: Colors.white),
//                     const SizedBox(height: 15),
//                     Text("Check Your Skin",
//                         style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 5),
//                     const Text("Instant AI analysis for lesions",
//                         style: TextStyle(color: Colors.white70)),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _showPickerOptions,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 15),
//                       ),
//                       child: const Text("Start Scan",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/stat_card.dart';
import '../../services/ai_model.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AiModelService _aiService = AiModelService();
  File? _selectedImage;
  String _result = "No scan performed yet";
  List<Map<String, dynamic>> _topResults = [];
  int _scanCount = 0;
  int _alertCount = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _aiService.loadModel());
  }

  // --- UPDATED PICK AND SCAN (CROP REMOVED) ---
  Future<void> _pickAndScan() async {
    final picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Image Source",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Take a Photo"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text("Choose from Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() => _selectedImage = imageFile);

        final results = await _aiService.getTopPredictions(imageFile);

        setState(() {
          _topResults = results;
          if (_topResults.isNotEmpty) {
            _result =
                "${_topResults[0]['label']} (${_topResults[0]['confidence'].toStringAsFixed(1)}%)";
            _scanCount++;
            if (_topResults[0]['label'].toString().toUpperCase() != 'NONE') {
              _alertCount++;
            }
          }
        });
        _showResultSheet(_topResults);
      }
    }
  }

  void _showResultSheet(List<Map<String, dynamic>> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Analysis Result",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...results.map((res) {
              String label = res['label'].toString().toUpperCase();
              double confidence = res['confidence'];
              Color themeColor =
                  label.contains("NONE") ? Colors.green : Colors.blueAccent;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label,
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: themeColor,
                                fontWeight: FontWeight.w600)),
                        Text("${confidence.toStringAsFixed(1)}%",
                            style: GoogleFonts.poppins(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                          value: confidence / 100,
                          minHeight: 10,
                          backgroundColor: Colors.grey[200],
                          color: themeColor),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("CLOSE", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- THIS WAS MISSING: THE BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChatScreen())),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: const Text("Ask AI", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, User!",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
              Text("Skin Health",
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                      child: StatCard(
                          title: "Scans",
                          value: _scanCount.toString(),
                          icon: Icons.history,
                          color: Colors.blue)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: StatCard(
                          title: "Alerts",
                          value: _alertCount.toString(),
                          icon: Icons.warning_amber,
                          color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_selectedImage!,
                            height: 150, width: 150, fit: BoxFit.cover),
                      )
                    else
                      const Icon(Icons.qr_code_scanner,
                          size: 60, color: Colors.white),
                    const SizedBox(height: 15),
                    Text("Check Your Skin",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickAndScan, // Fixed reference
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent),
                      child: const Text("Start Scan"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
