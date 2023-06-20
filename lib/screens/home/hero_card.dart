import 'package:dota_animated/models/hero_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;


class HeroCard extends StatefulWidget {
  final Heroes heroes;

  const HeroCard({super.key, required this.heroes});

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -pi / 2),
        weight: 0.5,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: pi / 2, end: 0.0),
        weight: 0.5,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.isCompleted || _controller.velocity > 0) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
          _isFront = !_isFront;
          _expanded = !_expanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _expanded ? MediaQuery.of(context).size.width - 60 : 200,
        height: _expanded ? MediaQuery.of(context).size.height - 60 : 350,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_animation.value),
              child: IndexedStack(
                alignment: Alignment.center,
                index: _controller.value < 0.5 ? 0 : 1,
                children: [
                  _cardFront(),
                  _cardBack(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cardFront() {
    return Hero(
      tag: widget.heroes.name,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              widget.heroes.image,
              width: 280,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 280,
            height: 400,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.heroes.name,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (widget.heroes.category == 'AGILITY')
                      Image.asset(
                        'assets/hero_agility.png',
                        height: 25,
                        width: 25,
                      ),
                    if (widget.heroes.category == 'STRENGTH')
                      Image.asset(
                        'assets/hero_strength.png',
                        height: 25,
                        width: 25,
                      ),
                    if (widget.heroes.category == 'INTELLIGENCE')
                      Image.asset(
                        'assets/hero_intelligence.png',
                        height: 25,
                        width: 25,
                      ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      widget.heroes.category,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 55,
                  child: ListView.builder(
                      itemCount: widget.heroes.powers.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(widget.heroes.powers[index]),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBack() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Image.asset(
              widget.heroes.image,
              width: 280,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 280,
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.black12
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.heroes.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                widget.heroes.story,
                textAlign: TextAlign.justify,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
