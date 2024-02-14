
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
    const CustomTextField({
        super.key, required this.hintText, required this.isPassword, required this.icon, this.validator, required this.controller,
    });

    final String hintText;
  final bool isPassword;
  final IconData icon;
  final String? Function(String?)? validator;

  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

}
class _CustomTextFieldState extends State<CustomTextField> {
  bool showHidePassword = true;

    @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && showHidePassword,
        validator: widget.validator,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword ? IconButton(
            icon:showHidePassword
            ? const Icon(Icons.visibility)
            :const Icon(Icons.visibility_off),
            onPressed: (){
              showHidePassword =!showHidePassword;
              setState(() {
                
              });
            },
          )
          :const SizedBox.shrink(),
            prefixIcon:  Icon(widget.icon, color: Colors.blue),
            hintText: widget.hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Colors.blue, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Colors.red, width: 2))),
      ),
    );
  }
}