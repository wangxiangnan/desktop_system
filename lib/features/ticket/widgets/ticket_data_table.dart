import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';

class TicketDataTable extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket) onRowTap;

  const TicketDataTable({
    super.key,
    required this.tickets,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          AppColors.primary.withValues(alpha: 0.1),
        ),
        columns: const [
          DataColumn(
            label: Text(
              'Ticket #',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Passenger',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Route', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Departure',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: tickets.map((ticket) => _buildDataRow(ticket)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(Ticket ticket) {
    return DataRow(
      cells: [
        DataCell(Text(ticket.ticketNumber)),
        DataCell(Text(ticket.passengerName)),
        DataCell(Text(ticket.route)),
        DataCell(Text(_formatDateTime(ticket.departureTime))),
        DataCell(_StatusChipWidget(status: ticket.status)),
        DataCell(Text('\$${ticket.price.toStringAsFixed(2)}')),
      ],
      onSelectChanged: (_) => onRowTap(ticket),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusChipWidget extends StatelessWidget {
  final TicketStatus status;

  const _StatusChipWidget({required this.status});

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
