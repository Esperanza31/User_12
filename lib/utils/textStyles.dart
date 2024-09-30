import 'package:flutter/cupertino.dart';

class BookingConfirmationText extends StatelessWidget {
  final String label;
  final String value;
  final double size;

  const BookingConfirmationText({
    required this.label,
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * size),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
