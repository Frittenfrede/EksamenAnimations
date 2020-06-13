import 'dart:math';

import 'package:example_animations/animated_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// LINK: https://medium.com/flutterdevs/example-animations-in-flutter-2-1034a52f795b

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation _arrowAnimation, _heartAnimation;
  AnimationController _arrowAnimationController, _heartAnimationController;

  @override
  void initState() {
    super.initState();
    //Controlleren bliver sat til at være 300 millisekunder om at køre animationen
    _arrowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    
    //Starter vandret og rotere 180 grader
    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);


// Sætter hjerte animationen
// starter ved 150 og bouncer ud til 170
    _heartAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _heartAnimation = Tween(begin: 150.0, end: 170.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _heartAnimationController));

// Når animatioen er færdig gentager denne det
    _heartAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _heartAnimationController.repeat();
      }
    });
  }

// Oprydning efter controlleren så det ikke giver memory leaks
  @override
  void dispose() {
    super.dispose();
    _arrowAnimationController?.dispose();
    _heartAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Animations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Tilføjer rowes der indeholder de to animationer
          firstChild(),
          SizedBox(
            height: 50.0,
          ),
          secondChild(),
          SizedBox(
            height: 50.0,
          ),
          OutlineButton(
            color: Colors.white,
            textColor: Colors.black,
            padding: const EdgeInsets.all(12.0),
            child: Text('Start Container Animation'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AnimatedScreen()));
            },
            splashColor: Colors.red,
          )
        ],
      ),
    );
}

  Widget firstChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Animated builder er en mere effektiv måde at kalde animationer fremfor setstate()
        AnimatedBuilder(
          animation: _arrowAnimationController,
          // Pakker arrow ikonet ind i en Transform widget, så den akn roterer omkirng dennes centrum
          builder: (context, child) => Transform.rotate(
                angle: _arrowAnimation.value,
                child: Icon(
                  Icons.expand_more,
                  size: 50.0,
                  color: Colors.black,
                ),
              ),
          //  child:
        ),
        OutlineButton(
          color: Colors.white,
          textColor: Colors.black,
          padding: const EdgeInsets.all(12.0),
          child: Text('Start Icon Animation'),
          onPressed: () {
            // Rotere pilen frem og tilbage
            _arrowAnimationController.isCompleted
                ? _arrowAnimationController.reverse()
                : _arrowAnimationController.forward();
          },
          splashColor: Colors.red,
        )
      ],
    );
  }

  Widget secondChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: AnimatedBuilder(
            animation: _heartAnimationController,
            builder: (context, child) {
              return Center(
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: _heartAnimation.value,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: OutlineButton(
              padding: const EdgeInsets.all(12.0),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Start Beating Heart Animation'),
              onPressed: () {
                _heartAnimationController.forward();
              },
              splashColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
