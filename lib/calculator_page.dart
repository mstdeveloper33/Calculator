import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculatorapp/durationitems/duration_items.dart';
import 'package:calculatorapp/lottie_theme.dart';
import 'package:calculatorapp/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool isLigt = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: DurationItems.durationNormal());
  }

  String _currentInput = ''; // Kullanıcının mevcut girdisi
  String _display = '0'; // Ekranda gösterilen metin
  // Operatörlerin doğrulanması
  bool isOperator(String char) {
    return "+-x/%".contains(char); // Operatörleri kontrol et
  }

  Color getDisplayTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  void onButtonPress(String btnText) {
    setState(() {
      if (btnText == 'C') {
        _currentInput = '';
        _display = '0';
      } else if (btnText == '➞') {
        // Geri silme
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _display = _currentInput.isNotEmpty ? _currentInput : '0';
        }
      } else if (isOperator(btnText)) {
        // Operatörleri kontrol et
        if (_currentInput.isEmpty ||
            isOperator(_currentInput[_currentInput.length - 1])) {
          return; // Çift operatörü engelle
        }
        _currentInput += btnText;
        _display = _currentInput;
      } else if (btnText == '0') {
        // Sıfır ekleme
        if (_currentInput.isEmpty || _currentInput == '0') {
          return; // Başlangıçtaki sıfırları kontrol et
        }
        _currentInput += '0';
        _display = _currentInput;
      } else if (btnText == '.') {
        if (_currentInput.contains('.')) {
          return; // Çift noktayı engelle
        }
        _currentInput += btnText;
        _display = _currentInput;
      } else if (btnText == '=') {
        // Hesaplama yap
        try {
          String expressionString = _currentInput.replaceAll('x', '*');
          Parser parser = Parser();
          Expression expression = parser.parse(expressionString);
          ContextModel context = ContextModel();
          var result = expression.evaluate(EvaluationType.REAL, context);

          if (result == result.roundToDouble()) {
            // Eğer tam sayıysa
            _display = result.toInt().toString();
          } else {
            // Ondalık kısmı varsa
            _display = result
                .toStringAsFixed(13) // Belirli basamakta sıfırları temizle
                .replaceFirst(
                    RegExp(r'\.?0+$'), ''); // Gereksiz sıfırları kaldır
          }

          _currentInput = _display;
        } catch (e) {
          _display = 'Error';
          _currentInput = '';
        }
      } else {
        if (_currentInput == '0' && btnText != '.') {
          _currentInput = btnText; // Başlangıçta fazladan sıfır olmasın
        } else {
          _currentInput += btnText; // Normal ekleme
        }
        _display = _currentInput;
      }
    });
  }

  Widget calcbutton(String btntext, Color btncolor, Color txtcolor,
      {int flex = 1, ShapeBorder? shape, EdgeInsetsGeometry? padding}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            onButtonPress(btntext);
          },
          child: Text(
            btntext,
            style: TextStyle(fontSize: 35, color: txtcolor),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: btncolor,
              shape: CircleBorder(),
              padding: EdgeInsets.all(20)),
        ),
      ),
    );
  }

  Widget calcButton(String btnText, Color btnColor, Color txtColor,
      {int flex = 1, EdgeInsetsGeometry? padding}) {
    return Expanded(
      flex: flex,
      child: ElevatedButton(
        onPressed: () => onButtonPress(btnText),
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: StadiumBorder(),
          padding: padding ?? EdgeInsets.all(20),
        ),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle(fontSize: 25, color: txtColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              child: InkWell(
                onTap: () async {
                  await controller.animateTo(!isLigt ? 0.5 : 1);
                  isLigt = !isLigt;
                  Future.microtask(
                      () => context.read<ThemeNotifer>().changeTheme());
                },
                child: Lottie.asset(LottieItems.themeChange.lottiePath,
                    repeat: false, controller: controller),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: AutoSizeText(
                  _display,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: getDisplayTextColor(context),
                    fontSize: 80,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  minFontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              calcbutton("C", Colors.grey, Colors.black),
              calcbutton("➞", Colors.grey, Colors.black),
              calcbutton("%", Colors.grey, Colors.black),
              calcbutton("/", Colors.amber[700]!, Colors.white),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              calcbutton("7", Colors.grey[850]!, Colors.white),
              calcbutton("8", Colors.grey[850]!, Colors.white),
              calcbutton("9", Colors.grey[850]!, Colors.white),
              calcbutton("x", Colors.amber[700]!, Colors.white),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              calcbutton("4", Colors.grey[850]!, Colors.white),
              calcbutton("5", Colors.grey[850]!, Colors.white),
              calcbutton("6", Colors.grey[850]!, Colors.white),
              calcbutton("-", Colors.amber[700]!, Colors.white),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              calcbutton("1", Colors.grey[850]!, Colors.white),
              calcbutton("2", Colors.grey[850]!, Colors.white),
              calcbutton("3", Colors.grey[850]!, Colors.white),
              calcbutton("+", Colors.amber[700]!, Colors.white),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    onButtonPress("0");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850]!,
                      padding: EdgeInsets.fromLTRB(34, 20, 100, 20),
                      shape: StadiumBorder()),
                  child: Text(
                    "0",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              calcbutton(
                ".",
                Colors.grey[850]!,
                Colors.white,
              ),
              calcbutton("=", Colors.amber[700]!, Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
