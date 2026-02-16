import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart'; // Using your AppColors

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Center(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(
            Icons.contact_support,
            size: 80,
            color: AppColors.accent,
          ),
           SizedBox(height: 20),
           Text(
            'Contact Support:',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
           SizedBox(height: 10),
           Text(
            '012 345 678',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}