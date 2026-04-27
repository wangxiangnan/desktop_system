import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/domain/repositories/ticket_repository.dart';
import 'package:desktop_system/domain/entities/ticket_entity.dart';
import '../bloc/ticket_bloc.dart';
import '../bloc/ticket_event.dart';
import '../bloc/ticket_state.dart';

class TicketListPage extends StatelessWidget {
  const TicketListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TicketBloc(getIt<TicketRepository>())
            ..add(const TicketLoadRequested()),
      child: const _TicketListView(),
    );
  }
}

class _TicketListView extends StatefulWidget {
  const _TicketListView();

  @override
  State<_TicketListView> createState() => _TicketListViewState();
}

class _TicketListViewState extends State<_TicketListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      /* appBar: AppBar(
        title: const Text('Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create ticket - coming soon')),
              );
            },
          ),
        ],
      ), */
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tickets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TicketBloc>().add(
                            const TicketSearchRequested(''),
                          );
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<TicketBloc>().add(TicketSearchRequested(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TicketBloc, TicketState>(
              builder: (context, state) {
                if (state is TicketLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TicketError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TicketBloc>().add(
                              const TicketLoadRequested(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TicketLoaded) {
                  if (state.tickets.isEmpty) {
                    return const Center(child: Text('No tickets found'));
                  }

                  return _buildDataTable(context, state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          BlocBuilder<TicketBloc, TicketState>(
            builder: (context, state) {
              if (state is TicketLoaded && state.totalPages > 1) {
                return _buildPagination(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, TicketLoaded state) {
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
        rows: state.tickets
            .map((ticket) => _buildDataRow(context, ticket))
            .toList(),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Ticket ticket) {
    return DataRow(
      cells: [
        DataCell(Text(ticket.ticketNumber)),
        DataCell(Text(ticket.passengerName)),
        DataCell(Text(ticket.route)),
        DataCell(Text(_formatDateTime(ticket.departureTime))),
        DataCell(_buildStatusChip(ticket.status)),
        DataCell(Text('\$${ticket.price.toStringAsFixed(2)}')),
      ],
      onSelectChanged: (_) {
        context.push('/tickets/${ticket.id}');
      },
    );
  }

  Widget _buildStatusChip(TicketStatus status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case TicketStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'Pending';
        break;
      case TicketStatus.processing:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'Processing';
        break;
      case TicketStatus.completed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Completed';
        break;
      case TicketStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'Cancelled';
        break;
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

  Widget _buildPagination(BuildContext context, TicketLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: state.currentPage > 1
                ? () =>
                      context.read<TicketBloc>().add(const TicketPageChanged(1))
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.currentPage > 1
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(state.currentPage - 1),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            'Page ${state.currentPage} of ${state.totalPages}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.currentPage < state.totalPages
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(state.currentPage + 1),
                  )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: state.currentPage < state.totalPages
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(state.totalPages),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
