import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:academichub/data/repository/auth_repository.dart';
import 'package:academichub/data/services/authService.dart';
import 'package:academichub/presentation/widgets/loginWidget.dart';
import 'package:academichub/presentation/widgets/registerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});
  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final med = mediaQuery.size.width;
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository(AuthServices())),
      child: Scaffold(
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
              SizedBox(height: med * 0.05),
              Text(
                "Welcome to\nAcademicHub",
                style: TextStyle(
                  fontSize: med * 0.06,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: med * 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Learn - Grow - Succeed")],
              ),

              SizedBox(height: med * 0.03),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: _currentPage == 0
                                ? Colors.blue[900]
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _controller.animateToPage(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: _currentPage == 0
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: _currentPage == 1
                                ? Colors.blue[900]
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _controller.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: _currentPage == 1
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: med * 0.09),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    color: Colors.grey[200],
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [LoginWidget(), RegisterWidget()],
                    ),
                  ),
                ),
              ),
              SizedBox(height: med * 0.05),
              Text("Secure access to your learning journey"),
              SizedBox(height: med * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
