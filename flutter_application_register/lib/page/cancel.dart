import 'package:flutter/material.dart';


class CancelConsent extends StatefulWidget {
  const CancelConsent({super.key});

  @override
  State<CancelConsent> createState() => _CancelConsentState();
}

class _CancelConsentState extends State<CancelConsent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('This is Cancel Page',style: TextStyle(fontSize: 30),),
    );
  }
}