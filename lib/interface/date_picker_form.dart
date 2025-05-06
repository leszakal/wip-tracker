import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatelessWidget {
  // https://docs.flutter.dev/get-started/fundamentals/state-management#using-callbacks
  final ValueChanged<DateTime> onDateSelected;
  final TextEditingController controller;
  final DateTime? initialDate;

  const DatePickerFormField({
    super.key,
    required this.onDateSelected,
    required this.controller,
    this.initialDate,
  });

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a start date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        final selection = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selection != null) {
          controller.text = DateFormat.yMd().format(selection).toString();
          onDateSelected(selection);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'MM/DD/YYYY',
            helperText: 'Enter a start date (MM/DD/YYYY)',
            labelText: 'Start Date',
            border: OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          //validator: _validateDate,
        ),
      ),
    );
  }
}
