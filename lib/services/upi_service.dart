import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart' as upi;
import 'dart:math';

enum UpiPaymentStatus { SUCCESS, FAILURE, SUBMITTED }

class UpiService {
  static const double MAX_PAYMENT_LIMIT = 1000.0; // Limit to avoid exceeding transaction size

  static Future<bool> initiateUpiPayment({
    required BuildContext context,
    required double amount,
    required String upiId,
    required String receiverName,
  }) async {
    if (amount > MAX_PAYMENT_LIMIT) {
      double remainingAmount = amount;
      while (remainingAmount > 0) {
        double chunkAmount = remainingAmount > MAX_PAYMENT_LIMIT ? MAX_PAYMENT_LIMIT : remainingAmount;
        bool paymentSuccess = await _initiatePayment(context, chunkAmount, upiId, receiverName);
        if (!paymentSuccess) {
          return false;
        }
        remainingAmount -= chunkAmount;
      }
      return true;
    } else {
      return await _initiatePayment(context, amount, upiId, receiverName);
    }
  }

  static Future<bool> _initiatePayment(
    BuildContext context,
    double amount,
    String upiId,
    String receiverName,
  ) async {
    final upiPayPlugin = upi.UpiPay();
    final transactionRef = Random.secure().nextInt(1 << 32).toString();

    final selectedApp = await _selectUpiApp(context);
    if (selectedApp == null) {
      print('No app selected');
      return false;
    }

    try {
      final response = await upiPayPlugin.initiateTransaction(
        amount: amount.toString(),
        app: selectedApp,
        receiverName: receiverName,
        receiverUpiAddress: upiId,
        transactionRef: transactionRef,
        transactionNote: 'UPI Payment',
      );

      print('Transaction Response: ${response.rawResponse}'); // Log raw response

      if (response.status == UpiPaymentStatus.SUCCESS) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful: ${response.rawResponse}')),
        );
        return true;  // Payment was successful
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Failed: ${response.status}')),
        );
        print('Error: Payment failed with status ${response.status}'); // Log failure details
        return false;  // Payment failed
      }
    } catch (e) {
      print('Error during UPI transaction: $e'); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  static Future<upi.UpiApplication?> _selectUpiApp(BuildContext context) async {
    return await showDialog<upi.UpiApplication>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Google Pay'),
                onTap: () {
                  Navigator.pop(context, upi.UpiApplication.googlePay);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('PhonePe'),
                onTap: () {
                  Navigator.pop(context, upi.UpiApplication.phonePe);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Paytm'),
                onTap: () {
                  Navigator.pop(context, upi.UpiApplication.paytm);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Amazon Pay'),
                onTap: () {
                  Navigator.pop(context, upi.UpiApplication.amazonPay);
                },
              ),
             
               
              
            ],
          ),
        );
      },
    );
  }

  static Map<upi.UpiApplication, String> upiAppPackageNames = {
    upi.UpiApplication.googlePay: 'com.google.android.apps.nbu.paisa.user',
    upi.UpiApplication.phonePe: 'com.phonepe.app',
    upi.UpiApplication.paytm: 'net.one97.paytm',
    upi.UpiApplication.amazonPay: 'in.amazon.mShop.android.shopping',
    upi.UpiApplication.bhim: 'in.org.npci.upiapp',
    upi.UpiApplication.miPay: 'com.mipay.wallet',
    upi.UpiApplication.sbiPay: 'com.sbi.upi',
    upi.UpiApplication.axisPay: 'com.upi.axispay',
    upi.UpiApplication.bhimAllBank: 'com.infrasofttech.BHIM',
    upi.UpiApplication.bhimOrientalPay: 'com.oriental.bhim',
    upi.UpiApplication.bhimYesPay: 'com.yesbank',
  };
}

