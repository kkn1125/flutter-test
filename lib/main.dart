import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 158;
  double? _imageWidth; // 너비 저장
  double? _imageHeight; // 높이 저장
  Uint8List? _imageBytes; // 높이 저장

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.

  void _loadImage() async {
    String BASE64_STRING =
        "data:image/jpeg;base64,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";
    // Image img = Image.memory(base64Decode(BASE64_STRING));
    // Base64 문자열에서 앞의 "data:image/jpeg;base64," 부분 제거
    String cleanBase64String = BASE64_STRING.split(',')[1];
    // 디코딩
    Uint8List bytes = base64Decode(cleanBase64String);
    Image img = Image.memory(bytes);

    // 이미지 디코딩하여 높이 얻기
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frame = await codec.getNextFrame();
    ui.Image image = frame.image;
    // 이미지 높이 설정
    setState(() {
      _imageWidth = image.width.toDouble();
      _imageHeight = image.height.toDouble();
      _imageBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
      ),
      body: SizedBox(
          width: double.infinity,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: _imageBytes == null
              ? const CircularProgressIndicator()
              : Column(
                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  //
                  // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                  // action in the IDE, or press "p" in the console), to see the
                  // wireframe for each widget.

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 120),
                      child: Column(
                        children: [
                          const Center(
                              child: Text(
                            'You have pushed the button this many times:',
                            textAlign: TextAlign.center,
                          )),
                          Text(
                            '$_counter번',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // width: double.infinity,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(_imageBytes!),
                            fit: BoxFit.cover),
                      ),
                      /* child: Image.memory(
                      Uri.parse(BASE64_STRING).data!.contentAsBytes(),
                      fit: BoxFit.contain) */
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
