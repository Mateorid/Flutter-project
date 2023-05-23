import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/services/storage_service.dart';

import '../../future_builder.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../styles.dart';
import '../../widgets/core/basic_button.dart';

class UploadFilePage extends StatefulWidget {
  final _storageService = GetIt.I<StorageService>();
  final _userService = GetIt.I<UserService>();
  final String id;
  final bool onlyReturnUrl;
  late UserExtended user;

  UploadFilePage({Key? key, required this.id, this.onlyReturnUrl = false}) : super(key: key);

  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  PlatformFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    if (widget.onlyReturnUrl){
      return _buildScaffold(context);
    }
    else {
      return GenericFutureBuilder(
          future: widget._userService.getUserById(widget.id),
          onLoaded: (user) {
            widget.user = user;
            return _buildScaffold(context);
          });
    }
  }

  Widget _buildScaffold(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DARK_GREEN),
          onPressed: () => {context.pop()},
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_pickedFile != null)
            Container(
              height: size.height * 0.4, // Set the desired height here
              child: Image.file(
                File(_pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          _buildSelectFile(context),
          if (_pickedFile != null) _buildUploadFile(context),
        ],
      )),
    );
  }

  Future<void> _onUploadPressed(BuildContext context) async {
    var url = await handleAsyncOperation(
        asyncOperation: _uploadFile(),
        onSuccessText: "Image uploaded successfully",
        context: context);
    if (widget.onlyReturnUrl){
      context.pop(url);
    }
    else {
      context.pop();
    }
  }

  Future<String> _uploadFile() async {
    final path = await widget._storageService
        .uploadFile(filePath: _pickedFile!.path!, fileName: _pickedFile!.name);
    final fullPath =
        await widget._storageService.getDownloadUrl(partialUrl: path);
    if (!widget.onlyReturnUrl){
      UserExtended updatedUser = widget.user.copyWith(imageUrl: fullPath);
      widget._userService.updateUserX(updatedUser);
    }
    return fullPath;
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg']);
    if (result == null) {
      return;
    }
    setState(() {
      _pickedFile = result.files.first;
    });
  }

  Widget _buildSelectFile(BuildContext context) {
    return BasicButton(
      text: "SELECT PICTURE",
      background: MAIN_GREEN,
      foreground: Colors.white,
      onPressed: _selectFile,
    );
  }

  Widget _buildUploadFile(BuildContext context) {
    return BasicButton(
      text: "UPLOAD PICTURE",
      background: MAIN_GREEN,
      foreground: Colors.white,
      onPressed: () => {_onUploadPressed(context)},
    );
  }
}
