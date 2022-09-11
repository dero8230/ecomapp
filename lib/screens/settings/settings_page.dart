import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eShop/PanelTemp/cpanelHome.dart';
import 'package:eShop/app_properties.dart';
import 'package:eShop/custom_background.dart';
import 'package:eShop/screens/settings/change_country.dart';
import 'package:eShop/screens/settings/change_password_page.dart';
import 'package:eShop/screens/settings/legal_about_page.dart';
import 'package:eShop/screens/settings/notifications_settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ndialog/ndialog.dart';

import 'change_language_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white.withOpacity(0),
          title: Text(
            'Settings',
            style: TextStyle(color: darkGrey),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder: (builder, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                          maxWidth:
                              (MediaQuery.of(context).size.width * 2) / 3),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'General',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Language A / का'),
                              leading: Image.asset('assets/icons/language.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeLanguagePage())),
                            ),
                            ListTile(
                              title: Text('Change Country'),
                              leading: Image.asset('assets/icons/country.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeCountryPage())),
                            ),
                            ListTile(
                              title: Text('Notifications'),
                              leading:
                                  Image.asset('assets/icons/notifications.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          NotificationSettingsPage())),
                            ),
                            ListTile(
                              title: Text('Legal & About'),
                              leading: Image.asset('assets/icons/legal.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => LegalAboutPage())),
                            ),
                            ListTile(
                              title: Text('About Us'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {},
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Change Password'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage())),
                            ),
                            ListTile(
                              title: Text('Sign out'),
                              leading: Image.asset('assets/icons/sign_out.png'),
                              onTap: () async {
                                await GoogleSignIn().signOut();
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                              },
                            ),
                            // futureBuilder
                            FutureBuilder<bool>(
                                future: FireStorage.isAdmin(
                                    FirebaseAuth.instance.currentUser),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  // return error
                                  if (snapshot.hasError) {
                                    return ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        'request admin privileges',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    if (!snapshot.data!) {
                                      return ElevatedButton(
                                        onPressed: () => Trans().dialogNav(
                                            RequestPrivilegesPage(), context),
                                        child: Text(
                                          'request admin privileges',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                    return ListTile(
                                      title: Text('Admin Panel'),
                                      leading: Icon(Icons.admin_panel_settings),
                                      onTap: () // push cpanel
                                          =>
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                        builder: (_) => FitnessAppHomeScreen(),
                                      )),
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}

class RequestPrivilegesPage extends StatefulWidget {
  const RequestPrivilegesPage({Key? key}) : super(key: key);

  @override
  State<RequestPrivilegesPage> createState() => _RequestPrivilegesPageState();
}

class _RequestPrivilegesPageState extends State<RequestPrivilegesPage> {
  late Widget home;
  final TextEditingController txt = TextEditingController();
  void requestAdminPrivileges() async {
    final uKey = txt.text.trim();
    if (uKey.isEmpty) return;
    var pro = ProgressDialog(context,
        title: Text("Please Wait"),
        message: Text("verifying key"),
        dismissable: false);
    final pro2 = ProgressDialog(context,
        title: Text("Key is valid"),
        message: Text("updating privileges"),
        dismissable: false);
    try {
      pro.show();
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) throw Exception("no internet connection");
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc("adminKey")
          .get(GetOptions(source: Source.server));
      final data = doc.data();
      if (data == null)
        throw Exception("an error occurred while verifying key");
      final adminKey = data["key"] as String;
      final bool isValid = uKey == adminKey;
      if (!isValid) throw Exception("invalid key");
      pro.dismiss();
      pro = pro2;
      pro.show();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final map = <String, dynamic>{'admin': true};
      await FirebaseFirestore.instance.collection("users").doc(uid).set(map);
      pro.dismiss();
      setState(() {
        home = NAlertDialog(
          onDismiss: Navigator.of(context).pop,
          actions: [
            TextButton(
                onPressed: Navigator.of(context).pop, child: Text("dismiss"))
          ],
          title: Text("All Done!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/success.svg",
                color: kPrimaryColor,
              ),
              Text("you are now an admin"),
            ],
          ),
        );
      });
    } on Exception catch (e) {
      pro.dismiss();
      NAlertDialog(
        actions: [
          TextButton(
              onPressed: Navigator.of(context).pop, child: Text("dismiss"))
        ],
        title: Align(alignment: Alignment.topLeft, child: Icon(Icons.error)),
        content: Text(e.toString().format()),
      ).show(context);
    }
  }

  @override
  void initState() {
    home = DialogBackground(
      blur: 3,
      dismissable: false,
      dialog: NDialog(
        title: Text("Enter admin key"),
        content: TextField(
          controller: txt,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "key",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel")),
          TextButton(onPressed: requestAdminPrivileges, child: Text("proceed"))
        ],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return home;
  }
}
