// import 'package:flutter/material.dart';
// import 'package:zagasm_studio/features/presentation/screens/home/screen/home_screen.dart';
// import 'package:zagasm_studio/features/presentation/screens/profile/screens/profile.dart';
// import '../../features/event/screens/create_event_four.dart';
// import '../../features/presentation/screens/ticket/screens/ticket_screen.dart';

// class HomeNav extends StatefulWidget {
//   final int initialIndex;
//   const HomeNav({super.key, this.initialIndex = 0});

//   @override
//   _HomeNavState createState() => _HomeNavState();
// }

// class _HomeNavState extends State<HomeNav> {
//   late int _currentIndex = 0;

//   final List<Widget> _screens = [
//     HomeExploreScreen(),
//     CreateEventFour(),
//     TicketScreen(),
//     ProfileScreen(),
//   ];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey[600],
//           selectedLabelStyle: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//           unselectedLabelStyle: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//           items: [
//             BottomNavigationBarItem(
//               icon: _buildNavItem(Icons.explore_outlined, 0),
//               label: 'Discover',
//             ),
//             BottomNavigationBarItem(
//               icon: _buildNavItem(Icons.favorite_border, 1),
//               label: 'Saved',
//             ),
//             BottomNavigationBarItem(
//               icon: _buildNavItem(Icons.chat_bubble_outline, 2),
//               label: 'Tickets',
//             ),
//             BottomNavigationBarItem(
//               icon: _buildNavItem(Icons.person_outline, 3),
//               label: 'Account',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, int index) {
//     bool isSelected = _currentIndex == index;
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: isSelected ? Color(0xFF7B2CBF) : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Icon(
//         icon,
//         color: isSelected ? Colors.white : Colors.grey[600],
//         size: 24,
//       ),
//     );
//   }
// }

// // Screen Classes
// class DiscoverScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover'),
//         backgroundColor: Color(0xFF7B2CBF),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.explore, size: 80, color: Color(0xFF7B2CBF)),
//             SizedBox(height: 20),
//             Text(
//               'Discover',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7B2CBF),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Explore new places and experiences',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7B2CBF),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text('Start Exploring'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SavedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved'),
//         backgroundColor: Color(0xFF7B2CBF),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.favorite, size: 80, color: Color(0xFF7B2CBF)),
//             SizedBox(height: 20),
//             Text(
//               'Saved Items',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7B2CBF),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Your favorite places and memories',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7B2CBF),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text('View Saved'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//         backgroundColor: Color(0xFF7B2CBF),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.chat_bubble, size: 80, color: Color(0xFF7B2CBF)),
//             SizedBox(height: 20),
//             Text(
//               'Chat',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7B2CBF),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Connect with friends and community',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7B2CBF),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text('Start Chatting'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AccountScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Account'),
//         backgroundColor: Color(0xFF7B2CBF),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Color(0xFF7B2CBF),
//               child: Icon(Icons.person, size: 60, color: Colors.white),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'My Account',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7B2CBF),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Manage your profile and settings',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7B2CBF),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text('Edit Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
