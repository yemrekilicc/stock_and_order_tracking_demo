import 'package:siparis_takip_demo/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthModel {
  static AuthModel _instance = AuthModel._init();
  static AuthModel get instance => AuthModel._instance;
  AuthModel._init();


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance=FirebaseFirestore.instance;


  Future<String?> readUserEmail({required String userName})async{
    try{
      DocumentSnapshot<Map<String, dynamic>> data;
      if(userName!=""){
        data=await firestoreInstance.collection("userNames").doc(userName).get();
        if(data.data()!=null){
          return data.data()!["owner"];
        }
        else{
          return null;
        }
      }
      else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> signIn({required String userName,required String password}) async {
    try{
      userName=userName.replaceAll(RegExp(r' '), '-');
      String? check=await readUserEmail(userName: userName);
      if(check!=null){
        await _firebaseAuth.signInWithEmailAndPassword(email: check, password: password);
        await readUserInfo();
      }
      else{
        throw("Böyle bir kullanıcı bulunmamaktadır.");
      }
    } on FirebaseAuthException catch  (e) {
      if(e.code=="invalid-email"){
        throw("email adres formatı doğru değil");
      }
      else if(e.code=="user-not-found"){
        throw("Bu email adresiyle kayıtlı bir kullanıcı bulunmamaktadır");
      }
      else if(e.code=="wrong-password"){
        throw("Şifre yanlış");
      }
      else if(e.code=="network-request-failed"){
        throw("İnternet bağlantısı kurulamadı");
      }
      else{
        throw(e.message!);
      }
    }on FirebaseException{
      rethrow;
    }
    catch(e){
      rethrow;
    }



  }

  saveUserInfo({required User? user,required String name}) async {
    if(user!=null){
      try{
        await firestoreInstance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email":user.email,
          "isAdmin": false,
        });

        await firestoreInstance.collection("userNames").doc(name).set({
          "owner": user.email,
        });

      }catch(e){
        rethrow;
      }
    }
  }

  Future<bool> checkUserNameTaken({required String name})async{
      try{
        DocumentSnapshot<Map<String, dynamic>> data;
        if(name!=""){
          data=await firestoreInstance.collection("userNames").doc(name).get();
          if(data.data()!=null){
            return true;
          }
          else{
            return false;
          }
        }
        else{
          return true;
        }
      }catch(e){
        rethrow;
      }
  }

  Future<User?> register({required String name,required String email,required String password}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try{
      name=name.replaceAll(RegExp(r' '), '-');
      if(await checkUserNameTaken(name: name)){
        throw ("Kullanıcı adı alınmıştır.");
      }
      else{
        UserCredential result = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: password);
        await saveUserInfo(user: result.user,name: name);
        return result.user;
      }
    } catch(e){
      rethrow;
    }finally{
      await app.delete();
    }

  }
  readUserInfo() async {
    var firebaseUser = _firebaseAuth.currentUser;
    if(firebaseUser!=null){
      try {
        var documentSnapshot = await firestoreInstance.collection('users')
            .doc(firebaseUser.uid)
            .get();
        UserModel.fromJson(documentSnapshot.data()!);
      }on FirebaseException catch(e){
        throw(e.message!);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
        // print(e.message!);
      }
      catch(e){
        rethrow;
      }
    }


  }


  Future<void> logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}