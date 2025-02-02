import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('LazyIndexedStack')),
        body: const Builder(builder: buildLazyIndexedStack),
      ),
    ),
  );
}

Widget buildLazyIndexedStack(BuildContext context) {
  return LazyIndexedStack(
    index: 0,
    alignment: Alignment.center,
    sizing: StackFit.expand,
    children: List<Widget>.generate(
      3,
      (int index) => Text(
        'Children index:\n'
        '${'$index' * (index + 1)}',
      ),
    ),
  );
}

class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  }) : super(key: key);

  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int? index;
  final List<Widget> children;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<bool> _activatedList = List<bool>.generate(
    widget.children.length,
    (int i) => i == widget.index,
  );

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO: Implement a more precise control for children updates.
  }

  void _activateIndex(int? index) {
    if (index == null) {
      return;
    }
    if (!_activatedList[index]) {
      _activatedList[index] = true;
    }
  }

  List<Widget> _buildChildren(BuildContext context) {
    return <Widget>[
      for (int i = 0; i < widget.children.length; i++)
        if (_activatedList[i] == true)
          widget.children[i]
        else
          const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _activateIndex(widget.index);
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: widget.index,
      children: _buildChildren(context),
    );
  }
}
