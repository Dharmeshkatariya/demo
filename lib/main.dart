import 'dart:convert';
import 'package:apidata/model/userdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }
  _getData()async{

    var client = http.Client();
    var url = "https://jsonplaceholder.typicode.com/users";
    var uri = Uri.parse(url);
    var response = await client.get(uri);

    if(response.statusCode == 200){
      List<dynamic> uList = jsonDecode(response.body);

      for(int i=0;i<uList.length;i++){
        Map<String,dynamic> userMap = uList[i];
        print(userMap);
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Container(),

    );
  }
}
