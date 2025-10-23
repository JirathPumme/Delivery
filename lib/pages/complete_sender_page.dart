import 'package:delivery/pages/profile_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CompleteSenderPage extends StatefulWidget {
  // TODO: รับ deliveryId หรือข้อมูลอื่นๆ ที่จำเป็นมาแสดงผล
  //final String deliveryId;
  // TODO: รับ parameter เพื่อบอกให้แสดง Pop-up หรือไม่
  final bool showConfirmationPopup;

  const CompleteSenderPage({
    super.key,
    // required this.deliveryId,
    this.showConfirmationPopup = false, // ค่า default คือ ไม่แสดง
  });

  @override
  State<CompleteSenderPage> createState() => _CompleteSenderPageState();
}

class _CompleteSenderPageState extends State<CompleteSenderPage> {
  // --- ส่วนของข้อความ Pop-up ---
  bool _showConfirmationMessage = false;

 @override
void initState() {
  super.initState();
  // เช็คค่าที่ส่งมาก่อน ถ้าเป็น true ค่อยแสดง Pop-up
  if (widget.showConfirmationPopup) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerConfirmationMessage(); // เรียกฟังก์ชันแสดง Pop-up
     });
  }
}

  // --- ฟังก์ชันแสดง Pop-up ---
  void _triggerConfirmationMessage() {
    if (mounted) { // ตรวจสอบว่า Widget ยังอยู่บนหน้าจอ
      setState(() {
        _showConfirmationMessage = true;
      });

      // ตั้งเวลาให้ข้อความหายไปหลังจาก 5 วินาที
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showConfirmationMessage = false;
          });
        }
      });
    }
  }
  // --- สิ้นสุดฟังก์ชัน Pop-up ---


  @override
  Widget build(BuildContext context) {
    // --- Mock Data (ข้อมูลจำลอง) ---
    final String imageUrl = '';
    final String productName = 'มังงะ';
    final String dropOffLocation = 'zz/zz';
    final String pickupLocation = 'xx/xx';
    // --- สิ้นสุด Mock Data ---

    return Scaffold(
      appBar: AppBar(
        //leading: const BackButton(),
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        automaticallyImplyLeading: false, // เอาปุ่ม back ออก
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 40),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileUser()),
                );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.yellowAccent[700],

      // *** ใช้ Stack เพื่อให้ Pop-up แสดงทับเนื้อหาได้ ***
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Container( // ข้อความ "รับสินค้าสำเร็จ" ด้านบนการ์ด
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      
                     ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.camera_alt, size: 30, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                       imageUrl,
                       height: 250,
                       fit: BoxFit.contain,
                       errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                       loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                     ),
                    const SizedBox(height: 20),
                    Align( // รายละเอียดสินค้า
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('สินค้า : $productName', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text('สถานที่ส่ง : $dropOffLocation', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text('สถานที่รับ : $pickupLocation', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton( // ปุ่มกลับหน้าหลัก
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 78, 230, 84),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('กลับไปหน้าหลัก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // --- สิ้นสุดเนื้อหาหลัก ---

          // --- ส่วนของข้อความ Pop-up ---
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: _showConfirmationMessage ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _showConfirmationMessage // เช็คก่อนสร้าง Widget
                  ? Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 31, 207, 37),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Text(
                        'รับสินค้าสำเร็จ', //  ข้อความ Pop-up
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox.shrink(),
              ),
            ),
          ),
          // --- สิ้นสุดPop-up ---
        ],
      ),
    );
  }
}