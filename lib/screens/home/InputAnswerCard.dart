import 'package:flutter/material.dart';

class InputAnswerCard extends StatefulWidget {
  final Widget child;
  final String setSlide;
  InputAnswerCard({this.child, this.setSlide=""});

  @override
  _InputAnswerCardState createState() => _InputAnswerCardState();
}

class _InputAnswerCardState extends State<InputAnswerCard>with SingleTickerProviderStateMixin{
  AnimationController _slideController;
  Animation<Offset> _slideAnimation;
  Tween<Offset> direction =Tween<Offset>(
    begin:Offset(0,2),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = direction.animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.decelerate,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _slideController.dispose();
  }

  //Could move the entire widget structure here, but I want to do it after we get firebase working
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _slideAnimation,
        child:widget.child,
    );
  }

  @override
  void didUpdateWidget(InputAnswerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runSlideCheck();
  }

  void _runSlideCheck() {
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
    _slideController.reverse(from: 1.0);
  }
  void slideDownCancel(){
    _slideController.reverse(from: 1.0);
  }
  void slideUpShow(){
    direction.begin = Offset(0,2);
    _slideController.forward();
  }
}
