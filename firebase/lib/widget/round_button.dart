import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool loading;
  const RoundButton({Key? key, required this.title, required this.ontap,this.loading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading? const CircularProgressIndicator(color: Colors.white,):
          Text(title,style: const TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
