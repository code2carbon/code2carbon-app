import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class EcoBotChatDrawer extends StatefulWidget {
  const EcoBotChatDrawer({super.key});

  @override
  State<EcoBotChatDrawer> createState() => _EcoBotChatDrawerState();
}

class _EcoBotChatDrawerState extends State<EcoBotChatDrawer> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          '👋 Hello! I am EcoBot, your institutional sustainability assistant. '
          'Ask me anything about greenhouse gas accounting, ISO 14064-1, Scope 1-3 math, or tap a quick question below!',
      isUser: false,
    ),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<({String label, String q, String a, List<String> keywords})> _qa = [
    (
      label: '🌿 Scope 1, 2 & 3 Emissions',
      q: 'What are Scope 1, 2, and 3 emissions?',
      a: '• Scope 1 (Direct): Emissions from institute-owned vehicles, diesel backup generators, and dining hall LPG cooking.\n\n'
          '• Scope 2 (Energy): Indirect emissions from purchased grid electricity consumed on campus (CEA Factor: 0.792 kg CO₂/kWh).\n\n'
          '• Scope 3 (Value Chain): Commuting by staff/students, administrative paper usage, water distribution, and waste disposal.',
      keywords: ['scope', 'direct', 'indirect', 'emissions', 'scope 1', 'scope 2', 'scope 3']
    ),
    (
      label: '⚡ Electricity Carbon Math',
      q: 'How is electricity carbon footprint calculated?',
      a: 'Purchased electricity calculation:\n\n'
          'Emissions (kg CO₂) = Monthly Electricity (kWh) × 0.792 kg CO₂/kWh (CEA India Baseline Database v19).\n\n'
          'Divide by 1,000 to convert to metric tons (tCO₂e).\n\n'
          'Example: 50,000 kWh × 0.792 = 39,600 kg (39.6 tCO₂e).',
      keywords: ['electricity', 'kwh', 'power', 'grid', 'energy', 'electric']
    ),
    (
      label: '🌲 Tree Sequestration Math',
      q: 'How many trees are needed to offset 1 ton of CO₂?',
      a: 'Tree carbon sequestration:\n\n'
          '• 1 mature broadleaf tree (e.g. Neem, Peepal, Banyan) absorbs approximately 45 to 60 kg of CO₂ per year.\n\n'
          '• To offset 1 metric ton (1,000 kg) of CO₂e, an institution requires approximately 20 to 45 mature trees growing for one full calendar year.',
      keywords: ['tree', 'trees', 'plant', 'sequestration', 'absorption', 'offset 1 ton']
    ),
    (
      label: '☀️ Solar Panel Offsets',
      q: 'How do rooftop solar panels reduce campus emissions?',
      a: 'Solar PV Clean Offsets:\n\n'
          'Every 1 kWh of solar electricity generated directly displaces 0.792 kg of coal-heavy fossil grid electricity.\n\n'
          'A 50 kW rooftop solar array producing ~6,200 kWh/month avoids approximately 58.9 metric tons of CO₂e every year!',
      keywords: ['solar', 'panel', 'pv', 'clean energy', 'renewable']
    ),
    (
      label: '📊 ISO 14064 & GHG Protocol',
      q: 'What standards does Code2Carbon use?',
      a: 'Code2Carbon aligns with authoritative sustainability frameworks:\n\n'
          '1. GHG Protocol Corporate Standard: Global standard for organizational greenhouse gas accounting.\n\n'
          '2. ISO 14064-1: Specifications at the institutional level for quantification and reporting of greenhouse gas emissions.\n\n'
          '3. CEA CO₂ Baseline Database: Official grid emission factors for Indian power systems.',
      keywords: ['iso', 'standard', 'ghg', 'protocol', 'compliance', 'framework', 'audit']
    ),
    (
      label: '🎯 Campus Net-Zero Roadmap',
      q: 'What are the top actionable steps for campus net-zero?',
      a: 'Top 5 Actionable Steps for Net-Zero:\n\n'
          '1. Rooftop Solar PV: Offset 30%+ of purchased grid power.\n'
          '2. EV Campus Fleet: Replace diesel shuttles with electric vehicles.\n'
          '3. Smart LED Retrofits: Cut lighting and HVAC electricity by 15%.\n'
          '4. 100% Paperless Campus: Digital exams, admissions, and administration.\n'
          '5. Composting & Recycling: Divert organic food waste to campus bio-composters.',
      keywords: ['net-zero', 'net zero', 'roadmap', 'steps', 'action', 'strategy', 'reduce']
    ),
  ];

  void _askQuestion(String question, String answer) async {
    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: answer, isUser: false));
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _handleSubmittedText(String text) {
    final query = text.trim();
    if (query.isEmpty) return;
    _textController.clear();

    final lower = query.toLowerCase();
    String bestAnswer =
        'Thank you for your question! In institutional carbon accounting, emissions are categorized into Scope 1 (Direct), Scope 2 (Purchased Energy), and Scope 3 (Value Chain). You can use our Carbon Calculator suite to compute exact figures for vehicles, electricity, generators, paper, and ecological sinks.';

    for (var item in _qa) {
      if (item.keywords.any((k) => lower.contains(k))) {
        bestAnswer = item.a;
        break;
      }
    }

    _askQuestion(query, bestAnswer);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EcoBot Assistant', style: AppTypography.titleMedium),
                      Text('Code2Carbon Knowledge Base • Offline & AI',
                          style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 20, color: AppColors.textMuted),
                  tooltip: 'Clear Chat',
                  onPressed: () {
                    setState(() {
                      _messages.clear();
                      _messages.add(
                        ChatMessage(
                          text: 'Chat cleared. How can I assist you?',
                          isUser: false,
                        ),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Quick Question Chips
          Container(
            color: AppColors.lightBg,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _qa.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(item.label),
                      labelStyle: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      onPressed: () => _askQuestion(item.q, item.a),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'EcoBot is thinking...',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask EcoBot anything...',
                        hintStyle: AppTypography.bodySmall,
                        isDense: true,
                        fillColor: AppColors.lightBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide:
                              const BorderSide(color: AppColors.borderSubtle),
                        ),
                      ),
                      onSubmitted: _handleSubmittedText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.aiGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => _handleSubmittedText(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 8, right: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 13,
                color: AppColors.primaryDark,
              ),
            ),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.lightBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isUser ? Colors.white : AppColors.dark,
                  fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
