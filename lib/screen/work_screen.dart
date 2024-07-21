import 'package:flutter/material.dart';

class WorkScreen extends StatefulWidget {
  final String machineName;

  WorkScreen({required this.machineName});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final _amountController = TextEditingController();
  final _amountNotifier = ValueNotifier<int>(0);

  int _calculateTime(int amount) {
    if (amount == 30) {
      return 55 * 60;
    } else if (amount == 20) {
      return 46 * 60;
    } else {
      return 0;
    }
  }

  void _submit() {
    final amount = int.tryParse(_amountController.text) ?? 0;
    final time = _calculateTime(amount);

    if (amount > 0) {
      Navigator.pop(context, {
        'status': time > 0 ? 'ไม่ว่าง' : 'ว่าง',
        'time': time,
        'amount': amount,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกจำนวนเงินที่ถูกต้อง')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final amount = int.tryParse(_amountController.text) ?? 0;
      _amountNotifier.value = amount;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text('${widget.machineName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'images/WASH.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'กรอกจำนวนเงิน:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'จำนวนเงิน',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: _amountNotifier,
              builder: (context, amount, child) {
                return ElevatedButton(
                  onPressed: (amount == 20 || amount == 30) ? _submit : null,
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      (amount == 20 || amount == 30) ? Colors.white : Color.fromARGB(255, 208, 207, 207),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'หมายเหตุ: 20 บาทสำหรับเครื่องเล็ก และ 30 บาท สำหรับเครื่องใหญ่',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
