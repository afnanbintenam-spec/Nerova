import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        title: Text(
          'Nero AI',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.electric,
          labelColor: AppColors.electric,
          unselectedLabelColor: AppColors.navy.withValues(alpha: 0.5),
          labelStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'Summarizer'),
            Tab(text: 'Quiz'),
            Tab(text: 'Planner'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ChatTab(),
          _SummarizerTab(),
          _QuizTab(),
          _PlannerTab(),
        ],
      ),
    );
  }
}

// ==================== CHAT TAB ====================
class _ChatTab extends StatefulWidget {
  const _ChatTab();

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'message':
          'Hi! I\'m Nero, your AI study assistant. I can help you with explanations, summaries, quizzes, and study planning. What would you like to work on today?',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'message': _messageController.text});
      _messageController.clear();

      // Simulate AI response
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'role': 'assistant',
              'message':
                  'That\'s a great question! Let me help you with that. I can provide more detailed explanations if you need them.',
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message['role'] == 'user';

              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.electric : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    message['message']!,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: isUser ? Colors.white : AppColors.ink,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask Nero anything...',
                    hintStyle: GoogleFonts.nunito(
                      color: AppColors.navy.withValues(alpha: 0.4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.navy.withValues(alpha: 0.2),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.electric,
                onPressed: _sendMessage,
                child: const Icon(Icons.send_rounded, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== SUMMARIZER TAB ====================
class _SummarizerTab extends StatefulWidget {
  const _SummarizerTab();

  @override
  State<_SummarizerTab> createState() => _SummarizerTabState();
}

class _SummarizerTabState extends State<_SummarizerTab> {
  final TextEditingController _textController = TextEditingController();
  String? _summary;
  bool _isLoading = false;

  void _generateSummary() {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to summarize')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _summary =
              'This text discusses ${_textController.text.split(' ').length <= 50 ? 'the provided content' : 'several key concepts'}. Key points include: 1) Main concept introduction, 2) Supporting details and examples, 3) Practical applications and implications. The material emphasizes the importance of understanding fundamentals before moving to advanced topics.';
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_rounded,
                    color: AppColors.electric,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Summarizer',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Paste text and let AI create a concise summary',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Paste text to summarize...',
                  hintStyle: GoogleFonts.nunito(
                    color: AppColors.navy.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.navy.withValues(alpha: 0.2),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _generateSummary,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.electric,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Generate Summary')),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading) ...[
          const SizedBox(height: 16),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.electric),
            ),
          ),
        ],
        if (_summary != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.done_rounded, color: AppColors.mint, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Summary',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _summary!,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.ink,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ==================== QUIZ TAB ====================
class _QuizTab extends StatefulWidget {
  const _QuizTab();

  @override
  State<_QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<_QuizTab> {
  final TextEditingController _topicController = TextEditingController();
  String? _selectedDifficulty = 'Medium';
  int? _questionCount = 5;
  bool _isGenerating = false;
  List<Map<String, String>>? _quiz;

  void _generateQuiz() {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a topic')));
      return;
    }

    setState(() => _isGenerating = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _quiz = [
            {
              'q': 'What is the main concept of ${_topicController.text}?',
              'options': 'Option A|Option B|Option C|Option D',
              'answer': '0',
            },
            {
              'q':
                  'Which of the following best describes ${_topicController.text}?',
              'options': 'Definition 1|Definition 2|Definition 3|Definition 4',
              'answer': '1',
            },
          ];
          _isGenerating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.quiz_rounded, color: AppColors.rose, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Quiz Generator',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Create custom quizzes for any topic',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Topic or Course',
                  hintText: 'e.g., Photosynthesis, Calculus...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Difficulty',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButton<String>(
                          value: _selectedDifficulty,
                          isExpanded: true,
                          onChanged: (value) =>
                              setState(() => _selectedDifficulty = value),
                          items: ['Easy', 'Medium', 'Hard']
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Questions',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButton<int>(
                          value: _questionCount,
                          isExpanded: true,
                          onChanged: (value) =>
                              setState(() => _questionCount = value),
                          items: [5, 10, 15, 20]
                              .map(
                                (count) => DropdownMenuItem(
                                  value: count,
                                  child: Text('$count'),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _generateQuiz,
                style: FilledButton.styleFrom(backgroundColor: AppColors.rose),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Generate Quiz')),
                ),
              ),
            ],
          ),
        ),
        if (_isGenerating) ...[
          const SizedBox(height: 16),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.rose),
            ),
          ),
        ],
        if (_quiz != null) ...[
          const SizedBox(height: 16),
          ..._quiz!.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final question = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.rose.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q$index: ${question['q']}',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(question['options'] ?? '').split('|').map((option) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.navy.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              option,
                              style: GoogleFonts.nunito(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }
}

// ==================== PLANNER TAB ====================
class _PlannerTab extends StatefulWidget {
  const _PlannerTab();

  @override
  State<_PlannerTab> createState() => _PlannerTabState();
}

class _PlannerTabState extends State<_PlannerTab> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController(
    text: '2',
  );
  String? _studyPlan;
  bool _isGenerating = false;

  void _generatePlan() {
    if (_goalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a study goal')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          final hours = _hoursController.text;
          _studyPlan =
              '''📚 Study Plan for: ${_goalController.text}

⏱️ Duration: $hours hour(s)

Session 1 (0-50 min): Introduction & Key Concepts
- Review fundamental concepts
- Take notes on main ideas
- Identify difficult areas

Break (10 min): Rest & Refresh

Session 2 (60-110 min): Deep Dive & Practice
- Work through examples
- Practice problems
- Test understanding

Break (5 min): Quick refresh

Session 3 (115+ min): Review & Consolidation
- Summarize key points
- Create mind maps
- Test recall memory

💡 Tips:
✓ Remove all distractions
✓ Stay hydrated
✓ Use active recall
✓ Take meaningful notes''';
          _isGenerating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _goalController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: AppColors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Study Plan Generator',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Get a customized study schedule',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _goalController,
                decoration: InputDecoration(
                  labelText: 'Study Goal',
                  hintText: 'What do you want to study?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Available Time (hours)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _generatePlan,
                style: FilledButton.styleFrom(backgroundColor: AppColors.amber),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Generate Plan')),
                ),
              ),
            ],
          ),
        ),
        if (_isGenerating) ...[
          const SizedBox(height: 16),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.amber),
            ),
          ),
        ],
        if (_studyPlan != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: AppColors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Study Plan',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _studyPlan!,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppColors.ink,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/focus');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.electric,
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Start Focus Session')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
