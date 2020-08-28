import 'dart:convert';

import 'package:covid/world.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Tcases.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://corona.lmao.ninja/v2/all";

  Future<Tcases> getJsonData() async {
    var response = await http.get(
        //response avoir des données et decodejson je veux completer le body de api
        Uri.encodeFull(url) //notre url
        );
    if (response.statusCode == 200) {
      final convertJsonData = jsonDecode(response.body);
      return Tcases.fromJson(convertJsonData);
    } else {
      throw Exception("Essayez d'actualiser à nouveau");
    }
  }

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  navigateToCountry() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => World(),
        ));
  }

  navigateToUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Text("Le lien $url n'est pas accessible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 News'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.black,
      body: Container(
          child: Center(
        child: ListView(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Text(
                    "Restez",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Card(
                    color: Colors.red,
                    child: Text(
                      "Chez Vous",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Les Statistiques globales du Covid-19",
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
                child: Card(
                    color: Colors.white,
                    child: ListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Cas Total ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "          Morts Total ",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "     Nouveaux Cas ",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )))),
            FutureBuilder<Tcases>(
              future: getJsonData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final covid = snapshot.data;
                  return Column(
                    children: [
                      Card(
                          color: Colors.black12,
                          child: ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${covid.cases}",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${covid.deaths}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${covid.todayCases}",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )))
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else
                  return CircularProgressIndicator();
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Card(
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(9)),
                          Image(
                            image: AssetImage("assets/globe.png"),
                            height: 90,
                            width: 90,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          OutlineButton(
                              onPressed: () => navigateToCountry(),
                              borderSide: BorderSide(color: Colors.yellow),
                              child: Text('Statistiques par pays',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold))),
                        ],
                      )),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(9)),
                        Image(
                          image: AssetImage("assets/fr.png"),
                          height: 90,
                          width: 90,
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        OutlineButton(
                            onPressed: () => navigateToUrl(
                                "http://www.leparisien.fr/coronavirus/"),
                            borderSide: BorderSide(color: Colors.yellow),
                            child: Text('Actualités',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold)))
                      ],
                    )),
                  ),
                ),
              ],
            )),
            Padding(padding: EdgeInsets.only(top: 8)),
            Card(
              color: Colors.blue,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Image(
                      image: AssetImage("assets/oms.png"),
                      height: 120,
                      width: 120,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    OutlineButton(
                        onPressed: () => navigateToUrl(
                            "https://www.who.int/fr/emergencies/diseases/novel-coronavirus-2019"),
                        borderSide: BorderSide(color: Colors.white),
                        child: Text('OMS',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
