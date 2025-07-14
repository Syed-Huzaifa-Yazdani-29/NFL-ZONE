import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFL Player Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PlayerSearchScreen(),
    );
  }
}

class PlayerSearchScreen extends StatefulWidget {
  const PlayerSearchScreen({super.key});

  @override
  _PlayerSearchScreenState createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends State<PlayerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String _searchError = '';

  // MySportsFeeds API credentials
  final String _apiKey = 'ab22512e-ebc0-4833-8288-04e3e1';
  final String _password = 'MYSPORTSFEEDS'; // Default password for v2.1 API

  Future<void> _searchPlayers(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
      _searchError = '';
    });

    try {
      // First search for players
      final response = await _makeApiRequest(
          'https://api.mysportsfeeds.com/v2.1/pull/nfl/players.json?player=${Uri.encodeQueryComponent(query)}'
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['players'] ?? [];
          _isSearching = false;
          if (_searchResults.isEmpty) {
            _searchError = 'No players found matching "$query"';
          }
        });
      } else {
        setState(() {
          _isSearching = false;
          _searchError = 'Failed to search players: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchError = 'Error: ${e.toString()}';
      });
    }
  }

  Future<http.Response> _makeApiRequest(String url) async {
    final credentials = base64Encode('$_apiKey:$_password'.codeUnits);

    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search NFL Players'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Players',
                hintText: 'Enter player name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchPlayers(_searchController.text),
                ),
              ),
              onSubmitted: _searchPlayers,
            ),
            const SizedBox(height: 20),
            if (_isSearching)
              const Center(child: CircularProgressIndicator())
            else if (_searchError.isNotEmpty)
              Text(_searchError, style: const TextStyle(color: Colors.red))
            else if (_searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final player = _searchResults[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            '${player['firstName'][0]}${player['lastName'][0]}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text('${player['firstName']} ${player['lastName']}'),
                        subtitle: Text(player['position'] ?? 'Unknown position'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerStatsScreen(
                                playerId: player['id'],
                                playerName: '${player['firstName']} ${player['lastName']}',
                                apiKey: _apiKey,
                                password: _password,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class PlayerStatsScreen extends StatefulWidget {
  final String playerId;
  final String playerName;
  final String apiKey;
  final String password;

  const PlayerStatsScreen({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.apiKey,
    required this.password,
  });

  @override
  _PlayerStatsScreenState createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen> {
  Map<String, dynamic>? _playerStats;
  bool _isLoading = false;
  String _errorMessage = '';
  String _season = '2023-regular'; // Default to 2023 season

  @override
  void initState() {
    super.initState();
    _fetchPlayerStats();
  }

  Future<void> _fetchPlayerStats() async {
    setState(() {
      _isLoading = true;
      _playerStats = null;
      _errorMessage = '';
    });

    try {
      final response = await _makeApiRequest(
          'https://api.mysportsfeeds.com/v2.1/pull/nfl/$_season/player_stats_totals.json?player=${widget.playerId}'
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _playerStats = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load player stats: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<http.Response> _makeApiRequest(String url) async {
    final credentials = base64Encode('${widget.apiKey}:${widget.password}'.codeUnits);

    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playerName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          : _playerStats == null
          ? const Center(child: Text('No stats available'))
          : _buildStatsDisplay(),
    );
  }

  Widget _buildStatsDisplay() {
    final stats = _playerStats!['playerStatsTotals'][0]['stats'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Season Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _season,
                items: [
                  '2023-regular',
                  '2022-regular',
                  '2021-regular',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.split('-')[0]),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _season = newValue;
                    });
                    _fetchPlayerStats();
                  }
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          if (stats['passing'] != null) _buildStatCategory('Passing', stats['passing']),
          if (stats['rushing'] != null) _buildStatCategory('Rushing', stats['rushing']),
          if (stats['receiving'] != null) _buildStatCategory('Receiving', stats['receiving']),
          if (stats['defense'] != null) _buildStatCategory('Defense', stats['defense']),
          if (stats['kicking'] != null) _buildStatCategory('Kicking', stats['kicking']),
        ],
      ),
    );
  }

  Widget _buildStatCategory(String category, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...stats.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatStatName(entry.key),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatStatName(String name) {
    name = name.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
    );
    return name.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}