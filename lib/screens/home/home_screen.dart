import 'dart:math';
import 'package:dota_animated/data/hero_data.dart';
import 'package:dota_animated/screens/home/hero_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  double top = -900;
  double left = -400;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final columns = sqrt(heroes.length).toInt();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onPanUpdate: (details) {
          var topPos = top + (details.delta.dy * 1.5);
          var leftPos = left + (details.delta.dx * 1.5);
          //set the state
          setState(() {
            top = topPos;
            left = leftPos;
          });
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration:  BoxDecoration(
            color: Colors.black.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                top: top,
                left: left,
                child: SizedBox(
                  width: columns * 350,
                  child: Wrap(
                    children: List.generate(
                      heroes.length,
                          (index) => Transform.translate(
                        offset: Offset(0, index.isEven ? 100 : 0),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 280,
                          height: 400,
                          child: HeroCard(heroes: heroes[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

