import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/providers/free_book_pdf_provider.dart';

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
                  onTap: () async {
                    debugPrint("Notification Type received: '${noti.type}'");

                    // ១. កំណត់ថាអានរួច
                    notiProvider.markAsRead(noti.id);

                    // ២. បង្កើត Variable ដើម្បីឆែកមើល Type (ការពារករណី null)
                    final String notiType = noti.type ?? '';

                    // ៣. ឆែកលក្ខខណ្ឌឱ្យត្រូវនឹងអ្វីដែល API ផ្ញើមក (free_pdf)
                    if (notiType == 'promotion') {
                      // ទៅកាន់ទំព័រ Special Offers
                      context.read<BookProvider>().onOrderSuccess?.call(5);
                    } else if (notiType == 'free_pdf' ||
                        notiType == 'free_ebook' ||
                        notiType == 'pdf') {
                      // កន្លែងនេះសំខាន់៖ បន្ថែម notiType == 'free_pdf'

                      // Fetch ទិន្នន័យ PDF ទុកមុន
                      await context
                          .read<FreeBookPdfProvider>()
                          .fetchFreeBooks();

                      // ទៅកាន់ទំព័រ Book PDF Free
                      context.read<BookProvider>().onOrderSuccess?.call(4);
                    } else {
                      // ក្រៅពីនោះ ឱ្យទៅទំព័រ Books ធម្មតា
                      context.read<BookProvider>().onOrderSuccess?.call(1);
                    }

                    // ៤. បិទផ្ទាំង Notification
                    if (context.mounted) Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}
