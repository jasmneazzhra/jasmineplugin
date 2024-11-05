// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:photofilters/photofilters.dart';
// import 'package:image/image.dart' as img;
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:logging/logging.dart';

// class FilterScreen extends StatefulWidget {
//   final String imagePath;

//   const FilterScreen({Key? key, required this.imagePath}) : super(key: key);

//   @override
//   _FilterScreenState createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   img.Image? _image;
//   File? _filteredImage;
//   final List<Filter> _filters =
//       presetFiltersList; // Ensure this is defined in your package
//   final _logger = Logger('FilterScreen');

//   @override
//   void initState() {
//     super.initState();
//     _loadImage();
//   }

//   Future<void> _loadImage() async {
//     try {
//       final imageFile = File(widget.imagePath);
//       final image = img.decodeImage(await imageFile.readAsBytes());
//       if (image != null) {
//         setState(() {
//           _image = image;
//         });
//       }
//     } catch (e) {
//       _logger.severe("Error loading image: $e");
//     }
//   }

//   Future<void> _applyFilter(Filter filter) async {
//     if (_image == null) return;

//     try {
//       final filteredImage = filter.apply(_image!);
//       final tempDir = await getTemporaryDirectory();
//       final path = join(tempDir.path, 'filtered_${basename(widget.imagePath)}');
//       final filteredFile = File(path)
//         ..writeAsBytesSync(img.encodeJpg(filteredImage));

//       setState(() {
//         _filteredImage = filteredFile;
//       });
//     } catch (e) {
//       _logger.severe("Error applying filter: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Apply Filter'),
//       ),
//       body: Column(
//         children: [
//           if (_filteredImage != null)
//             Image.file(_filteredImage!)
//           else if (_image != null)
//             Image.file(File(widget.imagePath)),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 4.0,
//                 mainAxisSpacing: 4.0,
//               ),
//               itemCount: _filters.length,
//               itemBuilder: (context, index) {
//                 final filter = _filters[index];
//                 return GestureDetector(
//                   onTap: () => _applyFilter(filter),
//                   child: Column(
//                     children: [
//                       if (_image != null)
//                         _buildFilterThumbnail(filter)
//                       else
//                         const CircularProgressIndicator(),
//                       Text(filter.name),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterThumbnail(Filter filter) {
//     if (_image == null) return const SizedBox.shrink();

//     final thumbnail = filter.apply(_image!);
//     return Image.memory(
//       img.encodeJpg(thumbnail),
//       width: 50,
//       height: 50,
//       fit: BoxFit.cover,
//     );
//   }
// }
