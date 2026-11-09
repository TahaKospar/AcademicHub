import 'package:flutter/material.dart';

extension AcademicHubColorScheme on ColorScheme {
  Color adaptiveColor({required Color light, required Color dark}) {
    return brightness == Brightness.dark ? dark : light;
  }

  Color taskStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
      case 'reviewed':
        return brightness == Brightness.dark ? tertiary : Colors.green;
      case 'pending':
        return brightness == Brightness.dark ? secondary : Colors.amber;
      case 'required':
        return primary;
      case 'to do':
        return brightness == Brightness.dark ? primary : Colors.red;
      default:
        return brightness == Brightness.dark ? onSurfaceVariant : Colors.grey;
    }
  }
}
