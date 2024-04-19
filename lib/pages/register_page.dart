import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  final double fem = 1.0;
  final double ffem = 1.0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String url = 'http://52.70.170.161:5000/api/users/register';

    final Map<String, String> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print('Email: ${emailController.text}');
    print('Response body: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      // Manejar la respuesta del servidor según tus necesidades
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registro Exitoso'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  // Navegar al LoginPage después de cerrar el diálogo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Manejar errores de la solicitud
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al registrar el usuario'),
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
          padding: EdgeInsets.fromLTRB(43 * fem, 60 * fem, 43 * fem, 157 * fem),
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xffffffff)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 71 * fem),
                child: Text(
                  'Registro',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 40 * ffem,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff354664),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30 * fem),
                padding: EdgeInsets.fromLTRB(19 * fem, 9 * fem, 19 * fem, 7 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffa9a2a2)),
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
                child: TextFormField(
                  
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20 * ffem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30 * fem),
                padding: EdgeInsets.fromLTRB(19 * fem, 9 * fem, 19 * fem, 7 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffa9a2a2)),
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20 * ffem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 104 * fem),
                padding: EdgeInsets.fromLTRB(19 * fem, 8 * fem, 19 * fem, 8 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffa9a2a2)),
                  borderRadius: BorderRadius.circular(5 * fem),
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
                    fontSize: 20 * ffem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 3 * fem),
                width: double.infinity,
                height: 44 * fem,
                decoration: BoxDecoration(
                  color: Color(0xff354664),
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
                 child: InkWell(
                  onTap: () {
                    _register(context); // Llama a la función _register para registrar al usuario
                  },
                  child: Center(
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 94 * fem),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4196a9), 
                    ),
                    children: [
                      TextSpan(
                        text: 'Ya tienes una cuenta',
                        style: TextStyle(
                          color: Color(0xffbdc2c3), 
                        ),
                      ),
                      TextSpan(
                        text: '?',
                        style: TextStyle(
                          color: Color(0xff70d9f1), 
                        ),
                      ),
                      TextSpan(
                        text: '  Inicia sesión',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Color(0xff354664), 
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 68 * fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 1 * fem, 28 * fem, 0),
                      width: 138 * fem,
                      height: 1 * fem,
                      color: Color(0xff000000),
                    ),
                    Text(
                      'O',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff354664),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(29 * fem, 1 * fem, 0, 0),
                      width: 138 * fem,
                      height: 1 * fem,
                      color: Color(0xff000000),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 44 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 39 * fem,
                      top: 7 * fem,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 30 * fem,
                          height: 30 * fem,
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
                          width: 344 * fem,
                          height: 44 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            border: Border.all(color: Color(0xffa9a2a2)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 84 * fem,
                      top: 9 * fem,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 228 * fem,
                          height: 28 * fem,
                          child: Text(
                            'Registrate con Google',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 20 * ffem,
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