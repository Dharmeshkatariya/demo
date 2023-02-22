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
      debugShowCheckedModeBanner: false,
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


    List<UserData> userList = [];
    List<UserData> searchList = [];

    final _searchController =  TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }

  _getData() async {
    var client = http.Client();
    var url = "https://jsonplaceholder.typicode.com/users";
    var uri = Uri.parse(url);
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> uList = jsonDecode(response.body);

      for (int i = 0; i < uList.length; i++) {
        Map<String, dynamic> userMap = uList[i];

        UserData userData = UserData.fromJson(userMap);
        userList.add(userData);
        print(userData);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: userList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      width: double.infinity,
                     color: Colors.green,
                      child: const Text(
                        "Business Model",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                    ),
                    _textInput(),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _searchController.text.isEmpty? userList.length : searchList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _containerData(index);
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _containerData(int index) {
    UserData userData = _searchController.text.isEmpty? userList[index] :searchList[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customText(text: "id : ${userData.id}",),
          _customText(text: "Name : ${userData.name}",),
          _customText(text: "City : ${userData.address.city}"),
          _customText(text: "Website : ${userData.website}"),
          _customText(text: "Company Name : ${userData.company.name}"),
        ],
      ),
    );
  }
  _searchData(String str){
    searchList.clear();
    if(str.isNotEmpty){
      for(int i=0;i<userList.length;i++){
        if(userList[i].name.toLowerCase().contains(str.toLowerCase())){
          searchList.add(userList[i]);
        }
      }
      setState(() {

      });
    }
  }

  Widget _customText({String? text}) {
    return Text(
      text!,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white,),
    );
  }

  Widget _textInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: TextField(
        onChanged: (value){
          _searchData(value);
        },
        controller: _searchController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            suffixIcon:const Icon(Icons.search,color: Colors.green,),
            hintText: "Search name",
            labelText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )),
      ),
    );
  }
}
