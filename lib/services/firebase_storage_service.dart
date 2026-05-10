import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<Map<String, dynamic>?> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return null;

    if (kIsWeb) {
      Uint8List webImage = await picked.readAsBytes();

      return {
        'webImage': webImage,
        'fileImage': null,
      };
    } else {
      File fileImage = File(picked.path);

      return {
        'webImage': null,
        'fileImage': fileImage,
      };
    }
  }

  static Future<String> uploadProductImage({
    File? file,
    Uint8List? webFile,
  }) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask;

    if (kIsWeb) {
      uploadTask = ref.putData(webFile!);
    } else {
      uploadTask = ref.putFile(file!);
    }

    await uploadTask;

    return await ref.getDownloadURL();
  }


}