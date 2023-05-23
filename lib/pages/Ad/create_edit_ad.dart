import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/future_builder.dart';
import 'package:pet_sitting/pages/create_edit_page_template.dart';
import 'package:pet_sitting/services/ad_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/validators/locationValidator.dart';
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';
import 'package:pet_sitting/widgets/form_dropdown.dart';

import '../../Models/Ad/ad.dart';
import '../../handle_async_operation.dart';
import '../../ioc_container.dart';
import '../../services/auth_service.dart';
import '../../widgets/plain_text_field.dart';

class CreateEditAdPage extends StatefulWidget {
  String? adId;

  CreateEditAdPage({super.key, this.adId});

  final adService = GetIt.I<AdService>();

  @override
  State<CreateEditAdPage> createState() => _CreateEditAdPageState();
}

class _CreateEditAdPageState extends State<CreateEditAdPage> {
  late Ad ad;
  late String petId;
  late UserExtended user;
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _detailsController = TextEditingController();
  final _locationController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final edit = widget.adId != null;

    return CreateEditPageTemplate(
      pageTitle: edit ? 'Edit Ad' : 'Create Ad',
      buttonText: edit ? 'EDIT' : 'SAVE',
      buttonCallback: edit ? _onEditPressed : _onCreatePressed,
      isLoading: _loading,
      body: WidgetFutureBuilder<UserExtended?>(
        future: get<UserService>().currentUser,
        onLoaded: (instance) {
          user = instance!;
          return edit ? _initFields() : _buildContent();
        },
      ),
    );
  }

  Widget _initFields() {
    return GenericFutureBuilder(
      future: widget.adService.getAdById(widget.adId!),
      onLoaded: (ad) {
        final dateFormat = DateFormat('yyyy-MM-dd');
        _fromController.text = dateFormat.format(ad.from);
        _toController.text = dateFormat.format(ad.to);
        _titleController.text = ad.title;
        _costController.text = ad.costPerHour.toString();
        _locationController.text = ad.location;
        _detailsController.text = ad.description ?? '';
        this.ad = ad;
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        children: [
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
          PlainTextField(
            labelText: "Title*",
            placeholder: "Enter the title of request",
            controller: _titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          FormDropDown(
              //todo this should be like a pop-up select - similar to reviews
              label: 'Pet',
              hintText: 'Select which pet is this ad for',
              items: user.pets,
              onChanged: (id) {
                petId = id!;
              }),
          _buildDatePicker(_fromController, "From*: "),
          _buildDatePicker(_toController, "To*: "),
          PlainTextField(
            labelText: "Daily rate*",
            placeholder: "Enter the daily rate of the pet sitter",
            controller: _costController,
            iconData: Icons.euro,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an daily rate';
              }
              return null;
            },
          ),
          PlainTextField(
            labelText: "Location*",
            placeholder: "Enter location",
            controller: _locationController,
            validator: locationValidator,
            iconData: Icons.location_on,
          ),
          PlainTextField(
            labelText: "Additional details",
            placeholder: "Enter additional details",
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

  Widget _buildDatePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a date';
          }
          return null;
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today), //icon of text field
          labelText: label,
        ),
        readOnly: true,
        onTap: () => _calendarOnTap(controller),
      ),
    );
  }

  void _calendarOnTap(TextEditingController controller) async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<void> _createAdd() async {
    final id = get<AuthService>().currentUserId;
    if (id != null) {
      final ad = Ad(
          title: _titleController.text,
          location: _locationController.text,
          description: _detailsController.text,
          costPerHour: int.parse(_costController.text),
          from: DateTime.parse(_fromController.text),
          to: DateTime.parse(_toController.text),
          petId: petId,
          creatorId: id,
          active: true);
      await widget.adService.createNewAd(ad);
    }
  }

  Future<void> _editAd() async {
    final id = get<AuthService>().currentUserId;
    var newAd = ad.copyWith(
        title: _titleController.text,
        location: _locationController.text,
        description: _detailsController.text,
        costPerHour: int.parse(_costController.text),
        from: DateTime.parse(_fromController.text),
        to: DateTime.parse(_toController.text),
        petId: petId,
        creatorId: id,
        active: true);
    widget.adService.updateAd(newAd.id!, newAd);
  }

  void _onEditPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      await handleAsyncOperation(
          asyncOperation: _editAd(),
          onSuccessText: 'Request edited',
          context: context);
      // context.pop();
      setState(() {
        _loading = false;
      });
    }
  }

  void _onCreatePressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      final ok = await handleAsyncOperation(
          asyncOperation: _createAdd(),
          onSuccessText: 'Request created',
          context: context);
      if (ok && context.mounted) {
        context.pop();
      }
    }
  }
}
