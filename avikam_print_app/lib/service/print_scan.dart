import 'package:avikam_print_app/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:bluetooth_print_plus/bluetooth_print_model.dart';

class BlePrint extends StatefulWidget {
  const BlePrint({super.key});

  @override
  State<BlePrint> createState() => _BlePrintState();
}

class _BlePrintState extends State<BlePrint> {
  final _bluetoothPrintPlus = BluetoothPrintPlus.instance;
  bool _connected = false;
  BluetoothDevice? _device;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bool isConnected = await _bluetoothPrintPlus.isConnected ?? false;
    _bluetoothPrintPlus.state.listen((state) {
      debugPrint('********** cur device status: $state **********');
      switch (state) {
        case BluetoothPrintPlus.connected:
          setState(() {
            if (_device == null) return;
            _connected = true;
            _bluetoothPrintPlus.stopScan();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => const HomePage()));
          });
          break;
        case BluetoothPrintPlus.disconnected:
          setState(() {
            _device = null;
            _connected = false;
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Devices'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<BluetoothDevice>>(
                stream: _bluetoothPrintPlus.scanResults,
                initialData: [],
                builder: (c, snapshot) => ListView(
                  children: snapshot.data!
                      .map((d) => Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.name ?? ''),
                                    Text(
                                      d.address ?? 'null',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const Divider(),
                                  ],
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    _bluetoothPrintPlus.connect(d);
                                    _device = d;
                                  },
                                  child: const Text("connect"),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child: const Text("Search", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    _bluetoothPrintPlus.isAvailable;
                    _bluetoothPrintPlus.startScan(
                        timeout: const Duration(seconds: 30));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
