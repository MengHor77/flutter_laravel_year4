import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import '../../../providers/user_provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProvider>();
    _nameController = TextEditingController(text: provider.userName);
    _emailController = TextEditingController(text: provider.userEmail);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if system/app is in dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      // Dynamic Background
      backgroundColor: AppColors.getBackground(isDark),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.accent,
                      backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmf4NlFls31qGMTqzjbaNgxmoNwClN9140-A&s',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildLabel("Full Name", isDark),
              _buildTextField(
                isDark: isDark,
                controller: _nameController,
                hint: "Enter your name",
                icon: Icons.person_outline,
                validator: (val) => val!.isEmpty ? "Name is required" : null,
              ),

              const SizedBox(height: 20),

              _buildLabel("Email Address", isDark),
              _buildTextField(
                isDark: isDark,
                controller: _emailController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? "Email is required" : null,
              ),

              const SizedBox(height: 20),

              _buildLabel("Current Password", isDark),
              _buildTextField(
                isDark: isDark,
                controller: _currentPasswordController,
                hint: "Enter current password to verify",
                icon: Icons.lock_open_outlined,
                isPassword: true,
                obscureText: _obscureCurrent,
                onToggleVisibility: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (val) => (val == null || val.isEmpty)
                    ? "Current password is required"
                    : null,
              ),

              const SizedBox(height: 20),

              _buildLabel("New Password", isDark),
              _buildTextField(
                isDark: isDark,
                controller: _newPasswordController,
                hint: "Enter at least 8 characters",
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscureNew,
                onToggleVisibility: () =>
                    setState(() => _obscureNew = !_obscureNew),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return "New password is required";
                  if (val.length < 8)
                    return "Password must be at least 8 characters";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel("Confirm New Password", isDark),
              _buildTextField(
                isDark: isDark,
                controller: _confirmPasswordController,
                hint: "Repeat new password",
                icon: Icons.check_circle_outline,
                isPassword: true,
                obscureText: _obscureConfirm,
                onToggleVisibility: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return "Please confirm your password";
                  if (val != _newPasswordController.text)
                    return "Passwords do not match";
                  return null;
                },
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final messenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            final provider = context.read<UserProvider>();

                            bool success = await provider.updateProfile(
                              name: _nameController.text,
                              email: _emailController.text,
                              currentPassword: _currentPasswordController.text,
                              newPassword: _newPasswordController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Profile Updated Successfully",
                                  ),
                                  backgroundColor: AppColors.getSuccess(isDark),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              navigator.pop();
                            } else {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Failed to update. Check current password.",
                                  ),
                                  backgroundColor: AppColors.getDanger(isDark),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SAVE CHANGES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // Dynamic Secondary Text
          color: AppColors.getTextSecondary(isDark),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required bool isDark,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        // Dynamic Card Background
        color: AppColors.getCardBg(isDark),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        // Dynamic Border for dark mode to help fields stand out
        border: Border.all(color: AppColors.getBorder(isDark), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        // Dynamic Input Text Color
        style: TextStyle(color: AppColors.getTextPrimary(isDark)),
        decoration: InputDecoration(
          hintText: hint,
          // Dynamic Hint Style
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
          prefixIcon: Icon(icon, color: AppColors.accent),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
