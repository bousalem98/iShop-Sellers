import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ishop_sellers/components/global.dart';
import 'package:ishop_sellers/components/snackbar.dart';
import 'package:ishop_sellers/screens/authentication/signin.dart';
import 'package:ishop_sellers/screens/earningsScreen/earnings_screen.dart';
import 'package:ishop_sellers/screens/historyScreen/history_screen.dart';
import 'package:ishop_sellers/screens/home_page.dart';
import 'package:ishop_sellers/screens/order/orders_screen.dart';
import 'package:ishop_sellers/screens/shifted_parcels/shifted_parcels_screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black38,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                Container(
                    // ignore: prefer_const_constructors
                    child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 225, 225, 225),
                  radius: 71,
                  backgroundImage:
                      NetworkImage(sharedPreferences!.getString("photoUrl")!),
                )),

                const SizedBox(
                  height: 20,
                ),

                //user name
                Text(
                  sharedPreferences!.getString("fullname")!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 50,
          ),
          //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //home
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => const HomePage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "Earnings",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const EarningsScreen()));
                  },
                ),

                //my orders
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "New Orders",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const OrdersScreen()));
                  },
                ),

                //not yet received orders
                ListTile(
                  leading: const Icon(
                    Icons.picture_in_picture_alt_rounded,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "Shifted Parcels",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const ShiftedParcelsScreen()));
                  },
                ),

                //history
                ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const HistoryScreen()));
                  },
                ),

                //logout
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                    showSnackBar(context, "logout succefully");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
