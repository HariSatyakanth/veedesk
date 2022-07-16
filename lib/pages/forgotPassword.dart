import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> implements WidgetCallBack{
  String email ,_errorMessageEmail = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0,backgroundColor: ColorsUsed.baseColor,),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                    child: Container(
                      height: Constants().containerHeight(context)/5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,
                      child: Text(S.capitalForgot,
                        textAlign: TextAlign.center,
                        style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
                      ),
                    ),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(50.0, Constants().containerHeight(context)/7, 50.0, 20.0),
                    child: Column(
                      children: <Widget>[
                        _enterEmail(),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            Expanded(child: Constants().buttonRaised(context, ColorsUsed.baseColor,  S.regularContinue,this))
                          ],
                        ),
                      ],
                    ),)
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.0,-1.4),
              heightFactor: 0.1,
              child: Image.asset("Images/forgotPassword/forgot.png",width: Constants().containerHeight(context)/3.8,),
            )
          ],
        ),
      ),
    );
  }

  _enterEmail() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value){
              email = value;
              print(email);
            },
            decoration: InputDecoration(
              hintText: 'Enter email address',
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: Icon(Icons.email),
            ),
          ),

          SizedBox(height: 10.0),
          Text(_errorMessageEmail,style: Constants().txtStyleFont16(Colors.red, 12))
        ],
      ),
    );
  }
  validation(BuildContext context){
    if(email!=null){
      if(EmailValidator.validate(email)){
        setState(() {
          _errorMessageEmail = "";
        });
      }else{
        setState(() {
          _errorMessageEmail = "Please enter a valid email address";
        });
//        Constants.showToast("Please enter a valid email address");
      }
    }else{
      setState(() {
        _errorMessageEmail = "Please enter email address";
      });
    }
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case S.regularContinue:
        validation(context);
    }
  }

}
