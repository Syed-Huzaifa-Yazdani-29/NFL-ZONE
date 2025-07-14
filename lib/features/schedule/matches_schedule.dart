import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchesScheduleScreen extends StatefulWidget {
  @override
  _MatchesScheduleScreenState createState() => _MatchesScheduleScreenState();
}

class _MatchesScheduleScreenState extends State<MatchesScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002244),
      appBar: AppBar(
        title: Text(
          'NFL SCHEDULE',
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF013369),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          isScrollable: true,
          tabs: const [
            Tab(text: 'WEEK 1'),
            Tab(text: 'WEEK 2'),
            Tab(text: 'WEEK 3'),
            Tab(text: 'WEEK 4'),
            Tab(text: 'WEEK 5'),
            Tab(text: 'WEEK 6'),
            Tab(text: 'WEEK 7'),
            Tab(text: 'WEEK 8'),
            Tab(text: 'WEEK 9'),
            Tab(text: 'WEEK 10'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeek1Schedule(),
          _buildWeek2Schedule(),
          _buildWeek3Schedule(),
          _buildWeek4Schedule(),
          _buildWeek5Schedule(),
          _buildWeek6Schedule(),
          _buildWeek7Schedule(),
          _buildWeek8Schedule(),
          _buildWeek9Schedule(),
          _buildWeek10Schedule(),
        ],
      ),
    );
  }

  Widget _buildWeek1Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'matchup': 'Dallas Cowboys VS Philadelphia Eagles',
        'time': 'Friday, Sept 5 — 5:20 AM PKT',
        'broadcast': 'NBC / Peacock / NFL+',
        'stadium': 'Lincoln Financial Field, Philadelphia, PA',
      },
      {
        'matchup': 'Kansas City Chiefs VS Los Angeles Chargers',
        'time': 'Saturday, Sept 6 — 5:00 AM PKT',
        'broadcast': 'YouTube (global stream)',
        'stadium': 'Arena Corinthians, São Paulo, Brazil',
      },
      {
        'dayHeader': 'Sunday, September 7',
        'matchup': 'Tampa Bay Buccaneers VS Atlanta Falcons',
        'time': '10:00 PM PKT (Sunday Night)',
        'broadcast': 'FOX',
        'stadium': 'Mercedes-Benz Stadium, Atlanta, GA',
      },
      {
        'matchup': 'Cincinnati Bengals VS Cleveland Browns',
        'time': '10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'FirstEnergy Stadium, Cleveland, OH',
      },
      {
        'matchup': 'Miami Dolphins VS Indianapolis Colts',
        'time': '10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Lucas Oil Stadium, Indianapolis, IN',
      },
      {
        'matchup': 'Las Vegas Raiders VS New England Patriots',
        'time': '10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Gillette Stadium, Foxborough, MA',
      },
      {
        'matchup': 'Arizona Cardinals VS New Orleans Saints',
        'time': '10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Caesars Superdome, New Orleans, LA',
      },
      {
        'matchup': 'Pittsburgh Steelers VS New York Jets',
        'time': '10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'MetLife Stadium, East Rutherford, NJ',
      },
      {
        'matchup': 'New York Giants VS Washington Commanders',
        'time': '10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'FedExField, Landover, MD',
      },
      {
        'matchup': 'Carolina Panthers VS Jacksonville Jaguars',
        'time': '10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'TIAA Bank Field, Jacksonville, FL',
      },
      {
        'matchup': 'Tennessee Titans VS Denver Broncos',
        'time': 'Monday, Sept 8 — 1:05 AM PKT',
        'broadcast': 'ESPN',
        'stadium': 'Empower Field at Mile High, Denver, CO',
      },
      {
        'matchup': 'San Francisco 49ers VS Seattle Seahawks',
        'time': 'Monday, Sept 8 — 1:05 AM PKT',
        'broadcast': 'ABC',
        'stadium': 'Lumen Field, Seattle, WA',
      },
      {
        'matchup': 'Detroit Lions VS Green Bay Packers',
        'time': 'Monday, Sept 8 — 1:25 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'Lambeau Field, Green Bay, WI',
      },
      {
        'matchup': 'Houston Texans VS Los Angeles Rams',
        'time': 'Monday, Sept 8 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'SoFi Stadium, Inglewood, CA',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Baltimore Ravens VS Buffalo Bills',
        'time': 'Monday, Sept 8 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'Highmark Stadium, Orchard Park, NY',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'Minnesota Vikings VS Chicago Bears',
        'time': 'Tuesday, Sept 9 — 5:15 AM PKT',
        'broadcast': 'ESPN / ABC',
        'stadium': 'Soldier Field, Chicago, IL',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek2Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Washington Commanders VS Green Bay Packers',
        'time': 'Friday, Sept 12 — 6:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'Lambeau Field, Green Bay, WI',
      },
      {
        'dayHeader': 'Sunday, September 14 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'Cleveland Browns VS Baltimore Ravens',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'M&T Bank Stadium, Baltimore',
      },
      {
        'matchup': 'Jacksonville Jaguars VS Cincinnati Bengals',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Paycor Stadium, Cincinnati',
      },
      {
        'matchup': 'New York Giants VS Dallas Cowboys',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'AT&T Stadium, Arlington',
      },
      {
        'matchup': 'San Francisco 49ers VS New Orleans Saints',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Caesars Superdome, New Orleans',
      },
      {
        'matchup': 'Buffalo Bills VS New York Jets',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'MetLife Stadium, New Jersey',
      },
      {
        'matchup': 'New England Patriots VS Miami Dolphins',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Hard Rock Stadium, Miami',
      },
      {
        'matchup': 'Los Angeles Rams VS Tennessee Titans',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Nissan Stadium, Nashville',
      },
      {
        'matchup': 'Seattle Seahawks VS Pittsburgh Steelers',
        'time': 'Sunday, Sept 14 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Acrisure Stadium, Pittsburgh',
      },
      {
        'dayHeader': 'Sunday, September 14 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
        'matchup': 'New Orleans Saints VS Seattle Seahawks',
        'time': 'Monday, Sept 15 — 1:05 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Caesars Superdome, New Orleans',
      },
      {
        'matchup': 'Denver Broncos VS Los Angeles Chargers',
        'time': 'Monday, Sept 15 — 1:05 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'SoFi Stadium, Los Angeles',
      },
      {
        'dayHeader': 'Sunday, September 14 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Arizona Cardinals VS San Francisco 49ers',
        'time': 'Monday, Sept 15 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Levi\'s Stadium, Santa Clara',
      },
      {
        'matchup': 'Dallas Cowboys VS Chicago Bears',
        'time': 'Monday, Sept 15 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Soldier Field, Chicago',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Kansas City Chiefs VS New York Giants',
        'time': 'Monday, Sept 15 — 5:15 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'Arrowhead Stadium, Kansas City',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek3Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Miami Dolphins VS Buffalo Bills',
        'time': 'Friday, Sept 19 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'Highmark Stadium, Orchard Park, NY',
      },
      {
        'dayHeader': 'Sunday, September 21 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'Atlanta Falcons VS Carolina Panthers',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Bank of America Stadium, Charlotte',
      },
      {
        'matchup': 'Green Bay Packers VS Cleveland Browns',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'FirstEnergy Stadium, Cleveland',
      },
      {
        'matchup': 'Houston Texans VS Jacksonville Jaguars',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'EverBank Stadium, Jacksonville',
      },
      {
        'matchup': 'Cincinnati Bengals VS Minnesota Vikings',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'U.S. Bank Stadium, Minneapolis',
      },
      {
        'matchup': 'Pittsburgh Steelers VS New England Patriots',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Gillette Stadium, Foxborough',
      },
      {
        'matchup': 'Los Angeles Rams VS Philadelphia Eagles',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lincoln Financial Field, Philadelphia',
      },
      {
        'matchup': 'New York Jets VS Tampa Bay Buccaneers',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Raymond James Stadium, Tampa',
      },
      {
        'matchup': 'Indianapolis Colts VS Tennessee Titans',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Nissan Stadium, Nashville',
      },
      {
        'matchup': 'Las Vegas Raiders VS Washington Commanders',
        'time': 'Sunday, Sept 21 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'FedExField, Landover MD',
      },
      {
        'dayHeader': 'Sunday, September 21 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
        'matchup': 'Denver Broncos VS Los Angeles Chargers',
        'time': 'Monday, Sept 22 — 1:05 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'matchup': 'New Orleans Saints VS Seattle Seahawks',
        'time': 'Monday, Sept 22 — 1:05 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Caesars Superdome, New Orleans',
      },
      {
        'dayHeader': 'Sunday, September 21 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Dallas Cowboys VS Chicago Bears',
        'time': 'Monday, Sept 22 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Soldier Field, Chicago',
      },
      {
        'matchup': 'Arizona Cardinals VS San Francisco 49ers',
        'time': 'Monday, Sept 22 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Levi\'s Stadium, Santa Clara',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Kansas City Chiefs VS New York Giants',
        'time': 'Monday, Sept 22 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'MetLife Stadium, East Rutherford',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'Detroit Lions VS Baltimore Ravens',
        'time': 'Tuesday, Sept 23 — 5:15 AM PKT',
        'broadcast': 'ESPN / ABC',
        'stadium': 'M&T Bank Stadium, Baltimore',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek4Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Seattle Seahawks VS Arizona Cardinals',
        'time': 'Friday, Sept 26 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'State Farm Stadium, Glendale, AZ',
      },
      {
        'dayHeader': 'International Game',
        'matchup': 'Minnesota Vikings VS Pittsburgh Steelers',
        'time': 'Sunday, Sept 28 — 6:30 PM PKT',
        'broadcast': 'NFL Network',
        'stadium': 'Croke Park, Dublin',
      },
      {
        'dayHeader': 'Sunday, September 28 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'New Orleans Saints VS Buffalo Bills',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Highmark Stadium, Orchard Park',
      },
      {
        'matchup': 'Washington Commanders VS Atlanta Falcons',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Mercedes-Benz Stadium, Atlanta',
      },
      {
        'matchup': 'Los Angeles Chargers VS New York Giants',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'MetLife Stadium, East Rutherford',
      },
      {
        'matchup': 'Tennessee Titans VS Houston Texans',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'NRG Stadium, Houston',
      },
      {
        'matchup': 'Cleveland Browns VS Detroit Lions',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Ford Field, Detroit',
      },
      {
        'matchup': 'Carolina Panthers VS New England Patriots',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Gillette Stadium, Foxborough',
      },
      {
        'matchup': 'Philadelphia Eagles VS Tampa Bay Buccaneers',
        'time': 'Sunday, Sept 28 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Raymond James Stadium, Tampa',
      },
      {
        'dayHeader': 'Sunday, September 28 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
        'matchup': 'Jacksonville Jaguars VS San Francisco 49ers',
        'time': 'Monday, Sept 29 — 1:05 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Levi\'s Stadium, Santa Clara',
      },
      {
        'matchup': 'Indianapolis Colts VS Los Angeles Rams',
        'time': 'Monday, Sept 29 — 1:05 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'dayHeader': 'Sunday, September 28 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Baltimore Ravens VS Kansas City Chiefs',
        'time': 'Monday, Sept 29 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Arrowhead Stadium, Kansas City',
      },
      {
        'matchup': 'Chicago Bears VS Las Vegas Raiders',
        'time': 'Monday, Sept 29 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Allegiant Stadium, Las Vegas',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Green Bay Packers VS Dallas Cowboys',
        'time': 'Monday, Sept 29 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'AT&T Stadium, Arlington',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'New York Jets VS Miami Dolphins',
        'time': 'Tuesday, Sept 30 — 4:15 AM PKT',
        'broadcast': 'ESPN',
        'stadium': 'Hard Rock Stadium, Miami',
      },
      {
        'matchup': 'Cincinnati Bengals VS Denver Broncos',
        'time': 'Tuesday, Sept 30 — 5:15 AM PKT',
        'broadcast': 'ABC',
        'stadium': 'Empower Field at Mile High, Denver',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek5Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Los Angeles Rams VS San Francisco 49ers',
        'time': 'Friday, Oct 3 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'dayHeader': 'Sunday, October 5 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'Cleveland Browns VS Minnesota Vikings',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'FirstEnergy Stadium, Cleveland',
      },
      {
        'matchup': 'Baltimore Ravens VS Houston Texans',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'M&T Bank Stadium, Baltimore',
      },
      {
        'matchup': 'Carolina Panthers VS Miami Dolphins',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Bank of America Stadium, Charlotte',
      },
      {
        'matchup': 'Indianapolis Colts VS Las Vegas Raiders',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Lucas Oil Stadium, Indianapolis',
      },
      {
        'matchup': 'New Orleans Saints VS New York Giants',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Caesars Superdome, New Orleans',
      },
      {
        'matchup': 'New York Jets VS Dallas Cowboys',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'MetLife Stadium, East Rutherford',
      },
      {
        'matchup': 'Philadelphia Eagles VS Denver Broncos',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lincoln Financial Field, Philadelphia',
      },
      {
        'matchup': 'Arizona Cardinals VS Tennessee Titans',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'State Farm Stadium, Glendale',
      },
      {
        'matchup': 'Seattle Seahawks VS Tampa Bay Buccaneers',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lumen Field, Seattle',
      },
      {
        'matchup': 'Cincinnati Bengals VS Detroit Lions',
        'time': 'Sunday, Oct 5 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Paycor Stadium, Cincinnati',
      },
      {
        'dayHeader': 'Sunday, October 5 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
        'matchup': 'Tampa Bay Buccaneers VS Seattle Seahawks',
        'time': 'Monday, Oct 6 — 1:05 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lumen Field, Seattle',
      },
      {
        'matchup': 'Tennessee Titans VS Arizona Cardinals',
        'time': 'Monday, Oct 6 — 1:05 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'State Farm Stadium, Glendale',
      },
      {
        'dayHeader': 'Sunday, October 5 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Washington Commanders VS Los Angeles Chargers',
        'time': 'Monday, Oct 6 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'matchup': 'Detroit Lions VS Cincinnati Bengals',
        'time': 'Monday, Oct 6 — 1:25 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Paycor Stadium, Cincinnati',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'New England Patriots VS Buffalo Bills',
        'time': 'Monday, Oct 6 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'Highmark Stadium, Orchard Park',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'Jacksonville Jaguars VS Kansas City Chiefs',
        'time': 'Tuesday, Oct 7 — 5:15 AM PKT',
        'broadcast': 'ESPN / ABC',
        'stadium': 'EverBank Stadium, Jacksonville',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek6Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Philadelphia Eagles VS New York Giants',
        'time': 'Friday, Oct 10 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'MetLife Stadium, East Rutherford, NJ',
      },
      {
        'dayHeader': 'International Game',
        'matchup': 'Denver Broncos VS New York Jets',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'NFL Network',
        'stadium': 'Tottenham Hotspur Stadium, London',
      },
      {
        'dayHeader': 'Sunday, October 12 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'Cleveland Browns VS Pittsburgh Steelers',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Acrisure Stadium, Pittsburgh',
      },
      {
        'matchup': 'Los Angeles Chargers VS Miami Dolphins',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Hard Rock Stadium, Miami',
      },
      {
        'matchup': 'San Francisco 49ers VS Tampa Bay Buccaneers',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Raymond James Stadium, Tampa',
      },
      {
        'matchup': 'Seattle Seahawks VS Jacksonville Jaguars',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'EverBank Stadium, Jacksonville',
      },
      {
        'matchup': 'Dallas Cowboys VS Carolina Panthers',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Bank of America Stadium, Charlotte',
      },
      {
        'matchup': 'Los Angeles Rams VS Baltimore Ravens',
        'time': 'Sunday, Oct 12 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'M&T Bank Stadium, Baltimore',
      },
      {
        'dayHeader': 'Sunday, October 12 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
        'matchup': 'Arizona Cardinals VS Indianapolis Colts',
        'time': 'Monday, Oct 13 — 1:05 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lucas Oil Stadium, Indianapolis',
      },
      {
        'matchup': 'Tennessee Titans VS Las Vegas Raiders',
        'time': 'Monday, Oct 13 — 1:05 AM PKT',
        'broadcast': 'FOX',
        'stadium': 'Allegiant Stadium, Las Vegas',
      },
      {
        'dayHeader': 'Sunday, October 12 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Cincinnati Bengals VS Green Bay Packers',
        'time': 'Monday, Oct 13 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Lambeau Field, Green Bay',
      },
      {
        'matchup': 'New England Patriots VS New Orleans Saints',
        'time': 'Monday, Oct 13 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Caesars Superdome, New Orleans',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Detroit Lions VS Kansas City Chiefs',
        'time': 'Monday, Oct 13 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'GEHA Field at Arrowhead Stadium, Kansas City',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'Buffalo Bills VS Atlanta Falcons',
        'time': 'Tuesday, Oct 14 — 4:15 AM PKT',
        'broadcast': 'ESPN',
        'stadium': 'Mercedes-Benz Stadium, Atlanta',
      },
      {
        'matchup': 'Chicago Bears VS Washington Commanders',
        'time': 'Tuesday, Oct 14 — 5:15 AM PKT',
        'broadcast': 'ABC',
        'stadium': 'FedEx Field, Landover, MD',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildWeek7Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Pittsburgh Steelers VS Cincinnati Bengals',
        'time': 'Friday, Oct 17 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'Paycor Stadium, Cincinnati',
      },
      {
        'dayHeader': 'International Game',
        'matchup': 'Los Angeles Rams VS Jacksonville Jaguars',
        'time': 'Sunday, Oct 19 — 6:30 PM PKT',
        'broadcast': 'NFL Network',
        'stadium': 'Wembley Stadium, London',
      },
      {
        'dayHeader': 'Sunday, October 19 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'New Orleans Saints VS Chicago Bears',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Soldier Field, Chicago',
      },
      {
        'matchup': 'Miami Dolphins VS Cleveland Browns',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Cleveland Stadium',
      },
      {
        'matchup': 'Las Vegas Raiders VS Kansas City Chiefs',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Arrowhead Stadium, Kansas City',
      },
      {
        'matchup': 'Philadelphia Eagles VS Minnesota Vikings',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'U.S. Bank Stadium, Minneapolis',
      },
      {
        'matchup': 'Carolina Panthers VS New York Jets',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'MetLife Stadium',
      },
      {
        'matchup': 'New England Patriots VS Tennessee Titans',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Nissan Stadium, Nashville',
      },
      {
        'matchup': 'New York Giants VS Denver Broncos',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Empower Field at Mile High, Denver',
      },
      {
        'matchup': 'Indianapolis Colts VS Los Angeles Chargers',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'matchup': 'Green Bay Packers VS Arizona Cardinals',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'State Farm Stadium, Glendale',
      },
      {
        'matchup': 'Washington Commanders VS Dallas Cowboys',
        'time': 'Sunday, Oct 19 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'AT&T Stadium, Arlington',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Atlanta Falcons VS San Francisco 49ers',
        'time': 'Monday, Oct 20 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'Levi\'s Stadium, Santa Clara',
      },
      {
        'dayHeader': 'Monday Night Football (Doubleheader)',
        'matchup': 'Tampa Bay Buccaneers VS Detroit Lions',
        'time': 'Tuesday, Oct 21 — 4:00 AM PKT',
        'broadcast': 'ESPN / ABC',
        'stadium': 'Ford Field, Detroit',
      },
      {
        'matchup': 'Houston Texans VS Seattle Seahawks',
        'time': 'Tuesday, Oct 21 — 7:00 AM PKT',
        'broadcast': 'ESPN+',
        'stadium': 'Lumen Field, Seattle',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }
    Widget _buildWeek8Schedule() {
      final List<Map<String, dynamic>> games = [
        {
          'dayHeader': 'Thursday Night Football',
          'matchup': 'Minnesota Vikings VS Los Angeles Rams',
          'time': 'Friday, Oct 24 — 5:15 AM PKT',
          'broadcast': 'Prime Video',
          'stadium': 'SoFi Stadium, Inglewood, CA',
        },
        {
          'dayHeader': 'Sunday, October 26 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
          'matchup': 'Atlanta Falcons VS Carolina Panthers',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'FOX',
          'stadium': 'Bank of America Stadium, Charlotte, NC',
        },
        {
          'matchup': 'Baltimore Ravens VS Cleveland Browns',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'CBS',
          'stadium': 'FirstEnergy Stadium, Cleveland, OH',
        },
        {
          'matchup': 'Chicago Bears VS Washington Commanders',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'FOX',
          'stadium': 'FedExField, Landover, MD',
        },
        {
          'matchup': 'Houston Texans VS Jacksonville Jaguars',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'CBS',
          'stadium': 'TIAA Bank Field, Jacksonville, FL',
        },
        {
          'matchup': 'Indianapolis Colts VS Detroit Lions',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'FOX',
          'stadium': 'Ford Field, Detroit, MI',
        },
        {
          'matchup': 'New England Patriots VS Buffalo Bills',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'CBS',
          'stadium': 'Highmark Stadium, Orchard Park, NY',
        },
        {
          'matchup': 'New York Jets VS Cincinnati Bengals',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'CBS',
          'stadium': 'Paycor Stadium, Cincinnati, OH',
        },
        {
          'matchup': 'Tennessee Titans VS Miami Dolphins',
          'time': 'Sunday, Oct 26 — 10:00 PM PKT',
          'broadcast': 'FOX',
          'stadium': 'Hard Rock Stadium, Miami Gardens, FL',
        },
        {
          'dayHeader': 'Sunday, October 26 (Late Afternoon Games - 4:05 PM ET / 1:05 AM PKT)',
          'matchup': 'Dallas Cowboys VS San Francisco 49ers',
          'time': 'Monday, Oct 27 — 1:05 AM PKT',
          'broadcast': 'FOX',
          'stadium': 'Levi\'s Stadium, Santa Clara, CA',
        },
        {
          'matchup': 'Denver Broncos VS New Orleans Saints',
          'time': 'Monday, Oct 27 — 1:05 AM PKT',
          'broadcast': 'CBS',
          'stadium': 'Empower Field at Mile High, Denver, CO',
        },
        {
          'dayHeader': 'Sunday, October 26 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
          'matchup': 'Green Bay Packers VS Arizona Cardinals',
          'time': 'Monday, Oct 27 — 1:25 AM PKT',
          'broadcast': 'CBS',
          'stadium': 'State Farm Stadium, Glendale, AZ',
        },
        {
          'matchup': 'Philadelphia Eagles VS Las Vegas Raiders',
          'time': 'Monday, Oct 27 — 1:25 AM PKT',
          'broadcast': 'FOX',
          'stadium': 'Allegiant Stadium, Las Vegas, NV',
        },
        {
          'dayHeader': 'Sunday Night Football',
          'matchup': 'Kansas City Chiefs VS Los Angeles Chargers',
          'time': 'Monday, Oct 27 — 5:20 AM PKT',
          'broadcast': 'NBC',
          'stadium': 'SoFi Stadium, Inglewood, CA',
        },
        {
          'dayHeader': 'Monday Night Football',
          'matchup': 'New York Giants VS Tampa Bay Buccaneers',
          'time': 'Tuesday, Oct 28 — 5:15 AM PKT',
          'broadcast': 'ESPN / ABC',
          'stadium': 'Raymond James Stadium, Tampa, FL',
        },
      ];

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _buildGameCard(context, game);
        },
      );
    }
  Widget _buildWeek9Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Baltimore Ravens VS Miami Dolphins',
        'time': 'Friday, Oct 31 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'Hard Rock Stadium, Miami Gardens, FL',
      },
      {
        'dayHeader': 'Sunday, November 2 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'Chicago Bears VS Cincinnati Bengals',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Paycor Stadium, Cincinnati',
      },
      {
        'matchup': 'Minnesota Vikings VS Detroit Lions',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Ford Field, Detroit',
      },
      {
        'matchup': 'Carolina Panthers VS Green Bay Packers',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Lambeau Field, Green Bay',
      },
      {
        'matchup': 'Denver Broncos VS Houston Texans',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'NRG Stadium, Houston',
      },
      {
        'matchup': 'Atlanta Falcons VS New England Patriots',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Gillette Stadium, Foxborough',
      },
      {
        'matchup': 'San Francisco 49ers VS New York Giants',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'MetLife Stadium, East Rutherford',
      },
      {
        'matchup': 'Indianapolis Colts VS Pittsburgh Steelers',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Acrisure Stadium, Pittsburgh',
      },
      {
        'matchup': 'Los Angeles Chargers VS Tennessee Titans',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'LP Field, Nashville',
      },
      {
        'matchup': 'Jacksonville Jaguars VS Las Vegas Raiders',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Allegiant Stadium, Las Vegas',
      },
      {
        'matchup': 'New Orleans Saints VS Los Angeles Rams',
        'time': 'Sunday, Nov 2 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'SoFi Stadium, Inglewood',
      },
      {
        'dayHeader': 'Sunday, November 2 (Late Afternoon Games - 4:25 PM ET / 1:25 AM PKT)',
        'matchup': 'Kansas City Chiefs VS Buffalo Bills',
        'time': 'Monday, Nov 3 — 1:25 AM PKT',
        'broadcast': 'CBS',
        'stadium': 'Highmark Stadium, Orchard Park',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Seattle Seahawks VS Washington Commanders',
        'time': 'Monday, Nov 3 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'FedEx Field, Landover',
      },
      {
        'dayHeader': 'Monday Night Football',
        'matchup': 'Arizona Cardinals VS Dallas Cowboys',
        'time': 'Tuesday, Nov 4 — 5:15 AM PKT',
        'broadcast': 'ESPN / ABC',
        'stadium': 'AT&T Stadium, Arlington',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }
  Widget _buildWeek10Schedule() {
    final List<Map<String, dynamic>> games = [
      {
        'dayHeader': 'Thursday Night Football',
        'matchup': 'Las Vegas Raiders VS Denver Broncos',
        'time': 'Friday, Nov 7 — 5:15 AM PKT',
        'broadcast': 'Prime Video',
        'stadium': 'Empower Field at Mile High, Denver, CO',
      },
      {
        'dayHeader': 'International Game - Sunday, November 9',
        'matchup': 'Atlanta Falcons VS Indianapolis Colts',
        'time': 'Sunday, Nov 9 — 6:30 PM PKT',
        'broadcast': 'NFL Network',
        'stadium': 'Olympiastadion Berlin',
      },
      {
        'dayHeader': 'Sunday, November 9 (Early Games - 1:00 PM ET / 10:00 PM PKT)',
        'matchup': 'New Orleans Saints VS Carolina Panthers',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Bank of America Stadium, Charlotte',
      },
      {
        'matchup': 'New York Giants VS Chicago Bears',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Soldier Field, Chicago',
      },
      {
        'matchup': 'Jacksonville Jaguars VS Houston Texans',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'NRG Stadium, Houston',
      },
      {
        'matchup': 'Buffalo Bills VS Miami Dolphins',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Hard Rock Stadium, Miami Gardens',
      },
      {
        'matchup': 'Cleveland Browns VS New York Jets',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'MetLife Stadium, East Rutherford',
      },
      {
        'matchup': 'New England Patriots VS Tampa Bay Buccaneers',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Raymond James Stadium, Tampa',
      },
      {
        'matchup': 'Arizona Cardinals VS Seattle Seahawks',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'CBS',
        'stadium': 'Lumen Field, Seattle',
      },
      {
        'matchup': 'Los Angeles Rams VS San Francisco 49ers',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'Levi\'s Stadium, Santa Clara',
      },
      {
        'matchup': 'Detroit Lions VS Washington Commanders',
        'time': 'Sunday, Nov 9 — 10:00 PM PKT',
        'broadcast': 'FOX',
        'stadium': 'FedEx Field, Landover, MD',
      },
      {
        'dayHeader': 'Sunday Night Football',
        'matchup': 'Pittsburgh Steelers VS Los Angeles Chargers',
        'time': 'Monday, Nov 10 — 5:20 AM PKT',
        'broadcast': 'NBC',
        'stadium': 'SoFi Stadium, Inglewood',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _buildGameCard(context, game);
      },
    );
  }
  }

  Widget _buildGameCard(BuildContext context, Map<String, dynamic> game) {
    final teams = game['matchup'].contains(' VS ')
        ? game['matchup'].split(' VS ')
        : ['', game['matchup']];
    final awayTeam = teams[0];
    final homeTeam = teams[1];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF013369).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (game['dayHeader'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  game['dayHeader'],
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (awayTeam.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: _getTeamLogoUrl(_getTeamAbbreviation(awayTeam)),
                        height: 50,
                        width: 50,
                        placeholder: (context, url) => Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[800],
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.sports_football,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.transparent,
                      ),
                    const SizedBox(height: 4),
                    if (awayTeam.isNotEmpty)
                      Text(
                        _getTeamAbbreviation(awayTeam),
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      awayTeam.isNotEmpty ? 'VS' : '',
                      style: GoogleFonts.robotoCondensed(
                        color: const Color(0xFFA5ACAF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        game['matchup'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    if (homeTeam.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: _getTeamLogoUrl(_getTeamAbbreviation(homeTeam)),
                        height: 50,
                        width: 50,
                        placeholder: (context, url) => Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[800],
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.sports_football,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.transparent,
                      ),
                    const SizedBox(height: 4),
                    if (homeTeam.isNotEmpty)
                      Text(
                        _getTeamAbbreviation(homeTeam),
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildDetailRow(Icons.access_time, game['time']),
            _buildDetailRow(Icons.tv, game['broadcast']),
            _buildDetailRow(Icons.stadium, game['stadium']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFFA5ACAF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTeamAbbreviation(String teamName) {
    final cleanName = teamName
        .replaceAll(RegExp(r'\(.*\)'), '')
        .trim()
        .toLowerCase();

    switch (cleanName) {
      case 'dallas cowboys': return 'DAL';
      case 'philadelphia eagles': return 'PHI';
      case 'kansas city chiefs': return 'KC';
      case 'los angeles chargers': return 'LAC';
      case 'tampa bay buccaneers': return 'TB';
      case 'atlanta falcons': return 'ATL';
      case 'cincinnati bengals': return 'CIN';
      case 'cleveland browns': return 'CLE';
      case 'miami dolphins': return 'MIA';
      case 'indianapolis colts': return 'IND';
      case 'las vegas raiders': return 'LV';
      case 'new england patriots': return 'NE';
      case 'arizona cardinals': return 'ARI';
      case 'new orleans saints': return 'NO';
      case 'pittsburgh steelers': return 'PIT';
      case 'new york jets': return 'NYJ';
      case 'new york giants': return 'NYG';
      case 'washington commanders': return 'WSH';
      case 'carolina panthers': return 'CAR';
      case 'jacksonville jaguars': return 'JAX';
      case 'tennessee titans': return 'TEN';
      case 'denver broncos': return 'DEN';
      case 'san francisco 49ers': return 'SF';
      case 'seattle seahawks': return 'SEA';
      case 'detroit lions': return 'DET';
      case 'green bay packers': return 'GB';
      case 'houston texans': return 'HOU';
      case 'los angeles rams': return 'LAR';
      case 'baltimore ravens': return 'BAL';
      case 'buffalo bills': return 'BUF';
      case 'minnesota vikings': return 'MIN';
      case 'chicago bears': return 'CHI';
      default: return teamName.split(' ').last.substring(0, 3).toUpperCase();
    }
  }


  String _getTeamLogoUrl(String abbreviation) {
    return 'https://a.espncdn.com/i/teamlogos/nfl/500/$abbreviation.png';
  }
