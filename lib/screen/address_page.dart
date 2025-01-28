import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/address_provider.dart';
import 'package:provider/provider.dart'; // Import AddressProvider
import 'order_confirmation_page.dart'; // Your order confirmation page

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
  bool _isAddingNewAddress = false; // Track whether the user wants to add a new address

  @override
  void initState() {
    super.initState();
    // Load the saved address when the page is initialized
    _loadSavedAddress();
  }

  // Method to load the saved address
  void _loadSavedAddress() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.loadAddress();  // Load the saved address from SharedPreferences
  }

  // Method to delete the saved address
  void _deleteSavedAddress() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.clearAddress();  // Clear the saved address from SharedPreferences

    // Optionally, reset the form fields
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _pincodeController.clear();

    // Show confirmation that the address was deleted
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved address deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Delivery Address'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Section for saved address (if available)
              addressProvider.address != null
                  ? Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saved Address:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text('Name: ${addressProvider.address?.street ?? 'N/A'}'),
                            Text('Address: ${addressProvider.address?.city ?? 'N/A'}, ${addressProvider.address?.state ?? 'N/A'}, ${addressProvider.address?.zipCode ?? 'N/A'}, ${addressProvider.address?.country ?? 'N/A'}'),
                            Text('Phone: ${addressProvider.address?.street ?? 'N/A'}'), // For illustration. Replace with actual data.
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Autofill form fields with saved address
                                _nameController.text = addressProvider.address!.street;
                                _addressController.text = addressProvider.address!.city;
                                _phoneController.text = 'Saved Phone'; // Use saved phone if available
                                _pincodeController.text = addressProvider.address!.zipCode;
                              },
                              child: const Text('Use This Address for Next Order'),
                            ),
                            const Divider(),
                          ],
                        ),
                        
                        // Delete Button in the top-right corner
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                            onPressed: _deleteSavedAddress,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              // Toggle Button for Adding New Address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Address:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      _isAddingNewAddress ? Icons.remove_circle : Icons.add_circle,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAddingNewAddress = !_isAddingNewAddress;
                      });
                    },
                  ),
                ],
              ),
              
              // Add New Address Form (Visible only when _isAddingNewAddress is true)
              _isAddingNewAddress
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        
                        // Name Input
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Address Input
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Phone Number Input
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Pincode Input
                        TextFormField(
                          controller: _pincodeController,
                          decoration: const InputDecoration(
                            labelText: 'Pincode',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pincode';
                            } else if (value.length != 6) {
                              return 'Pincode must be 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    )
                  : const SizedBox(),

              // Proceed to Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submitAddress,
                  child: const Text(
                    'Proceed to Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle form submission
  void _submitAddress() {
    if (_formKey.currentState!.validate()) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);

      // Save the new address if it's valid
      final address = Address(
        street: _nameController.text,
        city: _addressController.text,
        state: 'State', // You can replace with actual fields
        zipCode: _pincodeController.text,
        country: 'Country',
      );

      addressProvider.saveAddress(address);

      // Proceed to the next page (Order Confirmation)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            cartItems: widget.cartItems,
            totalPrice: _calculateTotalPrice(),
          ),
        ),
      );
    }
  }

  // Calculate the total price of the items in the cart
  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in widget.cartItems) {
      totalPrice += item['price'] * item['quantity'];
    }
    return totalPrice;
  }
}
