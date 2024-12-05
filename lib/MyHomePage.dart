
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<MyHomePage> {
//   final String userName = "Avinash Mane";
//   final String userInfo =
//       "I believe in the transformative power of technology and am committed to being a part of this global transformation. "
//       "I specialize in crafting robust, scalable, and efficient software solutions with clean and maintainable code that exceeds industry standards.";

//   @override
//   Widget build(BuildContext context) {
//     return mainUI();
//   }

//   Widget profileImage() {
//     return const CircleAvatar(
//       radius: 100,
//       backgroundImage: AssetImage('assets/profile_image.jpg'),
//     );
//   }

//   Widget profileName() {
//     return Text(
//       userName,
//       style: Theme.of(context).textTheme.headlineMedium,
//     );
//   }
//   Widget profileInfo() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
//       child: Text(
//         userInfo,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//   Widget sectionDivider() {
//     return const Divider(
//       color: Colors.blue, 
//       thickness: 2,       
//       indent: 30,         
//       endIndent: 30,    
//     );
//   }

//   Widget socialMedia(){
//     return const Padding(
//           padding: EdgeInsets.only(top: 16.0),
//           child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//           Icon(
//               FontAwesomeIcons.linkedin,
//               color: Color.fromARGB(255, 4, 118, 210),
//               size: 24.0,
//               // semanticLabel: 'Text to announce in accessibility modes',
//             ),
//           Icon(
//             FontAwesomeIcons.github,
//             // color: Colors.green,
//             size: 30.0,
//           ),
//           Icon(
//             FontAwesomeIcons.envelope,
//             color: Colors.red,
//             size: 36.0,
//           ),
//         ],
//       )
//         );
//   }
//  Widget mainUI(){
//   return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 50),
//           child: Column(
//             children: <Widget>[
//               profileImage(),
//               profileName(),
//               profileInfo(),
//               sectionDivider(),
//               socialMedia(),
               
//     ],
//           ),
//         ),
        
//       ),
//     );
//  }

// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String userName = "Avinash Mane";
  final String userInfo =
      "I believe in the transformative power of technology and am committed to being a part of this global transformation. "
      "I specialize in crafting robust, scalable, and efficient software solutions with clean and maintainable code that exceeds industry standards.";

  bool showDetails = false; // Controls visibility of details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet or larger screen
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDetails = !showDetails; // Toggle details on tap
                          });
                        },
                        child: profileImage(),
                      ),
                      const SizedBox(height: 16),
                      profileName(),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.blue,
                  thickness: 2,
                  width: 40,
                ),
                Expanded(
                  flex: 3,
                  child: showDetails
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileInfo(),
                            const SizedBox(height: 16),
                            sectionDivider(),
                            socialMedia(),
                          ],
                        )
                      : const Center(
                          child: Text(
                            'Tap on the profile picture to view details',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ],
            );
          } else {
            // Mobile layout
            return Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  profileImage(),
                  profileName(),
                  profileInfo(),
                  sectionDivider(),
                  socialMedia(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget profileImage() {
    return const CircleAvatar(
      radius: 100,
      backgroundImage: AssetImage('assets/profile_image.jpg'),
    );
  }

  Widget profileName() {
    return Text(
      userName,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget profileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Text(
        userInfo,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget sectionDivider() {
    return const Divider(
      color: Colors.blue,
      thickness: 2,
      indent: 30,
      endIndent: 30,
    );
  }

  Widget socialMedia() {
    return const Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.linkedin,
            color: Color.fromARGB(255, 4, 118, 210),
            size: 24.0,
          ),
          Icon(
            FontAwesomeIcons.github,
            size: 30.0,
          ),
          Icon(
            FontAwesomeIcons.envelope,
            color: Colors.red,
            size: 36.0,
          ),
        ],
      ),
    );
  }
}
