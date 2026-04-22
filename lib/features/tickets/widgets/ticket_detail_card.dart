import 'package:desktop_system/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';

class TicketDetailCard extends StatelessWidget {
  final Ticket ticket;
  final Widget child;

  const TicketDetailCard({
    super.key,
    required this.ticket,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
