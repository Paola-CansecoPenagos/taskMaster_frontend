import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fem = 1;
    double ffem = fem;
    double fontSize = 12 * fem; // Tamaño de fuente inicial
    int selectedDay = 12;
    void previousMonth() {}
    void nextMonth() {}

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16 * fem),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: previousMonth,
                ),
                Text(
                  'abril 2024',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: nextMonth,
                ),
              ],
            ),
            SizedBox(height: 20 * fem),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              childAspectRatio: 1.5,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: List.generate(30, (index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedDay == index + 1 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: selectedDay == index + 1 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize, // Aplicar tamaño de fuente aquí
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
