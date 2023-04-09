import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globe_sisters_take_home_project/add_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String title}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Globe Sisters');
  var foodList = [];
  final List<int> colorCodes = <int>[500, 400, 300];

  @override
  void initState() {
    foodList = [];

    FirebaseFirestore.instance
        .collection("restaurants")
        .get()
        .then((querySnapShot) {
      print("Sucessfully loaded all restaurants");
      querySnapShot.docs.forEach((element) {
        print(element.data());
        foodList.add(element.data());
      });
      setState(() {});
    }).catchError((error) {
      print("Failed to load restaurants");
      print(error.toString());
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by name ....',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Globe Sisters');
                }
              });
            },
            icon: customIcon,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30, right: 40, left: 20),
        child: Column(
          children: [
            Expanded(
              flex: 70,
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30),
                  itemCount: foodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 50,
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${foodList[index]['imageUrl']}'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Name: ${foodList[index]['name']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 15),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'cuisine: ${foodList[index]['cuisine']}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.brown),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text('\$'),
                            Text('${foodList[index]['price']}'),
                            Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () {




                              },
                            ),
                          ],
                        ));
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddScreen(
                        title: 'Add Item Screen',
                      )));
        },
        child: Icon(
            Icons.add,
        ),
      ),
    );
  }

}
