import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/alertbox.dart';
import '../../../../utils/size_config.dart';
import '../../../../utils/uri.dart';

class ViewDocumentEcabinet extends StatefulWidget {
  String mettingCode;
  String agendaId;
  String computerNo;
  String itemDetails;
  String departmentName;
  int show = 0;

  ViewDocumentEcabinet(
      {Key key,
      @required this.mettingCode,
      this.agendaId,
      this.computerNo,
      this.itemDetails,
      this.departmentName,
      this.show})
      : super(key: key);

  @override
  State<ViewDocumentEcabinet> createState() => _ViewDocumentEcabinetState(
      mettingCode: mettingCode,
      agendaId: agendaId,
      computerNo: computerNo,
      itemDetails: itemDetails,
      departmentName: departmentName,
      show: show);
}

class _ViewDocumentEcabinetState extends State<ViewDocumentEcabinet> {
  String mettingCode;
  String agendaId;
  String computerNo;
  String itemDetails;
  String departmentName;
  String currentDate;
  String remotePDFpath = "";
  bool visible = false;
  int show = 0;

  _ViewDocumentEcabinetState(
      {Key key,
      @required this.mettingCode,
      this.agendaId,
      this.computerNo,
      this.itemDetails,
      this.departmentName,
      this.show});

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    currentDate = formatter.format(now);

    createFileOfPdfUrl("0").then((f) {
      setState(() {
        remotePDFpath = f.path;
        if (remotePDFpath.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(
                  path: remotePDFpath,
                  fileName: "मा० मंत्रिपरिषद के लिए टिप्पणी"),
            ),
          );
        }
      });
    });
  }

  Future<File> createFileOfPdfUrl(String docno) async {
    visible = true;
    Completer<File> completer = Completer();

    var fileName = "CM_${docno}_${agendaId}_${computerNo}_${currentDate}.pdf";
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName");

    if (file.existsSync()) {
      print("File Is Already Exist.");
      visible = false;
      completer.complete(file);
    } else {
      print("File Is Not Exist.");
      try {
        final uri = Uri.parse(URI_API().api_url_ecabinet +
            'getPdfDocDocument?meetingcode=${mettingCode}&agendatypeid=${agendaId}&itemComputerNo=${computerNo}&userid=anil.rajbhar@gov.in&docno=${docno}');

        var response = await http.get(
          uri,
        );

        var statuscode = response.statusCode;
        var bytes = response.bodyBytes;

        if (statuscode == 200) {
          visible = false;
          var fileName =
              "CM_${docno}_${agendaId}_${computerNo}_${currentDate}.pdf";
          var dir = await getApplicationDocumentsDirectory();
          File file = File("${dir.path}/$fileName");
          await file.writeAsBytes(bytes, flush: true);
          completer.complete(file);
        }

        visible = false;
      } catch (e) {
        visible = false;
        throw Exception('Error downloading pdf file!');
      }
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            'फाइल ${itemDetails}',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 2.0 * SizeConfig.height),
          ),
        ),
        body: visible == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(0.0 * SizeConfig.height),
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(1.5 * SizeConfig.height),
                            child: Text(
                                '(${computerNo}) विभाग-${departmentName}',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(1.5 * SizeConfig.height),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          visible = true;
                          createFileOfPdfUrl("0").then((f) {
                            setState(() {
                              remotePDFpath = f.path;
                              if (remotePDFpath.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFScreen(
                                        path: remotePDFpath,
                                        fileName:
                                            "मा० मंत्रिपरिषद के लिए टिप्पणी"),
                                  ),
                                );
                              }
                            });
                          });
                        },
                        label: Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: Text(
                            'मा० मंत्रिपरिषद के लिए टिप्पणी देखें',
                            style: TextStyle(
                                fontSize: 1.8 * SizeConfig.height,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        icon: Icon(
                          Icons.folder,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("1").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 1"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 1 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("2").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;

                                  print("Remote path == ${remotePDFpath}");

                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 2"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 2 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("3").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 3"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 3 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("4").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 4"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 4 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("5").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 5"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 5 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("6").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 6"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 6 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("7").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 7"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 7 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("8").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 8"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 8 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("9").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 9"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 9 ',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(1.5 * SizeConfig.height),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              createFileOfPdfUrl("10").then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  if (remotePDFpath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            fileName: "संलग्नक 10"),
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                            label: Padding(
                              padding: EdgeInsets.all(1.5 * SizeConfig.height),
                              child: Text(
                                'संलग्नक 10',
                                style: TextStyle(
                                    fontSize: 1.8 * SizeConfig.height,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            icon: Icon(
                              Icons.folder,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                )));
  }

  @override
  void dispose() {
    super.dispose();
    visible = false;
  }
}

class PDFScreen extends StatefulWidget {
  final String path;
  final String fileName;

  PDFScreen({Key key, this.path, this.fileName}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String currentDate = '';
  static final Random random = Random();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel androidNotificationChannel;

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    currentDate = formatter.format(now);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails('channel id', 'channel name',
        priority: Priority.high, importance: Importance.max,ongoing: true,styleInformation: BigTextStyleInformation(''));
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    var randid = random.nextInt(10000);

    await flutterLocalNotificationsPlugin.show(
        randid,
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? '${downloadStatus['fileName']} File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<bool> _checkPermission() async {
    bool pstatus = false;
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      pstatus = true;
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }

    return pstatus;
  }

  Future<void> _readFileByte() async {
    bool status = await _checkPermission();

    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'fileName': null,
      'error': null,
    };

    if (status == true) {
      try {
        Uri myUri = Uri.parse(widget.path);
        File audioFile = new File.fromUri(myUri);
        Uint8List bytes;
        await audioFile.readAsBytes().then((value) {
          bytes = Uint8List.fromList(value);
          print('reading of bytes is completed');
        }).catchError((onError) {
          print('Exception Error while reading audio from path:' +
              onError.toString());
        });

        var randid = random.nextInt(10000);
        var fileName = "CM_${randid}_${currentDate}.pdf";

        //String _localPath = (await getExternalStorageDirectories(type: StorageDirectory.downloads)).first.path;

        Directory directory;

        String _localPath;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);

          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);

          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          _localPath = directory.path;
        } else if (Platform.isIOS) {
          _localPath = (await getDownloadsDirectory()).path;
        }

        File file2 = File("${_localPath}/$fileName");
        await file2.writeAsBytes(bytes);

        print('download Completed = ' + _localPath);

        result['isSuccess'] = true;
        result['filePath'] = "${_localPath}/$fileName";
        result['fileName'] = fileName;
      } catch (e) {
        result['error'] = e.toString();
      } finally {
        await _showNotification(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "${widget.fileName}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 2.0 * SizeConfig.height),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () {
              _readFileByte();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      /*floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),*/
    );
  }
}
