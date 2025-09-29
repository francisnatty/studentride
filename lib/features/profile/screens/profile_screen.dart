// lib/features/profile/presentation/pages/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/notifier/auth_session.dart';
import '../../auth/screens/login.dart';
import '../sm/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError && !provider.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'Failed to load profile',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.fetchProfile(forceRefresh: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = provider.userModel;
          if (user == null) {
            return const Center(child: Text('No profile data available'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchProfile(forceRefresh: true),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, user),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildInfoCard(context, user, provider),
                      const SizedBox(height: 16),
                      if (provider.isDriver) ...[
                        _buildDriverStatsCard(context, user),
                        const SizedBox(height: 16),
                      ],
                      _buildMenuSection(context, provider),
                      const SizedBox(height: 16),
                      _buildAccountSection(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic user) {
    final avatarUrl = user.profile?.avatar;
    final isOnline = user.isOnline ?? false;

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                      child:
                          avatarUrl == null || avatarUrl.isEmpty
                              ? Text(
                                _getInitials(
                                  user.name ?? user.displayName ?? 'U',
                                ),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                              : null,
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                user.displayName ?? user.name ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.role?.toUpperCase() ?? 'USER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigate to edit profile
            // Navigator.pushNamed(context, '/edit-profile');
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    dynamic user,
    ProfileProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.person_outline,
            'Full Name',
            user.name ?? 'Not provided',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.email_outlined,
            'Email',
            user.email ?? 'Not provided',
            trailing:
                user.emailVerified == true
                    ? const Icon(Icons.verified, color: Colors.green, size: 20)
                    : const Text(
                      'Not verified',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.phone_outlined,
            'Phone',
            user.phone ?? 'Not provided',
            trailing:
                user.phoneVerified == true
                    ? const Icon(Icons.verified, color: Colors.green, size: 20)
                    : const Text(
                      'Not verified',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.toggle_on_outlined,
            'Account Status',
            user.isActive == true ? 'Active' : 'Inactive',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    user.isActive == true
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.isActive == true ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: user.isActive == true ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverStatsCard(BuildContext context, dynamic user) {
    final driverDetails = user.driverDetails;
    final isVerified = driverDetails?.isVerified ?? false;
    final rating = driverDetails?.rating ?? 0;
    final totalRides = driverDetails?.totalRides ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Driver Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.star_rounded,
                  'Rating',
                  rating.toString(),
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  Icons.local_taxi_rounded,
                  'Total Rides',
                  totalRides.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ProfileProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.history,
            'Ride History',
            onTap: () {
              // Navigate to ride history
            },
          ),
          const Divider(height: 1),
          if (provider.isDriver) ...[
            _buildMenuItem(
              Icons.directions_car,
              'My Vehicles',
              onTap: () {
                // Navigate to vehicles
              },
            ),
            const Divider(height: 1),
          ],
          _buildMenuItem(
            Icons.payment,
            'Payment Methods',
            onTap: () {
              // Navigate to payment methods
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.notifications_outlined,
            'Notifications',
            onTap: () {
              // Navigate to notifications settings
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.help_outline,
            'Help & Support',
            onTap: () {
              // Navigate to help
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.settings_outlined,
            'Settings',
            onTap: () {
              // Navigate to settings
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.logout,
            'Logout',
            textColor: Colors.red,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  context.read<ProfileProvider>().clearProfile();
                  await context.read<AuthSession>().logout();

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }
}
