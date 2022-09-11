import 'package:eShop/app_properties.dart';
import 'package:eShop/screens/faq_page.dart';
import 'package:eShop/screens/payment/payment_page.dart';
import 'package:eShop/screens/settings/settings_page.dart';
import 'package:eShop/screens/tracking_page.dart';
import 'package:eShop/screens/wallet/wallet_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ndialog/ndialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void login() async {
    var pro = ProgressDialog(context,
        title: Text("Please Wait"),
        message: Text("logging in"),
        dismissable: false);
    try {
      pro.show();
      GoogleSignInAccount? account = await GoogleSignIn().signIn();
      if (account == null) {
        throw FirebaseAuthException(
            code: "error", message: "Sign In failed or aborted");
      }
      var aut = await account.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: aut.accessToken, idToken: aut.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      pro.dismiss();
      errorp.success(
          "Logged in as ${FirebaseAuth.instance.currentUser!.displayName}",
          context);
    } on FirebaseAuthException catch (e) {
      pro.dismiss();
      errorp.showErr(e.message!, context);
    } catch (e) {
      pro.dismiss();
      errorp.showErr("an error occurred login you in", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("login to continue"),
                      SizedBox(height: 15),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: login,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset("assets/icons/gIcon.svg",
                                  height: 30),
                              Text("oogle",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )),
                    ],
                  ),
                );
              }
              final name = snapshot.data!.displayName!;
              final imageLink = snapshot.data!.photoURL!;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: kToolbarHeight),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 48,
                        backgroundImage: Image.network(
                          imageLink,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/error.png');
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                        value: (progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                                    .toInt())
                                            .toDouble()),
                                  );
                          },
                        ).image,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: kPrimaryColor.withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1))
                            ]),
                        height: 150,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon:
                                        Image.asset('assets/icons/wallet.png'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => WalletPage())),
                                  ),
                                  Text(
                                    'Wallet',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Image.asset('assets/icons/truck.png'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => TrackingPage())),
                                  ),
                                  Text(
                                    'Shipped',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Image.asset('assets/icons/card.png'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => PaymentPage())),
                                  ),
                                  Text(
                                    'Payment',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Image.asset(
                                        'assets/icons/contact_us.png'),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    'Support',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Settings'),
                        subtitle: Text('Privacy and logout'),
                        leading: Image.asset(
                          'assets/icons/settings_icon.png',
                          fit: BoxFit.scaleDown,
                          width: 30,
                          height: 30,
                        ),
                        trailing:
                            Icon(Icons.chevron_right, color: kPrimaryColor),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SettingsPage())),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Help & Support'),
                        subtitle: Text('Help center and legal support'),
                        leading: Image.asset('assets/icons/support.png'),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: kPrimaryColor,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('FAQ'),
                        subtitle: Text('Questions and Answer'),
                        leading: Image.asset('assets/icons/faq.png'),
                        trailing:
                            Icon(Icons.chevron_right, color: kPrimaryColor),
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => FaqPage())),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
