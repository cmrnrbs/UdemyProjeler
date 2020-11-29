import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customclasses/page.dart';
import 'homepage.dart';

class AppIntroScreen extends StatefulWidget {
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  int pageindex = 0;
  PageController _pageController;
  List<CustomPage> myPages = [
    CustomPage(avatar: Icons.home, title: 'Title1', subtitle: 'Subtitle1'),
    CustomPage(
        avatar: Icons.accessibility, title: 'Title2', subtitle: 'Subtitle2'),
    CustomPage(
        avatar: Icons.shopping_basket, title: 'Title3', subtitle: 'Subtitle3'),
  ];

  Widget getPage(index) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green[600]),
                child: Icon(
                  myPages[index].avatar,
                  size: 40,
                  color: Colors.white,
                )),
            SizedBox(
              height: 40,
            ),
            Text(
              myPages[index].title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Text(myPages[index].subtitle)
          ],
        ),
      ),
    );
  }

  setFirstRunAndGotoPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("firstRun", false).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController = new PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                pageindex = value;
              });
            },
            children: [getPage(0), getPage(1), getPage(2)],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CustomPageIndicator(
                        index: pageindex,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            if (pageindex != 2) {
                              _pageController.animateToPage(pageindex + 1,
                                  duration: new Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            } else {
                              //Sayfaya git
                              setFirstRunAndGotoPage();
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(pageindex != 2 ? 'İleri' : 'Bitir'),
                              pageindex != 2
                                  ? Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    )
                                  : SizedBox()
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomPageIndicator extends StatelessWidget {
  int index;
  CustomPageIndicator({this.index});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: index == 0 ? Colors.black : Colors.grey,
              shape: BoxShape.circle),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: index == 1 ? Colors.black : Colors.grey,
              shape: BoxShape.circle),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: index == 2 ? Colors.black : Colors.grey,
              shape: BoxShape.circle),
        ),
      ],
    );
  }
}
