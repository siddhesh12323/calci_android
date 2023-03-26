import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Color foregroundColor = Color.fromARGB(255, 227, 145, 140);
Color backgroundColor = Color.fromARGB(255, 228, 236, 147);

class _HomePageState extends State<HomePage> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 40.0;
  double resultFontSize = 60.0;

  Color buttonColor = Color.fromARGB(255, 223, 215, 215);
  String defaultFont = 'Unbounded';

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 40.0;
        resultFontSize = 60.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 60.0;
        resultFontSize = 40.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 40.0;
        resultFontSize = 60.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result =
              '${exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(3)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 60.0;
        resultFontSize = 40.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return calculatorPage(context);
  }

  Widget calculatorPage(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dx < 0) {
            setState(() {
              width2 = MediaQuery.of(context).size.width / 2;
              height2 = MediaQuery.of(context).size.height;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Another Calci'),
          ),
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: backgroundColor,
                // be sure to add shadow to container
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          // color: foregroundColor,
                          decoration: BoxDecoration(
                              color: foregroundColor,
                              boxShadow: [
                                BoxShadow(
                                    color: foregroundColor,
                                    blurRadius: 15.0,
                                    offset: const Offset(0, 6))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  equation,
                                  style: TextStyle(
                                      fontSize: equationFontSize,
                                      fontFamily: defaultFont),
                                ),
                                Text(
                                  result,
                                  style: TextStyle(
                                      fontSize: resultFontSize,
                                      fontFamily: defaultFont),
                                ),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: (MediaQuery.of(context).size.height) / 2,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                textbutton('C'),
                                iconbutton1(Icon(
                                  Icons.backspace,
                                  color: Colors.black,
                                )),
                                textbutton('%'),
                                textbutton('÷'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                textbutton('7'),
                                textbutton('8'),
                                textbutton('9'),
                                textbutton('×'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                textbutton('4'),
                                textbutton('5'),
                                textbutton('6'),
                                textbutton('-'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                textbutton('1'),
                                textbutton('2'),
                                textbutton('3'),
                                textbutton('+'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconbutton2(Icon(
                                  Icons.colorize,
                                  color: Colors.black,
                                )),
                                textbutton('0'),
                                textbutton('.'),
                                textbutton('='),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: Visibility(
                  child: sidebar(),
                ),
              ),
              Visibility(
                child: AnimatedOpacity(
                  opacity: isVisible2 ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 35, 8, 0),
                    child: Container(
                      color: Color.fromARGB(50, 249, 247, 247),
                      height: 350,
                      width: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Foreground Color'),
                          ),
                          ColorPicker(299),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Background Color'),
                          ),
                          ColorPicker(301),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget textbutton(String text) {
    return ElevatedButton(
        onPressed: (() {
          buttonPressed(text);
        }),
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            shape: CircleBorder(),
            elevation: 6.0,
            shadowColor: Color.fromARGB(255, 165, 147, 147),
            padding: EdgeInsets.all(20)),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: defaultFont),
        ));
  }

  Widget iconbutton1(Icon icon) {
    return ElevatedButton(
        onPressed: (() {
          buttonPressed('⌫');
        }),
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: CircleBorder(),
            elevation: 6.0,
            shadowColor: Color.fromARGB(255, 165, 147, 147),
            padding: EdgeInsets.all(20)),
        child: icon);
  }

  bool isVisible2 = false;

  Widget iconbutton2(Icon icon) {
    return ElevatedButton(
        onPressed: (() {
          setState(() {
            isVisible2 = !isVisible2;
          });
          // sidebar(MediaQuery.of(context).size.height,
          //     MediaQuery.of(context).size.width / 2);
        }),
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: CircleBorder(),
            elevation: 6.0,
            shadowColor: Color.fromARGB(255, 165, 147, 147),
            padding: EdgeInsets.all(20)),
        child: icon);
  }

  double width2 = 0;
  double height2 = 600;

  Widget sidebar() {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          setState(() {
            width2 = 0;
            height2 = MediaQuery.of(context).size.height;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: Color.fromARGB(100, 202, 123, 123),
        curve: Curves.fastLinearToSlowEaseIn,
        width: width2,
        height: height2,
        child: ListView(
          children: [
            presetThemes(
                'assets/redYELLOW.jpg',
                Color.fromARGB(255, 227, 145, 140),
                Color.fromARGB(255, 228, 236, 147)),
            presetThemes(
                'assets/redBLACK.jpg',
                Color.fromARGB(255, 226, 132, 127),
                Color.fromARGB(255, 83, 80, 80)),
            presetThemes(
                'assets/redWHITE.jpg',
                Color.fromARGB(255, 226, 132, 127),
                Color.fromARGB(255, 231, 219, 219)),
            presetThemes(
                'assets/greenBLUE.jpg',
                Color.fromARGB(255, 231, 235, 191),
                Color.fromARGB(255, 169, 212, 235)),
            presetThemes(
                'assets/blueGREEN.jpg',
                Color.fromARGB(255, 164, 181, 231),
                Color.fromARGB(255, 216, 221, 163))
          ],
        ),
      ),
    );
  }

  Widget presetThemes(String imageAsset, Color fg, Color bg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width / 2 - 10,
        child: InkWell(
            onTap: () {
              setState(() {
                foregroundColor = fg;
                backgroundColor = bg;
              });
            },
            splashColor: Colors.white.withOpacity(0.5),
            child: Image.asset(imageAsset)),
      ),
    );
  }
}

// Color Picker
class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(position, size.height / 2), 12, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}

class ColorPicker extends StatefulWidget {
  final double width;
  ColorPicker(this.width);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 127),
    Color.fromARGB(255, 128, 128, 128),
  ];
  double _colorSliderPosition = 0;
  late double _shadeSliderPosition;
  late Color _currentColor;
  late Color _shadedColor;
  @override
  initState() {
    super.initState();
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
    _shadeSliderPosition = widget.width / 2; //center the shader selector
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
  }

  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    print("New pos: $position");
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(_colorSliderPosition);
      _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    });
  }

  _shadeChangeHandler(double position) {
    //handle out of bounds gestures
    if (position > widget.width) position = widget.width;
    if (position < 0) position = 0;
    setState(() {
      _shadeSliderPosition = position;
      _shadedColor = _calculateShadedColor(_shadeSliderPosition);
      if (widget.width < 300) {
        foregroundColor = _shadedColor;
      } else {
        backgroundColor = _shadedColor;
      }
      print(
          "r: ${_shadedColor.red}, g: ${_shadedColor.green}, b: ${_shadedColor.blue}");
    });
  }

  Color _calculateShadedColor(double position) {
    double ratio = position / widget.width;
    if (ratio > 0.5) {
      //Calculate new color (values converge to 255 to make the color lighter)
      int redVal = _currentColor.red != 255
          ? (_currentColor.red +
                  (255 - _currentColor.red) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int greenVal = _currentColor.green != 255
          ? (_currentColor.green +
                  (255 - _currentColor.green) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int blueVal = _currentColor.blue != 255
          ? (_currentColor.blue +
                  (255 - _currentColor.blue) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else if (ratio < 0.5) {
      //Calculate new color (values converge to 0 to make the color darker)
      int redVal = _currentColor.red != 0
          ? (_currentColor.red * ratio / 0.5).round()
          : 0;
      int greenVal = _currentColor.green != 0
          ? (_currentColor.green * ratio / 0.5).round()
          : 0;
      int blueVal = _currentColor.blue != 0
          ? (_currentColor.blue * ratio / 0.5).round()
          : 0;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else {
      //return the base color
      return _currentColor;
    }
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray =
        (position / widget.width * (_colors.length - 1));
    print(positionInColorArray);
    int index = positionInColorArray.truncate();
    print(index);
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              print("_-------------------------STARTED DRAG");
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            //This outside padding makes it much easier to grab the   slider because the gesture detector has
            // the extra padding to recognize gestures inside of
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: _colors),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_colorSliderPosition),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              print("_-------------------------STARTED DRAG");
              _shadeChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            //This outside padding makes it much easier to grab the slider because the gesture detector has
            // the extra padding to recognize gestures inside of
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      colors: [Colors.black, _currentColor, Colors.white]),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_shadeSliderPosition),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: _shadedColor,
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }
}

// class CalculatorPage extends StatefulWidget {
//   const CalculatorPage({super.key});

//   @override
//   State<CalculatorPage> createState() => _CalculatorPageState();
// }

// class _CalculatorPageState extends State<CalculatorPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
