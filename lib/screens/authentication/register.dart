import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishop_sellers/components/decoration_register.dart';
import 'package:ishop_sellers/components/global.dart';
import 'package:ishop_sellers/components/snackbar.dart';
import 'package:ishop_sellers/screens/authentication/signin.dart';
import 'package:ishop_sellers/screens/home_page.dart';
import 'package:path/path.dart' show basename;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisable1 = true;
  bool isVisable2 = true;

  File? imgPath;
  String? imgName;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  uploadImage2Screen(ImageSource source) async {
    final pickedImg =
        await ImagePicker().pickImage(source: source, imageQuality: 25);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

// Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref("sellers-imgs/$imgName");
      await storageRef.putFile(imgPath!);
      String imgUrl = await storageRef.getDownloadURL();

      //print(credential.user!.uid);

      CollectionReference sellers =
          FirebaseFirestore.instance.collection('sellers');

      sellers
          .doc(credential.user!.uid)
          .set({
            "uid": credential.user!.uid,
            "fullname": fullnameController.text,
            "email": emailController.text,
            "phone": phoneController.text,
            "address": locationController.text,
            "photoUrl": imgUrl,
            "status": "approved",
            "earnings": 0.0,
          })
          .then((value) async => {
                sharedPreferences = await SharedPreferences.getInstance(),
                await sharedPreferences!.setString("uid", credential.user!.uid),
                await sharedPreferences!
                    .setString("fullname", fullnameController.text),
                await sharedPreferences!
                    .setString("email", emailController.text),
                await sharedPreferences!.setString("photoUrl", imgUrl),
                await sharedPreferences!
                    .setStringList("userCart", ["initialValue"]),
              })
          .whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              ))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "ERROR - Please try again late");
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                ),
                child: Stack(
                  children: [
                    imgPath == null
                        ? const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 225, 225, 225),
                            radius: 71,
                            backgroundImage:
                                AssetImage("assets/images/user.jpg"),
                          )
                        : ClipOval(
                            child: Image.file(
                              imgPath!,
                              width: 145,
                              height: 145,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      left: 99,
                      bottom: -10,
                      child: IconButton(
                        onPressed: () {
                          // uploadImage2Screen();
                          showmodel();
                        },
                        icon: const Icon(Icons.add_a_photo),
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Enter your real Store Name" : null;
                  },
                  controller: fullnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  obscureText: false,
                  maxLength: 20,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Store Name : ",
                      suffixIcon: const Icon(Icons.person))),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                  // we return "null" when something is valid
                  validator: (value) {
                    return value!.length != 8
                        ? "Enter your real phone number"
                        : null;
                  },
                  controller: phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Phone number : ",
                      suffixIcon: const Icon(Icons.phone))),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Enter your real address" : null;
                  },
                  controller: locationController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your address : ",
                      suffixIcon: const Icon(Icons.location_city))),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                  // we return "null" when something is valid
                  validator: (email) {
                    return email!.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Enter a valid email";
                  },
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: const Icon(Icons.email))),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                  // we return "null" when something is valid
                  validator: (value) {
                    return value!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisable1 ? true : false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable1 = !isVisable1;
                            });
                          },
                          icon: isVisable1
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)))),
              const SizedBox(
                height: 22,
              ),
              TextFormField(
                  // we return "null" when something is valid
                  validator: (value) {
                    return value != passwordController.text
                        ? "the passwords are not identical"
                        : null;
                  },
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmpasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisable2 ? true : false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Confirm Your Password : ",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable2 = !isVisable2;
                            });
                          },
                          icon: isVisable2
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)))),
              const SizedBox(
                height: 22,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      imgName != null &&
                      imgPath != null) {
                    await register();
                    if (!mounted) return;
                  } else {
                    showSnackBar(context, "Please select an image");
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You have already an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      },
                      child: const Text('Sign In',
                          style:
                              TextStyle(fontSize: 18, color: Colors.purple))),
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
