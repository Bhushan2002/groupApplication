import 'package:conversation/helper/helper_function.dart';
import 'package:conversation/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUsernameAndPassword(String email,String password) async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!= null){
        return true;
        //call our database service to update the user data.

      }
    } on FirebaseAuthException catch(e){
      return e.message ;

    }
  }





//registration
  Future registerUserWithEmailandPassword(String fullName, String email,String password) async{
    try{
       User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
       if(user!= null){
         DatabaseService(uId: user.uid).saveUserData(fullName, email);
         //call our database service to update the user data.
         return true;

       }
    } on FirebaseAuthException catch(e){
      return e.message ;

    }
  }

  // Sign out
Future SignOut() async{
    try{
      await HelperFunction.saveUserEmailSF('');
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserNameSF('');
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
}
}