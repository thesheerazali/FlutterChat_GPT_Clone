import 'dart:developer';

import 'package:chatgpt_flutter/constants/constants.dart';
import 'package:chatgpt_flutter/providers/chats_provider.dart';
import 'package:chatgpt_flutter/widgets/chat_widget.dart';
import 'package:chatgpt_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return WillPopScope(
      onWillPop: () async { 
        chatProvider
            .resetChat(); // Assuming you have a method to clear the list
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 2,
          // leading: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Image.asset(AssetsManager.botImage),
          // ),
          title: Image.asset(AssetsManager.openaiLogo, height: 110),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    controller: _listScrollController,
                    itemCount:
                        chatProvider.getChatList.length, //chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatProvider
                            .getChatList[index].msg, // chatList[index].msg,
                        chatIndex: chatProvider.getChatList[index]
                            .chatIndex, //chatList[index].chatIndex,
                        shouldAnimate:
                            chatProvider.getChatList.length - 1 == index,
                      );
                    }),
              ),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => showDeleteConfirmationDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            'Delete Chat',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to clear the chat?',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // Clear the chat when the user confirms
                chatProvider.resetChat(); // Replace with your clear method
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
