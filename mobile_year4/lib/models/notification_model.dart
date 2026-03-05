class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'promotion' ឬ 'free_pdf'
  final String? targetId; // ID របស់សៀវភៅសម្រាប់ចុចទៅមើល
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.targetId,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'promotion',
      targetId: json['target_id']?.toString(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
    );
  }
}