import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InjuriesScreen extends StatefulWidget {
  const InjuriesScreen({Key? key}) : super(key: key);

  @override
  State<InjuriesScreen> createState() => _InjuriesScreenState();
}

class _InjuriesScreenState extends State<InjuriesScreen> {
  List<InjuryReport> _injuryReports = [];
  List<HistoricalInjury> _historicalInjuries = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _showHistory = false;
  bool _isLoadingHistory = false;
  String _selectedTeam = 'All Teams';
  List<String> _teamNames = [];
  String? _selectedPlayerForHistory;
  bool _showHistoricalData = false;
  String _selectedYear = '2024'; // Default to most recent year

  final List<Map<String, String>> historicalInjuries = [
    // 2024
    {'year': '2024', 'player': 'Deshaun Watson', 'team': 'Browns', 'injury': 'Achilles tendon tear'},
    {'year': '2024', 'player': 'Trevor Lawrence', 'team': 'Jaguars', 'injury': 'Shoulder injury (surgery)'},
    {'year': '2024', 'player': 'Christian McCaffrey', 'team': '49ers', 'injury': 'PCL tear; calf/Achilles issues'},
    {'year': '2024', 'player': 'Jahmyr Gibbs', 'team': 'Lions', 'injury': 'Hamstring injury'},
    {'year': '2024', 'player': 'Nick Chubb', 'team': 'Texans', 'injury': 'Broken foot; prior ACL/MCL injuries'},
    {'year': '2024', 'player': 'Puka Nacua', 'team': 'Rams', 'injury': 'PCL sprain'},
    {'year': '2024', 'player': 'Tank Dell', 'team': 'Texans', 'injury': 'Dislocated knee + ACL/MCL/PCL tears'},
    {'year': '2024', 'player': 'Tyler Higbee', 'team': 'Rams', 'injury': 'ACL/MCL tear, chest injury'},
    {'year': '2024', 'player': 'Shaq Thompson', 'team': 'Bills', 'injury': 'Achilles tear'},
    {'year': '2024', 'player': 'Trevon Diggs', 'team': 'Cowboys', 'injury': 'Knee injury (prior ACL leg)'},
    {'year': '2024', 'player': 'Jaire Alexander', 'team': 'Packers', 'injury': 'PCL injury, arthroscopic knee surgery'},

    // 2023
    {'year': '2023', 'player': 'Aaron Rodgers', 'team': 'Jets', 'injury': 'Left Achilles tendon rupture'},
    {'year': '2023', 'player': 'Kyler Murray', 'team': 'Cardinals', 'injury': 'Returned from 2022 ACL recovery – missed 9 games'},
    {'year': '2023', 'player': 'Anthony Richardson', 'team': 'Colts', 'injury': 'Grade 3 AC joint sprain; shoulder surgery'},
    {'year': '2023', 'player': 'Joe Burrow', 'team': 'Bengals', 'injury': 'Scapholunate ligament tear (wrist)'},
    {'year': '2023', 'player': 'Damar Hamlin', 'team': 'Bills', 'injury': 'Commotio cordis collapse (on-field cardiac event)'},
    {'year': '2023', 'player': 'Leighton Vander Esch', 'team': 'Cowboys', 'injury': 'Recurring neck injury (IR)'},
    {'year': '2023', 'player': 'Christian McCaffrey', 'team': '49ers', 'injury': 'Achilles & knee issues late season'},

    // 2022
    {'year': '2022', 'player': 'Kyler Murray', 'team': 'Cardinals', 'injury': 'Non-contact ACL tear (Week 14)'},
    {'year': '2022', 'player': 'Von Miller', 'team': 'Bills', 'injury': 'ACL tear (post-Thanksgiving)'},
    {'year': '2022', 'player': 'Matthew Stafford', 'team': 'Rams', 'injury': 'Concussion then spinal cord contusion'},
    {'year': '2022', 'player': 'Jason Verrett', 'team': '49ers', 'injury': 'Achilles tear (after return)'},
    {'year': '2022', 'player': 'Tyron Smith', 'team': 'Cowboys', 'injury': 'Hamstring tear (training camp)'},
    {'year': '2022', 'player': 'Jourdan Lewis', 'team': 'Cowboys', 'injury': 'Lisfranc foot injury'},
    {'year': '2022', 'player': 'Marcus Peters', 'team': 'Ravens', 'injury': 'ACL tear (pre-season)'},
    {'year': '2022', 'player': 'Frank Ragnow', 'team': 'Lions', 'injury': 'Toe injury (missed 13 games)'},
    {'year': '2022', 'player': 'Jalen Ramsey', 'team': 'Rams', 'injury': 'AC joint issues (camp)'},
    {'year': '2022', 'player': 'Tre Davious White', 'team': 'Bills', 'injury': 'ACL rehab (camp)'},

    // 2021
    {'year': '2021', 'player': 'Derrick Henry', 'team': 'Titans', 'injury': 'Foot fracture (Jones fracture)'},
    {'year': '2021', 'player': 'Jameis Winston', 'team': 'Saints', 'injury': 'Torn ACL and MCL damage'},
    {'year': '2021', 'player': 'J.K. Dobbins', 'team': 'Ravens', 'injury': 'Torn ACL (preseason)'},
    {'year': '2021', 'player': 'Michael Thomas', 'team': 'Saints', 'injury': 'Ankle injury (missed entire season)'},
    {'year': '2021', 'player': 'Chase Young', 'team': 'Commanders', 'injury': 'Torn ACL (Week 10)'},

    // 2020
    {'year': '2020', 'player': 'Dak Prescott', 'team': 'Cowboys', 'injury': 'Compound fracture & dislocation (ankle)'},
    {'year': '2020', 'player': 'Nick Bosa', 'team': '49ers', 'injury': 'Torn ACL (Week 2)'},
    {'year': '2020', 'player': 'Saquon Barkley', 'team': 'Giants', 'injury': 'Torn ACL (Week 2)'},
    {'year': '2020', 'player': 'Christian McCaffrey', 'team': 'Panthers', 'injury': 'High ankle sprain (missed 13 games)'},
    {'year': '2020', 'player': 'Von Miller', 'team': 'Broncos', 'injury': 'Tendon injury (season-ending pre-season)'},

    // 2019
    {'year': '2019', 'player': 'Ben Roethlisberger', 'team': 'Steelers', 'injury': 'Elbow injury (season-ending)'},
    {'year': '2019', 'player': 'Cam Newton', 'team': 'Panthers', 'injury': 'Foot injury (Lisfranc fracture)'},
    {'year': '2019', 'player': 'Andrew Luck', 'team': 'Colts', 'injury': 'Retired due to ongoing injuries'},
    {'year': '2019', 'player': 'Kwon Alexander', 'team': '49ers', 'injury': 'Torn pectoral muscle'},
    {'year': '2019', 'player': 'Hunter Henry', 'team': 'Chargers', 'injury': 'Knee injury (tibia plateau fracture)'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchInjuryReports();
  }

  Future<void> _fetchInjuryReports() async {
    final url = Uri.parse('https://site.api.espn.com/apis/site/v2/sports/football/nfl/injuries');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['sports'] == null ||
            data['sports'].isEmpty ||
            data['sports'][0]['leagues'] == null ||
            data['sports'][0]['leagues'].isEmpty) {
          setState(() {
            _isLoading = false;
            _hasError = false;
            _injuryReports = [];
          });
          return;
        }

        final List<dynamic> items = data['sports'][0]['leagues'][0]['teams'] ?? [];

        List<InjuryReport> reports = [];
        Set<String> teamNames = {'All Teams'};

        for (var team in items) {
          final teamData = team['team'] ?? {};
          final teamName = teamData['displayName']?.toString() ?? 'Unknown Team';
          teamNames.add(teamName);

          final players = team['players'] ?? [];
          for (var player in players) {
            final injuries = player['injuries'] ?? [];
            final primaryInjury = injuries.isNotEmpty ? injuries[0] : {};

            reports.add(
              InjuryReport(
                teamName: teamName,
                teamAbbreviation: teamData['abbreviation']?.toString() ?? '',
                playerName: player['fullName']?.toString() ?? 'Unknown Player',
                position: player['position']?['abbreviation']?.toString() ??
                    player['position']?['name']?.toString() ?? 'Unknown Position',
                injuryStatus: player['status']?.toString() ?? 'Unknown Status',
                injuryDetails: primaryInjury['details']?['description']?.toString() ?? 'No details available',
                dateUpdated: primaryInjury['date']?.toString() ?? '',
                practiceStatus: primaryInjury['practice']?.toString() ?? '',
              ),
            );
          }
        }

        setState(() {
          _injuryReports = reports;
          _teamNames = teamNames.toList();
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Error fetching injury reports: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchHistoricalInjuries(String playerName) async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      // In a real app, you would call an actual API here
      // This is a mock implementation to simulate the behavior
      await Future.delayed(const Duration(seconds: 1));

      // Filter historical injuries for this player
      final playerInjuries = historicalInjuries
          .where((injury) => injury['player'] == playerName)
          .map((injury) => HistoricalInjury(
        date: DateTime.now(),
        status: 'Historical',
        description: injury['injury'] ?? 'No details',
        season: injury['year'] ?? '',
        team: injury['team'] ?? '',
      ))
          .toList();

      setState(() {
        _historicalInjuries = playerInjuries;
        _isLoadingHistory = false;
      });
    } catch (e) {
      print('Error fetching historical injuries: $e');
      setState(() {
        _historicalInjuries = [];
        _isLoadingHistory = false;
      });
    }
  }

  List<InjuryReport> get _filteredReports {
    if (_selectedTeam == 'All Teams') {
      return _injuryReports;
    }
    return _injuryReports.where((report) => report.teamName == _selectedTeam).toList();
  }

  List<Map<String, String>> get _filteredHistoricalInjuries {
    if (_selectedYear == 'All Years') {
      return historicalInjuries;
    }
    return historicalInjuries.where((injury) => injury['year'] == _selectedYear).toList();
  }

  Widget _buildTeamFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Team',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _teamNames.map((team) {
                final isSelected = _selectedTeam == team && !_showHistoricalData;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      team == 'All Teams' ? team : team.split(' ').last,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFFA5ACAF),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTeam = team;
                        _showHistoricalData = false;
                        _showHistory = false;
                        _selectedPlayerForHistory = null;
                      });
                    },
                    backgroundColor: const Color(0xFF013369).withOpacity(0.5),
                    selectedColor: const Color(0xFFD50A0A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFFD50A0A)
                            : const Color(0xFFA5ACAF).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearFilter() {
    final years = ['All Years', '2024', '2023', '2022', '2021', '2020', '2019'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Year',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: years.map((year) {
                final isSelected = _selectedYear == year && _showHistoricalData;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      year,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFFA5ACAF),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedYear = year;
                        _showHistoricalData = true;
                      });
                    },
                    backgroundColor: const Color(0xFF013369).withOpacity(0.5),
                    selectedColor: const Color(0xFFD50A0A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFFD50A0A)
                            : const Color(0xFFA5ACAF).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInjuryCard(InjuryReport report) {
    final isOut = report.injuryStatus.toLowerCase().contains('out');
    final isDoubtful = report.injuryStatus.toLowerCase().contains('doubtful');
    final isQuestionable = report.injuryStatus.toLowerCase().contains('questionable');

    Color statusColor;
    if (isOut) {
      statusColor = Colors.red;
    } else if (isDoubtful) {
      statusColor = Colors.orange;
    } else if (isQuestionable) {
      statusColor = Colors.yellow[700]!;
    } else {
      statusColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFF013369).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.playerName,
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  report.teamName,
                  style: GoogleFonts.roboto(
                    color: const Color(0xFFA5ACAF),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${report.position}',
                  style: GoogleFonts.roboto(
                    color: const Color(0xFFA5ACAF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            report.injuryStatus.toUpperCase(),
            style: GoogleFonts.robotoCondensed(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.practiceStatus.isNotEmpty)
                  _buildDetailRow(
                    Icons.sports,
                    'Practice Status',
                    report.practiceStatus,
                    Colors.blue,
                  ),
                if (report.dateUpdated.isNotEmpty)
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Last Updated',
                    DateFormat('MMM d, y').format(DateTime.parse(report.dateUpdated)),
                    Colors.purple,
                  ),
                const SizedBox(height: 8),
                Text(
                  'Injury Details',
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.injuryDetails,
                  style: GoogleFonts.roboto(
                    color: const Color(0xFFA5ACAF),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // History button and loading indicator
                if (_isLoadingHistory && _selectedPlayerForHistory == report.playerName)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedPlayerForHistory == report.playerName && _showHistory) {
                        setState(() {
                          _showHistory = false;
                          _selectedPlayerForHistory = null;
                        });
                      } else {
                        setState(() {
                          _selectedPlayerForHistory = report.playerName;
                          _showHistory = true;
                        });
                        await _fetchHistoricalInjuries(report.playerName);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _selectedPlayerForHistory == report.playerName && _showHistory
                          ? 'Hide Injury History'
                          : 'Show Injury History',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Historical injuries section
                if (_showHistory && _selectedPlayerForHistory == report.playerName)
                  _buildHistoricalInjuriesSection(),

                if (report.teamAbbreviation.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: 'https://a.espncdn.com/i/teamlogos/nfl/500/${report.teamAbbreviation}.png',
                    height: 40,
                    width: 40,
                    placeholder: (context, url) => Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFFD50A0A),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.sports_football,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalInjuryCard(Map<String, String> injury) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFF013369).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              injury['player'] ?? 'Unknown Player',
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  injury['team'] ?? 'Unknown Team',
                  style: GoogleFonts.roboto(
                    color: const Color(0xFFA5ACAF),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD50A0A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD50A0A),
                    ),
                  ),
                  child: Text(
                    injury['year'] ?? '',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFD50A0A),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Injury Details',
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              injury['injury'] ?? 'No details available',
              style: GoogleFonts.roboto(
                color: const Color(0xFFA5ACAF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalInjuriesSection() {
    if (_historicalInjuries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'No historical injury data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Injury History',
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ..._historicalInjuries.map((injury) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${injury.season} - ${injury.team}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(injury.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getStatusColor(injury.status),
                      ),
                    ),
                    child: Text(
                      injury.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(injury.status),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                injury.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const Divider(color: Colors.grey, height: 16),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.roboto(
              color: const Color(0xFFA5ACAF),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoCondensed(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'out':
        return Colors.red;
      case 'doubtful':
        return Colors.orange;
      case 'questionable':
        return Colors.yellow[700]!;
      case 'ir':
        return Colors.red[800]!;
      default:
        return Colors.green;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _showHistory = false;
      _selectedPlayerForHistory = null;
      _showHistoricalData = false;
    });
    await _fetchInjuryReports();
  }

  Widget _buildToggleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showHistoricalData = !_showHistoricalData;
                if (!_showHistoricalData) {
                  _showHistory = false;
                  _selectedPlayerForHistory = null;
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _showHistoricalData ? const Color(0xFFD50A0A) : const Color(0xFF013369),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              _showHistoricalData ? 'Show Current Injuries' : 'Show Historical Injuries',
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFD50A0A),
        backgroundColor: const Color(0xFF013369),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'INJURY REPORTS',
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshData,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: _buildToggleButton(),
            ),
            if (!_showHistoricalData)
              SliverToBoxAdapter(
                child: _buildTeamFilter(),
              )
            else
              SliverToBoxAdapter(
                child: _buildYearFilter(),
              ),
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFD50A0A),
                  ),
                ),
              )
            else if (_hasError)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load injury reports.',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFFA5ACAF),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD50A0A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _refreshData,
                        child: Text(
                          'Retry',
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (!_showHistoricalData && _filteredReports.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.medical_services,
                          size: 60,
                          color: Color(0xFFA5ACAF),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No injuries reported',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFFA5ACAF),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedTeam == 'All Teams'
                              ? 'All teams are healthy!'
                              : '${_selectedTeam.split(' ').last} has no injuries',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFFA5ACAF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_showHistoricalData && _filteredHistoricalInjuries.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 60,
                            color: Color(0xFFA5ACAF),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No historical injuries found',
                            style: GoogleFonts.roboto(
                              color: const Color(0xFFA5ACAF),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _selectedYear == 'All Years'
                                ? 'Try selecting a specific year'
                                : 'No injuries for $_selectedYear',
                            style: GoogleFonts.roboto(
                              color: const Color(0xFFA5ACAF),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_showHistoricalData)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return _buildHistoricalInjuryCard(_filteredHistoricalInjuries[index]);
                        },
                        childCount: _filteredHistoricalInjuries.length,
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return _buildInjuryCard(_filteredReports[index]);
                        },
                        childCount: _filteredReports.length,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class InjuryReport {
  final String teamName;
  final String teamAbbreviation;
  final String playerName;
  final String position;
  final String injuryStatus;
  final String injuryDetails;
  final String dateUpdated;
  final String practiceStatus;

  InjuryReport({
    required this.teamName,
    required this.teamAbbreviation,
    required this.playerName,
    required this.position,
    required this.injuryStatus,
    required this.injuryDetails,
    required this.dateUpdated,
    required this.practiceStatus,
  });
}

class HistoricalInjury {
  final DateTime date;
  final String status;
  final String description;
  final String season;
  final String team;

  HistoricalInjury({
    required this.date,
    required this.status,
    required this.description,
    this.season = '',
    this.team = '',
  });
}