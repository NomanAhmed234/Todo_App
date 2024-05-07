import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/api_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();
  String? nameS;

  Future<List<ApiModel>> getApi() async {
    var url = Uri.parse(
        "https://crudcrud.com/api/65d019e259e0440999805e8bcafd5015/unicorns");
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
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: FutureBuilder(
          future: getApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print("Error:${snapshot.error}");
              return Text("Error:${snapshot.error}");
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Enter text',
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
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, int index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index].name.toString()),
                              subtitle: Row(
                                children: [
                                  Text(snapshot.data![index].sId.toString()),
                                  Text(snapshot.data![index].age.toString()),
                                ],
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
                                            title: Text('Delete Task'),
                                            content: Text(
                                                'Do you want to delete Your task.'),
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
                                                child: Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete),
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
                                    icon: Icon(Icons.new_label),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else
              return Text("No Data");
          }),
      floatingActionButton: ElevatedButton(
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
          child: Icon(Icons.add)),
    );
  }
}

Future<void> deleteItem(String id) async {
  var url = Uri.parse(
      "https://crudcrud.com/api/65d019e259e0440999805e8bcafd5015/unicorns/$id");

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
      "https://crudcrud.com/api/65d019e259e0440999805e8bcafd5015/unicorns");

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
      "https://crudcrud.com/api/65d019e259e0440999805e8bcafd5015/unicorns$id");

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
