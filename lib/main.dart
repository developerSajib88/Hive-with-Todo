import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("Database");
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  Box? database;
  final TextEditingController _getData = TextEditingController();
  final TextEditingController _updateData = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var updatekey = GlobalKey<FormState>();


  editDialog(BuildContext context, int getindex){
    return showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),

                ),

                child: Form(
                  key: updatekey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _updateData,
                        decoration: InputDecoration(
                          label: const Text("Enter Updated Data"),
                          border:  OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Colors.green,width: 3.0)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Colors.green,width: 3.0)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Colors.green,width: 3.0))
                        ),
                        validator: (value){
                          if(value!.isEmpty)return "Plese give some Input";
                        },
                      ),

                      const SizedBox(height: 20.0,),

                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                            onPressed: (){
                              if(updatekey.currentState!.validate()) {
                                database!.putAt(getindex, _updateData.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("UPDATE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
                        ),
                      ),

                    ],

                  ),
                ),

              ),
            ),
          );
        }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = Hive.box("Database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO with Hive"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _getData,
                    decoration: const InputDecoration(
                      enabled: true,
                      label: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Enter Your Data"),
                      ),
                      labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w800),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 3.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 3.0),
                      ),
                    ),
                    

                    validator: (value){

                      if(value!.isEmpty) {
                        return "Please Enter Data";
                      }
                    },

                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                        onPressed: (){
                          print(_getData.text);
                          var isValid = formKey.currentState!.validate();
                          if(isValid)database!.add(_getData.text);_getData.clear();

                        },
                        child: const Text("SUBMIT",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                        ),
                    ),
                  ),

                  const SizedBox(height: 10.0,),

                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box("Database").listenable(),
                      builder: (context,box,widget){
                        return ListView.builder(
                            itemCount: database!.keys.toList().length,
                            itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Card(
                                  child: ListTile(
                                    title: Text(box.getAt(index)),
                                    trailing: SizedBox(
                                      width: 100.0,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              editDialog(context, index);
                                            },
                                            icon: const Icon(Icons.edit_rounded),
                                          ),

                                          IconButton(
                                            onPressed: (){
                                              database!.deleteAt(index);
                                            },
                                            icon: const Icon(Icons.delete),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              );
                            }
                        );
                      },

                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

