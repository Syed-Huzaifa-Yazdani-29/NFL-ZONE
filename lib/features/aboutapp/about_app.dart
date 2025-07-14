import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF013369),
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD50A0A).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ABOUT NFL ZONE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF013369), Color(0xFF002048)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.stadium,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD50A0A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'YOUR ULTIMATE NFL COMPANION',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    icon: Icons.newspaper,
                    title: 'Live News',
                    description: 'Get the latest breaking news, updates, and analysis from around the NFL. Stay informed about trades, injuries, and team developments as they happen.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: 'Team Stats',
                    description: 'Dive deep into comprehensive team statistics from past seasons. Compare team performance, analyze trends, and track your favorite team\'s historical data.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.calendar_month,
                    title: '2025-26 Schedule',
                    description: 'View the complete schedule for the upcoming 2025-26 NFL season. Never miss a game with detailed matchup information, dates, times, and locations.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.person_search,
                    title: 'Player Search',
                    description: 'Search and discover detailed information about any NFL player. Access career stats, performance metrics, and personal information for every player in the league.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.groups,
                    title: 'All Teams Info',
                    description: 'Explore comprehensive information for all 32 NFL teams. Get team rosters, coaching staff, historical data, and current season performance.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.people,
                    title: 'Team Roster 2025',
                    description: 'Access complete team rosters for the 2025 season. View player positions, jersey numbers, and detailed player profiles for every team.',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.emoji_events,
                    title: 'Top Players',
                    description: 'Discover the top performers from recent seasons. View rankings for quarterbacks, running backs, receivers, and defensive players based on their performance metrics.',
                  ),
                  const SizedBox(height: 30),
                  _buildContactSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD50A0A), width: 1),
      ),
      color: Colors.white,
      shadowColor: const Color(0xFF013369).withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF013369).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD50A0A), width: 1.5),
              ),
              child: Icon(
                icon,
                size: 30,
                color: const Color(0xFF013369),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF013369),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF013369), Color(0xFF002048)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF013369).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'CONTACT US',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Have questions or feedback? We\'d love to hear from you!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactOption(
            icon: Icons.email,
            label: 'Email us at',
            value: 'huzaifafaze298@gmail.com',
            onTap: () => _launchEmail(),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD50A0A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '© 2025 NFL ZONE APP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'All NFL team names and logos are property of the NFL',
              style: TextStyle(color: Colors.white54, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String label,
    required String value,
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
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'huzaifafaze298@gmail.com',
      queryParameters: {'subject': 'NFL Zone App Feedback'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}