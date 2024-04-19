import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatelessWidget {
  final String userId;

  const NotificationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NotificationsContent(userId: userId),
      ),
    );
  }
}

class NotificationsContent extends StatefulWidget {
  final String userId;

  const NotificationsContent({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationsContentState createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    var url = Uri.parse('http://52.70.170.161:5000/api/notifications/list?user_id=${widget.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        notifications = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to load notifications'); // Manejar el error
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: isLoading
      ? Center(child: CircularProgressIndicator())
      : notifications.isEmpty
          ? Center(child: Text("No hay notificaciones"))
          : Center( 
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // limita el ancho
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // centra las notificaciones verticalmente
                  children: [
                    Flexible( // hace que el ListView se adapte al tamaño de su contenido
                      child: ListView.builder(
                        shrinkWrap: true, // limita el ListView a su contenido inmediato
                        physics: NeverScrollableScrollPhysics(), // deshabilita el scroll dentro del ListView
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 8), // Espacio entre cada notificación
                            decoration: BoxDecoration(
                              color: Color(0xff87e2d0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              notifications[index]['message'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff354664),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
  );
}


}
