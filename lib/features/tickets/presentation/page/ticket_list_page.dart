import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/setup_dependencies.dart';
import '../../../../data/repositories/ticket_repository.dart';
import '../bloc/ticket_bloc.dart';
import '../bloc/ticket_event.dart';
import '../bloc/ticket_state.dart';
import '../widgets/ticket_card.dart';

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
      appBar: AppBar(
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
      ),
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

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = state.tickets[index];
                      return TicketCard(
                        ticket: ticket,
                        onTap: () {
                          context.push('/tickets/${ticket.id}');
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
