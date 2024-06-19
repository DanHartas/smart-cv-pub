import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'common/styles.dart';
import 'common/section_notifier.dart';

import 'sections/credbox.dart';
import 'sections/topbar.dart';

import 'widgets/background.dart';
import 'widgets/content.dart';
import 'widgets/loading.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SectionNotifier(),
      child: const CV(),
    ),
  );
}

class CV extends StatefulWidget {
  const CV({super.key});

  @override
  CVState createState() => CVState();
}

class CVState extends State<CV> {
  bool showCred = false;
  Map<String, dynamic>? data;
  late String sessionId;
  late Map<int, List<int>> collapsibleParents;

  void toggleCred() {
    setState(() {
      showCred = !showCred;
    });
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://dh-smart-cv-backend-fa1514ad8fd4.herokuapp.com'));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      setState(() {
        data = jsonDecode(body);
        sessionId = data!['session_id'];
        collapsibleParents =
            (data!['collapsible parents'] as Map<String, dynamic>)
                .map((key, value) {
          int cID = int.parse(key);
          List<int> parents =
              (value as List).map((e) => int.parse(e.toString())).toList();
          return MapEntry(cID, parents);
        });
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SectionNotifier>(context, listen: false)
            .initialise(collapsibleParents);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Dan Hartas - Smart CV',
      home: DefaultTextStyle(
        style: TextStyles.qButton,
        child: data == null
            ? const Loading()
            : Scaffold(
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return Background(
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TopBar(cred: toggleCred),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Content(
                                    width: width,
                                    fullWidth: fullWidth,
                                    data: data!,
                                    sessionId: sessionId,
                                    collapsibleParents: collapsibleParents,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (showCred)
                            CredBox(width: width, close: toggleCred),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
