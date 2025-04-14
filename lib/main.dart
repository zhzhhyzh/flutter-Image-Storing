import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Profile Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,

          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.8),
          child: Column(
            children: [
              _image == null ? Icon(Icons.person,size:150): Image.file(_image!,width: 150, height: 150,)
              ,const SizedBox(height: 8.0,),
              IconButton(onPressed: (){
                getImageFromGallery();
              }, icon: Icon(
                Icons.edit,
                color: Colors.grey,
              )),
              const SizedBox(height: 8.0,),
              ElevatedButton(onPressed: (){
                savePicture();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved!')));
              }, child: const Text('Save'))
            ],
          ),
        )

    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> savePicture() async {
    if (_image != null) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final newImagePath = '${appDocDir.path}/profile.png';

        await _image!.copy(newImagePath);
        print('File image copied successfully to $newImagePath');
      } catch (e) {
        print('File error copying image: $e');
      }
    } else {
      AlertDialog(
        title: const Text('Profile Image'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Profile Image'),
              Text('Profile Image file is missing.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Future<void> loadProfileImage() async{
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagePath = '${appDocDir.path}/profile.png';

    final file = File(imagePath);

    if(await file.exists()){
      setState(() {
        _image = file;
        print('File path: $imagePath');
      });
    }else {
      print('File not found in $imagePath');
    }
  }

  @override
  void initState(){
    loadProfileImage();
    super.initState();
  }
}
