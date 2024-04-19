import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String url = 'http://52.70.170.161:5000/api/users/login';

    final Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String user = responseData['user'];
      final String userId = responseData['user_id'];
      // Navegar a HomePage con los datos del usuario
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user, userId: userId),
        ),
      );
    } else {
      // Manejar errores de la solicitud
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error en el inicio de sesión'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(43, 60, 43, 157),
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xffffffff)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(1, 0, 0, 71),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    height: 1.3625,
                    color: Color(0xff354664),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                padding: EdgeInsets.fromLTRB(19, 9, 19, 7),
                width: 305,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffa9a2a2)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 104),
                padding: EdgeInsets.fromLTRB(19, 8, 19, 8),
                width: 305,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffa9a2a2)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(0xff354664),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    _login(context); // Llama a la función _login para iniciar sesión
                  },
                  child: Center(
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 168),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No tienes una cuenta? ',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffbcc1c3),
                        ),
                      ),
                      TextSpan(
                        text: 'Registrate',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff354664),
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 68),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 1, 28, 0),
                      width: 138,
                      height: 1,
                      color: Color(0xff000000),
                    ),
                    Text(
                      'O',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff354664),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(29, 1, 0, 0),
                      width: 138,
                      height: 1,
                      color: Color(0xff000000),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 44,
                child: Stack(
                  children: [
                    Positioned(
                      left: 39,
                      top: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'assets/images/google_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 344,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color(0xffa9a2a2)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 84,
                      top: 9,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 228,
                          height: 28,
                          child: Text(
                            'Inicia sesión con Google',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff354664),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
