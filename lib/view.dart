import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db.dart';

class View extends StatefulWidget {
  View({Key? key, required this.accion, required this.db}) : super(key: key);
  Map accion;
  Database db;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  TextEditingController tituloController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController fechaController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print(widget.accion);
    tituloController.text = widget.accion['titulo'];
    descripcionController.text = widget.accion['descripcion'];
    fechaController.text = DateFormat('dd/MM/yyyy')
        .format(widget.accion['fecha'].toDate())
        .toString();
  }

  var _fecha;

  void callDatePicker() async {
    var selectedDate = await getDatePicker();
    setState(() {
      _fecha = selectedDate;
      if (_fecha != null) {
        fechaController.text =
            DateFormat('dd/MM/yyyy').format(_fecha).toString();
      }
    });
  }

  Future<DateTime?> getDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        title: Text("Editar accion de guerra"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.db.delete(widget.accion["id"]);
                Navigator.pop(context, true);
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://w0.peakpx.com/wallpaper/540/152/HD-wallpaper-camouflage-pattern-green-black.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Titulo"),
                controller: tituloController,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Descripcion"),
                controller: descripcionController,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true,
                style: TextStyle(color: Colors.white),
                decoration: inputDecoration("Fecha"),
                controller: fechaController,
                onTap: callDatePicker,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.transparent,
                child: BottomAppBar(
                  color: Colors.transparent,
                  child: RaisedButton(
                      color: Color.fromRGBO(56, 75, 49, 1.0),
                      onPressed: () {
                        widget.db.update(
                            widget.accion['id'],
                            tituloController.text,
                            descripcionController.text,
                            _fecha);
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        "Guardar",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
      labelText: labelText,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color.fromRGBO(56, 75, 49, 1.0),
          width: 2.0,
        ),
      ),
    );
  }
}
