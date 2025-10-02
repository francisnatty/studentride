import 'dart:convert';

class WalletTransaction {
  final String user;
  final int amount;
  final String reason;
  final String status;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  WalletTransaction({
    required this.user,
    required this.amount,
    required this.reason,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  // Factory method to create a WalletTransaction from JSON
  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      user: json['user'],
      amount: json['amount'],
      reason: json['reason'],
      status: json['status'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  // Method to convert WalletTransaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'amount': amount,
      'reason': reason,
      'status': status,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

// Model class for WalletResponse
class WalletResponse {
  final bool success;
  final List<WalletTransaction> data;

  WalletResponse({required this.success, required this.data});

  // Factory method to create a WalletResponse from JSON
  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'],
      data:
          (json['data'] as List)
              .map((item) => WalletTransaction.fromJson(item))
              .toList(),
    );
  }

  // Method to convert WalletResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
