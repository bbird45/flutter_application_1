import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
import 'dart:async';

import 'package:flutter_application_1/screen/work_screen.dart';

class MachineInfo {
  final String name;
  String status;
  int time;
  Timer? timer;

  MachineInfo({required this.name, required this.status, required this.time});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MachineInfo> machines = [
    MachineInfo(name: 'เครื่องซักผ้า 1', status: 'ว่าง', time: 0),
    MachineInfo(name: 'เครื่องซักผ้า 2', status: 'ไม่ว่าง', time: 1800),
    MachineInfo(name: 'เครื่องซักผ้า 3', status: 'ว่าง', time: 0),
    MachineInfo(name: 'เครื่องซักผ้า 4', status: 'ไม่ว่าง', time: 2500),
    MachineInfo(name: 'เครื่องซักผ้า 5', status: 'ว่าง', time: 0),
    MachineInfo(name: 'เครื่องซักผ้า 6', status: 'ไม่ว่าง', time: 1000),
    MachineInfo(name: 'เครื่องซักผ้า 7', status: 'ว่าง', time: 0),
    MachineInfo(name: 'เครื่องซักผ้า 8', status: 'ไม่ว่าง', time: 2000),
  ];

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    for (int i = 0; i < machines.length; i++) {
      if (machines[i].status == 'ไม่ว่าง' && machines[i].time > 0) {
        machines[i].timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (machines[i].time > 0) {
              machines[i].time--;
            } else {
              machines[i].status = 'ว่าง';
              machines[i].timer?.cancel();
            }
          });
        });
      }
    }
  }

  void _updateMachine(int index, String status, int time) {
    setState(() {
      machines[index].status = status;
      machines[index].time = time;
      machines[index].timer?.cancel();

      if (status == 'ไม่ว่าง') {
        machines[index].timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (machines[index].time > 0) {
              machines[index].time--;
            } else {
              machines[index].status = 'ว่าง';
              machines[index].timer?.cancel();
            }
          });
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text('หน้าหลัก'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'โปรไฟล์',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('หน้าแรก'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('การตั้งค่า'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('บัญชีผู้ใช้'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('ออกจากระบบ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: machines.length,
        itemBuilder: (context, index) {
          return MachineTile(
            machineInfo: machines[index],
            onTap: () async {
              if (machines[index].status == 'ว่าง') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkScreen(machineName: machines[index].name),
                  ),
                );

                if (result != null) {
                  _updateMachine(index, result['status'], result['time']);
                }
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'เติมเงิน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'สแกน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
        ],
      ),
    );
  }
}
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

class MachineTile extends StatelessWidget {
  final MachineInfo machineInfo;
  final VoidCallback? onTap;

  MachineTile({required this.machineInfo, this.onTap});

 @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.local_laundry_service,
                size: 100.0, color: Colors.blue[400]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  machineInfo.name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      machineInfo.status == 'ว่าง'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: machineInfo.status == 'ว่าง'
                          ? Colors.green
                          : Colors.red,
                    ),
                    SizedBox(width: 8.0), 
                    Text(
                      machineInfo.status,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: machineInfo.status == 'ว่าง'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16.0,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8.0), 
                    Text(
                      _formatTime(machineInfo.time),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onTap,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  machineInfo.status == 'ว่าง' ? Colors.green : Colors.white,
                ),
              ),
              child: Text(
                machineInfo.status == 'ว่าง' ? 'สั่งทำงาน' : 'จองคิว',
                style: TextStyle(
                  color: machineInfo.status == 'ว่าง'
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
