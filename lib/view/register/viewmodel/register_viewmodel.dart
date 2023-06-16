import 'dart:async';
import 'package:siparis_takip_demo/core/init/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel{

  TextEditingController emailController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  final formKey = GlobalKey<FormState>();
  @override
  Future<void> init() async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
  }
  Future register(BuildContext context)async{

    try{
      showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      var result=await AuthModel.instance.register(email: emailController.text.trim(),name: nameController.text.trim(),password: passwordController.text.trim());
      //if (context.mounted) Navigator.of(context).pop();
      if(result!=null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kullanıcı kaydedildi")));
        //NavigationService.instance.popPage();
      }
    }
    on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
      debugPrint(e.message);
      return null;
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      debugPrint(e.toString());
    }finally{
      Navigator.of(context).pop();
    }

  }

  @override
  void setContext(BuildContext context) {
  }


}