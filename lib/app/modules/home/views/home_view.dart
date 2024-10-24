import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/appcolor.dart';
import '../../../data/widget_background.dart';
import 'create_task_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key); // Added const constructor

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    
    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(isEdit: false),
            ),
          );
          if (result != null && result) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task has been created'),
            ));
            setState(() {});
          }
        },
        backgroundColor: appColor.colorTertiary,
      ),
    );
  }

  Widget _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return SizedBox(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Todo List',
              style: Theme.of(context).textTheme.titleLarge, // Updated deprecated title
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('tasks').orderBy('date').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length, // Updated documents to docs
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> task = document.data() as Map<String, dynamic>; // Updated data access
                    String strDate = task['date'] as String;
                    
                    return Card(
                      child: ListTile(
                        title: Text(task['name'] as String),
                        subtitle: Text(
                          task['description'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: appColor.colorSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${int.parse(strDate.split(' ')[0])}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              strDate.split(' ')[1],
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              bool? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateTaskScreen(
                                    isEdit: true,
                                    documentId: document.id,
                                    name: task['name'] as String,
                                    description: task['description'] as String,
                                    date: task['date'] as String,
                                  ),
                                ),
                              );
                              if (result != null && result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Task updated successfully')),
                                );
                              }
                            } else if (value == 'delete') {
                              // Implement delete functionality
                              await firestore.collection('tasks').doc(document.id).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Task deleted successfully')),
                              );
                            }
                          },
                          child: const Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}