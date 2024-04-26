import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  /* late AnimationController _animacionOndaIncom; */
  Animation<double>? animation;
  double strokeWidth = 4;
  double tamanioOnda = 40;
  double periodo = 5;
  double fase = 0;

  Tween<double>? offsetTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      offsetTween = Tween(begin: 0, end: MediaQuery.sizeOf(context).width);

      setState(() {});

      animation = offsetTween!
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text("Ondas")),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ElevatedButton(
            onPressed: () {
              _controller.reset();
              _controller.forward();
            },
            child: const Text("Animar onda")),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Stroke width",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Slider(
                    value: strokeWidth,
                    min: 1,
                    max: 8,
                    onChanged: (val) {
                      strokeWidth = val;
                      setState(() {});
                    }),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Tamaño de onda mostrada",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Slider(
                    value: tamanioOnda,
                    min: 40,
                    max: width * periodo,
                    onChanged: (val) {
                      tamanioOnda = val;
                      setState(() {});
                    }),
              ],
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Frecuencia",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Slider(
                    value: periodo,
                    min: 5,
                    max: 40,
                    onChanged: (val) {
                      if (width * periodo > tamanioOnda) {
                        periodo = val;
                        setState(() {});
                      } else {
                        tamanioOnda = width * periodo;
                      }
                    }),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Fase",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Slider(
                    value: fase,
                    min: 0,
                    max: 630,
                    onChanged: (val) {
                      fase = val;
                      setState(() {});
                    }),
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 50,
        ),
        if (animation != null)
          Container(
            padding: const EdgeInsets.all(5),
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                )),
            child: CustomPaint(
              size: Size(
                width,
                periodo * 2 + 5,
              ),
              painter: OndaIntermedia(
                  width: width,
                  fase: fase,
                  x: animation!.value,
                  strokeWidth: strokeWidth,
                  tamanioOnda: tamanioOnda.ceil(),
                  periodo: periodo.ceil()),
            ),
          ),
        /* CustomPaint(
          painter:
              OndaCompleta(width: width, fase: fase, periodo: periodo.ceil()),
        ), */
      ]),
    );
  }
}

class OndaCompleta extends CustomPainter {
  OndaCompleta({required this.width, this.fase = 500, this.periodo = 10});

  final double width;
  final double fase;
  final int periodo;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    final List<Offset> offsets = [];
    for (var i = 0; i < width.ceil() * periodo; i++) {
      offsets.add(
          Offset(i.toDouble() / periodo, math.sin((i + fase) / 100) * periodo));
    }
    path.addPolygon(offsets, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class OndaIntermedia extends CustomPainter {
  OndaIntermedia(
      {this.x = 500,
      this.fase = 0,
      required this.width,
      this.periodo = 10,
      this.tamanioOnda = 50,
      this.strokeWidth = 4});

  final double x;
  final double width;
  final double fase;
  final double strokeWidth;
  final int tamanioOnda;
  final int periodo;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    final List<Offset> offsets = [];
    int c = 0;
    int desplazamientoX = x.ceil() * periodo;

    while (c < tamanioOnda) {
      final Offset punto = Offset(desplazamientoX.toDouble() / periodo,
          math.sin((desplazamientoX + fase) / 100) * periodo + periodo);

      if (punto.dx < width) {
        offsets.add(punto);
      }
      desplazamientoX++;
      c++;
    }

    path.addPolygon(offsets, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
