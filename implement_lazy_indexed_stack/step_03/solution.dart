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

  List<Widget> _buildChildren(BuildContext context) {
    // Use List.generate again? You get the index for free.
    //
    // return List.generate(
    //   widget.children.length, 
    //   (i) => _activatedList[i] ? widget.children[i] : const SizedBox.shrink(),
    // );


    // Is this actually lazy? The widget has already been created by this point.
    //
    // I thought a LazyIndexedStack would use a `builder` function to lazily
    // build the correct widget for the specific index, similar to
    // `ListView.builder`?
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
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: widget.index,
      children: _buildChildren(context),
    );
  }
}
