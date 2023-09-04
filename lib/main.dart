import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zain_cash/server.dart';
import 'package:zaincash/zaincash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? transactionId;

  @override
  Widget build(BuildContext context) {
    // test if seccess of not
    ZaincashService.paymentStateListener.listen((state) {
      if (state['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("success"),
        ));
        Logger().d('Zain cash success');
      }

      if (state['success'] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("failed"),
        ));
        Logger().e('Zain cash error');
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('zainCash'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (transactionId != null)
              ZainCash(
                  transactionId: transactionId!,
                  production: false,
                  closeOnSuccess: true,
                  closeOnError: true),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //1
            String token = createToken();
            //2
            //3 get the transaction id and paument the money
            transactionId = await transAction(token);

            setState(() {});
          },
          child: const Icon(Icons.payment)),
    );
  }
}
