import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/address_provider.dart';
import 'package:flutter_application_1/screen/map.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'order_confirmation_page.dart';


class AddressPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const AddressPage({super.key, required this.cartItems});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  bool _isAddingNewAddress = false;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  void _loadSavedAddress() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.loadAddress();
  }

  void _deleteSavedAddress() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.clearAddress();
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _pincodeController.clear();
    setState(() => _selectedLocation = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved address deleted')),
    );
  }

  void _pickLocationOnMap() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (pickedLocation != null) {
      setState(() => _selectedLocation = pickedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (addressProvider.address != null) ...[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saved Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Name: ${addressProvider.address!.street}'),
                        Text('Address: ${addressProvider.address!.city}, ${addressProvider.address!.state}, ${addressProvider.address!.zipCode}, ${addressProvider.address!.country}'),
                        Text('Phone: ${_phoneController.text.isNotEmpty ? _phoneController.text : 'N/A'}'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _nameController.text = addressProvider.address!.street;
                                _addressController.text = addressProvider.address!.city;
                                _pincodeController.text = addressProvider.address!.zipCode;
                                setState(() => _isAddingNewAddress = true);
                              },
                              child: const Text('Use This Address'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: _deleteSavedAddress,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              SwitchListTile(
                title: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.bold)),
                value: _isAddingNewAddress,
                activeColor: Colors.orange,
                onChanged: (value) => setState(() => _isAddingNewAddress = value),
              ),

              if (_isAddingNewAddress) _buildAddressForm(),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickLocationOnMap,
                child: const Text('Pick Location on Map'),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: _submitAddress,
                  child: const Text('Proceed to Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      children: [
        _buildTextField(_nameController, 'Full Name', TextInputType.text),
        _buildTextField(_addressController, 'Address', TextInputType.streetAddress, maxLines: 3),
        _buildTextField(_phoneController, 'Phone Number', TextInputType.phone),
        _buildTextField(_pincodeController, 'Pincode', TextInputType.number),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType type, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: type,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (label == 'Phone Number' && value.length != 10) return 'Phone number must be 10 digits';
          if (label == 'Pincode' && value.length != 6) return 'Pincode must be 6 digits';
          return null;
        },
      ),
    );
  }

  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      final address = Address(
        street: _nameController.text,
        city: _addressController.text,
        state: 'State',
        zipCode: _pincodeController.text,
        country: 'Country',
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
      );
      addressProvider.saveAddress(address);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            cartItems: widget.cartItems,
            totalPrice: _calculateTotalPrice(widget),
          ),
        ),
      );
    }
  }
}
 double _calculateTotalPrice(dynamic widget) {
    return widget.cartItems.fold(0.0, (sum, item) => sum + item['price'] * item['quantity']);
  }

