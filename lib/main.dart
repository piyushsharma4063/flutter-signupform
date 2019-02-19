import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Simple Form',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      home: new SignUpForm(),
    );
  }
}


class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() => new SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  String _name = '';
  String _email = '';
  int _age = 0;
  String _password = '';
  int _selectedGender = 0;
  String _maritalStatus = 'single';
  bool _termsChecked = true;

  List<DropdownMenuItem<int>> genderList = [];

  void loadGenderList() {
    genderList = [];

    genderList.add(new DropdownMenuItem(
      child: new Text("Male"),
      value: 0,
    ));

    genderList.add(new DropdownMenuItem(
      child: new Text("Female"),
      value: 1,
    ));

    genderList.add(new DropdownMenuItem(
      child: new Text("Others"),
      value: 2,
    ));
  }

  void onPressedSubmit() {
    if (_formKey.currentState.validate() && _termsChecked) {
      _formKey.currentState.save();

      print("Name " + _name);
      print("Email " + _email);
      print("Age " + _age.toString());
      switch (_selectedGender) {
        case 0:
          print("Gender Male");
          break;
        case 1:
          print("Gender Female");
          break;
        case 2:
          print("Gender Others");
          break;
      }
      print("Marital Status " + _maritalStatus);
      print("Password " + _password);
      print("Termschecked " + _termsChecked.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Form Submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    return new Scaffold(
      appBar: AppBar(
        title: Text('Flutter Simple Form'),
      ),
      body: Form(
        key: _formKey,
        child: new ListView(
          children: getFormWidget(),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new TextFormField(
        decoration: InputDecoration(labelText: 'Enter Name', hintText: 'Name'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter a name';
          }
        },
        onSaved: (value) {
          setState(() {
            _name = value;
          });
        }));

    formWidget.add(new TextFormField(
        decoration:
            InputDecoration(labelText: 'Enter Email', hintText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        onSaved: (value) {
          setState(() {
            _email = value;
          });
        }));

    formWidget.add(new TextFormField(
        decoration: InputDecoration(labelText: 'Enter Age', hintText: 'Age'),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Age';
          }
        },
        onSaved: (value) {
          setState(() {
            _age = int.tryParse(value);
          });
        }));

    formWidget.add(new TextFormField(
        key: _passKey,
        obscureText: true,
        decoration:
            InputDecoration(labelText: 'Enter Password', hintText: 'Password'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Password';
          }
          if (value.length < 8) {
            return 'Password should be more than 8 characters';
          }
        }));

    formWidget.add(
      new TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Confirm Password',
              labelText: 'Enter Confirm Password'),
          validator: (confirmPassword) {
            if (confirmPassword.isEmpty) return 'Enter confirm password';
            var password = _passKey.currentState.value;
            if (!equalsIgnoreCase(confirmPassword, password))
              return 'Confirm Password invalid';
          },
          onSaved: (value) {
            setState(() {
              _password = value;
            });
          }),
    );

    formWidget.add(new DropdownButton(
      hint: new Text('Select Gender'),
      items: genderList,
      value: _selectedGender,
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      isExpanded: true,
    ));

    formWidget.add(new Column(
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('Single'),
          value: 'single',
          groupValue: _maritalStatus,
          onChanged: (value) {
            setState(() {
              _maritalStatus = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Married'),
          value: 'married',
          groupValue: _maritalStatus,
          onChanged: (value) {
            setState(() {
              _maritalStatus = value;
            });
          },
        ),
      ],
    ));

    formWidget.add(CheckboxListTile(
      value: _termsChecked,
      onChanged: (value) {
        setState(() {
          _termsChecked = value;
        });
      },
      subtitle: !_termsChecked
          ? Text(
        'Required',
        style: TextStyle(color: Colors.red, fontSize: 12.0),
      )
          : null,
      title: new Text(
        'I agree to the terms and condition',
      ),
      controlAffinity: ListTileControlAffinity.leading,
    ));

    formWidget.add(new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Sign Up'),
        onPressed: onPressedSubmit));

    return formWidget;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter mail';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
