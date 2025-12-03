import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:university_delivery_app/core/constants/app_constants.dart';
import 'package:university_delivery_app/data/models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<User?> authStateChanges();
  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithApple();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  // Lazy-loaded to avoid accessing Firebase before initialization
  FirebaseAuth get _auth {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
    }
    return FirebaseAuth.instance;
  }
  
  FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
    }
    return FirebaseFirestore.instance;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
      }
      
      // Add timeout to prevent infinite loading
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Login timeout. Please check your internet connection and try again.');
        },
      );

      // Get user data from Firestore with timeout
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Failed to load user data. Please try again.');
            },
          );

      if (!userDoc.exists) {
        throw Exception('User data not found. Please register first.');
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      String errorMessage = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email. Please register first.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message ?? e.code}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // Handle other errors
      final errorString = e.toString();
      if (errorString.contains('timeout')) {
        throw Exception(errorString);
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Login failed: ${e.toString()}');
      }
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
      }
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Create user profile in Firestore
      final userModel = UserModel(
        id: userId,
        email: email,
        name: name,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set(userModel.toFirestore());

      return userModel;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (Firebase.apps.isEmpty) {
        return; // Nothing to logout if Firebase not initialized
      }
      // Sign out from Firebase
      await _auth.signOut();
      // Also sign out from Google Sign In if user was signed in with Google
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (e) {
        // Ignore Google Sign In logout errors
      }
    } catch (e) {
      // Ignore errors if Firebase not initialized
      if (Firebase.apps.isNotEmpty) {
        throw Exception('Logout failed: $e');
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        return null;
      }
      
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return null;

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> authStateChanges() {
    // Check if Firebase is initialized
    try {
      if (Firebase.apps.isEmpty) {
        // Firebase not initialized - return empty stream
        return Stream.value(null);
      }
      return _auth.authStateChanges();
    } catch (e) {
      // Return empty stream if Firebase is not initialized
      return Stream.value(null);
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
      }

      // Trigger the Google Sign In flow
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      final userId = userCredential.user!.uid;

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      UserModel userModel;

      if (userDoc.exists) {
        // User exists, return existing user
        userModel = UserModel.fromFirestore(userDoc);
      } else {
        // New user, create profile in Firestore
        userModel = UserModel(
          id: userId,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? googleUser.displayName ?? 'User',
          phone: userCredential.user!.phoneNumber ?? '',
          role: AppConstants.roleStudent, // Default role
          profileImageUrl: userCredential.user!.photoURL ?? googleUser.photoUrl,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .set(userModel.toFirestore());
      }

      return userModel;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<UserModel> loginWithApple() async {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase is not configured. Please add google-services.json to android/app/ folder.');
      }

      // Request credential from Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      final userId = userCredential.user!.uid;

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      UserModel userModel;

      if (userDoc.exists) {
        // User exists, return existing user
        userModel = UserModel.fromFirestore(userDoc);
      } else {
        // New user, create profile in Firestore
        final displayName = appleCredential.givenName != null && appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : 'User';

        userModel = UserModel(
          id: userId,
          email: userCredential.user!.email ?? appleCredential.email ?? '',
          name: displayName,
          phone: userCredential.user!.phoneNumber ?? '',
          role: AppConstants.roleStudent, // Default role
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .set(userModel.toFirestore());
      }

      return userModel;
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }
}

