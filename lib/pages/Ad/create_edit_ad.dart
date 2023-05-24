import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/Ad/ad.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/create_edit_page_template.dart';
import 'package:pet_sitting/services/ad_service.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/validators/locationValidator.dart';
import 'package:pet_sitting/validators/not_null_validator.dart';
import 'package:pet_sitting/widgets/core/widget_stream_builder.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';

class CreateEditAdPage extends StatefulWidget {
  final Ad? ad;
  final adService = get<AdService>();

  CreateEditAdPage({super.key, this.ad});

  @override
  State<CreateEditAdPage> createState() => _CreateEditAdPageState();
}

class _CreateEditAdPageState extends State<CreateEditAdPage> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _detailsController = TextEditingController();
  final _locationController = TextEditingController();
  bool _loading = false;
  String? _petId;
  late List<Pet> _pets;

  @override
  void initState() {
    super.initState();
    if (widget.ad != null) {
      _setControllers(widget.ad!);
    }
  }

  void _setControllers(Ad ad) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    _fromController.text = dateFormat.format(ad.from);
    _toController.text = dateFormat.format(ad.to);
    _titleController.text = ad.title;
    _costController.text = ad.costPerHour.toString();
    _locationController.text = ad.location;
    _detailsController.text = ad.description ?? '';
    _petId = ad.petId;
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.ad != null;

    return CreateEditPageTemplate(
      pageTitle: edit ? 'Edit Ad' : 'Create Ad',
      buttonText: edit ? 'EDIT' : 'SAVE',
      buttonCallback: edit ? _onEditPressed : _onCreatePressed,
      isLoading: _loading,
      body: WidgetStreamBuilder(
        stream: get<PetService>().currentUserPetStream,
        onLoaded: (pets) {
          _pets = pets;
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
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
            validator: notNullValidator,
          ),
          _buildPetDropdown(),
          _buildDatePicker(_fromController, "From*: "),
          _buildDatePicker(_toController, "To*: "),
          PlainTextField(
            labelText: "Daily rate*",
            placeholder: "Enter the daily rate of the pet sitter",
            controller: _costController,
            iconData: Icons.euro,
            inputType: TextInputType.number,
            validator: notNullValidator,
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
            validator: (_) => null,
          ),
        ],
      ),
    );
  }

  Widget _buildPetDropdown() {
    return DropdownButtonFormField<String>(
      hint: const Text('Select pet for pet sitting'),
      value: _petId,
      validator: notNullValidator,
      onChanged: (value) {
        if (value != null) {
          _petId = value;
        }
      },
      items: _pets.map((p) {
        return DropdownMenuItem(
          value: p.id,
          child: Text(p.name),
        );
      }).toList(),
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
        firstDate: DateTime.now(),
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
          petId: _petId!,
          creatorId: id,
          active: true);
      await widget.adService.createNewAd(ad);
    }
  }

  Future<void> _editAd() async {
    final id = get<AuthService>().currentUserId;
    var newAd = widget.ad!.copyWith(
        title: _titleController.text,
        location: _locationController.text,
        description: _detailsController.text,
        costPerHour: int.parse(_costController.text),
        from: DateTime.parse(_fromController.text),
        to: DateTime.parse(_toController.text),
        petId: _petId,
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
      await handleAsyncOperation(
          asyncOperation: _createAdd(),
          onSuccessText: 'Request created',
          context: context);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
