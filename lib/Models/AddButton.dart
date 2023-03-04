import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  AddButton(Function this.func);
  final Function func;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ElevatedButton.icon(onPressed: func,
        icon: Icon(
          Icons.add,
          color: Colors.green,
          size: 40,
        ),
        label: Text('Add',style: TextStyle(fontSize: 25),),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.black; // Defer to the widget's default.
              },
            ),
            minimumSize: MaterialStateProperty.resolveWith<Size>(
                  (Set<MaterialState> states) {
                return Size(60, 60); // Defer to the widget's default.
              },
            )
        ),
      ),
    );
  }
}
