import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Shipping Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Shipping Address', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 32),
              const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber.withOpacity(0.05),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.money, color: Colors.amber),
                    SizedBox(width: 16),
                    Text('Cash on Delivery (COD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSubmitting = true);
                            bool success = await store.checkout(
                              _nameController.text,
                              _addressController.text,
                              _phoneController.text,
                            );
                            setState(() => _isSubmitting = false);
                            if (success) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  title: const Text('Order Placed Successfully!'),
                                  content: const Text('Thank you for shopping with Mohammed Dhair Perfumes. Your order is pending fulfillment.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text('OK', style: TextStyle(color: Colors.amber)),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.amber)
                      : const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}