import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:fukui_old_train/my_home_page.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  double left = 1050;
  bool tapped = false;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Stack(
        children: [
          CameraPreview(controller),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            left: left,
            child: SizedBox(
              width: 400,
              height: 400,
              child: Image.asset('images/train_kikansya_kemuri.png'),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visible = true;
                      left = -400;
                    });
                  },
                  child: const Text('再現'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visible = false;
                      left = 1050;
                    });
                  },
                  child: const Text('リセット'),
                ),
              ],
            ),
          ),
          //   MyHomePage()
        ],
      ),
    );
  }
}
