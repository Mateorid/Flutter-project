import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pet_sitting/future_builder.dart';
import 'package:pet_sitting/services/ad_service.dart';
import 'package:pet_sitting/validators/locationValidator.dart';

import '../../Models/Ad/ad.dart';
import '../../handle_async_operation.dart';
import '../../ioc_container.dart';
import '../../services/auth_service.dart';
import '../../styles.dart';
import '../../widgets/core/basic_title.dart';
import '../../widgets/plain_text_field.dart';
import '../../widgets/round_button.dart';

class CreateEditAdPage extends StatefulWidget {
  String? adId;
  CreateEditAdPage({super.key, this.adId});
  final adService = GetIt.I<AdService>();


  @override
  State<CreateEditAdPage> createState() => _CreateEditAdPageState();
}

class _CreateEditAdPageState extends State<CreateEditAdPage> {
  bool _loading = false;
  late Ad ad;
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _detailsController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.adId != null){
      return GenericFutureBuilder(future: widget.adService.getAdById(widget.adId!), onLoaded: (ad) {
        final dateFormat = DateFormat('yyyy-MM-dd');
        _fromController.text = dateFormat.format(ad.from);
        _toController.text = dateFormat.format(ad.to);
        _titleController.text = ad.title;
        _costController.text = ad.costPerHour.toString();
        _locationController.text = ad.location;
        _detailsController.text = ad.description ?? '';
        this.ad = ad;
        return _buildScaffold();

      });
    }
    else {
      return _buildScaffold();
    }

  }

  Widget _buildScaffold(){
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: DARK_GREEN),
            onPressed: () => {context.pop()},
          ),
        ),
        body: _loading
            ? const CircularProgressIndicator()
            : Container(
            padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                const BasicTitle(text: 'CREATE A REQUEST'),
                const SizedBox(height: 15),
                _buildForm(),
                RoundButton(
                    color: MAIN_GREEN,
                    text: 'SAVE',
                    onPressed: widget.adId == null? _onCreatePressed : _onEditPressed),
              ],
            )));
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
          petId: "K3YvqdaiOoZDNnKJ2URi",
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
        petId: "K3YvqdaiOoZDNnKJ2URi",
        creatorId: id,
        active: true);
    widget.adService.updateAd(newAd.id!, newAd);
  }

  void _onEditPressed() async {
    if (_formKey.currentState!.validate()) {
      await handleAsyncOperation(
          asyncOperation: _editAd(),
          onSuccessText: 'Request edited',
          context: context);
      context.pop();
    }
  }

  void _onCreatePressed() async {
    if (_formKey.currentState!.validate()) {
      await handleAsyncOperation(
          asyncOperation: _createAdd(),
          onSuccessText: 'Request created',
          context: context);
      context.pop();
    }
  }
}
