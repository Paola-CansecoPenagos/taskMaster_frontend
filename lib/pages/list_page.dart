import 'package:flutter/material.dart';
import 'edit_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatelessWidget {
  final String taskId;
  final String userId;
  final String user;

  const ListPage({Key? key, required this.taskId, required this.userId, required this.user}) : super(key: key);

  Future<Map<String, dynamic>> fetchTask() async {
    final url = Uri.parse('http://52.70.170.161:5000/api/task/list?user_id=$userId&task_id=$taskId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load task');
    }
  }
  Future<void> deleteTask(BuildContext context) async {
    final url = Uri.parse('http://52.70.170.161:5000/api/task/delete/$userId/$taskId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Si la tarea se elimina correctamente, regresar a la página anterior
      Navigator.of(context).pop();
    } else {
      // Si falla la eliminación, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la tarea')),
      );
    }
  }
    void confirmDelete(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar'),
            content: Text('¿Estás seguro de que quieres eliminar esta tarea?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo
              ),
              TextButton(
                child: Text('Eliminar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo antes de borrar
                  deleteTask(context); // Llama a la función para eliminar la tarea
                },
              ),
            ],
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / 375.0;
    double ffem = MediaQuery.of(context).size.height / 812.0;

    return Scaffold(
      body: Center( // Envuelve el cuerpo con un widget Center para centrar todo el contenido.
        child: FutureBuilder<Map<String, dynamic>>(
        future: fetchTask(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No hay datos disponibles"));
          } else {
            var task = snapshot.data!;
            return Container(
              width: 344 * fem,
              height: 426 * fem,
              child: Stack(
                children: [
                  Positioned(
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 344 * fem,
                        height: 426 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15 * fem),
                          color: Color(0xff87e2d0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0 * fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'],
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff354664),
                                ),
                              ),
                              SizedBox(height: 8 * ffem),
                              Text(
                                "${task['start_time']} - ${task['end_time']}",
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 12 * fem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xaa354664),
                                ),
                              ),
                              SizedBox(height: 8 * ffem),
                              Text(
                                'Detalles',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff354664),
                                ),
                              ),
                              SizedBox(height: 8 * ffem),
                              Text(
                                task['description'],
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 12 * fem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xaa354664),
                                ),
                              ),
                              SizedBox(height: 16 * ffem),
                              Text(
                                'Subtareas',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff354664),
                                ),
                              ),
                              ...task['subtasks'].map<Widget>((subtask) {
                                return ListTile(
                                  title: Text(subtask['name']), // Asumiendo que las subtareas tienen un campo 'name'
                                );
                              }).toList(),
                              Text(
                                'Recordatorios',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff354664),
                                ),
                              ),
                              ...task['reminders'].map<Widget>((reminder) {
                                return ListTile(
                                  title: Text(reminder['description']), // Asumiendo que los recordatorios tienen un campo 'description'
                                );
                              }).toList(),
                              SizedBox(height: 16 * ffem),
                              Text(
                                'Fecha de entrega',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15 * fem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xaa354664),
                                ),
                              ),
                              SizedBox(height: 8 * ffem),
                              Text(
                                task['deadline'],
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 12 * fem,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xaa354664),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 10 * ffem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 24 * fem),
              color: Color(0xff354664),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(userId: userId, taskId: taskId, user: user),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 24 * fem),
              color: Color(0xff354664),
              onPressed: () => deleteTask(context), // Maneja la eliminación aquí
            ),
          ],
        ),
      ),
    );
  }
}
