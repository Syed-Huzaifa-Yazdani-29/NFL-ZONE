import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamStatsScreen extends StatefulWidget {
  const TeamStatsScreen({Key? key}) : super(key: key);

  @override
  _TeamStatsScreenState createState() => _TeamStatsScreenState();
}

class _TeamStatsScreenState extends State<TeamStatsScreen> {
  int _selectedYear = DateTime.now().year;
  String? _selectedTeam;
  Map<String, dynamic> _teamStats = {};
  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _years = List.generate(10, (index) => (DateTime.now().year - index).toString());

  final Map<String, String> _nflTeams = {
    '1': 'Arizona Cardinals',
    '2': 'Atlanta Falcons',
    '3': 'Baltimore Ravens',
    '4': 'Buffalo Bills',
    '5': 'Carolina Panthers',
    '6': 'Chicago Bears',
    '7': 'Cincinnati Bengals',
    '8': 'Cleveland Browns',
    '9': 'Dallas Cowboys',
    '10': 'Denver Broncos',
    '11': 'Detroit Lions',
    '12': 'Green Bay Packers',
    '13': 'Houston Texans',
    '14': 'Indianapolis Colts',
    '15': 'Jacksonville Jaguars',
    '16': 'Kansas City Chiefs',
    '17': 'Las Vegas Raiders',
    '18': 'Los Angeles Chargers',
    '19': 'Los Angeles Rams',
    '20': 'Miami Dolphins',
    '21': 'Minnesota Vikings',
    '22': 'New England Patriots',
    '23': 'New Orleans Saints',
    '24': 'New York Giants',
    '25': 'New York Jets',
    '26': 'Philadelphia Eagles',
    '27': 'Pittsburgh Steelers',
    '28': 'San Francisco 49ers',
    '29': 'Seattle Seahawks',
    '30': 'Tampa Bay Buccaneers',
    '31': 'Tennessee Titans',
    '32': 'Washington Commanders',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdowns(),
            const SizedBox(height: 20),
            if (_selectedTeam != null && _teamStats.isNotEmpty)
              Column(
                children: [
                  Text(_nflTeams[_selectedTeam]!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('$_selectedYear Season Statistics',
                      style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 16),
                ],
              ),
            _buildStatsContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        _buildYearDropdown(),
        const SizedBox(height: 12),
        _buildTeamDropdown(),
      ],
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<int>(
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Season',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFF2D2D2D),
      ),
      value: _selectedYear,
      onChanged: (value) {
        setState(() {
          _selectedYear = value!;
        });
        _fetchTeamStats();
      },
      items: _years.map((year) {
        return DropdownMenuItem<int>(
          value: int.parse(year),
          child: Text(year, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget _buildTeamDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Team',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFF2D2D2D),
      ),
      value: _selectedTeam,
      onChanged: (value) {
        setState(() {
          _selectedTeam = value;
        });
        _fetchTeamStats();
      },
      items: _nflTeams.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Future<void> _fetchTeamStats() async {
    if (_selectedTeam == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url =
        'https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/seasons/$_selectedYear/types/2/teams/$_selectedTeam/statistics';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _teamStats = data;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStatsContent() {
    if (_isLoading) {
      return const Expanded(
          child: Center(child: CircularProgressIndicator(color: Color(0xFF013369))));
    }

    if (_errorMessage.isNotEmpty) {
      return Expanded(child: Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red))));
    }

    if (_teamStats.isEmpty) {
      return const Expanded(child: Center(child: Text("No data available", style: TextStyle(color: Colors.white))));
    }

    final List categories = _teamStats['splits']['categories'] ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          return _buildStatCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildStatCategoryCard(dynamic category) {
    final List stats = category['stats'] ?? [];
    final String categoryName = category['name'] ?? 'Unknown';

    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryName.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...stats.map((stat) => _buildStatItem(stat)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(dynamic stat) {
    final String rawStatName = stat['name'] ?? 'Unknown Stat';
    final String statName = formatStatName(rawStatName);
    final String statValue = stat['displayValue'] ?? '--';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(statName, style: const TextStyle(color: Colors.white70)),
          Text(statValue, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String formatStatName(String input) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return input.split(regex).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}