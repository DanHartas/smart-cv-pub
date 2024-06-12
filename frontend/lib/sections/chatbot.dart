import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/quarticle.dart';
import '../common/section_notifier.dart';
import '../common/styles.dart';

import '../widgets/icon_qbutton.dart';
import '../widgets/toggle_button.dart';

class ChatBot extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;
  final String sessionId;
  final Map<int, List<int>> collapsibleParents;

  const ChatBot({
    super.key,
    required this.width,
    required this.data,
    required this.sessionId,
    required this.collapsibleParents,
  });

  @override
  ChatBotState createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  final List<Widget> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add(BotMessage(
      width: widget.width * 2 / 3,
      text: widget.data['opening message'],
      cIDs: const [],
      collapsibleParents: widget.collapsibleParents,
    ));
  }

  Future<void> _respond() async {
    final message = _controller.text;
    var uri = Uri.parse('http://localhost:8000/sendMessage');

    setState(() {
      messages.add(UserMessage(text: message, width: widget.width * 2 / 3));
      _controller.clear();
      messages.add(LoadingMessage(width: widget.width * 2 / 3));
    });

    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'session_id': widget.sessionId}),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);

      List<int> cIDs = List<int>.from(data['cIDs']);

      setState(() {
        messages.removeLast();
        messages.add(BotMessage(
          width: widget.width * 2 / 3,
          text: data['message'],
          cIDs: cIDs,
          collapsibleParents: widget.collapsibleParents,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double threadWidth = widget.width * 2 / 3;
    return SizedBox(
      width: threadWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ToggleButton(
            text: 'Chat Bot',
            icon: Icons.chat_bubble_rounded,
            cID: widget.data['cID'],
            isExpander: false,
          ),
          SizedBox(height: widget.width / 96),
          for (var message in messages) message,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: threadWidth - 110,
                child: QuarticleContainer(
                  style: QStyles.input,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      hintStyle: TextStyles.message
                          .copyWith(color: const Color(0xFFC0C0C0)),
                      border: InputBorder.none,
                    ),
                    style: TextStyles.message,
                    cursorColor: Colours.cvGlassyTurquoise,
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconQButton(
                icon: Icons.send_rounded,
                qStyle: QStyles.input,
                textStyle: const TextStyle(color: Colors.white, fontSize: 24),
                onPressed: _respond,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  final String text;
  final double width;

  const UserMessage({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuarticleContainer(
              style: QStyles.input,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: width - 72,
              child: QuarticleContainer(
                style: QStyles.input,
                child: SelectableText(
                  text,
                  style: TextStyles.message,
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class BotMessage extends StatefulWidget {
  final double width;
  final String text;
  final List<int> cIDs;
  final Map<int, List<int>> collapsibleParents;

  const BotMessage({
    super.key,
    required this.width,
    required this.text,
    required this.cIDs,
    required this.collapsibleParents,
  });

  @override
  BotMessageState createState() => BotMessageState();
}

class BotMessageState extends State<BotMessage> {
  bool showButton = false;
  String displayText = '';

  @override
  void initState() {
    super.initState();
    _typeMessage();
  }

  void _typeMessage() {
    final List<String> words = widget.text.split(' ');
    int index = 0;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index < words.length) {
        setState(() {
          displayText += (index == 0 ? '' : ' ') + words[index];
        });
        index++;
      } else {
        timer.cancel();
        if (widget.cIDs.isNotEmpty) {
          setState(() {
            showButton = true;
          });
        }
      }
    });
  }

  void _highlight() {
    Provider.of<SectionNotifier>(context, listen: false);
    for (var cID in widget.cIDs) {
      Provider.of<SectionNotifier>(context, listen: false)
          .expandParents(widget.collapsibleParents[cID]);
      Provider.of<SectionNotifier>(context, listen: false)
          .highlightSection(cID);
      Provider.of<SectionNotifier>(context, listen: false).expandSection(cID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: widget.width - 72,
                  child: QuarticleContainer(
                    style: QStyles.label,
                    child: SelectableText(
                      displayText,
                      style: TextStyles.message,
                      maxLines: null,
                    ),
                  ),
                ),
                Visibility(
                  visible: showButton,
                  child: Container(
                      padding: const EdgeInsets.all(12),
                      child: IconQButton(
                        text: "Highlight related content",
                        icon: Icons.search_rounded,
                        textStyle: TextStyles.qButtonMid,
                        qStyle: QStyles.input,
                        onPressed: _highlight,
                      )),
                ),
              ],
            ),
            const SizedBox(width: 12),
            QuarticleContainer(
              style: QStyles.label,
              child: const Icon(
                Icons.tag_faces_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class LoadingMessage extends StatelessWidget {
  final double width;

  const LoadingMessage({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Center(
        child: CircularProgressIndicator(
          color: Colours.cvGlassyTurquoise,
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
