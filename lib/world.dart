import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends State<World> {
  final String url = "https://corona.lmao.ninja/v2/countries";
  Future<List> datas;
  Future<List> getData() async {
    var response = await Dio().get(url); 
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    datas = getData();
  }

  Future showCard(String cases, deaths, today) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                "Nombre total de Cas: $cases",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              Text(
                "Nombre total de morts: $deaths",
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
              Text("Nouveaux cas d'aujourd'hui: $today",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques par pays'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: datas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0),
                itemCount: 207,
                itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: () => showCard(
                          snapshot.data[index]['cases'].toString(),
                          snapshot.data[index]['deaths'].toString(),
                          snapshot.data[index]['todayDeaths'].toString()),
                      child: Card(
                        child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Nombre de cas: ${snapshot.data[index]['cases'].toString()}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                ),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Image(
                                  image: AssetImage("assets/local.png"),
                                  height: 85,
                                  width: 85,
                                ),
                                Text(
                                  snapshot.data[index]['country'],
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    )),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
