import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/api/api_client.dart';
import 'package:royal/core/constants/api_url.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class ProfilePictureUploadWidget extends StatefulWidget {
  final String userId;
  final VoidCallback? onUploadSuccess;

  const ProfilePictureUploadWidget({
    Key? key,
    required this.userId,
    this.onUploadSuccess,
  }) : super(key: key);

  @override
  State<ProfilePictureUploadWidget> createState() =>
      _ProfilePictureUploadWidgetState();
}

class _ProfilePictureUploadWidgetState
    extends State<ProfilePictureUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  final authController = Get.find<UserAuthDetailsController>();
  XFile? _selectedImage;
  bool _isUploading = false;

  /// Upload image to Cloudinary
  // Future<Map<String, dynamic>?> uploadImageToCloudinary(
  //     String imageFilePath) async {
  //   try {
  //     final url = Uri.parse('https://api.cloudinary.com/v1_1/dung0euqm/upload');

  //     final request = http.MultipartRequest('POST', url)
  //       ..fields['upload_preset'] = 'davyking'
  //       ..files.add(await http.MultipartFile.fromPath('file', imageFilePath));

  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseData = await response.stream.toBytes();
  //       final responseString = String.fromCharCodes(responseData);
  //       final jsonMap = jsonDecode(responseString);
  //       final responseUrl = jsonMap['url'];
  //       final publicId = jsonMap['public_id'];
  //       return {"image": responseUrl, "public_id": publicId};
  //     }
  //     return null;
  //   } catch (error) {
  //     print('Cloudinary upload error: ${error.toString()}');
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>?> uploadImageToCloudinary(XFile imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dung0euqm/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'davyking';

      if (kIsWeb) {
        // 🌐 WEB → read file as bytes
        Uint8List imageBytes = await imageFile.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: imageFile.name,
          ),
        );
      } else {
        // 📱 MOBILE → use file path
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseBody);

        return {
          "image": jsonMap['secure_url'],
          "public_id": jsonMap['public_id'],
        };
      } else {
        print('Cloudinary error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Cloudinary upload failed: $e');
      return null;
    }
  }

  /// Send image data to backend API
  Future<bool> uploadProfilePictureToBackend(
      String imageUrl, String publicId) async {
    try {
      final apiClient = DioClient();

      final response = await apiClient.patch(
        '${ApiUrl.users}/${widget.userId}/profile-picture',
        data: {
          'user_id': widget.userId,
          'image_url': imageUrl,
          'public_id': publicId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print('Backend upload error: $e');
      return false;
    }
  }

  /// Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = XFile(pickedFile.path);
        });

        // Start upload process
        await _uploadImage();
      }
    } catch (e) {
      showSnackbar('Error', 'Failed to pick image: $e');
    }
  }

  /// Upload image process
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      showSnackbar('Error', 'No image selected');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Step 1: Upload to Cloudinary
      showSnackbar('Uploading', 'Uploading image to cloud...', isError: false);

      final cloudinaryResult = await uploadImageToCloudinary(_selectedImage!);

      if (cloudinaryResult == null) {
        showSnackbar('Error', 'Failed to upload image to Cloudinary');
        setState(() {
          _isUploading = false;
        });
        return;
      }

      final imageUrl = cloudinaryResult['image'] as String;
      final publicId = cloudinaryResult['public_id'] as String;

      // Step 2: Save to backend database
      showSnackbar('Saving', 'Saving profile picture...', isError: false);

      final backendSuccess =
          await uploadProfilePictureToBackend(imageUrl, publicId);

      if (backendSuccess) {
        // Update user in auth controller
        final currentUser = authController.user.value;
        if (currentUser != null) {
          currentUser.profilePictureUrl = imageUrl;
          authController.updateUser(currentUser);
        }

        showSnackbar('Success', 'Profile picture updated successfully!',
            isError: false);

        // Clear selected image
        setState(() {
          _selectedImage = null;
        });

        // Callback if provided
        widget.onUploadSuccess?.call();
      } else {
        showSnackbar('Error', 'Failed to save profile picture to database');
      }
    } catch (e) {
      showSnackbar('Error', 'Upload failed: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// Show image source selection dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text('Select where you want to upload the image from'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }

  Widget buildImage(XFile image) {
    if (kIsWeb) {
      // 🌐 Web
      return Image.network(
        image.path, // blob URL
        fit: BoxFit.cover,
        width: 30,
      );
    } else {
      // 📱 Mobile
      return Image.file(
        File(image.path),
        fit: BoxFit.cover,
        width: 30,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture Display
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
            ),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _selectedImage != null
                ?

                // Image.file(
                //     File(_selectedImage!.path),
                //     fit: BoxFit.cover,
                //     width: 30,
                //   )

                buildImage(_selectedImage!)
                : (authController.user.value?.profilePictureUrl != null &&
                        authController.user.value!.profilePictureUrl!.isNotEmpty
                    ? Image.network(
                        authController.user.value!.profilePictureUrl!,
                        fit: BoxFit.cover,
                        width: 30,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey[400],
                        ),
                      )),
          ),
        ),
        const SizedBox(height: 16),
        // Upload Button
        _isUploading
            ? const Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.camera_alt, size: 12),
                label: const Text('Upload Picture'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  backgroundColor: LightThemeColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
      ],
    );
  }
}
