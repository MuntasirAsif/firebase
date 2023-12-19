import 'dart:io';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase/ui/post_screen.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late String url;
  File ? _image;
  final picker = ImagePicker();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  DateTime _lunchingDateTime = DateTime.now();
  DateTime _returningDateTime = DateTime.now();
  final toController = TextEditingController();
  final fromController = TextEditingController();
  final companyController = TextEditingController();
  final spaceController = TextEditingController();
  final priceController = TextEditingController();
  final lunchCode = DateTime.now().microsecondsSinceEpoch.toString();
  late String destinationType = '';
  void onLaunching(DateTime lunchingDate) {
    setState(() {
      _lunchingDateTime = lunchingDate;
    });
  }

  void onReturn(DateTime returnDate) {
    setState(() {
      _returningDateTime = returnDate;
    });
  }

  void addPost(String url) {
    ref.child(lunchCode).set({
      'image' : url,
      'fromAdd': fromController.text.toString(),
      'toAdd': toController.text.toString(),
      'lunchCode': lunchCode,
      'spaceName': spaceController.text.toString(),
      'price': priceController.text.toString(),
      'destinationType': destinationType,
      'lunchingDate': _lunchingDateTime.toString().substring(0,10),
      'returningDate': _returningDateTime.toString().substring(0,10),
    }).then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScrren()));
      Utils().toastMessages('Post added Successfully');
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessages(error.toString());
    });
  }

  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile!=null){
        _image = File(pickedFile.path);
      }else{
        Utils().toastMessages('No image Selected');
      }
    });
  }


  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://fir-aa282-default-rtdb.asia-southeast1.firebasedatabase.app')
      .ref("post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wirte Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              const Text('Destination Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Column(
                children: [
                  const Gap(5),
                  CustomRadioButton(
                    enableShape: true,
                    buttonLables: const [
                      'Planet',
                      'Satelite',
                      'Space Station',
                    ],
                    buttonValues: const [
                      'Planet',
                      'Satelite',
                      'Space Station',
                    ],
                    radioButtonValue: (value) {
                      destinationType = value;
                    },
                    unSelectedColor: Colors.white70,
                    selectedColor: Colors.black,
                  ),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Gap(20),
                      const Row(
                        children: [
                          Icon(Icons.location_on),
                          Text(
                            ' Destination',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 170,
                            child: TextFormField(
                              controller: fromController,
                              maxLines: 1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Address';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "From",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: TextFormField(
                              controller: toController,
                              maxLines: 1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Address';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "To",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.rocket_launch),
                                  Text(' Launching Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                              const Gap(5),
                              SizedBox(
                                width: 170,
                                child: CupertinoDateTextBox(
                                  initialValue: _lunchingDateTime,
                                  onDateChange: onLaunching,
                                  hintText: 'Date',
                                  hintColor: Colors.black12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.rocket_rounded),
                                  Text(' Return Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                              const Gap(5),
                              SizedBox(
                                width: 170,
                                child: CupertinoDateTextBox(
                                  initialValue: _returningDateTime,
                                  onDateChange: onReturn,
                                  hintText: 'Date',
                                  hintColor: Colors.black12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Space',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const Gap(5),
                                SizedBox(
                                  width: 170,
                                  child: TextFormField(
                                    controller: spaceController,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Name';
                                      } else if (value.length > 8) {
                                        return 'More than 8 Characters ';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Space Name",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                ),
                              ]),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const Gap(5),
                              SizedBox(
                                width: 170,
                                child: TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Price';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "\$ 10000000",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(10),
                      Column(
                        children: [
                          const Text('Destination Image'),
                          const Gap(10),
                          InkWell(
                            onTap: (){
                              getImageGallery();
                            },
                            child: Container(
                              height: 150,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: _image != null ? Image.file(_image!.absolute): const Icon(Icons.image),
                            ),
                          )
                        ],
                      ),
                      const Gap(20),
                    ],
                  )),
              SizedBox(
                child: RoundButton(
                  ontap: () {
                    setState(() {
                      loading = true;
                    });
                    if(destinationType == ''){
                      loading = false;
                      Utils().toastMessages('Select Destination Type');
                    }else if(_image == null){
                      loading = false;
                      Utils().toastMessages('Select Destination Image');
                    }
                    else{
                      if (_formKey.currentState!.validate()) {
                        warningDialog();
                      } else {
                        loading = false;
                      }
                    }
                  },
                  title: 'Add post',
                  loading: loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> warningDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ),
                Gap(10),
                Text('Warning',style: TextStyle(color: Colors.red),)
              ],
            ),
            content: const SizedBox(
              height: 90,
              width: 300,
              child: Column(
                children: [
                  Text(
                      "You can't change after submission. Please check all information are right"),
                  Gap(30),
                  Text('Are you sure ? ',style: TextStyle(color: Colors.red),)
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    uploadPic(_image!);
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
  uploadPic(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child("image${DateTime.now()}");
    UploadTask uploadTask = storageRef.putFile(image);
    Future.value(uploadTask).then((value) async {
      url = await storageRef.getDownloadURL();
      addPost(url);
    }).catchError((onError) {
      Utils().toastMessages(onError);
    });
  }
}
