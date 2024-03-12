import 'package:camera/camera.dart';
import 'package:face_detection_app/preview_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() {}); // Update the UI after camera initialization
  }

  void _flipCamera() async {
    final newIndex =
        _cameraController.description.lensDirection == CameraLensDirection.front
            ? _cameras.indexWhere(
                (desc) => desc.lensDirection == CameraLensDirection.back)
            : _cameras.indexWhere(
                (desc) => desc.lensDirection == CameraLensDirection.front);

    if (newIndex != -1) {
      await _cameraController.dispose();
      _cameraController =
          CameraController(_cameras[newIndex], ResolutionPreset.max);
      await _cameraController.initialize();
      setState(() {}); // Update the UI after flipping the camera
    }
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Dispose the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController)
                : const CircularProgressIndicator(), // Show a loading indicator while camera initializes
          ),
          Center(
            child: MaterialButton(
              child: Icon(Icons.camera),
              onPressed: () async{
                await _cameraController.setFlashMode(FlashMode.auto);
                XFile photo = await _cameraController.takePicture();
                Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewPage(photo: photo)));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _flipCamera,
        child: const Icon(Icons.switch_camera),
      ),
    );
  }
}
