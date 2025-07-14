import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nflzoneofficial/features/aboutapp/about_app.dart';
import 'package:nflzoneofficial/features/authentication/login_screen.dart';
import 'package:nflzoneofficial/features/teams/teams_screen.dart';
import 'package:nflzoneofficial/features/news/news_screen.dart';
import 'package:nflzoneofficial/features/stats/nfl_team_stats.dart';
import 'package:nflzoneofficial/features/players/players_screen.dart';
import 'package:nflzoneofficial/features/stats/best_players.dart';
import 'package:nflzoneofficial/features/schedule/matches_schedule.dart';
import 'package:nflzoneofficial/features/teams/team_roster_screen.dart';
import 'package:nflzoneofficial/features/userinfo/user_info.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<Widget> _screens = [
    const NewsScreen(),
    const TeamStatsScreen(),
    MatchesScheduleScreen(),
    const PlayersScreen(),
    const TeamsScreen(),
    const TeamRosterScreen(),
    const NFLTopPlayersScreen(),
  ];

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showUserSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildSettingsSheet(context),
    );
  }

  Widget _buildSettingsSheet(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    decoration: const BoxDecoration(
    color: Color(0xFF002244),
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
    )),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    width: 60,
    height: 4,
    decoration: BoxDecoration(
    color: const Color(0xFFA5ACAF),
    borderRadius: BorderRadius.circular(2),
    ),
    ),
    ),
    const SizedBox(height: 24),

    // Account Section
    const Text(
    'ACCOUNT',
    style: TextStyle(
    color: Color(0xFFA5ACAF),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    ),
    ),
    const SizedBox(height: 16),

    // User Info Option
    _buildSettingsOption(
    icon: Icons.account_circle_outlined,
    label: 'Account Information',
    onTap: () {
    Navigator.pop(context); // Close settings sheet
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const UserInfoScreen()),
    );
  },
    ),
    const SizedBox(height: 16),

    // App Settings Section
    const Text(
    'APP SETTINGS',
    style: TextStyle(
    color: Color(0xFFA5ACAF),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    ),
    ),
    const SizedBox(height: 16),

    // About App option
    _buildSettingsOption(
    icon: Icons.info_outline,
    label: 'About App',
    onTap: () {
    Navigator.pop(context); // Close settings sheet
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AboutAppScreen()),
    );
  },
    ),
    const SizedBox(height: 24),

    // Logout Button
    SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
    onPressed: () => _logout(context),
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD50A0A),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: const Text(
    'LOGOUT',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: Colors.white,
    ),
    ),
    ),
    ),
    const SizedBox(height: 16),

    // Close Button
    SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton(
    onPressed: () => Navigator.pop(context),
    style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Color(0xFFA5ACAF)),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: const Text(
    'CLOSE',
    style: TextStyle(
    color: Color(0xFFA5ACAF),
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFA5ACAF)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color(0xFFA5ACAF)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    String title;
    switch (_currentIndex) {
      case 0:
        title = 'NFL NEWS';
        break;
      case 1:
        title = 'TEAM STATS';
        break;
      case 2:
        title = 'SCHEDULE';
        break;
      case 3:
        title = 'PLAYERS';
        break;
      case 4:
        title = 'TEAMS';
        break;
      case 5:
        title = 'TEAM ROSTER';
        break;
      case 6:
        title = 'TOP PLAYERS';
        break;
      default:
        title = 'NFL';
    }

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF013369),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _showUserSettings(context),
          tooltip: 'Account Settings',
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF013369),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFFA5ACAF).withOpacity(0.7),
          currentIndex: _currentIndex,
          selectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          elevation: 10,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _buildNavItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(Icons.newspaper, 'News', 0),
      _buildNavItem(Icons.assessment, 'Team Stats', 1),
      _buildNavItem(Icons.calendar_today, 'Schedule', 2),
      _buildNavItem(Icons.person, 'Players', 3),
      _buildNavItem(Icons.groups, 'Teams', 4),
      _buildNavItem(Icons.people, 'Roster', 5),
      _buildNavItem(Icons.emoji_events, 'Top Players', 6),
    ];
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(5),
        child: Icon(icon, size: 20),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _currentIndex == index ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Icon(icon, size: 20),
      ),
      label: label,
    );
  }
}