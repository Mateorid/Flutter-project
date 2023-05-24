import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/create_edit_page_template.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/validators/email_validator.dart';
import 'package:pet_sitting/validators/locationValidator.dart';
import 'package:pet_sitting/validators/name_validator.dart';
import 'package:pet_sitting/validators/phoneValidator.dart';
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';

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
    return CreateEditPageTemplate(
      pageTitle: 'Edit profile',
      buttonText: 'SAVE',
      buttonCallback: _onSubmitPressed,
      isLoading: _loading,
      body: WidgetFutureBuilder(
        future:
            widget._userService.getUserById(widget._authService.currentUserId!),
        onLoaded: (user) {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email;
          _phoneNumberController.text = user.phoneNumber ?? '';
          _locationController.text = user.location ?? '';
          _detailsController.text = user.aboutMe ?? '';
          widget.userExtended = user;
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          const SizedBox(height: 10),
          _buildImage(),
          const SizedBox(height: 35),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // _loading ? const CircularProgressIndicator() : Container(),
          PlainTextField(
            labelText: "Full Name",
            placeholder: "Enter your full name",
            controller: _nameController,
            validator: nameValidator,
            iconData: Icons.person,
          ),
          PlainTextField(
            labelText: "Contact email",
            placeholder: "Enter your contact email",
            inputType: TextInputType.emailAddress,
            controller: _emailController,
            validator: emailValidator,
            iconData: Icons.email,
          ),
          PlainTextField(
            labelText: "Contact phone number",
            placeholder: "Enter your contact phone number",
            inputType: TextInputType.phone,
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
            iconData: Icons.info_outline_rounded,
            validator: (value) {
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ProfileWidget(
      image: get<ImageService>().getUserImage(widget.userExtended),
      icon: const Icon(Icons.image_search, color: Colors.white, size: 25),
      onTap: () {
        context.pushNamed(
          "upload",
          params: {"id": widget._authService.currentUserId!},
        );
      },
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
    await get<UserService>().updateUser(user);
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
