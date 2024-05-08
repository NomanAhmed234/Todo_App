import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/api_model.dart';
import 'package:todo_app/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();

  String? nameS;
  bool onClick1 = false;
  bool onClick2 = true;
  bool onClick3 = true;
  bool text = true;

  Future<List<ApiModel>> getApi() async {
    var url = Uri.parse(
        "https://crudcrud.com/api/35a4610f1f844a0baddaa4e8199471ba/unicorns");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);

      List<ApiModel> apiModels =
          responseBody.map((json) => ApiModel.fromJson(json)).toList();

      return apiModels;
    } else {
      throw Exception('Failed to load API: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.blue,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: CustomColor.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            Text("Set Daily Task"),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: CustomColor.pink,
                ),
              );
            } else if (snapshot.hasError) {
              print("Error:${snapshot.error}");
              return Text("Error:${snapshot.error}");
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  onClick1 = !onClick1;
                                  onClick2 = true;
                                  onClick3 = true;
                                });
                              },
                              child: Card(
                                color:
                                    onClick1 ? Colors.white : CustomColor.pink,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "Recent",
                                    style: TextStyle(
                                      color: onClick1
                                          ? CustomColor.blue
                                          : Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  onClick2 = !onClick2;
                                  onClick1 = true;
                                  onClick3 = true;
                                });
                              },
                              child: Card(
                                color:
                                    onClick2 ? Colors.white : CustomColor.pink,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "Sort",
                                    style: TextStyle(
                                      color: onClick2
                                          ? CustomColor.blue
                                          : Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  onClick3 = !onClick3;
                                  onClick1 = true;
                                  onClick2 = true;
                                });
                              },
                              child: Card(
                                color:
                                    onClick3 ? Colors.white : CustomColor.pink,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "Normal",
                                    style: TextStyle(
                                      color: onClick3
                                          ? CustomColor.blue
                                          : Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CustomColor.blue,
                          hintText: "Add task",
                          hintStyle: TextStyle(color: CustomColor.lightblue),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColor.lightblue),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 3, right: 5, left: 5),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.data![index].name.toString(),
                                style: TextStyle(
                                    color: CustomColor.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: CustomColor.blue,
                                            title: Text(
                                              'Delete Task',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: Text(
                                              'Do you want to delete Your task.',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleteItem(snapshot
                                                        .data![index].sId
                                                        .toString());
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .lightblue),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .lightblue),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: CustomColor.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        nameS = snapshot.data![index].sId
                                            .toString();
                                        Map<String, dynamic> newData = {
                                          'name': nameS,
                                          'age': 35,
                                          'email': 'updated@example.com'
                                        };
                                        updateItem(
                                            snapshot.data![index].sId
                                                .toString(),
                                            newData);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: CustomColor.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            } else
              return Text("No Data");
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.pink,
        onPressed: () {
          setState(() {
            nameS = name.text;
            name.clear();
            Map<String, dynamic> data = {
              'name': nameS,
              'age': 30,
              'email': 'john@example.com'
            };

            postData(data);
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

Future<void> deleteItem(String id) async {
  var url = Uri.parse(
      "https://crudcrud.com/api/35a4610f1f844a0baddaa4e8199471ba/unicorns/$id");

  try {
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Item deleted successfully');
    } else {
      print('Failed to delete item: ${response.statusCode}');
    }
  } catch (error) {
    print('Failed to delete item: $error');
  }
}

Future<void> postData(Map<String, dynamic> data) async {
  var url = Uri.parse(
      "https://crudcrud.com/api/35a4610f1f844a0baddaa4e8199471ba/unicorns");

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      SnackBar(
        content: Text('This is a Snackbar'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      print('Data posted successfully');
    } else {
      print('Failed to post data: ${response.statusCode}');
    }
  } catch (error) {
    print('Failed to post data: $error');
  }
}

Future<void> updateItem(String id, Map<String, dynamic> newData) async {
  var url = Uri.parse(
      "https://crudcrud.com/api/35a4610f1f844a0baddaa4e8199471ba/unicorns$id");

  try {
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newData),
    );

    if (response.statusCode == 200) {
      print('Item updated successfully');
    } else {
      print('Failed to update item: ${response.statusCode}');
    }
  } catch (error) {
    print('Failed to update item: $error');
  }
}
