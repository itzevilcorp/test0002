import 'package:flutter/material.dart';

class PaymentGatewayScreen extends StatefulWidget {
  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(labelText: 'Expiry Date'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cvvController,
              decoration: InputDecoration(labelText: 'CVV'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Cardholder Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Do nothing for now, simulate order purchased
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Order Purchased'),
                      content: Text('Your order has been purchased.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
