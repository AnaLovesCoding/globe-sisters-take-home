import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globe_sisters_take_home_project/home_page.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key, required String title}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final _formKey = GlobalKey<FormState>();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Globe Sisters');
  TextEditingController nameController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () =>
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const HomePage(
                    title: 'Home Page',
                  ))),

        }, icon: Icon(Icons.arrow_back)),
        title: customSearchBar,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

      ),
      body: Column(
        children: [
          Expanded(
            flex: 40,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.grey[200],
                  width: 500,
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin:
                          EdgeInsets.only(left: 20, top: 20, bottom: 20),
                          child: const Text(
                            "Add Items",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      buildText('Name'),
                      buildTextField(nameController),
                      buildText('Cuisine'),
                      buildTextField(cuisineController),
                      buildText('Price'),
                      buildTextField(priceController),

                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        width: 370,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Item Added Successfully')),

                                  );

                                }
                                if(nameController.text.isEmpty || priceController.text.isEmpty || cuisineController.text.isEmpty){
                                  return;
                                }
                                else{
                                  CollectionReference items = FirebaseFirestore.instance.collection('restaurants');
                                  Future<void> addItems() {
                                    return items
                                        .add({
                                      'name': nameController.text,
                                      'cuisine': cuisineController.text,
                                      'price': priceController.text
                                    })
                                        .then((value) => print("Item Added"))
                                        .catchError((error) => print("Failed to add item: $error"));
                                  }
                                  addItems();

                                }


                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Align buildText(String fieldName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        child: RichText(
            text: TextSpan(
              text: fieldName,
              style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: const <TextSpan>[
                TextSpan(
                    text: ' * ',
                    style: TextStyle(
                      color: Colors.red,
                    ))
              ],
            )),
      ),
    );
  }

  Padding buildTextField(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: getTextField(textEditingController),
      ),
    );
  }

  TextFormField getTextField(TextEditingController textEditingController) {
    return TextFormField(
      decoration: const InputDecoration(
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
      validator: (value) {

        if (value == null || value.isEmpty) {
          return 'This Field cannot be empty';
        }
        return null;
      },
      controller: textEditingController,
    );
  }

}

