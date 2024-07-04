import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:projetoflutterapi/src/core/entities/user_entitie.dart';

abstract class AuthService {
  Stream<UserEntity?> get onAuthStateChanged;
  Future<UserEntity?> signInAnonymously();
  Future<UserEntity?> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<UserEntity?> createUserWithEmailAndPassword(
      {required String email, required String password, required String name});
  Future<void> signOut();
  Future<bool> isSignIn();
}

class FirebaseAuthServiceImp implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final UserEntity userEntity = GetIt.I<UserEntity>();

  FirebaseAuthServiceImp(this._firebaseAuth);

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(
      (user) {
        if (user == null) {
          return userEntity.update(
            id: user!.uid,
            name: user.displayName!,
            email: user.email!,
          );
        }
        return null;
      },
    );
  }

  @override
  Future<UserEntity?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userEntity.update(
      id: userCredential.user!.uid,
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    userEntity.update(id: '', name: '', email: '');
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userEntity.update(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName!,
        email: userCredential.user!.email!,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      return userEntity.update(
        id: userCredential.user!.uid,
        name: name,
        email: userCredential.user!.email!,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> isSignIn() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = _firebaseAuth.currentUser;
    return user != null;
  }
}
