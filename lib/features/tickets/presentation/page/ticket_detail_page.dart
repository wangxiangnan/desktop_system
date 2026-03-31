import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/setup_dependencies.dart';
import '../../../../data/models/ticket_model.dart';
import '../../../../data/repositories/ticket_repository.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketId;

  const TicketDetailPage({super.key, required this.ticketId});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  TicketModel? _ticket;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  Future<void> _loadTicket() async {
    try {
      final ticket = await getIt<TicketRepository>().getTicketById(
        widget.ticketId,
      );
      setState(() {
        _ticket = ticket;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(TicketStatus status) {
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

  String _getStatusText(TicketStatus status) {
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
    final dateFormat = DateFormat('MMMM dd, yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_ticket?.ticketNumber ?? 'Ticket Details'),
        actions: [
          if (_ticket != null)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                context.push('/tickets/${widget.ticketId}/print');
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _ticket == null
          ? const Center(child: Text('Ticket not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    _ticket!.status,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusText(_ticket!.status),
                                  style: TextStyle(
                                    color: _getStatusColor(_ticket!.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            'Passenger',
                            _ticket!.passengerName,
                            Icons.person,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Route', _ticket!.route, Icons.route),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            'Departure',
                            dateFormat.format(_ticket!.departureTime),
                            Icons.schedule,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            'Price',
                            '\$${_ticket!.price.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                          if (_ticket!.notes != null &&
                              _ticket!.notes!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              'Notes',
                              _ticket!.notes!,
                              Icons.note,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
