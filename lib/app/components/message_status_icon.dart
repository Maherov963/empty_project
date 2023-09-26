import 'package:flutter/material.dart';

import '../../domain/models/messages/message.dart';

/// Show icon based on [Message.status]
class MessageStatusIcon extends StatelessWidget {
  const MessageStatusIcon({
    Key? key,
    required this.status,
    required this.color,
  }) : super(key: key);

  final MessageStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const padding = 2.0;
    // Size difference between done icon and access_time icon.
    const iconSizeDifference = 4.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: status.isPending
            ? padding + 2 // 2 -> iconSizeDifference / 2
            : padding,
      ),
      child: Icon(
        _getStatusIcon(status),
        size: status.isPending ? 18 - iconSizeDifference : 18,
        color: status == MessageStatus.read
            ? Theme.of(context).colorScheme.tertiary
            : color,
      ),
    );
  }

  /// Return appropriate icon for message status
  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.pending:
        return Icons.access_time;
      case MessageStatus.sended:
        return Icons.done;
      case MessageStatus.delivered:
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }
}
