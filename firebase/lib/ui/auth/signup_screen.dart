import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);


  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  var confirmPass;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }
  void signUp(){
    _auth.createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passController.text.toString(),
    ).then((value) {
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessages(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Light',
                                textStyle: const TextStyle(
                                    fontSize: 40.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold),
                                colors: colorizeColors,
                              ),
                            ],
                            isRepeatingAnimation: true,
                            repeatForever: true,
                          ),
                        ),
                        const Text('Travel With speed of Light',style: TextStyle(fontSize: 8),)
                      ],
                    ),
                  ],
                ),
                const Gap(50),
                const Text('Create Account',style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),),
                const Gap(20),
                Form(
                    key:  _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Name';
                            }
                            else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.perm_identity_outlined),
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                          ),
                        ),
                        const Gap(10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Password';
                            }
                            else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                              hintText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                          ),
                        ),
                        const Gap(10),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passController,
                          obscureText: true,
                          validator: (value){
                            confirmPass = value;
                            if(value!.isEmpty){
                              return 'Enter Password';
                            }
                            else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_open),
                            hintText: 'Password',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                          ),
                        ),
                        const Gap(10),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: repassController,
                          obscureText: true,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Re-type Password';
                            }
                            else if(value != confirmPass.toString()){
                              return 'Password must be same';
                            }
                            else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_open),
                            hintText: 'Re-type Password',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                const Gap(40),
                RoundButton(title: 'Sign Up',
                  ontap: () {
                  setState(() {
                    loading = true;
                  });
                    if(_formKey.currentState!.validate()){
                      signUp();
                    }
                  },
                  loading: loading,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account ?"),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const LoginScreen()));
                    }, child: const Text('Login'))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
