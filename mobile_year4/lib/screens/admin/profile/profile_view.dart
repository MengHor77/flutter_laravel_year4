import 'dart:convert';
import '../../../colors.dart';
import 'edit_profile_view.dart';
import '../../../api_config.dart';
import '../../auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// 1. IMPORT THE NEW FILE HERE

class ProfileVeiew extends StatefulWidget {
  final VoidCallback? openDrawer;

  const ProfileVeiew({super.key, this.openDrawer});

  @override
  State<ProfileVeiew> createState() => _ProfileVeiewState();
}

class _ProfileVeiewState extends State<ProfileVeiew> {
  bool _isLoading = true;
  Map<String, dynamic>? adminData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profile),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          adminData = result['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                ApiConfig.userToken = null;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: const Text(
                "LOGOUT",
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        title: const Text("Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: _handleLogout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // --- Header Section ---
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 40, top: 20),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 65,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          adminData?['name']?.toUpperCase() ?? "ADMIN",
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          adminData?['email'] ?? "admin@gmail.com",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- Settings Menu Section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ACCOUNT SETTINGS",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // 2. NAVIGATE TO EDIT PROFILE
                        _buildMenuItem(
                          Icons.person_outline,
                          "Edit Profile",
                          "Change your info",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileView(adminData: adminData),
                              ),
                            ).then(
                              (_) => _fetchProfile(),
                            ); // Refresh when returning
                          },
                        ),

                        // _buildMenuItem(Icons.lock_outline, "Security", "Update your admin password"),
                        _buildMenuItem(
                          Icons.notifications_none,
                          "Notifications",
                          "Manage order alerts",
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'need update code notication more!',
                                ),
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          Icons.info_outline,
                          "App Version",
                          "v1.0.4 (Beta)",
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'need update code app version more!',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        // --- Logout Button ---
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.danger,
                              elevation: 0,
                              side: const BorderSide(
                                color: AppColors.danger,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _handleLogout,
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text(
                              "LOGOUT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 3. UPDATED HELPER WITH ONTAP
  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap, // Apply the click action
      ),
    );
  }
}
