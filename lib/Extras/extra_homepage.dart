// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget{
//   HomePage({super.key});
//
//   final user = FirebaseAuth.instance.currentUser!;
//
//   //sign user out method
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.deepPurple[100],
//           actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout), )]),
//       backgroundColor: Colors.deepPurple[200],
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               children: [
//                 const SizedBox(height: 10),
//                 _buildTile(context, Icons.report, "Report Incident",
//                 onTap: () {
//
//                   Navigator.pushNamed(context, '/report');
//                 }),
//                 _buildTile(context, Icons.access_alarm_sharp, "Trigger Alarm",
//                     onTap: () {
//
//                       Navigator.pushNamed(context, '/alarm');
//                     }),
//
//
//                 // _buildTile(context, Icons.report, "View Reports",
//                 //     onTap: () {
//                 //
//                 //       Navigator.pushNamed(context, '/reports');
//                 //     }),
//
//                 _buildTile(context, Icons.person_outline_sharp, "My Profile",
//                     onTap: () {
//
//                       Navigator.pushNamed(context, '/profile');
//                     }),
//
//                 _buildTile(context, Icons.contact_page, "Custom contacts",
//                     onTap: () {
//
//                       Navigator.pushNamed(context, '/contacts');
//                     }),
//               ]
//             )
//               ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildTile(BuildContext context, IconData icon, String label,
// {Color color = Colors.blue, VoidCallback? onTap}) {
//   return GestureDetector(
//       onTap: onTap,
//       child: Card(
//           color:
//           Colors.white.withAlpha(1470),
//           elevation: 4,
//           shape:
//           RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(icon, size: 40,
//                       color: color),
//                   const SizedBox(height: 10),
//                   Text(label, style:
//                   TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
//
//                   )
//                 ],
//               )
//           )
//       )
//   );
// }