import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final TicketStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case TicketStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'Pending';
      case TicketStatus.processing:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'Processing';
      case TicketStatus.completed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Completed';
      case TicketStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
