import 'package:equatable/equatable.dart';

enum TicketStatus { pending, processing, completed, cancelled }

class TicketModel extends Equatable {
  final String id;
  final String ticketNumber;
  final String passengerName;
  final String route;
  final DateTime departureTime;
  final TicketStatus status;
  final double price;
  final String? notes;
  final DateTime createdAt;

  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.passengerName,
    required this.route,
    required this.departureTime,
    required this.status,
    required this.price,
    this.notes,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      ticketNumber: json['ticket_number'] as String,
      passengerName: json['passenger_name'] as String,
      route: json['route'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.pending,
      ),
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'passenger_name': passengerName,
      'route': route,
      'departure_time': departureTime.toIso8601String(),
      'status': status.name,
      'price': price,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TicketModel copyWith({
    String? id,
    String? ticketNumber,
    String? passengerName,
    String? route,
    DateTime? departureTime,
    TicketStatus? status,
    double? price,
    String? notes,
    DateTime? createdAt,
  }) {
    return TicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      passengerName: passengerName ?? this.passengerName,
      route: route ?? this.route,
      departureTime: departureTime ?? this.departureTime,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    passengerName,
    route,
    departureTime,
    status,
    price,
    notes,
    createdAt,
  ];
}
