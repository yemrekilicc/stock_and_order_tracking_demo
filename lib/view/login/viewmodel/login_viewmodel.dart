import 'dart:async';

import 'package:siparis_takip_demo/core/init/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel{

  TextEditingController nameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool _isWaiting = false;
  bool get isWaiting => _isWaiting;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Future<void> init() async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
  }
  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
        try{
          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(child: CircularProgressIndicator());
            },
          );
          await AuthModel.instance.signIn(userName: nameController.text.trim(),password:  passwordController.text.trim());
        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          if(context.mounted)Navigator.of(context).pop();
          _isWaiting=false;
        }finally{

        }
    }
  }



  @override
  void setContext(BuildContext context) {
  }


}