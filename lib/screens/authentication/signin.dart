import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ishop_sellers/components/custom_text_field.dart';
import 'package:ishop_sellers/components/global.dart';
import 'package:ishop_sellers/components/password_text_field.dart';
import 'package:ishop_sellers/components/snackbar.dart';
import 'package:ishop_sellers/screens/authentication/forgetPassword.dart';
import 'package:ishop_sellers/screens/authentication/register.dart';
import 'package:ishop_sellers/screens/home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool? remember = false;
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    User? currentUser;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((auth) => {
                currentUser = auth.user,
              });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }
    if (currentUser != null) {
      await checkIfSellerRecordExists(currentUser!);
    }
    setState(() {
      isLoading = false;
    });
  }

  checkIfSellerRecordExists(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      if (record.exists) //record exists
      {
        //status is approved
        if (record.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!
              .setString("fullname", record.data()!["fullname"]);
          await sharedPreferences!
              .setString("photoUrl", record.data()!["photoUrl"]);

          //send seller to home screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const HomePage()));
              
          showSnackBar(context, "welcome back");
        } else //status is not approved
        {
          FirebaseAuth.instance.signOut();
          showSnackBar(context,
              "you have BLOCKED by admin.\ncontact Admin: admin@ishop.com");
        }
      } else //record not exists
      {
        FirebaseAuth.instance.signOut();
        showSnackBar(context, "This seller's record do not exists.");
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  "assets/images/login.png",
                  height: MediaQuery.of(context).size.height * 0.30,
                ),
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.purple,
                  fontFamily: "Arial",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  //email
                  CustomTextField(
                    textEditingController: emailController,
                    prefixiconData: Icons.email,
                    hintText: "Email",
                    isDone: false,
                  ),

                  //pass
                  PasswordTextField(
                    textEditingController: passwordController,
                    hintText: "Password",
                    isDone: true,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: remember,
                          activeColor: Colors.purpleAccent,
                          onChanged: (value) {
                            setState(() {
                              remember = value;
                            });
                          },
                        ),
                        const Text("Remember me"),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgetPassword()),
                            );
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                  ),
                  onPressed: () async {
                    await signIn();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset("assets/icons/google.svg"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset("assets/icons/facebook.svg"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset("assets/icons/twitter.svg"),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.purple),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
