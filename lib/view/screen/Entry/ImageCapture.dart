import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => new _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Capture image'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Click Here to Capture Image',
              ),
              new RaisedButton(
                child: Text('Capture Image'),
                onPressed: _capturePng,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
