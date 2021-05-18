import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestData extends StatefulWidget {
  @override
  _TestDataState createState() => _TestDataState();
}

class _TestDataState extends State<TestData> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("app")),
        body: ListView(
          padding: EdgeInsets.all(24),
          children: <Widget>[
            DateTimeForm(),
          ],
        ));
  }
}

class DateTimeForm extends StatefulWidget {
  @override
  _DateTimeFormState createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BasicDateField(),
          SizedBox(height: 24),
          RaisedButton(
            child: Text('Save'),
            onPressed: () => formKey.currentState.save(),
          ),
          RaisedButton(
            child: Text('Reset'),
            onPressed: () => formKey.currentState.reset(),
          ),
          RaisedButton(
            child: Text('Validate'),
            onPressed: () => formKey.currentState.validate(),
          ),
        ],
      ),
    );
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}

