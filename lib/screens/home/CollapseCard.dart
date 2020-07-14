import 'package:flutter/material.dart';
class CollapseCard extends StatefulWidget {
  final Widget child;
  final bool expand;
  CollapseCard({this.child, this.expand=true});
  @override
  _CollapseCardState createState() => _CollapseCardState();
}

class _CollapseCardState extends State<CollapseCard>with SingleTickerProviderStateMixin{
  AnimationController collapseController;
  Animation<double> _collapseAnimation;
  @override
  void initState() {
    super.initState();
    collapseController = AnimationController(
      duration: const Duration(seconds:1),
      vsync: this,
    );

    _collapseAnimation = CurvedAnimation(
      parent: collapseController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    super.dispose();
    collapseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment:1.0,
        sizeFactor: _collapseAnimation,
        child: widget.child
    );
  }

  @override
  void didUpdateWidget(CollapseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }
  void _runExpandCheck() {
    if(widget.expand) {
      collapseController.forward();
    }
    else if(!widget.expand) {
      collapseController.reverse();
    }
    else{
      return;
    }
  }
}
