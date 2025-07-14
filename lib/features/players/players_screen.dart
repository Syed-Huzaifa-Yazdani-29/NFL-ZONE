import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _players = [];
  bool _isLoading = false;
  String _errorMessage = '';
  dynamic _selectedPlayer;
  Map<int, String> _playerImagesCache = {}; // Cache for player images

  // API Configuration
  final String _apiKey = "35c57a0aa7d147c3b78fb6d5af1de235";
  final String _baseUrl = "https://api.sportsdata.io/v3/nfl/scores/json";
  final String _sportsDbApiKey = "3"; // TheSportsDB uses 1, 2, or 3 as API key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _selectedPlayer == null ? _buildSearchContent() : _buildPlayerDetailScreen(),
      ),
    );
  }

  Widget _buildSearchContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF013369),
          pinned: true,
          expandedHeight: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF002244),
                    Color(0xFF013369),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSearchBar(),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD50A0A),
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Color(0xFFA5ACAF),
                      fontSize: 16,
                    ),
                  ),
                ),
              if (_players.isNotEmpty) _buildPlayersGrid(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Card(
      color: const Color(0xFF013369).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search players...',
                  hintStyle: const TextStyle(color: Color(0xFFA5ACAF)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFA5ACAF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFA5ACAF)),
                    onPressed: _clearSearch,
                  )
                      : null,
                ),
                onSubmitted: (_) => _searchPlayers(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _searchPlayers,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50A0A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _players.length,
      itemBuilder: (context, index) {
        final player = _players[index];
        return _buildPlayerCard(player);
      },
    );
  }

  Widget _buildPlayerCard(dynamic player) {
    final playerId = player['PlayerID'];
    final cachedImage = _playerImagesCache[playerId];
    String photoUrl = cachedImage ??
        player['PhotoUrl'] ??
        'https://www.thesportsdb.com/images/media/player/thumb/default.jpg';

    return Card(
      color: const Color(0xFF013369).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _fetchPlayerDetails(player['PlayerID']),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD50A0A),
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFFA5ACAF),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                player['Name'] ?? 'Unknown Player',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${player['Position'] ?? ''} #${player['Number'] ?? 'N/A'}',
                style: const TextStyle(
                  color: Color(0xFFA5ACAF),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                player['Team'] ?? 'No Team',
                style: const TextStyle(
                  color: Color(0xFFD50A0A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerDetailScreen() {
    final player = _selectedPlayer;
    final playerId = player['PlayerID'];
    final cachedImage = _playerImagesCache[playerId];
    String photoUrl = cachedImage ??
        player['PhotoUrl'] ??
        'https://www.thesportsdb.com/images/media/player/thumb/default.jpg';

    return Column(
      children: [
        AppBar(
          backgroundColor: const Color(0xFF013369),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedPlayer = null;
              });
            },
          ),
          title: const Text(
            'PLAYER DETAILS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photoUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD50A0A),
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFFA5ACAF),
                      ),
                      fit: BoxFit.cover,
                      width: 160,
                      height: 160,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  player['Name'] ?? 'Unknown Player',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${player['Position'] ?? ''} #${player['Number'] ?? 'N/A'} | ${player['FullTeamName'] ?? player['Team'] ?? 'No Team'}',
                  style: const TextStyle(
                    color: Color(0xFFA5ACAF),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: const Color(0xFF013369).withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow('Age', player['Age']?.toString() ?? 'N/A'),
                        const Divider(color: Color(0xFFA5ACAF)),
                        _buildDetailRow('Height', player['Height'] ?? 'N/A'),
                        const Divider(color: Color(0xFFA5ACAF)),
                        _buildDetailRow('Weight', player['Weight']?.toString() ?? 'N/A', suffix: 'lbs'),
                        const Divider(color: Color(0xFFA5ACAF)),
                        _buildDetailRow('College', player['College'] ?? 'N/A'),
                        const Divider(color: Color(0xFFA5ACAF)),
                        _buildDetailRow('Experience', player['Experience']?.toString() ?? 'N/A', suffix: 'years'),
                        const Divider(color: Color(0xFFA5ACAF)),
                        _buildDetailRow('Status', player['Status'] ?? 'N/A'),
                        if (player['FullTeamName'] != null) ...[
                          const Divider(color: Color(0xFFA5ACAF)),
                          _buildDetailRow('Team', player['FullTeamName']!),
                        ],
                        if (player['TeamCity'] != null) ...[
                          const Divider(color: Color(0xFFA5ACAF)),
                          _buildDetailRow('Team City', player['TeamCity']!),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA5ACAF),
              fontSize: 16,
            ),
          ),
          Text(
            suffix != null ? '$value $suffix' : value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchPlayers() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _players = [];
      _selectedPlayer = null;
    });

    try {
      // First get players from SportsData.io
      final sportsDataResponse = await http.get(
        Uri.parse("$_baseUrl/Players?key=$_apiKey"),
        headers: {'Accept': 'application/json'},
      );

      if (sportsDataResponse.statusCode == 200) {
        final allPlayers = json.decode(sportsDataResponse.body);
        final searchTerm = _searchController.text.toLowerCase();

        final filteredPlayers = allPlayers.where((player) =>
        (player['Name']?.toString().toLowerCase().contains(searchTerm) ?? false)
        ).toList();

        // Now enrich with images from TheSportsDB
        final List<dynamic> enrichedPlayers = [];
        for (var player in filteredPlayers) {
          try {
            final playerId = player['PlayerID'];
            // Only fetch image if not already in cache
            if (!_playerImagesCache.containsKey(playerId)) {
              // Search player in TheSportsDB
              final sportsDbResponse = await http.get(
                Uri.parse("https://www.thesportsdb.com/api/v1/json/$_sportsDbApiKey/searchplayers.php?p=${player['Name']}"),
              );

              if (sportsDbResponse.statusCode == 200) {
                final sportsDbData = json.decode(sportsDbResponse.body);
                if (sportsDbData['player'] != null && sportsDbData['player'].isNotEmpty) {
                  // Take the first matching player's image
                  final imageUrl = sportsDbData['player'][0]['strCutout'] ??
                      sportsDbData['player'][0]['strThumb'] ??
                      'https://www.thesportsdb.com/images/media/player/thumb/default.jpg';

                  // Cache the image URL
                  _playerImagesCache[playerId] = imageUrl;
                  player['PhotoUrl'] = imageUrl;
                }
              }
            } else {
              // Use cached image
              player['PhotoUrl'] = _playerImagesCache[playerId];
            }
          } catch (e) {
            print('Error fetching player image: $e');
          }
          enrichedPlayers.add(player);
        }

        setState(() {
          _players = enrichedPlayers;
          if (_players.isEmpty) {
            _errorMessage = 'No players found with that name';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'API Error: ${sportsDataResponse.statusCode} - ${sportsDataResponse.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPlayerDetails(int playerId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // First fetch player details
      final playerResponse = await http.get(
        Uri.parse("$_baseUrl/Player/$playerId?key=$_apiKey"),
        headers: {'Accept': 'application/json'},
      );

      if (playerResponse.statusCode == 200) {
        final playerData = json.decode(playerResponse.body);

        // Then fetch team details if TeamID is available
        if (playerData['TeamID'] != null) {
          final teamResponse = await http.get(
            Uri.parse("$_baseUrl/Teams/${playerData['TeamID']}?key=$_apiKey"),
            headers: {'Accept': 'application/json'},
          );

          if (teamResponse.statusCode == 200) {
            final teamData = json.decode(teamResponse.body);
            // Update player data with full team name
            playerData['FullTeamName'] = teamData['FullName'] ?? teamData['Name'] ?? playerData['Team'];
            playerData['TeamCity'] = teamData['City'] ?? 'N/A';
          }
        }

        // Check if we have an image in cache
        if (_playerImagesCache.containsKey(playerId)) {
          playerData['PhotoUrl'] = _playerImagesCache[playerId];
        } else {
          // Try to fetch image if not in cache
          try {
            final sportsDbResponse = await http.get(
              Uri.parse("https://www.thesportsdb.com/api/v1/json/$_sportsDbApiKey/searchplayers.php?p=${playerData['Name']}"),
            );

            if (sportsDbResponse.statusCode == 200) {
              final sportsDbData = json.decode(sportsDbResponse.body);
              if (sportsDbData['player'] != null && sportsDbData['player'].isNotEmpty) {
                final imageUrl = sportsDbData['player'][0]['strCutout'] ??
                    sportsDbData['player'][0]['strThumb'] ??
                    'https://www.thesportsdb.com/images/media/player/thumb/default.jpg';

                // Cache the image URL
                _playerImagesCache[playerId] = imageUrl;
                playerData['PhotoUrl'] = imageUrl;
              }
            }
          } catch (e) {
            print('Error fetching player image in details: $e');
          }
        }

        setState(() {
          _selectedPlayer = playerData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch details: ${playerResponse.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _players = [];
      _selectedPlayer = null;
      _errorMessage = '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}