import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:provider/provider.dart';

class Widgets {
  final ConstantColors colors = ConstantColors();

  Text text({
    String val,
    Color color,
    double fontsize,
    Key key,
  }) {
    return Text(
      val,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      key: key,
      style: GoogleFonts.aBeeZee(
          color: color, fontSize: fontsize, textStyle: TextStyle()),
    );
  }

  OutlineInputBorder outlineInputBorder({@required Color borderColor}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        style: BorderStyle.solid,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    );
  }

  InputDecoration preInputDecoratioon({
    String hint,
    IconData icon,
    Color iconColor,
    Color lableColor,
    Color borderColor,
  }) {
    return InputDecoration(
      focusColor: colors.greyColor,
      alignLabelWithHint: true,
      disabledBorder: outlineInputBorder(borderColor: borderColor),
      prefixIcon: icon == null
          ? Icon(Icons.short_text_sharp)
          : Icon(
              icon,
              color: iconColor,
            ),
      focusedBorder: outlineInputBorder(borderColor: borderColor),
      labelText: hint,
      labelStyle: GoogleFonts.aBeeZee(
        color: lableColor,
        letterSpacing: 1.0,
      ),
      border: outlineInputBorder(borderColor: borderColor),
    );
  }

  InputDecoration inputDecoratioon({
    String hint,
    IconData icon,
    Color iconColor,
    Color lableColor,
    Color borderColor,
  }) {
    return InputDecoration(
      focusColor: borderColor,
      alignLabelWithHint: true,
      disabledBorder: outlineInputBorder(borderColor: borderColor),
      suffixIcon: icon == null
          ? Icon(Icons.short_text_sharp)
          : Icon(
              icon,
              color: iconColor,
            ),
      focusedBorder: outlineInputBorder(borderColor: borderColor),
      labelText: hint,
      labelStyle: GoogleFonts.aBeeZee(
        color: lableColor,
        letterSpacing: 1.0,
      ),
      border: outlineInputBorder(borderColor: borderColor),
    );
  }

  InputDecoration passdecoration({
    String hint,
    bool obscureText,
    IconData icon,
    Color iconColor,
    Color lableColor,
    Color borderColor,
    Function callback,
  }) {
    return InputDecoration(
      labelText: hint,
      labelStyle: GoogleFonts.aBeeZee(
        color: colors.greyColor,
        letterSpacing: 1.0,
      ),
      focusColor: borderColor,
      alignLabelWithHint: true,
      disabledBorder: outlineInputBorder(borderColor: borderColor),
      suffixIcon: IconButton(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        onPressed: callback,
      ),
      focusedBorder: outlineInputBorder(borderColor: borderColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }

  Consumer<FireApi> passwordTextfeild({
    @required Key key,
    @required String hint,
    @required Color borderColor,
    @required IconData icon,
    @required TextInputAction action,
    @required TextEditingController controller,
    @required Function callback,
    @required Color iconColor,
    @required Color lableColor,
  }) {
    return Consumer<FireApi>(builder: (context, api, child) {
      return Container(
        height: Get.height * 0.09,
        child: TextFormField(
          style: GoogleFonts.aBeeZee(color: colors.greyColor),
          key: key,
          obscureText: api.isPassword,
          textInputAction: action,
          controller: controller,
          decoration: passdecoration(
            callback: callback,
            borderColor: borderColor,
            hint: hint,
            icon: icon,
            iconColor: iconColor,
            lableColor: lableColor,
          ),
        ),
      );
    });
  }

  GetBar warningToste({
    @required String message,
  }) {
    Get.showSnackbar(
      GetBar(
        icon: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Icon(Icons.warning_amber_outlined, color: colors.orangeColor),
        ),
        shouldIconPulse: false,
        isDismissible: true,
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          key: UniqueKey(),
          style: GoogleFonts.aBeeZee(
              color: colors.greyColor, fontSize: 16.0, textStyle: TextStyle()),
        ),
        duration: Duration(milliseconds: 3000),
        borderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
      ),
    );
    return null;
  }

  GetBar customToaste({
    @required String message,
    @required Color messagecolor,
    @required IconData icon,
    @required Color iconColor,
  }) {
    Get.showSnackbar(
      GetBar(
        icon: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        shouldIconPulse: false,
        isDismissible: true,
        messageText: text(
          color: messagecolor,
          fontsize: 16,
          key: UniqueKey(),
          val: message,
        ),
        duration: Duration(milliseconds: 3000),
        borderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
      ),
    );
    return null;
  }

  GetBar successToste({
    @required String message,
  }) {
    Get.showSnackbar(
      GetBar(
        icon: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Icon(
            Icons.done,
            color: colors.greenColor,
          ),
        ),
        shouldIconPulse: false,
        isDismissible: true,
        messageText: text(
          color: colors.greyColor,
          fontsize: 16,
          key: UniqueKey(),
          val: message,
        ),
        duration: Duration(milliseconds: 2000),
        borderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
      ),
    );
    return null;
  }

  GetBar noInternetToaste() {
    Get.showSnackbar(
      GetBar(
        icon: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Icon(
            Icons.done,
            color: colors.greenColor,
          ),
        ),
        shouldIconPulse: false,
        isDismissible: true,
        messageText: text(
            color: colors.greyColor,
            fontsize: 16,
            key: UniqueKey(),
            val: "No internet connection"),
        duration: Duration(milliseconds: 1000),
        borderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
      ),
    );
    return null;
  }

  GetBar customTosteWithMainButton({
    @required String message,
    @required IconData icon,
    @required Color iconColor,
    @required Color messageColor,
  }) {
    Get.showSnackbar(
      GetBar(
        // mainButton: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: RaisedButton(
        //     color: colors.greyColor,
        //     onPressed: () => Get.back(),
        //     child: text(
        //         color: Colors.red,
        //         fontsize: 16,
        //         key: UniqueKey(),
        //         val: "Retry"),
        //   ),
        // ),
        icon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.warning_amber_outlined,
            color: Colors.orange,
          ),
        ),
        shouldIconPulse: false,
        isDismissible: true,
        messageText: text(
            color: Colors.orange,
            fontsize: 16,
            key: UniqueKey(),
            val: "no internet connection"),
        duration: Duration(milliseconds: 5000),
        borderRadius: 8.0,
        margin: EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
      ),
    );
    return null;
  }

  TextField preSignupTextfeild({
    Key key,
    String hint,
    IconData icon,
    Color borderColor,
    TextEditingController controller,
    Color labelColor,
    Color iconColor,
    TextInputType textInputType,
    bool isPassword,
    @required TextInputAction action,
  }) {
    return TextField(
      style: GoogleFonts.aBeeZee(
        color: colors.blueColor,
      ),
      cursorColor: colors.blueColor,
      obscureText: isPassword == null ? false : true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        if (textInputType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
      ],
      enableSuggestions: true,
      textCapitalization: TextCapitalization.words,
      key: key != null ? key : UniqueKey(),
      keyboardType: textInputType,
      controller: controller,
      textInputAction: action,
      decoration: preInputDecoratioon(
        borderColor: borderColor,
        lableColor: labelColor,
        iconColor: iconColor,
        hint: hint,
        icon: icon,
      ),
    );
  }

  TextField signupTextfeild({
    Key key,
    String hint,
    IconData icon,
    Color borderColor,
    TextEditingController controller,
    Color labelColor,
    Color iconColor,
    TextInputType textInputType,
    bool isPassword,
    @required TextInputAction action,
  }) {
    return TextField(
      style: GoogleFonts.aBeeZee(color: colors.greyColor),
      obscureText: isPassword == null ? false : true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        if (textInputType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
      ],
      enableSuggestions: true,
      textCapitalization: TextCapitalization.words,
      key: key != null ? key : UniqueKey(),
      keyboardType: textInputType,
      controller: controller,
      textInputAction: action,
      decoration: inputDecoratioon(
        borderColor: borderColor,
        lableColor: labelColor,
        iconColor: iconColor,
        hint: hint,
        icon: icon,
      ),
    );
  }

  Widget closeSnacbarShortcut() {
    return InkWell(
      onTap: () => Get.back(),
      child: Column(
        children: [
          Container(
            height: 2.0,
            width: 30.0,
            color: colors.blueColor,
          ),
          Container(
            margin: EdgeInsets.all(3.0),
            height: 2.0,
            width: 30.0,
            color: colors.blueColor,
          ),
        ],
      ),
    );
  }

  customSnacbarWithFieldAndButton({
    @required double height,
    @required double width,
    @required TextEditingController controller,
    @required Function callback,
    @required IconData fieldIcon,
    @required String hintText,
    @required String buttonText,
    @required TextInputType textInputType,
    @required Key fieldKey,
    @required Key actionButtonKey,
  }) {
    if (Get.isSnackbarOpen) Get.back();
    return Get.showSnackbar(
      GetBar(
        borderRadius: 2.0,
        borderColor: colors.blueColor,
        borderWidth: 2.0,
        backgroundColor: Colors.white,
        isDismissible: true,
        userInputForm: Form(
          child: Container(
            height: height * 0.2,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                closeSnacbarShortcut(),
                preSignupTextfeild(
                  action: TextInputAction.done,
                  key: fieldKey,
                  textInputType: textInputType,
                  borderColor: colors.blueColor,
                  controller: controller,
                  hint: hintText,
                  icon: fieldIcon,
                  iconColor: colors.blueColor,
                  labelColor: colors.blueColor,
                ),
                Container(
                  width: width * 0.9,
                  child: RaisedButton(
                    key: actionButtonKey,
                    elevation: 10.0,
                    color: colors.blueColor,
                    child: text(
                      color: colors.greyColor,
                      fontsize: 16.0,
                      val: buttonText,
                    ),
                    onPressed: callback,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customCard({
    BuildContext context,
    var actionCallback,
    String titleName,
    IconData actionIcon,
  }) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Card(
      color: colors.greyColor,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: _height * 0.1,
        width: _width * 0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(val: titleName, color: colors.blueColor, fontsize: 18.0),
            IconButton(
              icon: Icon(
                actionIcon,
                color: colors.blueColor,
              ),
              onPressed: actionCallback,
            ),
          ],
        ),
      ),
    );
  }

  customSnacbarWithtwoButtons({
    @required String titleText,
    @required Function primaryCallback,
    @required String primaryButtonText,
    @required String secondaryButtonText,
    @required Function secondaryCallback,
    @required Key secondaryKey,
    @required Key primaryKey,
  }) {
    Get.showSnackbar(GetBar(
      margin: EdgeInsets.all(8.0),
      borderColor: colors.blueColor,
      borderRadius: 4.0,
      borderWidth: 1.0,
      backgroundColor: colors.greyColor,
      userInputForm: Form(
        child: Container(
          height: Get.height * 0.15,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                titleText,
                style: GoogleFonts.aBeeZee(
                  color: colors.blueColor,
                  fontSize: 18.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlineButton(
                    borderSide: BorderSide(
                      color: colors.blueColor,
                      width: 2.0,
                    ),
                    child: text(
                      val: secondaryButtonText,
                      fontsize: 16.0,
                      color: colors.blueColor,
                      key: secondaryKey,
                    ),
                    onPressed: secondaryCallback,
                  ),
                  FlatButton(
                      color: colors.blueColor,
                      onPressed: primaryCallback,
                      child: text(
                        color: colors.greyColor,
                        fontsize: 16.0,
                        key: primaryKey,
                        val: primaryButtonText,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget customGemderSelector() {
    return Consumer<FireApi>(
      builder: (context, api, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: Get.width * 0.4,
              child: RaisedButton(
                color: api.gender != "female"
                    ? colors.pinkColor
                    : colors.greyColor,
                onPressed: () {
                  api.changeGender(updatedGender: "male");
                },
                child: text(
                    val: "Male",
                    color: api.gender == "female"
                        ? colors.blueColor
                        : colors.greyColor,
                    fontsize: 16.0),
              ),
            ),
            Container(
              width: Get.width * 0.4,
              child: RaisedButton(
                color: api.gender == "female"
                    ? colors.pinkColor
                    : colors.greyColor,
                onPressed: () {
                  api.changeGender(updatedGender: "female");
                },
                child: text(
                    val: "Female",
                    color: api.gender == "female"
                        ? colors.greyColor
                        : colors.blueColor,
                    fontsize: 16.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
