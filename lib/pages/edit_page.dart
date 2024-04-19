import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'alarm_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final String userId;
  final String taskId;
  final String user;

  EditPage({required this.userId, required this.taskId, required this.user});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> fetchTask() async {
    var url = Uri.parse('http://52.70.170.161:5000/api/task/list?user_id=${widget.userId}&task_id=${widget.taskId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      titleController.text = data['title'];
      deadlineController.text = data['deadline'];
      labelController.text = data['label'];
      descriptionController.text = data['description'];
      typeController.text = data['type'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load task'))
      );
    }
  }

  Future<void> updateTask(BuildContext context) async {
    var url = Uri.parse('http://52.70.170.161:5000/api/task/edit');
    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "user_id": widget.userId,
        "task_id": widget.taskId,
        "title": titleController.text,
        "start_time": "",
        "end_time": "",
        "label": labelController.text,
        "description": descriptionController.text,
        "type": typeController.text,
        "deadline": deadlineController.text,
        "subtasks": [],
        "reminders": []
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId, user: widget.user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede guardar la tarea'))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; 
    double ffem = 1.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 932 * fem,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 0 * fem,
              top: 0 * fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(19 * fem, 18 * fem, 32 * fem, 18 * fem),
                width: 480 * fem,
                height: 80 * fem,
                color: Color(0xff87e2d0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back, size: 20 * fem),
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 32 * fem,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff354664),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Titulo de la tarea',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero, // Remove padding
                          isDense: true, // Important to align with the icons
                        ),
                        controller: titleController, // You might want to initialize this controller with a default value or from the state management solution of your choice.
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Positioned(
              left: 60 * fem,
              top: 102 * fem,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15 * fem),
                        ),
                        child: CalendarPage(),
                      );
                    },
                  );
                },
                child: Container(
                  width: 243 * fem,
                  height: 30 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_today, size: 30 * fem),
                      SizedBox(width: 20 * fem),
                      Expanded(
                      child: TextFormField(
                        
                        controller: deadlineController,
                        decoration: InputDecoration(
                          hintText: '12 de abril del 2024',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: 20 * fem,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff354664).withOpacity(0.5),
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Positioned(
              left: 60 * fem,
              top: 165 * fem,
              child: Container(
                width: 231 * fem,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.label, size: 36.5 * fem),
                    SizedBox(width: 20 * fem),
                    Expanded(
                      child: TextFormField(
                      controller: labelController,
                      decoration: InputDecoration(
                        hintText: 'Añade etiquetas',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 20 * fem,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff354664).withOpacity(0.5),
                        ),
                      ), 
                    ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 60 * fem,
              top: 251 * fem,
              child: Container(
                width: 170 * fem,
                height: 31 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.description, size: 30 * fem),
                    SizedBox(width: 20 * fem),
                    Expanded(
                      child: TextFormField(
                        
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Descripción',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 20 * fem,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff354664).withOpacity(0.5),
                        ),
                      ), 
                    ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 60 * fem,
              top: 326 * fem,
              child: Container(
                width: 101 * fem,
                height: 31 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.flag, size: 30 * fem),
                    SizedBox(width: 20 * fem),
                    Expanded(
                      child: TextFormField(
                      controller: typeController,
                      decoration: InputDecoration(
                        hintText: 'Tipo',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 20 * fem,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff354664).withOpacity(0.5),
                        ),
                      ), 
                    ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
            left: 0 * fem,
            top: 381 * fem,
            child: Container(
              padding: EdgeInsets.fromLTRB(60 * fem, 21 * fem, 30 * fem, 29 * fem),
              width: 430 * fem,
              height: 193 * fem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.subdirectory_arrow_right, size: 30 * fem), // Cambiado a Icono de Flutter
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 10 * fem, 0 * fem),
                              width: 22 * fem,
                              height: 22 * fem,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff354664)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Subtarea 1',
                                style: TextStyle(
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff354664),
                                ),
                              ),
                            ),
                            Icon(Icons.close, size: 20 * fem), 
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * fem),
                ],
              ),
            ),
          ),
          Positioned(
            left: 30 * fem,
            top: 381 * fem,
            child: Container(
              padding: EdgeInsets.fromLTRB(60 * fem, 21 * fem, 30 * fem, 29 * fem),
              width: 430 * fem,
              height: 193 * fem, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 40 * fem), 
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 10 * fem, 0 * fem),
                              width: 22 * fem,
                              height: 22 * fem,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff354664)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Subtarea 2',
                                style: TextStyle(
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff354664),
                                ),
                              ),
                            ),
                            Icon(Icons.close, size: 20 * fem), 
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
            Positioned(
              left: 30 * fem,
              top: 381 * fem, 
              child: Container(
                padding: EdgeInsets.fromLTRB(60 * fem, 21 * fem, 30 * fem, 29 * fem),
                width: 430 * fem,
                height: 193 * fem, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80 * fem), 
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                width: 22 * fem,
                                height: 22 * fem,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff354664)),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Subtarea 3',
                                  style: TextStyle(
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff354664),
                                  ),
                                ),
                              ),
                              Icon(Icons.close, size: 20 * fem), 
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 120 * fem, 
              top: 530 * fem, 
              child: GestureDetector(
                onTap: () {
                  // Lógica para añadir una nueva subtarea
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 57 * fem, 0 * fem),
                  child: Text(
                    'añadir subtarea',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w400,
                      color: Color(0xcc354664),
                    ),
                  ),
                ),
              ),
            ),
                        Positioned(
              left: 60 * fem,
              top: 595 * fem,
              child: GestureDetector(
                onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15 * fem),
                      ),
                      child: AlarmPage(), 
                    );
                  },
                );
              },
              child: Container(
                width: 244 * fem,
                height: 31 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.alarm, size: 30 * fem),
                    SizedBox(width: 20 * fem),
                    Text(
                      'Añadir recordatorio',
                      style: TextStyle(
                        fontSize: 20 * fem,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff354664),
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),

            Positioned(
              left: 60 * fem,
              top: 673 * fem,
              child: GestureDetector(
                onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15 * fem),
                      ),
                      child: AlarmPage(), 
                    );
                  },
                );
              },
              child: Container(
                width: 259 * fem,
                height: 30 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.timer, size: 30 * fem),
                    SizedBox(width: 20 * fem),
                    Text(
                      '12:00 p.m - 12:30 p.m',
                      style: TextStyle(
                        fontSize: 20 * fem,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff354664),
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
            Positioned(
              left: 43 * fem,
              top: 735 * fem,
              child: InkWell(
                onTap: () => updateTask(context),
                child: Container(
                  width: 344 * fem,
                  height: 44 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xff354664),
                    borderRadius: BorderRadius.circular(5 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Guardar tarea',
                      style: TextStyle(
                        fontFamily: 'Open Sans', // Asegúrate de haber cargado esta fuente en tu proyecto
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Positioned(
  // line71tS (2039:2205)
  left:  0*fem,
  top:  155*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line8inr (2039:2206)
  left:  0*fem,
  top:  230*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line93q8 (2039:2207)
  left:  0*fem,
  top:  305*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line10BwL (2039:2208)
  left:  0*fem,
  top:  380*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line12ucS (2039:2209)
  left:  0*fem,
  top:  649*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line13doL (2039:2210)
  left:  0*fem,
  top:  724*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),
Positioned(
  // line11ksx (2039:2211)
  left:  0*fem,
  top:  574*fem,
  child:  
Align(
  child:  
SizedBox(
  width:  430*fem,
  height:  1*fem,
  child:  
Container(
  decoration:  BoxDecoration (
    color:  Color(0xff87e2d0),
  ),
),
),
),
),

          ],
        ),
      ),
    );
  }
}
