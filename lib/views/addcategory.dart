import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategory extends StatefulWidget {
  @override
  AddCategoryState createState() => AddCategoryState();
}

class AddCategoryState extends State<AddCategory> {
  final _hints = <String>[
    "Clothing",
    "Vehicle",
    "Food",
    "Kitchen",
    "Shopping",
    "Books",
    "Rides",
    "Public Transport",
    "transport",
  ];
  final TextEditingController _categoryController = TextEditingController();

  @override
  build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF7D30FA),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Add Category",
            style: GoogleFonts.aBeeZee(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _height,
              maxWidth: _width,
              minHeight: _height,
              minWidth: _width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  enableInteractiveSelection: true,
                  maxLengthEnforced: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.aBeeZee(),
                  autofillHints: _hints,
                  cursorColor: Colors.orange,
                  maxLength: 15,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Color(0xFF7D30FA),
                          style: BorderStyle.solid,
                          width: 1.0,
                        )),
                    hintText: "Category",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF7D30FA),
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                Card(
                  child: Container(
                    height: _height * 0.06,
                    width: _width,
                    child: RaisedButton.icon(
                      color: Color(0xff7d30fa),
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: Color(0xffeeeeee),
                      ),
                      label: Text(
                        "Add",
                        style: GoogleFonts.aBeeZee(
                          color: Color(0xffeeeeee),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
