
import 'package:flutter/material.dart';
class NameEditor extends StatefulWidget {
  final String initialValue;
  final void Function(String) onSave;

  const NameEditor({
    Key? key,
    required this.initialValue,
    required this.onSave,
  }) : super(key: key);

  @override
  _NameEditorState createState() => _NameEditorState();
}

class _NameEditorState extends State<NameEditor> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () {
            widget.onSave(_textEditingController.text);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
