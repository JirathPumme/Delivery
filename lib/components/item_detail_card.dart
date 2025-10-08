//กรอกรายละเอียดสินค้า
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemDetailCard extends StatefulWidget {
  final int itemNumber;

  const ItemDetailCard({super.key, required this.itemNumber});

  @override
  State<ItemDetailCard> createState() => _ItemDetailCardState();
}

class _ItemDetailCardState extends State<ItemDetailCard> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // เลขจํานวน , ปุ่มกล้องจ้า
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รายการที่ ${widget.itemNumber}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: _pickImage,
              ),
            ],
          ),
          const SizedBox(height: 8),
          //ช่องกรอกรายละเอียด
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'กรอกรายละเอียดสินค้าที่นี่',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          //แสดงรูปภาพที่เลือก
          if (_image != null)
            Center(
              child: Image.file(
                _image!,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}