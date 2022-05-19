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

class RowViewNotice extends StatefulWidget {
  int index;
  String meetingcode;
  String meetingtypeid;
  String changeLogID;
  String meetingtext;

  RowViewNotice(this.index, this.meetingcode, this.meetingtypeid,
      this.changeLogID, this.meetingtext);

  @override
  State<RowViewNotice> createState() => _RowViewNoticeState();
}

class _RowViewNoticeState extends State<RowViewNotice> {
  String currentDate;
  String remotePDFpath = "";
  bool visible = false;
  static final Random random = Random();

  Future<File> createFileOfPdfUrl(
      String mid, String mtyid, String docno) async {
    visible = true;
    Completer<File> completer = Completer();

    var fileName = "CM_Notice_${docno}_${currentDate}.pdf";
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
            'getMeetingDoc?meetingcode=${mid}&meetingType=${mtyid}');

        var response = await http.get(
          uri,
        );

        var statuscode = response.statusCode;
        var bytes = response.bodyBytes;

        if (statuscode == 200) {
          visible = false;
          var fileName = "CM_Notice_${docno}_${currentDate}.pdf";
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
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 4.0 * SizeConfig.width, right: 4.0 * SizeConfig.width),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: const Color(0xffFFff5722), width: 1.0)),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(1.0 * SizeConfig.height),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                  "(${widget.index + 1}) - " +
                                      widget.meetingtext,
                                  style: TextStyle(
                                      fontSize: 1.5 * SizeConfig.height,
                                      fontWeight: FontWeight.bold,
                                      height: 0.2 * SizeConfig.height,
                                      color: Colors.black)),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(
                                            0.7 * SizeConfig.height),
                                        child: GestureDetector(
                                          onTap: () {
                                            createFileOfPdfUrl(
                                                    widget.meetingcode,
                                                    widget.meetingtypeid,
                                                    widget.index.toString())
                                                .then((f) {
                                              setState(() {
                                                remotePDFpath = f.path;
                                                if (remotePDFpath.isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NoticeView(
                                                              path:
                                                                  remotePDFpath),
                                                    ),
                                                  );
                                                }
                                              });
                                            });
                                          },
                                          child: Text(
                                            'View Notice',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize:
                                                    1.7 * SizeConfig.height,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NoticeView extends StatefulWidget {
  final String path;

  NoticeView({Key key, this.path}) : super(key: key);

  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String currentDate = '';
  static final Random random = Random();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
        var fileName = "CM_Notice${randid}_${currentDate}.pdf";

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
          "नोटिस डॉक्यूमेंट",
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
    );
  }
}
