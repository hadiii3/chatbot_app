import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/chatbot/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatIdle(_initialMessages()));

  static List<ChatMessage> _initialMessages() => [
        ChatMessage(
          text:
              "Hi! I'm your Galala Uni Academic Assistant 🎓\nAsk me anything about your courses, registration, or academic policies!",
          isUser: false,
        ),
      ];

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(text: text, isUser: true);
    final updated = [...state.messages, userMsg];
    emit(ChatThinking(updated));

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final reply = _generateReply(text.toLowerCase());
    final botMsg = ChatMessage(text: reply, isUser: false);
    emit(ChatIdle([...updated, botMsg]));
  }

  String _generateReply(String input) {
    if (input.contains('gpa') || input.contains('grade')) {
      return "Your GPA is available on the Dashboard. The university uses a 4.0 scale. To improve your GPA, consider speaking with your academic advisor about course selection strategies.";
    }
    if (input.contains('course') ||
        input.contains('register') ||
        input.contains('enroll')) {
      return "Course registration opens at the beginning of each semester. Log in to the student portal and navigate to 'Registration'. For prerequisite waivers, contact your department coordinator.";
    }
    if (input.contains('credit')) {
      return "Credits are earned upon successful course completion. You need to complete all required credits for your major. Check the Dashboard for your current credits completed vs. required.";
    }
    if (input.contains('vehicle') ||
        input.contains('car') ||
        input.contains('parking')) {
      return "You can submit a vehicle access permit request through the Vehicle tab. Once submitted, Security will review your request within 3-5 business days.";
    }
    if (input.contains('scholarship') || input.contains('financial')) {
      return "For scholarship inquiries, please contact the Financial Aid office at financial.aid@gu.edu.eg or visit Building 5, Room 201. Application deadlines are announced at the start of each academic year.";
    }
    if (input.contains('graduation') || input.contains('graduate')) {
      return "Graduation requirements include completing all required credits for your major. Your progress is shown on the Dashboard. Apply for graduation through the Registrar's office one semester before your expected completion.";
    }
    if (input.contains('hello') ||
        input.contains('hi') ||
        input.contains('hey')) {
      return "Hello! How can I help you today? Feel free to ask about courses, credits, registration, or any academic matter.";
    }
    return "That's a great question! For specific details, I recommend contacting your academic advisor or visiting the Student Services office in Building A. Is there anything else I can help clarify?";
  }
}
