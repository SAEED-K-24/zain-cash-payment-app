import 'dart:convert';
import 'package:dart_jwt_token/dart_jwt_token.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

//>>>>>>>>>>>>>>>>>>>>>>> the info here is test from zain cash <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
const String msisdn = "9647835077893"; // your wallet number
const String secret =
    "\$2y\$10\$hBbAZo2GfSSvyqAyV2SaqOfYewgYpfR1O19gIh4SqyGWdmySZYPuS"; // the Merchant Secret

const String merchantId = "5ffacf6612b5777c6d44266f"; // Merchant Id
const String initUrl = 'https://test.zaincash.iq/transaction/init';
const String redirectUrl = "redirection_url";

Map<String, dynamic> data = {
  'amount': 250,
  'serviceType': "service_type",
  'msisdn': msisdn,
  'orderId': "Bill_123455445544545544554554567890",
  'redirectUrl': redirectUrl,
  'iat': DateTime.now().millisecondsSinceEpoch,
  'exp': DateTime.now().millisecondsSinceEpoch + 60 * 60 * 4 * 1000
};

//1- get the data of transaction and convert to token
String createToken() {
  String token = "";

  SecretKey key = SecretKey(secret);
  final jwt = JWT(
    data,
  );
  token = jwt.sign(key);

  return token;
}

// 2- get the token and create the transaction id
Future<String?> transAction(String token,[String language = "ar"]) async {
  // const String requestUrl = 'https://test.zaincash.iq/transaction/pay?id=';
  final Map<String, dynamic> postData = {
    'token': token,
    'merchantId': merchantId,
    'lang': language, // ZC support 3 languages ar, en, ku
  };
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  final http.Response response = await http.post(
    Uri.parse(initUrl),
    headers: headers,
    body: jsonEncode(postData),
  );
  
  if (response.statusCode == 200) {
    final String responseBody = response.body;
    final String operationId = jsonDecode(responseBody)['id'];
    return operationId;
  
  } else {
    Logger().e('body ${response.body}');
  }
  return null;
}
