import 'package:equatable/equatable.dart';

// ── Message Model ────────────────────────────────────────────────────────────
class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object?> get props => [text, isUser, timestamp];
}

// ── States ───────────────────────────────────────────────────────────────────
abstract class ChatState extends Equatable {
  final List<ChatMessage> messages;
  const ChatState(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatIdle extends ChatState {
  const ChatIdle(super.messages);
}

class ChatThinking extends ChatState {
  const ChatThinking(super.messages);
}
