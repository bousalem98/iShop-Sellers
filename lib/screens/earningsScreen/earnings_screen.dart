import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishop_sellers/components/global.dart';
import 'package:ishop_sellers/screens/home_page.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String totalSellerEarnings = "";

  readTotalEarnings() async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      setState(() {
        totalSellerEarnings = snap.data()!["earnings"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    readTotalEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$ $totalSellerEarnings",
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "My Total Earnings",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 220,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c) => const HomePage()));
                    },
                    leading: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Go Back",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
