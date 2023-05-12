import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/basic_title.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/round_button.dart';
import 'package:pet_sitting/widgets/user/user_round_image.dart';
import 'package:pet_sitting/future_builder.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/validators/email_validator.dart';
import 'package:pet_sitting/validators/locationValidator.dart';
import 'package:pet_sitting/validators/name_validator.dart';
import 'package:pet_sitting/validators/phoneValidator.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({Key? key}) : super(key: key);
  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<AuthService>();
  late UserExtended userExtended;

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder(
        future:
            widget._userService.getUserById(widget._authService.currentUserId!),
        onLoaded: (user) {
          final dateFormat = DateFormat('yyyy-MM-dd');
          _nameController.text = user.name ?? '';
          _emailController.text = user.email;
          _phoneNumberController.text = user.phoneNumber ?? '';
          _locationController.text = user.location ?? '';
          _detailsController.text = user.aboutMe ?? '';
          widget.userExtended = user;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: DARK_GREEN,
            ),
            onPressed: () => {context.pop()},
          ),
        ),
      ),
      body: _loading
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: ListView(
                children: [
                  const BasicTitle(text: 'Edit profile'),
                  const SizedBox(height: 15),
                  _buildImage(),
                  const SizedBox(height: 35),
                  _buildForm(),
                  RoundButton(
                      color: MAIN_GREEN,
                      text: 'SAVE',
                      onPressed: _onSubmitPressed),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _loading ? const CircularProgressIndicator() : Container(),
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
            iconData: Icons.email,
          ),
          PlainTextField(
            labelText: "Contact phone number",
            placeholder: "Enter your contact phone number",
            controller: _phoneNumberController,
            validator: phoneValidator,
            iconData: Icons.phone,
          ),
          PlainTextField(
            labelText: "Location",
            placeholder: "Enter your current location",
            controller: _locationController,
            validator: locationValidator,
            iconData: Icons.location_on,
          ),
          PlainTextField(
            labelText: "About me",
            placeholder: "Enter additional details about you",
            extended: true,
            controller: _detailsController,
            validator: (value) {
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: Stack(
        children: [
          UserRoundImage(
            size: 130,
            url: widget.userExtended.imageUrl,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                color: MAIN_GREEN,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.pushNamed(
                    "upload",
                    params: {"id": widget._authService.currentUserId!},
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final id = get<AuthService>().currentUserId;
    if (id == null) {
      throw Exception('Error while loading current user!');
    }
    final usr = await widget._userService.getUserById(id);
    final user = UserExtended(
        uid: id,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        location: _locationController.text,
        email: _emailController.text,
        aboutMe: _detailsController.text,
        imageUrl: usr.imageUrl,
        pets: usr.pets,
        reviews: usr.reviews);
    await get<UserService>().updateUserX(user);
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      handleAsyncOperation(
          asyncOperation: _saveChanges(),
          onSuccessText: 'Changes saved',
          context: context);
      setState(() {
        _loading = false;
      });
    }
  }
}
