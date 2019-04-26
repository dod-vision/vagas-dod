import 'dart:async';
import 'dart:io';
import 'package:desafio_dod/tabs/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraTab extends StatefulWidget {
  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  bool isLoading = false;

  final GlobalKey _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!isLoading){
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Desafio Dod'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: _cameraPreviewWidget()
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Desafio Dod'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }


  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              color: Colors.blue,
              onPressed: controller != null &&
                  controller.value.isInitialized
                  ? _onCapturePressed
                  : null,
            )
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(
                Icons.switch_camera
            ),
            label: Text("${lensDirection.toString()
                .substring(lensDirection.toString().indexOf('.')+1)}")
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    // Pegar a lista de cameras disponiveis e selecionar a primeira
    availableCameras()
    .then((availableCameras){
      cameras = availableCameras;

      if(cameras.length > 0){
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    })
    .catchError((e){
      print('Error: $e');
    });
  }


  Future _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Erro na câmera:${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }


  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  Future _takePicture() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Por favor, aguarde...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );

      return null;
    }

    // Do nothing if a capture is on progress
    if (controller.value.isTakingPicture) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pictureDirectory = '${appDirectory.path}/Pictures';
    await Directory(pictureDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$pictureDirectory/$currentTime.jpg';

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  void _onCapturePressed() {
    _takePicture().then((filePath) {
      if (mounted) {
        var url = 'https://tv.dodvision.com/test-app/';

        setState(() {
          imagePath = filePath;
          isLoading = true;
        });

        List<int> imageBytes = File(imagePath).readAsBytesSync();
        String jsonBase64 = jsonEncode({ 'image': base64Encode(imageBytes) });

        http.post(url,
            headers: {"Content-Type": "application/json"},
            body: jsonBase64
        ).then((http.Response response){
          print(response.body);
          print(response.statusCode);
          final Map<String, dynamic> parsed = jsonDecode(response.body);

          if(response.body == '{"emissora": ""}'){
            Fluttertoast.showToast(
                msg: 'Erro na foto, tente novamente',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white
            );
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeTab(parsed)));
          }

          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Erro: ${e.code}\nMensagem de erro: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Erro: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
  }
}