import 'package:academichub/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _pages = [
    {
      'title': 'All Your Campus Resources \nin One Hub',
      'subtitle':
          'Access lectures, PDFs, and schedules instantly \n without distraction.',
      "image": "assets/1.png",
    },
    {
      'title': 'Track Your \nAcademic Progress.',
      'subtitle':
          'Never miss an assignment deadline or lecture\n notification.',
      "image": "assets/2.png",
    },
    {
      'title': 'Interactive Learning \n& Feedback',
      'subtitle':
          'Connect with instructors, submit voice notes, \nand review assignment grades.',
      "image": "assets/3.png",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> navigateAndSetBool() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isFirstTime', false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, authScreen);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final med = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon2.png", width: med * .13),
            Text(
              "Academic",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: med * .06,
              ),
            ),
            Text(
              " Hub",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: med * .05,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "${_pages[index]['image']}",
                          height: med * 0.7,
                        ),
                        Text(
                          "${_pages[index]["title"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: med * 0.07,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: med * 0.03),
                        Text(
                          "${_pages[index]["subtitle"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: med * 0.03,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // SizedBox(height: med * 0.14),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: med * 0.001),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 60 : 30,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.blueAccent
                        : Colors.lightBlue[200],
                  ),
                );
              }),
            ),
            SizedBox(height: med * 0.17),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _currentPage == _pages.length - 1
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        navigateAndSetBool();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 25,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.blueAccent,
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Icon(
                              Icons.arrow_right_alt,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
