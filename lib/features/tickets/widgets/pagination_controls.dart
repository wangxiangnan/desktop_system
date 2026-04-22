import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ticket_bloc.dart';
import '../bloc/ticket_event.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1
                ? () =>
                      context.read<TicketBloc>().add(const TicketPageChanged(1))
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(currentPage - 1),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(currentPage + 1),
                  )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < totalPages
                ? () => context.read<TicketBloc>().add(
                    TicketPageChanged(totalPages),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
