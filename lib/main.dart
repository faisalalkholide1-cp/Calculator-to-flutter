import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // --- متغيرات الحالة ---
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0.0;
  String _operator = "";

  // --- دالة معالجة ضغطات الأزرار ---
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        _currentInput = "";
        _num1 = 0.0;
        _operator = "";
      }else if (buttonText == "+/-") { // <-- أضف هذا الشرط
        // -- منطق زر تغيير الإشارة --
        if (_currentInput.isNotEmpty) {
          if (_currentInput.startsWith('-')) {
            _currentInput = _currentInput.substring(1); // إزالة "-"
          } else {
            _currentInput = '-' + _currentInput; // إضافة "-"
          }
          _output = _currentInput;
        }
      }else if (buttonText == "%") { // <-- أضف هذا الشرط
        // -- منطق زر النسبة المئوية --
        if (_currentInput.isNotEmpty) {
          double currentValue = double.parse(_currentInput);
          currentValue /= 100;
          _currentInput = currentValue.toString();
          _output = _currentInput;
        }
      } 
       else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operator = buttonText;
          // عرض الرقم والعملية بشكل مؤقت
          _output = _num1.toString().replaceAll(RegExp(r'\.0$'), '') + " " + _operator;
          _currentInput = "";
        }
      } else if (buttonText == ".") {
        if (!_currentInput.contains(".")) {
          _currentInput += ".";
          _output = _currentInput;
        }
      } else if (buttonText == "=") {
        if (_currentInput.isNotEmpty && _operator.isNotEmpty) {
          double num2 = double.parse(_currentInput);
          double result = 0.0;

          if (_operator == "+") result = _num1 + num2;
          if (_operator == "-") result = _num1 - num2;
          if (_operator == "x") result = _num1 * num2;
          if (_operator == "/") {
            if (num2 == 0) {
              _output = "Error"; // التعامل مع القسمة على صفر
              _currentInput = "";
              _num1 = 0.0;
              _operator = "";
              return;
            }
            result = _num1 / num2;
          }
          
          // تنسيق النتيجة
          _output = result.toString();
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }

          _num1 = result;
          _currentInput = _output;
          _operator = "";
        }
      } else {
        // تجاهل إدخال أصفار متعددة في البداية
        if (_currentInput == "0" && buttonText == "0") return;
        if (_currentInput == "0" && buttonText != "0") _currentInput = "";

        _currentInput += buttonText;
        _output = _currentInput;
      }
    });
  }

  // --- بناء الواجهة ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Text(
                  _output,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  buildButtonRow(["AC", "+/-", "%", "/"]),
                  buildButtonRow(["7", "8", "9", "x"]),
                  buildButtonRow(["4", "5", "6", "-"]),
                  buildButtonRow(["1", "2", "3", "+"]),
                  buildButtonRow(["0", ".", "="]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((buttonText) {
          return Expanded(
            flex: (buttonText == "0") ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _buttonPressed(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getButtonColor(buttonText),
                  foregroundColor: getButtonTextColor(buttonText),
                  shape: (buttonText == "0") ? const StadiumBorder() : const CircleBorder(),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getButtonColor(String buttonText) {
    if (["/", "x", "-", "+", "="].contains(buttonText)) return Colors.orange;
    if (["AC", "+/-", "%"].contains(buttonText)) return Colors.grey[400]!;
    return Colors.grey[800]!;
  }

  Color getButtonTextColor(String buttonText) {
    if (["AC", "+/-", "%"].contains(buttonText)) return Colors.black;
    return Colors.white;
  }
}
