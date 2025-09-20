import 'package:flutter/material.dart';

class SosButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SosButton({super.key, required this.onPressed, this.isLoading = false});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> {


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenheight = screenSize.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: double.infinity,
          height: screenheight * 0.05,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.campaign_rounded, color: Colors.white, size: 35),
              SizedBox(width: 10),
              Text(
                'SOS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
