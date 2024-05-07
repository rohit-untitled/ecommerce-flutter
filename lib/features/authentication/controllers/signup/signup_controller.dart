import 'package:e_commerce/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce/data/repositories/user/user_repository.dart';
import 'package:e_commerce/features/authentication/screens/signup/verify_email.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // variables
  final hidePassword = true.obs; // for hiding showing the password
  final privacyPolicy = true.obs; // for privacy policy
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();

  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // for form validation

  // Signup
  void signup() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialog(
          'We are processsing your information...', TImages.docerAnimation);
      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!signupFormKey.currentState!.validate()) {
        // remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //privacy policy check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'In order to create account, you must have to read and accept Privacy Policy & Terms of use.');
        return;
      }

      //Register user in the firebase authentication and save user data in the firebase
      final UserCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());
      //save authenticated user data

      final newUser = UserModel(
        id: UserCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: email.text.trim(),
        profilePicture: '',
      );
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // remove loader
      TFullScreenLoader.stopLoading();

      //show success message
      TLoaders.successSnackbar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      //move to verify to email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // remove loader
      TFullScreenLoader.stopLoading();

      // show some generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
