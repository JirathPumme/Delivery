import 'package:flutter/material.dart';

class AddressInputCard extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropoffController;
  final VoidCallback onPickupMapTap;
  final VoidCallback onDropoffMapTap;

  const AddressInputCard({
    super.key,
    required this.pickupController,
    required this.dropoffController,
    required this.onPickupMapTap,
    required this.onDropoffMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          _buildAddressRow(
            icon: Icons.circle,
            iconColor: Colors.blue,
            controller: pickupController,
            hintText: 'บ้านเลขที่ XX ซอย yy',
            onMapTap: onPickupMapTap,
          ),
          const Divider(),
          _buildAddressRow(
            icon: Icons.location_on,
            iconColor: Colors.black,
            controller: dropoffController,
            hintText: 'จัดส่งไปที่ไหน',
            onMapTap: onDropoffMapTap,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow({
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onMapTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.map, color: Colors.black54),
          onPressed: onMapTap,
        ),
      ],
    );
  }
}