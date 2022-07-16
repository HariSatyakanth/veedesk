import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/models/login_model.dart';
import 'package:newproject/pages/forgotPassword.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = true;//_errorVisible = false;
  String _errorMessageEmail ="",_errorMessagePassword ="",pwd="";
  bool _isLoading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          padding: EdgeInsets.only(top: Constants().containerHeight(context)/13.5),
                          height: Constants().containerHeight(context)/3.5,
                          width: Constants().containerWidth(context),
                          color: ColorsUsed.baseColor,
                          child: Text(S.login,
                            textAlign: TextAlign.center,
                            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
                          ),
                        ),
                      ),
                      Container(padding: EdgeInsets.fromLTRB(50.0, Constants().containerHeight(context)/9, 50.0, 20.0),
                       child: Column(
                         children: <Widget>[
                           _enterEmail(),
                           _enterPassword(),
                           SizedBox(height: 15.0),
                           Row(mainAxisAlignment: MainAxisAlignment.end,
                             children: <Widget>[
                               InkWell(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                                 },
                                   child: Text(S.forgot,style: Constants().txtStyleFont16(ColorsUsed.baseColor, 14.0),)),
                             ],
                           ),
                           SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              _showCircularProgress()
                            ],

                          ),
                           // SizedBox(height: 10.0),
                           // Text("OR",style: Constants().txtStyleFont16(Colors.black, 18.0),),
                           // SizedBox(height: 10.0),
                           // Row(
                           //   children: <Widget>[
                           //     Expanded(child: Constants().button(context, ColorsUsed.googleButton, 1, S.google))
                           //   ],
                           // ),
                           SizedBox(height: 30.0),
                           Row(mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
//                             Text(S.noAccount,style: Constants().txtStyleFont16(Colors.grey, 14.0),),
                             InkWell(
                               onTap: (){
                                 _signupInformation();
                               },
                               child: Text(S.signUp,style: Constants().txtStyleFont16(ColorsUsed.baseColor, 15.0),),
                             )
                           ],)
                         ],
                       ),),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(0.0,-2.0),
                  heightFactor: 0.1,
                  child: Image.asset("Images/login/loginBg.png",width: Constants().containerHeight(context)/3.8,),
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
               LoginModel.email = value;
              print(LoginModel.email);
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter email address',
//              isCollapsed: true,
            ),
            keyboardType: TextInputType.emailAddress,

          ),
          SizedBox(height: 10.0),
          Text(_errorMessageEmail,style: Constants().txtStyleFont16(Colors.red, 12),)
        ],
      ),
    );
  }

  _enterPassword() {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value){
              LoginModel.password = value;
              print( LoginModel.password);
            },
            obscureText: _showPassword,
            decoration: InputDecoration(
              hintText: 'Enter password',
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                  icon: _showPassword?Icon(Icons.visibility_off):Icon(Icons.visibility),
                  onPressed: (){
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  })
            ),
          ),
          SizedBox(height: 10.0),
          Text(_errorMessagePassword,style: Constants().txtStyleFont16(Colors.red, 12))
        ],
      ),
    );
  }
  Widget _showCircularProgress() {
    // if (Constants.GROUP_CHAT_ENABLE) {
    //   return Center(child: CircularProgressIndicator());
    // }
    return Expanded(child: SizedBox(height: Constants().containerHeight(context)/16,
      child: Builder(builder: (context)=> RaisedButton(
        onPressed: (){
          validation(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: ColorsUsed.baseColor,
        child: Text(S.login,
            style: TextStyle(fontSize:16.0,color: ColorsUsed.whiteColor,fontFamily: "Montserrat",fontWeight: FontWeight.w500)),
      ),
      ),
    )
//                              Constants().button(context, Constants().baseColor, 0, S.login)
    );
  }


  validation(BuildContext context){
    //print(Util.passwordRegx(LoginModel.password));
    if(LoginModel.email.isNotEmpty){
      if(EmailValidator.validate(LoginModel.email)){
        setState(() {
          _errorMessageEmail = "";
        });
        if(Util.validatePassword(LoginModel.password)){

          setState(() {
            _errorMessagePassword = "";
            Constants.GROUP_CHAT_ENABLE=true;
          });
     //     LoginModel().handleGoogleLogOut(context);
          LoginModel().Login(context);
//          LoginModel().onLoading(context,3);

        }else{
          setState(() {
            _errorMessagePassword = "Password must contain number,alphabet and special character";
          });
//          Constants.showToast("Please enter Password");
          print("no pwd");
        }
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

   _signupInformation() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
          title: Text('Credentials are not working ?',
              style: Constants().txtStyleFont16(ColorsUsed.baseColor, 17)),
          content:  Text('Please confirm with your Admin Team',
              style: Constants().txtStyleFont16(ColorsUsed.baseColor, 14)),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(fontSize: 17.0),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
   }

}
