//เตรียมOrder ของฝั่ง User Sender
// ยังไม่เรียบร้อย มีบัค Map อยู๋
import 'package:delivery/pages/profile_user.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar.dart';
import 'package:delivery/components/backbutton.dart';
import 'package:delivery/components/address_input_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery/pages/map_picker_screen.dart';
import 'package:delivery/components/quantity_selector.dart';
import 'package:delivery/components/item_detail_card.dart';

class ReadyDelivery extends StatefulWidget {
  const ReadyDelivery({super.key});

  @override
  State<ReadyDelivery> createState() => _ReadyDeliveryState();
}

class _ReadyDeliveryState extends State<ReadyDelivery> {
  int _quantity = 0;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  final TextEditingController _pickupController = TextEditingController(text: 'บ้านเลขที่ XX ซอย yy');
  final TextEditingController _dropoffController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }
  // ------------------------------------

  Future<void> _pickLocationFromMap(bool isDropoff) async {
    final LatLng? selectedPosition = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (selectedPosition != null) {
      final newAddress = 'Lat: ${selectedPosition.latitude.toStringAsFixed(4)}, Lng: ${selectedPosition.longitude.toStringAsFixed(4)}';
      
      setState(() {
        if (isDropoff) {
          _dropoffController.text = newAddress;
        } else {
          _pickupController.text = newAddress;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.black, size: 40),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            
            AddressInputCard(
              pickupController: _pickupController,
              dropoffController: _dropoffController,
              onPickupMapTap: () => _pickLocationFromMap(false),
              onDropoffMapTap: () => _pickLocationFromMap(true),
            ),
            const SizedBox(height: 20),

            QuantitySelector(
              quantity: _quantity,
              onIncrement: _incrementQuantity,
              onDecrement: _decrementQuantity,
            ),
            const SizedBox(height: 20),

            //ช่องกรอกรายละเอียดสินค้า
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'กรอกรายละเอียดสินค้า',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            ListView.builder(
              itemCount: _quantity,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ItemDetailCard(
                  itemNumber: index + 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}