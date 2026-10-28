import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final TextInputType? type;
  final String? isIcon;
  final Icon? prefixIcon;
  final TextEditingController? myController;
  final String? Function(String?)? validator;
  const Textfield({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.isPassword,
    required this.myController,
    this.type,
    this.isIcon,
    this.validator,
    this.prefixIcon,
  });
  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Can't be empty";
        }
      },
      obscureText: widget.isPassword ? _obscure : false,
      controller: widget.myController,
      keyboardType: widget.type,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: Icon(
                  _obscure ? Icons.visibility_sharp : Icons.visibility_off,
                ),
              )
            : null,
        prefixIcon: widget.prefixIcon,
        fillColor: Colors.grey[300],
        hintText: "${widget.hintText}",
        labelText: "${widget.labelText}",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
