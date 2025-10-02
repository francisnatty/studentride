// lib/sm/wallet_provider.dart
import 'package:flutter/material.dart';
import '../data/repo/wallet_repo.dart';
// import 'package:your_app/data/repositories/wallet_repository.dart';

class WalletProvider with ChangeNotifier {
  double _balance = 0.0;
  double _totalSpent = 0.0;
  List<WalletTransaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  double get balance => _balance;
  double get totalSpent => _totalSpent;
  List<WalletTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final WalletRepo _homeRepo = WalletRepoImpl();

  // Constructor - Fetch initial data
  WalletProvider() {
    fetchWalletBalance();
    fetchTransactions();
  }

  /// Fetch wallet balance from API
  Future<void> fetchWalletBalance() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await walletRepository.getBalance();

      // Simulated API call
      await Future.delayed(const Duration(seconds: 1));
      _balance = 45000.00; // Replace with actual balance from API

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch transaction history from API
  Future<void> fetchTransactions() async {
    try {
      // TODO: Replace with actual API call
      // final response = await walletRepository.getTransactions();

      // Simulated API call
      await Future.delayed(const Duration(seconds: 1));

      _transactions = [
        WalletTransaction(
          id: '1',
          type: 'debit',
          amount: 2500.00,
          description: 'Ride to Campus Gate',
          status: 'completed',
          createdAt:
              DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
        ),
        WalletTransaction(
          id: '2',
          type: 'credit',
          amount: 10000.00,
          description: 'Wallet Funding',
          status: 'completed',
          createdAt:
              DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
        ),
        WalletTransaction(
          id: '3',
          type: 'debit',
          amount: 1500.00,
          description: 'Ride to Lecture Hall',
          status: 'completed',
          createdAt:
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String(),
        ),
        WalletTransaction(
          id: '4',
          type: 'credit',
          amount: 5000.00,
          description: 'Wallet Funding',
          status: 'completed',
          createdAt:
              DateTime.now()
                  .subtract(const Duration(days: 3))
                  .toIso8601String(),
        ),
        WalletTransaction(
          id: '5',
          type: 'debit',
          amount: 3000.00,
          description: 'Ride to Hostel',
          status: 'pending',
          createdAt:
              DateTime.now()
                  .subtract(const Duration(hours: 5))
                  .toIso8601String(),
        ),
      ];

      // Calculate total spent
      _totalSpent = _transactions
          .where((t) => t.type == 'debit' && t.status == 'completed')
          .fold(0.0, (sum, t) => sum + t.amount);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fund wallet
  Future<void> fundWallet(double amount, String paymentMethod) async {
    try {
      // TODO: Replace with actual API call
      // final response = await walletRepository.fundWallet(amount, paymentMethod);

      // Simulated API call
      await Future.delayed(const Duration(seconds: 2));

      // Update balance
      _balance += amount;

      // Add transaction
      _transactions.insert(
        0,
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'credit',
          amount: amount,
          description: 'Wallet Funding via $paymentMethod',
          status: 'completed',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Withdraw funds
  Future<void> withdrawFunds(Map<String, dynamic> withdrawalData) async {
    try {
      // TODO: Replace with actual API call
      // final response = await walletRepository.withdrawFunds(withdrawalData);

      // Simulated API call
      await Future.delayed(const Duration(seconds: 2));

      final amount = withdrawalData['amount'] as double;

      // Update balance
      _balance -= amount;

      // Add transaction
      _transactions.insert(
        0,
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'debit',
          amount: amount,
          description: 'Withdrawal to ${withdrawalData['bank']}',
          status: 'pending',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Deduct amount from wallet (for ride payments)
  Future<void> deductForRide(double amount, String driverId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await walletRepository.deductForRide(amount, driverId);

      // Simulated API call
      await Future.delayed(const Duration(seconds: 1));

      // Update balance
      _balance -= amount;

      // Add transaction
      _transactions.insert(
        0,
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'debit',
          amount: amount,
          description: 'Ride Payment',
          status: 'completed',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      _totalSpent += amount;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

/// Wallet Transaction Model
class WalletTransaction {
  final String id;
  final String type; // 'credit' or 'debit'
  final double amount;
  final String description;
  final String status; // 'completed', 'pending', 'failed'
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] ?? json['_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
