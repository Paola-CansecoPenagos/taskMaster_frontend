import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'list_page.dart';
import 'creation_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Task>> fetchTasks(String userId) async {
  final url = Uri.parse('http://52.70.170.161:5000/api/tasks/list?user_id=$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<Task> tasks = (json.decode(response.body) as List)
        .map((data) => Task.fromJson(data))
        .toList();
    return tasks;
  } else {
    throw Exception('Failed to load tasks');
  }
}
class Task {
  final String title;
  final String startTime;
  final String endTime;
  final String taskId;

  Task({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.taskId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      taskId: json['id'], // Asegúrate de que este campo coincida con tu modelo de datos.
    );
  }
}

class HomePage extends StatelessWidget {
  final String user;
  final String userId;
  
  const HomePage({required this.user, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.15,
              child: Text(
                user,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff354664),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.22,
              child: Container(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.015, screenWidth * 0.04, screenHeight * 0.014),
                width: screenWidth * 0.9, // Aumento del ancho del contenedor para dar más espacio
                height: screenHeight * 0.1, // Aumento de la altura para asegurarse de que el contenido vertical tenga espacio
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff87e2d0)),
                  color: Color(0xff87e2d0),
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Asegura que los elementos se distribuyan de forma uniforme
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox( // Ajusta el texto para evitar el desbordamiento
                            fit: BoxFit.scaleDown, // Escala el texto para que se ajuste al espacio disponible
                            child: Text(
                              'Crear nueva tarea',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff354664),
                              ),
                            ),
                          ),
                          Text(
                            'Crea tu tarea aquí',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w600,
                              color: Color(0xaa354664),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreationPage(userId: userId, user: user),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          color: Color(0xaa354664),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: screenWidth * 0.06, // Ligeramente reducido para adaptarse al espacio
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.33,
              child: FutureBuilder<List<Task>>(
                future: fetchTasks(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No hay tareas disponibles");
                  } else {
                    return SizedBox(
                      width: screenWidth * 0.9,
                      // No establecemos una altura fija para que el tamaño dependa del contenido
                      child: ListView.builder(
                        shrinkWrap: true, // Para que ListView ocupe el tamaño de sus hijos
                        physics: NeverScrollableScrollPhysics(), // Para evitar el scroll en el ListView
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Task task = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListPage(taskId: task.taskId, userId: userId, user: user,),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.015, screenWidth * 0.045, screenHeight * 0.016),
                              margin: EdgeInsets.only(bottom: screenHeight * 0.015), // Añade un margen entre elementos
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff87e2d0)),
                                color: Color(0xff87e2d0),
                                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          task.title, // Título de la tarea
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff354664),
                                          ),
                                        ),
                                        Text(
                                          "${task.startTime} - ${task.endTime}", // Horario de la tarea
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: screenWidth * 0.03,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xaa354664),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Color(0xff354664),
                                    size: screenWidth * 0.08,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),


            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.12,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.03,
                  child: Text(
                    'Hola',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff354664),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.9,
              top: screenHeight * 0.05,
              child: IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: screenWidth * 0.08,
                  color: Colors.black,
                ),
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(userId: userId),
                ),
              );
            },
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.05,
              child: IconButton(
                icon: Icon(Icons.menu),
                iconSize: screenWidth * 0.08,
                onPressed: () {
                },
              ),
            ),

         //////////aqui va
          ],
        ),
      ),
    );
  }
}
