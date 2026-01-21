import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [
    {"sender": "bot", "text": "Hello! How can I help you today?"}
  ];

  String selectedLanguage = "English";
  String lastLanguage = "English";
  bool isTyping = false;
  GenerativeModel? _model;
  ChatSession? _chat;

  @override
  void initState() {
    super.initState();
    _initChatSession();
  }

  void _initChatSession() {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      messages.add({
        "sender": "bot",
        "text": "API key missing. Set GEMINI_API_KEY in .env"
      });
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 200,
      ),
    );
    _chat = _model!.startChat(history: [
      Content.text('Please reply in $selectedLanguage.')
    ]);
    lastLanguage = selectedLanguage;
  }

  Future<void> sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty || isTyping) return;

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      isTyping = true;
    });
    _controller.clear();
    // Reset chat session if language changed
    if (selectedLanguage != lastLanguage) {
      _initChatSession();
    }

    if (_chat == null) {
      setState(() {
        messages.add({
          "sender": "bot",
          "text": "Chat not initialized. Configure API key."
        });
        isTyping = false;
      });
      return;
    }

    try {
      final response = await _chat!.sendMessage(Content.text(userMessage));
      final botResponse = response.text ?? "Sorry, I couldn't get a response.";

      setState(() {
        messages.add({"sender": "bot", "text": botResponse});
        isTyping = false;
      });
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "text": "Error: $e"});
        isTyping = false;
      });
    }

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
    final screenWidth = MediaQuery.of(context).size.width;

    final double bubblePadding = screenWidth * 0.04;
    final double fontSize = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.07;
    final double spacing = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Krishi Rath AI Assistant"),
        backgroundColor: Colors.green.shade700,
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedLanguage = value);
              }
            },
            items: ["English", "Hindi", "Marathi"]
                .map((lang) => DropdownMenuItem(
              value: lang,
              child: Text(lang, style: TextStyle(fontSize: fontSize)),
            ))
                .toList(),
          ),
          SizedBox(width: spacing),
        ],
      ),
      body: SafeArea(
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length + (isTyping ? 1 : 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  if (index == messages.length && isTyping) {
                    return _buildTypingIndicator(spacing);
                  }

                  final msg = messages[index];
                  final isUser = msg["sender"] == "user";

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: spacing / 2, horizontal: spacing),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.smart_toy, color: Colors.white),
                          ),
                        if (!isUser) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(bubblePadding),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isUser
                                    ? [Colors.blue, Colors.blueAccent]
                                    : [Colors.grey.shade300, Colors.grey.shade200],
                              ),
                              borderRadius: BorderRadius.circular(bubblePadding),
                            ),
                            child: isUser
                                ? Text(
                                    msg["text"] ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                    ),
                                  )
                                : SelectableText(
                                    msg["text"] ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fontSize,
                                    ),
                                  ),
                          ),
                        ),
                        if (isUser) const SizedBox(width: 8),
                        if (isUser)
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.mic_none, size: iconSize),
                    onPressed: isTyping ? null : () {},
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !isTyping,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: spacing, vertical: spacing),
                      ),
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                  SizedBox(width: spacing),
                  IconButton(
                    icon: Icon(Icons.send, size: iconSize),
                    color: Colors.green.shade700,
                    onPressed: isTyping ? null : sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(double spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.smart_toy, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text("Typing...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}