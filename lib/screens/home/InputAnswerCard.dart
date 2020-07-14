import 'package:flutter/material.dart';

class InputAnswerCard extends StatefulWidget {
  final Widget child;
  final String setSlide;
  InputAnswerCard({this.child, this.setSlide=""});

  @override
  _InputAnswerCardState createState() => _InputAnswerCardState();
}

class _InputAnswerCardState extends State<InputAnswerCard>with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Tween<Offset> direction =Tween<Offset>(
    begin:Offset(0,2),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = direction.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //Could move the entire widget structure here, but I want to do it after we get firebase working
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child:widget.child,
    );
  }

  @override
  void didUpdateWidget(InputAnswerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if(widget.setSlide=='Answer') {
      slideUpShow();
    }
    else if(widget.setSlide=='Submit'){
      slideUpwardsSubmit();
    }
    else if(widget.setSlide=='Cancel'){
      slideDownCancel();
    }
    else {
      return;
    }
  }

  void slideUpwardsSubmit(){
    direction.begin = Offset(0,-2);
    _controller.reverse(from: 1.0);
  }
  void slideDownCancel(){
    _controller.reverse(from: 1.0);
  }
  void slideUpShow(){
    direction.begin = Offset(0,2);
    _controller.forward();
  }
}
