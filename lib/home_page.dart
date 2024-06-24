import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:list_random_user/user_model.dart';
import 'package:list_random_user/detail_page.dart';


String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

List<User> users=[];

Future<List<User>> userDetails() async {
  if (users.length == 0) {
    var dataFromURL = await http.get(Uri.parse("https://randomuser.me/api/?results=20"),);
    var jsonData = json.decode(dataFromURL.body);
    print(jsonData['results'][0]['email']);
    int index = 0;
    for (var user in jsonData['results']) {
      User data = User(
          index: index,
          titel: user['name']['title'],
          email: user['email'],
          fname: user['name']['first'],
          lname: user['name']['last'],
          phone: user['phone'],
          pictureLarge: user['picture']['large'],
          pictureSmall: user['picture']['medium'],
          gender: user['gender'],
          dob:user['dob']['date'],
          );
      users.add(data);
      index++;
    }
  }
  return users;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  _reload() async {
    users=[];
    setState(() {});
  }

//mengklasifikasikan icon untuk men dan women
  String menOrWomen(gender){
    String imageURL = "";
    if(gender=="male"){
      imageURL = 'images/man.png';
    }else{
      imageURL = 'images/businesswoman.png';
    }
    return imageURL;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Daftar User Random"),
        centerTitle: false,
      ),
      body: new Container(
        child: new FutureBuilder(
          future: userDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    leading: new Hero(
                      tag: "image$index",
                      child: CircleAvatar(
                        backgroundImage:
                            new NetworkImage(snapshot.data[index].pictureSmall),
                      ),
                    ),
                    title: new Text(
                      capitalize(snapshot.data[index].titel) + ". " + capitalize(snapshot.data[index].fname) + " " + capitalize(snapshot.data[index].lname),
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: new Text(snapshot.data[index].email),
                    trailing: new SizedBox(
                      height: 20.0,
                      child: new Image.asset(menOrWomen(snapshot.data[index].gender)),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              Details(snapshot.data[index], index),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Reload",
        child: new Icon(Icons.refresh),
        onPressed: () {
          _reload();
        },
      ),
    );
  }
}