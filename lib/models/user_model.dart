import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  
  UserCredential firebaseUser;

  User user;
 

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);

    _loadCurrentUser();
  }
  
  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    try {
      firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userData["email"], password: pass);

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        onFail();
        isLoading = false;
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        onFail();
        isLoading = false;
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();

      print(e);
    }
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user)async{
        
        firebaseUser = user;

        await _loadCurrentUser();

        onSuccess();
        isLoading = false;
        notifyListeners();

    }).catchError((e){

      onFail();
      isLoading = false;
      notifyListeners();

    });

    isLoading = false;
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass() {}

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .doc(firebaseUser.user.uid)
        .set(userData);
  }



  Future<Null> _loadCurrentUser() async{

   

    if(firebaseUser == null){
        user =  await _auth.currentUser;
        
    }
    if(user != null)  {
      if(userData["name"] == null){
        DocumentSnapshot docUser = 
            await Firestore.instance.collection("users").doc(user.uid).get();
        userData = docUser.data();
      }
    }

    notifyListeners();


  }


}
