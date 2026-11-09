import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/widgets/text_field.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _academicCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _academicCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final med = mediaQuery.size.width;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back! 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.adaptiveColor(
                    light: Colors.black87,
                    dark: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Sign in to continue exploring AcademicHub",
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: Colors.grey,
                    dark: colors.onSurfaceVariant,
                  ),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              Textfield(
                hintText: "Enter Academic Code",
                isPassword: false,
                myController: _academicCodeController,
                labelText: 'Academic Code',
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: med * 0.08),
              Textfield(
                hintText: "Enter Password",
                isPassword: true,
                myController: _passwordController,
                labelText: 'Password',
                prefixIcon: Icon(Icons.phonelink_lock_outlined),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final Uri whatsapp = Uri.parse(
                      "https://wa.me/+01044745279",
                    );
                    await launchUrl(
                      whatsapp,
                      mode: LaunchMode.externalApplication,
                    );
                  },

                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: colors.adaptiveColor(
                        light: Colors.blue.shade900,
                        dark: colors.primary,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      mainScreen,
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome back"),
                        backgroundColor: colors.adaptiveColor(
                          light: Colors.grey,
                          dark: colors.inverseSurface,
                        ),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is AuthErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.adaptiveColor(
                              light: Colors.white,
                              dark: colors.onError,
                            ),
                          ),
                        ),
                        backgroundColor: colors.adaptiveColor(
                          light: Colors.red,
                          dark: colors.error,
                        ),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colors.adaptiveColor(
                          light: Colors.white,
                          dark: colors.primary,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.adaptiveColor(
                          light: Colors.blue.shade900,
                          dark: colors.primary,
                        ),
                        foregroundColor: colors.adaptiveColor(
                          light: Colors.white,
                          dark: colors.onPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).login(
                            academicCode: _academicCodeController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.adaptiveColor(
                            light: Colors.white,
                            dark: colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
