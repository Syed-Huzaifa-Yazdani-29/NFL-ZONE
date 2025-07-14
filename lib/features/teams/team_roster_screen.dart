import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamRosterScreen extends StatefulWidget {
  const TeamRosterScreen({Key? key}) : super(key: key);

  @override
  _TeamRosterScreenState createState() => _TeamRosterScreenState();
}

class _TeamRosterScreenState extends State<TeamRosterScreen> {
  String? _selectedTeam;
  List<dynamic> _players = [];
  bool _isLoading = false;
  String _errorMessage = '';

  final Map<String, String> _nflTeams = {
    'ari': 'Arizona Cardinals',
    'atl': 'Atlanta Falcons',
    'bal': 'Baltimore Ravens',
    'buf': 'Buffalo Bills',
    'car': 'Carolina Panthers',
    'chi': 'Chicago Bears',
    'cin': 'Cincinnati Bengals',
    'cle': 'Cleveland Browns',
    'dal': 'Dallas Cowboys',
    'den': 'Denver Broncos',
    'det': 'Detroit Lions',
    'gb': 'Green Bay Packers',
    'hou': 'Houston Texans',
    'ind': 'Indianapolis Colts',
    'jax': 'Jacksonville Jaguars',
    'kc': 'Kansas City Chiefs',
    'lv': 'Las Vegas Raiders',
    'lac': 'Los Angeles Chargers',
    'lar': 'Los Angeles Rams',
    'mia': 'Miami Dolphins',
    'min': 'Minnesota Vikings',
    'ne': 'New England Patriots',
    'no': 'New Orleans Saints',
    'nyg': 'New York Giants',
    'nyj': 'New York Jets',
    'phi': 'Philadelphia Eagles',
    'pit': 'Pittsburgh Steelers',
    'sf': 'San Francisco 49ers',
    'sea': 'Seattle Seahawks',
    'tb': 'Tampa Bay Buccaneers',
    'ten': 'Tennessee Titans',
    'was': 'Washington Commanders',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFL Team Roster'),
        centerTitle: true,
        backgroundColor: const Color(0xFF013369),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchForm(),
            const SizedBox(height: 16),
            if (_selectedTeam != null && _selectedTeam!.isNotEmpty)
              Text(
                '${_nflTeams[_selectedTeam]} Roster - 2025 Season',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            _buildRosterList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTeam,
              decoration: InputDecoration(
                labelText: 'Select Team',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _nflTeams.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(_nflTeams[key]!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedTeam = newValue);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTeam == null ? null : _fetchRoster,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF013369),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Get 2025 Roster',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchRoster() async {
    if (_selectedTeam == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
        'https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams/$_selectedTeam?enable=roster',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _players = data['team']['athletes'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load roster: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching roster: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildRosterList() {
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_players.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No players found. Select a team to see their 2025 roster.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          return _PlayerCard(player: player);
        },
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final dynamic player;

  const _PlayerCard({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: player['headshot'] != null && player['headshot']['href'] != null
                    ? DecorationImage(
                  image: NetworkImage(player['headshot']['href']),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: player['headshot'] == null || player['headshot']['href'] == null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player['displayName'] ?? 'Unknown Player',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player['position']?['abbreviation'] ?? 'N/A'} | #${player['jersey'] ?? '--'}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Player stats with clear labels
                  if (player['age'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Age: ${player['age']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                  if (player['height'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Height: ${player['height']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                  if (player['weight'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Weight: ${player['weight']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                  if (player['experience']?['years'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Experience: ${player['experience']['years']} years',
                        style: const TextStyle(fontSize: 14),
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