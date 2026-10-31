import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:academichub/business_logic/auth/cubit/auth_cubit.dart'; // مسار الكيوبت بتاعك

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});
  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _academicCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameController.dispose();
    _academicCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final med = mediaQuery.size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to AcademicHub! 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Register to continue exploring AcademicHub",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              Textfield(
                hintText: "Enter Name",
                isPassword: false,
                myController: _nameController,
                labelText: 'Name',
                prefixIcon: Icon(Icons.nest_cam_wired_stand),
              ),
              SizedBox(height: med * 0.07),
              Textfield(
                hintText: "Enter Academic Code",
                isPassword: false,
                myController: _academicCodeController,
                labelText: 'Academic Code',
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: med * 0.07),
              Textfield(
                hintText: "Enter Password",
                isPassword: true,
                myController: _passwordController,
                labelText: 'Password',
                prefixIcon: Icon(Icons.phonelink_lock_outlined),
              ),
              SizedBox(height: med * 0.07),
              Textfield(
                hintText: "Enter Confirm Password",
                isPassword: true,
                myController: _confirmPasswordController,
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.phonelink_lock_outlined),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 25),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessState) {
                    FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Email Registered",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginWidget, (route) => false);
                  } else if (state is AuthErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text.trim() !=
                              _confirmPasswordController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Password don't match",
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            BlocProvider.of<AuthCubit>(context).register(
                              academicCode: _academicCodeController.text.trim(),
                              password: _passwordController.text.trim(),
                              confirmPassword: _confirmPasswordController.text
                                  .trim(),
                              name: _nameController.text.trim(),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
