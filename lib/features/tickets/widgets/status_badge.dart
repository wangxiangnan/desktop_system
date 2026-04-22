import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final TicketStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _statusColor {
    switch (status) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.processing:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
      case TicketStatus.cancelled:
        return Colors.red;
    }
  }

  String get _statusText {
    switch (status) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.processing:
        return 'Processing';
      case TicketStatus.completed:
        return 'Completed';
      case TicketStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusText,
        style: TextStyle(color: _statusColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
