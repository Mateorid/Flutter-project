import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/basic_title.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/round_button.dart';
import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../validators/email_validator.dart';
import '../validators/locationValidator.dart';
import '../validators/name_validator.dart';
import '../validators/phoneValidator.dart';
import '../widgets/global_snack_bar.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({Key? key}) : super(key: key);

  final User? user = get<AuthService>().currentUser;

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _setControllerInitialValues();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              elevation: 1,
              backgroundColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: DARK_GREEN,
                ),
                onPressed: () => {context.pop()},
              )),
        ),
        body: _loading
            ? const CircularProgressIndicator() : Container(
            padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                const BasicTitle(text: 'Edit profile'),
                const SizedBox(height: 15),
                _buildImage(),
                const SizedBox(
                  height: 35,
                ),
                _buildForm(),
                const SizedBox(
                  height: 35,
                ),
                RoundButton(
                    color: MAIN_GREEN,
                    text: 'SAVE',
                    onPressed: _onSubmitPressed),
              ],
            )));
  }

  Future<void> _setControllerInitialValues() async {
    try {
      final id = get<AuthService>().currentUserId;
      if (id != null) {
        final user = await get<UserService>().getUserById(id);
        if (user != null) {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email;
          _phoneNumberController.text = user.phoneNumber ?? '';
          _locationController.text = user.location ?? '';
        }
      }
    } on FirebaseAuthException catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: "Error",
          smallText: e.message ?? 'Unknown error occurred');
    } catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: "Error",
          smallText: 'Unknown error, please try again later');
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _loading
              ? const CircularProgressIndicator() : Container(),
          PlainTextField(
            labelText: "Full Name",
            placeholder: "Enter your full name",
            controller: _nameController,
            validator: nameValidator,
          ),
          PlainTextField(
            labelText: "Contact email",
            placeholder: "Enter your contact email",
            controller: _emailController,
            validator: emailValidator,
          ),
          PlainTextField(
            labelText: "Contact phone number",
            placeholder: "Enter your contact phone number",
            controller: _phoneNumberController,
            validator: phoneValidator,
          ),
          PlainTextField(
            labelText: "Location",
            placeholder: "Enter your current location",
            controller: _locationController,
            validator: locationValidator,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 4, color: Theme
                    .of(context)
                    .scaffoldBackgroundColor),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://www.gensoldx.com/wp-content/uploads/2017/06/cdn.akc_.orgwhy_life_is_better_with_d-d4168a4c5d58d6716e64ae4828e297751c32b51f.jpg",
                    ))),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor,
                  ),
                  color: MAIN_GREEN,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }


  Future<void> _saveChanges() async {
    final id = get<AuthService>().currentUserId;
    final UserService userService = get<UserService>();
    if (id != null) {
      await userService.updateUser(
          id: id,
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          location: _locationController.text,
          email: _emailController.text);
    }
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      handleAsyncOperation(asyncOperation: _saveChanges(), onSuccessText: 'Changes saved', context: context);
      setState(() {
        _loading = false;
      });
    }
  }

}
