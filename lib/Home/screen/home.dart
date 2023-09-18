import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_app/constants/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Links {
  final String id;
  final String thumbnail;
  final String title;
  final String url;

  Links(
      {required this.id,
      required this.thumbnail,
      required this.title,
      required this.url});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
        id: json['id'],
        thumbnail: json['thumbnail'],
        title: json['title'],
        url: json['url']);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  bool isLoading = false;
  bool? isDownloading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: Constants.inputHintText,
                // errorText: Constants.inputErrorText,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                              'https://yt-downloader-backend-m39i.onrender.com/yt/https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DdQw4w9WgXcQ/metadata')),
                      title: Text('hello'),
                      horizontalTitleGap: 50,
                      
                      onTap: () {
                        // downloadFile(url: finalUrl);
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                onPressed: () {
                  fetchFile(link: _urlController.text);

                  // openFile(url: _urlController.text.trim());
                  // FileDownloader.downloadFile(
                  //     url: _urlController.text.trim(),
                  //     name: 'test',

                  //     onProgress: (name, progress) {
                  //       setState(() {
                  //         _progress = progress;
                  //       });
                  //     },
                  //     onDownloadCompleted: (value) {
                  //       final File file = File(value);
                  //       print('path $value');
                  //       setState(() {
                  //         _progress = null;
                  //       });
                  //     });
                },
                child: const Text(
                  'Check',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                  value: 0.3,
                ),
              ),
          ],
        ),
      )),
    );
  }

  // Future openFile({required String url, String? name}) async {
  //   final filename = name ?? url.split('/').last;
  //   final file = await downloadFile(url: url, name: filename);
  //   if (file == null) return;
  //   {
  //     print('path: ${file.path}');
  //     OpenFile.open(file.path);
  //   }
  // }

  // Future downloadFile({required String url, String? name}) async {
  //   final appStorage = await getExternalStorageDirectory();
  //   final file = File('${appStorage!.path}/$name');

  //   final response = await Dio().get(
  //     url,
  //     options: Options(
  //       responseType: ResponseType.bytes,
  //       followRedirects: false,
  //     ),
  //   );

  //   final raf = file.openSync(mode: FileMode.write);
  //   raf.writeFromSync(response.data);
  //   await raf.close();

  //   return file;
  // }

  Future downloadFile({required String url, String? name}) async {

    final appStorage = await getExternalStorageDirectory();
    
  }
  Future fetchFile({required String link}) async {
    final Dio dio = Dio();

    final finalUrl = Uri.encodeQueryComponent(link);
    var baseUrl =
        "https://yt-downloader-backend-m39i.onrender.com/yt/$finalUrl/metadata";
    print(baseUrl);

    var response = await dio.get(baseUrl);

    final jsonData = response.data as Map<String, dynamic>;
    final myData = Links.fromJson(jsonData);
    print("Url: ${myData.url}");
    print("Title: ${myData.title}");
    print("Thumbnail: ${myData.thumbnail}");
    print("Id: ${myData.id}");

    return myData;
  }
}
