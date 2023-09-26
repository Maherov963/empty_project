import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int? messageId;
  final DateTime? time;
  final String? userFullName;
  final int? userId;
  final MessageStatus? state;
  final String? audio;
  final String? image;
  final String? text;
  final int? duration;
  final int currentVal;
  final ReplyMessage? reply;

  const Message({
    this.audio,
    this.image,
    this.currentVal = 0,
    this.text,
    this.time,
    this.userFullName,
    this.userId,
    this.state,
    this.messageId,
    this.duration,
    this.reply,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userId: json['userId'],
      userFullName: json['userFullName'],
      time: DateTime.parse(json['time']),
      audio: json['audio'],
      image: json['image'],
      messageId: json['messageId'],
      text: json['text'],
      duration: json['duration'],
      reply:
          json['reply'] == null ? null : ReplyMessage.fromJson(json['reply']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userFullName': userFullName,
      'time': time?.toIso8601String(),
      'audio': audio,
      'messageId': messageId,
      'text': text,
      'image': image,
      'reply': reply?.toJson(),
      'duration': duration,
    };
  }

  Message copy() {
    return Message.fromJson(toJson());
  }

  @override
  List<Object?> get props => [messageId];
}

class ReplyMessage extends Equatable {
  final int? messageId;
  final String? userFullName;
  final int? userId;
  final String? text;
  final String? audio;
  final int? duration;
  final String? image;
  const ReplyMessage({
    this.text,
    this.userFullName,
    this.userId,
    this.messageId,
    this.image,
    this.audio,
    this.duration,
  });
  factory ReplyMessage.fromJson(Map<String, dynamic> json) {
    return ReplyMessage(
      userId: json['userId'],
      userFullName: json['userFullName'],
      messageId: json['messageId'],
      text: json['text'],
      image: json['image'],
      audio: json['audio'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userFullName': userFullName,
      'messageId': messageId,
      'image': image,
      'audio': audio,
      'text': text,
      'duration': duration,
    };
  }

  ReplyMessage copy() {
    return ReplyMessage.fromJson(toJson());
  }

  @override
  List<Object?> get props => [messageId];
}

enum MessageStatus {
  /// Message not sended to server.
  pending,

  /// Message sended to server.
  sended,

  /// Message delivered to user.
  delivered,

  /// Messaged read by user.
  read,

  ///sent the message has been failed
  failed;

  /// Return `true` if status is [MessageStatus.pending].
  bool get isPending => this == pending;
}
