import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<NFLTeam> allTeams = [];
  List<NFLTeam> displayedTeams = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedDivision = 'All Teams';

  // Fixed divisions data with correct abbreviations
  final Map<String, List<String>> divisions = {
    'AFC East': ['BUF', 'MIA', 'NE', 'NYJ'],
    'AFC North': ['BAL', 'CIN', 'CLE', 'PIT'],
    'AFC South': ['HOU', 'IND', 'JAX', 'TEN'],
    'AFC West': ['DEN', 'KC', 'LV', 'LAC'], // Chargers are LAC
    'NFC East': ['DAL', 'NYG', 'PHI', 'WAS'], // Commanders are WAS
    'NFC North': ['CHI', 'DET', 'GB', 'MIN'],
    'NFC South': ['ATL', 'CAR', 'NO', 'TB'], // Buccaneers are TB
    'NFC West': ['ARI', 'LA', 'SF', 'SEA'], // Rams are LA, 49ers are SF
  };

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse('https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final teamsList = (data['sports'][0]['leagues'][0]['teams'] as List)
            .where((team) => team['team'] != null)
            .map((team) => NFLTeam.fromJson(team['team']))
            .toList();

        setState(() {
          allTeams = teamsList;
          displayedTeams = teamsList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load teams: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load teams. Pull down to refresh.';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await _fetchTeams();
  }

  void _filterTeamsByDivision(String division) {
    setState(() {
      selectedDivision = division;
      if (division == 'All Teams') {
        displayedTeams = allTeams;
      } else {
        displayedTeams = allTeams.where((team) {
          return divisions[division]!.contains(team.abbreviation);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFD50A0A),
        backgroundColor: const Color(0xFF013369),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF002244),
                Colors.black,
              ],
            ),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD50A0A),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Color(0xFFA5ACAF),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD50A0A),
                ),
                onPressed: _refreshData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'NFL Teams',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF013369),
                    Color(0xFF002244),
                  ],
                ),
              ),
            ),
          ),
          pinned: true,
          backgroundColor: const Color(0xFF013369),
        ),
        SliverToBoxAdapter(
          child: _buildDivisionSelector(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => TeamCard(
                team: displayedTeams[index],
                onTap: () => _navigateToTeamDetails(context, displayedTeams[index]),
              ),
              childCount: displayedTeams.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivisionSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Division',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDivisionChip('All Teams'),
                _buildDivisionChip('AFC East'),
                _buildDivisionChip('AFC North'),
                _buildDivisionChip('AFC South'),
                _buildDivisionChip('AFC West'),
                _buildDivisionChip('NFC East'),
                _buildDivisionChip('NFC North'),
                _buildDivisionChip('NFC South'),
                _buildDivisionChip('NFC West'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionChip(String division) {
    final isSelected = selectedDivision == division;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          division,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFA5ACAF),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) => _filterTeamsByDivision(division),
        backgroundColor: const Color(0xFF013369).withOpacity(0.5),
        selectedColor: const Color(0xFFD50A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? const Color(0xFFD50A0A) : const Color(0xFFA5ACAF).withOpacity(0.5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  void _navigateToTeamDetails(BuildContext context, NFLTeam team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailsScreen(team: team),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final NFLTeam team;
  final VoidCallback onTap;

  const TeamCard({
    Key? key,
    required this.team,
    required this.onTap,
  }) : super(key: key);

  Widget _buildTeamLogo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: team.logoUrl != null && team.logoUrl!.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: team.logoUrl!,
        height: 52,
        width: 52,
        placeholder: (context, url) => _buildLoadingLogo(),
        errorWidget: (context, url, error) => _buildFallbackLogo(),
      )
          : _buildFallbackLogo(),
    );
  }

  Widget _buildFallbackLogo() {
    return const Icon(
      Icons.sports_football,
      color: Colors.white,
      size: 32,
    );
  }

  Widget _buildLoadingLogo() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFD50A0A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2A3A),
              Color(0xFF0D1A26),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTeamLogo(),
              const SizedBox(height: 12),
              Text(
                team.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                team.abbreviation,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamDetailsScreen extends StatelessWidget {
  final NFLTeam team;

  const TeamDetailsScreen({
    Key? key,
    required this.team,
  }) : super(key: key);

  // Updated with real historical facts for all 32 teams
  Map<String, String> _getTeamHistory(String teamName) {
    switch (teamName) {
      case 'Arizona Cardinals':
        return {
          'summary': 'Founded in 1898 in Chicago, making them the oldest continuously run professional football team in the US. Moved to Arizona in 1988.',
          'championships': '2 NFL Championships (1925, 1947), 1 Super Bowl appearance (XLIII)',
          'stadium': 'State Farm Stadium, Glendale',
          'notable': 'Larry Fitzgerald holds numerous NFL receiving records',
          'fun_fact': 'Only NFL team to have never hosted a Super Bowl despite having a stadium built for it'
        };
      case 'Atlanta Falcons':
        return {
          'summary': 'Founded in 1965 as an expansion team. Played in Super Bowl XXXIII and LI.',
          'championships': '0 Super Bowl wins, 2 appearances (XXXIII, LI)',
          'stadium': 'Mercedes-Benz Stadium, Atlanta',
          'notable': 'Home to the "Dirty Bird" celebration in the late 1990s',
          'fun_fact': 'Falcons blew a 28-3 lead in Super Bowl LI, the largest collapse in Super Bowl history'
        };
      case 'Baltimore Ravens':
        return {
          'summary': 'Established in 1996 when Art Modell moved the Cleveland Browns to Baltimore.',
          'championships': '2 Super Bowl wins (XXXV, XLVII)',
          'stadium': 'M&T Bank Stadium, Baltimore',
          'notable': 'Legendary defense led by Ray Lewis and Ed Reed',
          'fun_fact': 'Named after Edgar Allan Poe\'s famous poem "The Raven"'
        };
      case 'Buffalo Bills':
        return {
          'summary': 'Founded in 1960 as a charter member of the American Football League.',
          'championships': '2 AFL Championships (1964, 1965), 4 consecutive Super Bowl appearances (XXV-XXVIII)',
          'stadium': 'Highmark Stadium, Orchard Park',
          'notable': 'The only team to appear in 4 consecutive Super Bowls',
          'fun_fact': 'Famous for the "Bills Mafia" fanbase that breaks tables at tailgates'
        };
      case 'Carolina Panthers':
        return {
          'summary': 'Established in 1993 as an NFL expansion team, began play in 1995.',
          'championships': '2 Super Bowl appearances (XXXVIII, 50)',
          'stadium': 'Bank of America Stadium, Charlotte',
          'notable': 'Cam Newton\'s MVP season in 2015',
          'fun_fact': 'Team name was inspired by big cats found in the Carolina region'
        };
      case 'Chicago Bears':
        return {
          'summary': 'Founded in 1919 as the Decatur Staleys, moved to Chicago in 1921.',
          'championships': '9 NFL Championships (including Super Bowl XX)',
          'stadium': 'Soldier Field, Chicago',
          'notable': '1985 team considered one of the greatest defenses in NFL history',
          'fun_fact': 'George Halas coached the team for 40 seasons, winning 6 championships'
        };
      case 'Cincinnati Bengals':
        return {
          'summary': 'Founded in 1967 by Paul Brown as a member of the American Football League.',
          'championships': '0 Super Bowl wins, 3 appearances (XVI, XXIII, LVI)',
          'stadium': 'Paycor Stadium, Cincinnati',
          'notable': 'Joe Burrow led team to Super Bowl LVI in his second season',
          'fun_fact': 'First team to have a no-huddle offense as their base formation'
        };
      case 'Cleveland Browns':
        return {
          'summary': 'Founded in 1946, suspended operations from 1996-98, returned as an expansion team in 1999.',
          'championships': '4 AAFC Championships, 4 NFL Championships (last in 1964)',
          'stadium': 'Cleveland Browns Stadium, Cleveland',
          'notable': 'Jim Brown considered greatest running back of all time',
          'fun_fact': 'Have never appeared in a Super Bowl despite being an original NFL team'
        };
      case 'Dallas Cowboys':
        return {
          'summary': 'Founded in 1960 as an expansion team under Clint Murchison Jr.',
          'championships': '5 Super Bowl wins (VI, XII, XXVII, XXVIII, XXX)',
          'stadium': 'AT&T Stadium, Arlington',
          'notable': 'Known as "America\'s Team" with national fanbase',
          'fun_fact': 'Had 20 consecutive winning seasons from 1966-1985'
        };
      case 'Denver Broncos':
        return {
          'summary': 'Founded in 1960 as a charter member of the American Football League.',
          'championships': '3 Super Bowl wins (XXXII, XXXIII, 50)',
          'stadium': 'Empower Field at Mile High, Denver',
          'notable': 'John Elway led team to back-to-back Super Bowl wins',
          'fun_fact': 'First AFC team to defeat an NFC team in the Super Bowl (XXXII)'
        };
      case 'Detroit Lions':
        return {
          'summary': 'Founded in 1930 as the Portsmouth Spartans, moved to Detroit in 1934.',
          'championships': '4 NFL Championships (last in 1957)',
          'stadium': 'Ford Field, Detroit',
          'notable': 'Barry Sanders, one of the greatest running backs in NFL history',
          'fun_fact': 'Have never appeared in a Super Bowl and have the longest active playoff win drought'
        };
      case 'Green Bay Packers':
        return {
          'summary': 'Founded in 1919 by Earl "Curly" Lambeau and George Calhoun.',
          'championships': '13 championships (9 NFL titles, 4 Super Bowls)',
          'stadium': 'Lambeau Field, Green Bay',
          'notable': 'Only community-owned major professional sports team in US',
          'fun_fact': 'Lambeau Field is the oldest continuously occupied NFL stadium'
        };
      case 'Houston Texans':
        return {
          'summary': 'Founded in 2002 as an expansion team to replace the Houston Oilers.',
          'championships': '6 AFC South division titles',
          'stadium': 'NRG Stadium, Houston',
          'notable': 'J.J. Watt won 3 Defensive Player of the Year awards with Texans',
          'fun_fact': 'Youngest franchise in the NFL'
        };
      case 'Indianapolis Colts':
        return {
          'summary': 'Founded in 1953 as the Baltimore Colts, moved to Indianapolis in 1984.',
          'championships': '2 Super Bowl wins (V, XLI), 3 NFL Championships (1958, 1959, 1968)',
          'stadium': 'Lucas Oil Stadium, Indianapolis',
          'notable': 'Peyton Manning led team to Super Bowl XLI victory',
          'fun_fact': 'Subject of "The Greatest Game Ever Played" (1958 NFL Championship)'
        };
      case 'Jacksonville Jaguars':
        return {
          'summary': 'Founded in 1993 as an expansion team, began play in 1995.',
          'championships': '3 AFC Central/Central titles, 2 AFC Championship appearances',
          'stadium': 'EverBank Stadium, Jacksonville',
          'notable': 'Only expansion team to reach conference championship in their second season',
          'fun_fact': 'Played in the AFC Championship game more recently than 20 other NFL teams'
        };
      case 'Kansas City Chiefs':
        return {
          'summary': 'Founded in 1960 as the Dallas Texans, moved to Kansas City in 1963.',
          'championships': '3 Super Bowl wins (IV, LIV, LVII), 2 AFL Championships',
          'stadium': 'Arrowhead Stadium, Kansas City',
          'notable': 'Patrick Mahomes became fastest QB to 200 TD passes',
          'fun_fact': 'Arrowhead Stadium holds Guinness World Record for loudest stadium (142.2 dB)'
        };
      case 'Las Vegas Raiders':
        return {
          'summary': 'Founded in 1960 as the Oakland Raiders, moved to Las Vegas in 2020.',
          'championships': '3 Super Bowl wins (XI, XV, XVIII)',
          'stadium': 'Allegiant Stadium, Paradise',
          'notable': '"Commitment to Excellence" philosophy under Al Davis',
          'fun_fact': 'Only team to play in the Super Bowl in four different decades'
        };
      case 'Los Angeles Chargers':
        return {
          'summary': 'Founded in 1960 as the Los Angeles Chargers, moved to San Diego in 1961, returned to LA in 2017.',
          'championships': '1 AFL Championship (1963)',
          'stadium': 'SoFi Stadium, Inglewood',
          'notable': 'Dan Fouts set multiple passing records in Air Coryell offense',
          'fun_fact': 'First NFL team to use helmet logos in 1960'
        };
      case 'Los Angeles Rams':
        return {
          'summary': 'Founded in 1936 in Cleveland, moved to LA in 1946, to St. Louis in 1995, back to LA in 2016.',
          'championships': '2 Super Bowl wins (XXXIV, LVI), 3 NFL Championships',
          'stadium': 'SoFi Stadium, Inglewood',
          'notable': '"The Greatest Show on Turf" offense in late 1990s/early 2000s',
          'fun_fact': 'First team to play in Super Bowls representing three different cities'
        };
      case 'Miami Dolphins':
        return {
          'summary': 'Founded in 1966 as an expansion team.',
          'championships': '2 Super Bowl wins (VII, VIII)',
          'stadium': 'Hard Rock Stadium, Miami Gardens',
          'notable': 'Only perfect season in NFL history (17-0 in 1972)',
          'fun_fact': 'Don Shula holds record for most wins by a head coach (347)'
        };
      case 'Minnesota Vikings':
        return {
          'summary': 'Founded in 1961 as an expansion team.',
          'championships': '1 NFL Championship (1969), 4 Super Bowl appearances',
          'stadium': 'U.S. Bank Stadium, Minneapolis',
          'notable': '"Purple People Eaters" defensive line of the 1970s',
          'fun_fact': 'Have never won a Super Bowl despite making it to four'
        };
      case 'New England Patriots':
        return {
          'summary': 'Founded in 1959 as the Boston Patriots, renamed in 1971.',
          'championships': '6 Super Bowl wins (XXXVI, XXXVIII, XXXIX, XLIX, LI, LIII)',
          'stadium': 'Gillette Stadium, Foxborough',
          'notable': 'Tom Brady-Bill Belichick dynasty (2001-2019)',
          'fun_fact': 'Holds record for largest Super Bowl comeback (25 pts in Super Bowl LI)'
        };
      case 'New Orleans Saints':
        return {
          'summary': 'Founded in 1966 as an expansion team.',
          'championships': '1 Super Bowl win (XLIV)',
          'stadium': 'Caesars Superdome, New Orleans',
          'notable': 'Drew Brees set multiple NFL passing records',
          'fun_fact': 'Team was awarded to New Orleans on All Saints Day, hence the name'
        };
      case 'New York Giants':
        return {
          'summary': 'Founded in 1925 by Tim Mara.',
          'championships': '4 Super Bowl wins (XXI, XXV, XLII, XLVI), 4 NFL Championships',
          'stadium': 'MetLife Stadium, East Rutherford',
          'notable': 'Defeated undefeated Patriots in Super Bowl XLII',
          'fun_fact': 'Only NFL team to play home games in three different states (NY, NJ, CT)'
        };
      case 'New York Jets':
        return {
          'summary': 'Founded in 1959 as the Titans of New York, renamed in 1963.',
          'championships': '1 Super Bowl win (III)',
          'stadium': 'MetLife Stadium, East Rutherford',
          'notable': 'Joe Namath\'s "guarantee" and victory in Super Bowl III',
          'fun_fact': 'First AFL team to defeat an NFL team in the Super Bowl'
        };
      case 'Philadelphia Eagles':
        return {
          'summary': 'Founded in 1933 by Bert Bell and Lud Wray.',
          'championships': '1 Super Bowl win (LII), 3 NFL Championships',
          'stadium': 'Lincoln Financial Field, Philadelphia',
          'notable': '"Philly Special" trick play in Super Bowl LII',
          'fun_fact': 'Fans once booed and threw snowballs at Santa Claus in 1968'
        };
      case 'Pittsburgh Steelers':
        return {
          'summary': 'Founded in 1933 by Art Rooney.',
          'championships': '6 Super Bowl wins (most by any franchise)',
          'stadium': 'Acrisure Stadium, Pittsburgh',
          'notable': '"Steel Curtain" defense of the 1970s dynasty',
          'fun_fact': 'First team to win four Super Bowls and to win back-to-back twice'
        };
      case 'San Francisco 49ers':
        return {
          'summary': 'Founded in 1946 as charter members of the AAFC.',
          'championships': '5 Super Bowl wins (XVI, XIX, XXIII, XXIV, XXIX)',
          'stadium': 'Levi\'s Stadium, Santa Clara',
          'notable': 'Joe Montana and Steve Young led dynasty of 1980s-1990s',
          'fun_fact': 'First team to win 5 Super Bowls'
        };
      case 'Seattle Seahawks':
        return {
          'summary': 'Founded in 1974 as an expansion team.',
          'championships': '1 Super Bowl win (XLVIII)',
          'stadium': 'Lumen Field, Seattle',
          'notable': '"Legion of Boom" defense led by Richard Sherman',
          'fun_fact': '12th Man flag tradition with loudest crowd noise in NFL'
        };
      case 'Tampa Bay Buccaneers':
        return {
          'summary': 'Founded in 1974 as an expansion team.',
          'championships': '2 Super Bowl wins (XXXVII, LV)',
          'stadium': 'Raymond James Stadium, Tampa',
          'notable': 'Tom Brady led team to Super Bowl LV in his first season',
          'fun_fact': 'First team to win Super Bowl in their home stadium (LV)'
        };
      case 'Tennessee Titans':
        return {
          'summary': 'Founded in 1960 as the Houston Oilers, moved to Tennessee in 1997.',
          'championships': '2 AFL Championships (1960, 1961), 1 Super Bowl appearance (XXXIV)',
          'stadium': 'Nissan Stadium, Nashville',
          'notable': 'Eddie George and Steve McNair led team to Super Bowl XXXIV',
          'fun_fact': 'Known as the "Music City Miracle" team after famous playoff play'
        };
      case 'Washington Commanders':
        return {
          'summary': 'Founded in 1932 as the Boston Braves, moved to Washington in 1937.',
          'championships': '3 Super Bowl wins (XVII, XXII, XXVI)',
          'stadium': 'FedExField, Landover',
          'notable': '"The Hogs" offensive line of the 1980s-1990s',
          'fun_fact': 'Changed name from Washington Football Team in 2022'
        };
      default:
        return {
          'summary': '$teamName is a professional American football team in the NFL.',
          'championships': 'Check official records for championship history',
          'stadium': team.venue ?? 'Various stadiums throughout history',
          'notable': 'Many memorable moments and players throughout history',
          'fun_fact': 'Every NFL team has unique traditions and history'
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamName = '${team.location} ${team.name}';
    final teamHistory = _getTeamHistory(teamName);

    return Scaffold(
      appBar: AppBar(
        title: Text(team.displayName),
        backgroundColor: const Color(0xFF013369),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF002244),
              Colors.black,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: team.logoUrl != null && team.logoUrl!.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: team.logoUrl!,
                          height: 80,
                          width: 80,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD50A0A),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.sports_football,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                            : const Icon(
                          Icons.sports_football,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        teamName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (team.venue != null)
                      Center(
                        child: Text(
                          team.venue!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Team History Section
                    const Text(
                      'Team History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // History Summary Card
                    _buildHistoryCard(
                      icon: Icons.history,
                      title: 'Summary',
                      content: teamHistory['summary']!,
                      iconColor: Colors.blue,
                    ),
                    const SizedBox(height: 12),

                    // Championships Card
                    _buildHistoryCard(
                      icon: Icons.emoji_events,
                      title: 'Championships',
                      content: teamHistory['championships']!,
                      iconColor: Colors.amber,
                    ),
                    const SizedBox(height: 12),

                    // Stadium Card
                    _buildHistoryCard(
                      icon: Icons.stadium,
                      title: 'Stadium',
                      content: teamHistory['stadium']!,
                      iconColor: Colors.green,
                    ),
                    const SizedBox(height: 12),

                    // Notable Facts Card
                    _buildHistoryCard(
                      icon: Icons.star,
                      title: 'Notable Facts',
                      content: teamHistory['notable']!,
                      iconColor: Colors.purple,
                    ),
                    const SizedBox(height: 12),

                    // Fun Fact Card
                    _buildHistoryCard(
                      icon: Icons.celebration,
                      title: 'Fun Fact',
                      content: teamHistory['fun_fact']!,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
}

class NFLTeam {
  final String id;
  final String displayName;
  final String name;
  final String location;
  final String abbreviation;
  final String? logoUrl;
  final String? venue;

  NFLTeam({
    required this.id,
    required this.displayName,
    required this.name,
    required this.location,
    required this.abbreviation,
    this.logoUrl,
    this.venue,
  });

  factory NFLTeam.fromJson(Map<String, dynamic> json) {
    final logos = json['logos'] as List?;
    final venue = json['venue'] as Map<String, dynamic>?;
    final abbreviation = json['abbreviation'] as String? ?? '';

    return NFLTeam(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      abbreviation: abbreviation,
      logoUrl: (logos != null && logos.isNotEmpty) ? logos[0]['href'] : null,
      venue: venue?['fullName'],
    );
  }
}