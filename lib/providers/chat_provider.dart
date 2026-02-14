import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({this.messages = const [], this.isLoading = false, this.error});

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    final welcomeMessage = ChatMessage(
      id: '0',
      content:
          "Hi! I'm Nero, your AI study companion. I'm here to help you stay organized, motivated, and on track with your studies. Ask me anything about your tasks, productivity tips, or just chat!",
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = state.copyWith(messages: [welcomeMessage]);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate AI response (mock for now)
      final aiResponse = _generateAIResponse(content.toLowerCase());

      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send message: ${e.toString()}',
      );
    }
  }

  String _generateAIResponse(String userMessage) {
    // Mock AI responses based on keywords
    if (userMessage.contains('task') || userMessage.contains('todo')) {
      return "I can help you manage your tasks! You can create new tasks in the Planner tab. Would you like some tips on prioritizing your work?";
    } else if (userMessage.contains('focus') ||
        userMessage.contains('pomodoro')) {
      return "The Pomodoro technique is great for staying focused! Try working in 25-minute sessions with 5-minute breaks. Check out the Focus tab to start a timer.";
    } else if (userMessage.contains('stress') ||
        userMessage.contains('anxious')) {
      return "It's normal to feel stressed sometimes. Try taking a short break, doing some deep breathing, or tracking your mood in the Insights tab. Remember, you're doing great!";
    } else if (userMessage.contains('mood') || userMessage.contains('feel')) {
      return "Tracking your mood can help you understand patterns in your productivity. Head to the Insights tab to log how you're feeling today!";
    } else if (userMessage.contains('study') || userMessage.contains('learn')) {
      return "Here are some study tips: Break large topics into smaller chunks, use active recall, teach concepts to others, and take regular breaks. What subject are you working on?";
    } else if (userMessage.contains('motivat')) {
      return "You've got this! Remember why you started. Small progress is still progress. Check your study streak in Insights to see how far you've come!";
    } else if (userMessage.contains('help')) {
      return "I can assist with:\n• Task management and planning\n• Study techniques and tips\n• Focus and productivity strategies\n• Mood tracking insights\n• Motivation and support\n\nWhat would you like to know more about?";
    } else if (userMessage.contains('hello') ||
        userMessage.contains('hi') ||
        userMessage.contains('hey')) {
      return "Hello! How can I help you with your studies today? 😊";
    } else if (userMessage.contains('thank')) {
      return "You're welcome! I'm always here to help. Keep up the great work! 🌟";
    } else {
      return "That's an interesting question! While I'm still learning, I'm here to help you with your studies. Try asking me about tasks, focus techniques, or study tips!";
    }
  }

  void clearMessages() {
    _loadInitialMessages();
  }

  void deleteMessage(String messageId) {
    state = state.copyWith(
      messages: state.messages.where((m) => m.id != messageId).toList(),
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
