import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:studentride/core/widget/snackbar_helper.dart';
import '../notifier/auth_notifier.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();

  bool _canResend = false;
  int _resendTimeLeft = 60;
  Timer? _resendTimer;
  String _currentText = "";

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startResendTimer();

    Future.delayed(const Duration(milliseconds: 800), () {
      _pinFocusNode.requestFocus();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimeLeft = 60;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimeLeft > 0) {
          _resendTimeLeft--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOTP() async {
    if (_currentText.length != 6) {
      _errorController.add(ErrorAnimationType.shake);
      SnackBarHelper.showError(context, 'Please enter complete OTP');
      return;
    }

    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    await authNotifier.verifyOtp(
      context: context,
      email: widget.email,
      otp: _currentText,
    );

    if (!mounted) return;

    if (authNotifier.errorMessage == null) {
    } else {
      _errorController.add(ErrorAnimationType.shake);
      _pinController.clear();
      setState(() {
        _currentText = '';
      });
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await authNotifier.resendOtp(context: context, email: widget.email);

    if (!mounted) return;

    _startResendTimer();
    _pinController.clear();
    setState(() {
      _currentText = '';
    });
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length >= 4) {
      return '${phone.substring(0, phone.length - 4).replaceAll(RegExp(r'.'), '*')}${phone.substring(phone.length - 4)}';
    }
    return phone;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    _errorController.close();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: size.height),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const Icon(Icons.sms, color: Colors.white, size: 80),
                          const SizedBox(height: 20),
                          const Text(
                            'Verify Your Number',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Code sent to ${_formatPhoneNumber(widget.email)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Enter 6-digit OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _pinController,
                          focusNode: _pinFocusNode,
                          errorAnimationController: _errorController,
                          onChanged: (value) {
                            setState(() {
                              _currentText = value;
                            });
                          },
                          onCompleted: (_) => _verifyOTP(),
                          beforeTextPaste: (text) {
                            return text != null &&
                                text.length == 6 &&
                                RegExp(r'^\d+$').hasMatch(text);
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.blue,
                            activeColor: Colors.blue,
                          ),
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _verifyOTP,
                          child: const Text('Verify'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _canResend
                            ? TextButton(
                              onPressed: _resendOTP,
                              child: const Text('Resend OTP'),
                            )
                            : Text('Resend in $_resendTimeLeft s'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
