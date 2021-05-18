import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateStartField extends StatefulWidget {
  @override
  _DateStartFieldState createState() => _DateStartFieldState();
}

class _DateStartFieldState extends State<DateStartField> {
  final format = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('เลือกวันที่เริ่มวิ่ง'),
      Container(
        padding: EdgeInsets.all(10),
        child: DateTimeField(
          format: format,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ),
      ),
    ]);
  }
}

class DateEndField extends StatefulWidget {
  @override
  _DateEndFieldState createState() => _DateEndFieldState();
}

class _DateEndFieldState extends State<DateEndField> {
  final format = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('เลือกวันที่สิ้นสุดการวิ่ง'),
      Container(
        padding: EdgeInsets.all(10),
        child: DateTimeField(
          format: format,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ),
      ),
    ]);
  }
}

