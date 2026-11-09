import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:academichub/data/repository/auth/auth_repository.dart';
import 'package:academichub/data/services/auth/authService.dart';
import 'package:academichub/presentation/widgets/login_widget.dart';
import 'package:academichub/presentation/widgets/register_widget.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
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
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository(AuthServices())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.adaptiveColor(
            light: Colors.white,
            dark: colors.surface,
          ),
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
                  color: colors.adaptiveColor(
                    light: Colors.blue.shade900,
                    dark: colors.primary,
                  ),
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
                                ? colors.adaptiveColor(
                                    light: Colors.blue.shade900,
                                    dark: colors.primary,
                                  )
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
                                  ? colors.adaptiveColor(
                                      light: Colors.white,
                                      dark: colors.onPrimary,
                                    )
                                  : colors.adaptiveColor(
                                      light: Colors.black54,
                                      dark: colors.onSurfaceVariant,
                                    ),
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
                                ? colors.adaptiveColor(
                                    light: Colors.blue.shade900,
                                    dark: colors.primary,
                                  )
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
                                  ? colors.adaptiveColor(
                                      light: Colors.white,
                                      dark: colors.onPrimary,
                                    )
                                  : colors.adaptiveColor(
                                      light: Colors.black54,
                                      dark: colors.onSurfaceVariant,
                                    ),
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
                    color: colors.adaptiveColor(
                      light: const Color.fromRGBO(238, 238, 238, 1),
                      dark: colors.surfaceContainerHighest,
                    ),
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
