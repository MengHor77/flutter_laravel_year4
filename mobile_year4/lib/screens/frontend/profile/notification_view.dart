import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';
// lib/screens/frontend/profile/notification_view.dart

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final notiProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.accent,
      ),
      body: notiProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notiProvider.notifications.isEmpty
          ? const Center(child: Text("No notifications yet"))
          : ListView.builder(
              itemCount: notiProvider.notifications.length,
              itemBuilder: (context, index) {
                final noti = notiProvider.notifications[index];
                return ListTile(
                  leading: Icon(
                    noti.type == 'promotion'
                        ? Icons.local_offer
                        : Icons.picture_as_pdf,
                    color: AppColors.accent,
                  ),
                  title: Text(
                    noti.title,
                    style: TextStyle(
                      fontWeight: noti.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      color: AppColors.getTextPrimary(isDark),
                    ),
                  ),
                  subtitle: Text(noti.message),
                  trailing: !noti.isRead
                      ? const CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.red,
                        )
                      : null,
                  onTap: () {
                    notiProvider.markAsRead(noti.id);
                    // បន្ថែម Logic បើកទៅកាន់សៀវភៅ ឬ Promotion នៅទីនេះ
                  },
                );
              },
            ),
    );
  }
}
