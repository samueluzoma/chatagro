import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CrudOperation(),
    );
  }
}

class CrudOperation extends StatefulWidget {
  const CrudOperation({super.key});

  @override
  State<CrudOperation> createState() => _CrudOperationState();
}

class _CrudOperationState extends State<CrudOperation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //instantiate the firebase firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //String documentName = 'sam'; Given the document/table a name

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//initializing the variables
  String studentName = "";
  String studentID = "";
  String programID = "";
  double studentGPA = 0;
  //Function for declaring the above variables
  getStudentName(name) {
    studentName = name;
  }

  getStudentID(id) {
    studentID = id;
  }

  getProgramID(programid) {
    programID = programid;
  }

  getStudentGPA(gpa) {
    studentGPA = double.parse(gpa);
  }

  //the create method for the database
  createData() async {
    print('Create button is clicked');
    try {
      await firestore
          .collection('My College')
          .doc(studentName)
          . //TARGETING THE DOUCMENT AND GIVEN THE TABLE A NAME
          set({
        "studentName": studentName,
        "studentID": studentID,
        "programID": programID,
        "studentGPA": studentGPA,
      });
      print('Record added successfully');
    } catch (e) {
      print('Error adding record: $e');
    }
  }

  //Reading data record from the firebase database
  Future<void> readData() async {
    try {
      var docSnapshot =
          await firestore.collection('My College').doc(studentName).get();
      if (docSnapshot.exists) {
        var docData = docSnapshot.data()!;
        print(docData); //THIS PRINT ALL FIELDS IN DOCUMENT
        print(docData['programID']); //THIS PRINT SINGLE FIELDS IN DOCUMENT
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('An error has occured: $e');
    }
  }

  //the update method for the database
  Future<void> updateData() async {
    print('The up button is clicked');
    try {
      await firestore
          .collection('My College')
          .doc(studentName)
          . //TARGETING THE DOUCMENT AND GIVEN THE TABLE A NAME
          set({
        "studentName": studentName,
        "studentID": studentID,
        "programID": programID,
        "studentGPA": studentGPA,
      });
      print('Record updated successfully');
    } catch (e) {
      print('Error updating record: $e');
    }
  }

  Future<void> deleteData() async {
    try {
      var docDelete = firestore.collection('My College').doc(studentName);
      //check if the document exist before deleting them
      var docSnapShot = await docDelete.get();
      if (docSnapShot.exists) {
        //Delete document
        await docDelete.delete();
        print('$studentName is deleted successfully');
      } else {
        print('Record not found in the collection');
      }
    } catch (e) {
      print('$studentName is not deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Crud Operation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String id) {
                    getStudentID(id);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Study Program ID',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String programid) {
                    getProgramID(programid);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Student GPA',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (String gpa) {
                    getStudentGPA(gpa);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        createData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 12,
                          )),
                      child: const Text(
                        'create',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        readData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            fontSize: 12,
                          )),
                      child: const Text(
                        'Read',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 90,
                      child: ElevatedButton(
                        onPressed: () {
                          deleteData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('My College').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading data'),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot documentSnapshot = snapshot
                                      .data!.docs[
                                  index]; // the ! operator makes for a non null data
                              String studentName =
                                  documentSnapshot['studentName'] ?? 'N/A';
                              String studentID =
                                  documentSnapshot['studentID'] ?? 'N/A';
                              String programID =
                                  documentSnapshot['programID'] ?? 'N/A';
                              String studentGPA =
                                  documentSnapshot['studentGPA']?.toString() ??
                                      'N/A';

                              return ListTile(
                                title: Text('Name: $studentName'),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Student tID: $studentID'),
                                    Text(' Program ID: $programID'),
                                    Text(' GPA: $studentGPA'),
                                  ],
                                ),
                                // You can customize the ListTile as per your requirements
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
