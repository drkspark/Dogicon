import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall_paper_app/full_scrren.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    // String base = 'https://api.pexels.com/v1/curated?per_page=80';
    String base = 'https://api.pexels.com/v1/search?query=dog&per_page=80';

    await http.get(Uri.parse(base), headers: {
      'Authorization':
          'UR API KEY'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      //! print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    // String url ='https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    String url =
        'https://api.pexels.com/v1/search?query=dogs&per_page=80&page=' +
            page.toString();

    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'UR API KEY'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreen(
                            imageurl: images[index]['src']['large2x'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        images[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Load More',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
