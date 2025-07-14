import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class InjuredPlayersScreen extends StatefulWidget {
  const InjuredPlayersScreen({Key? key}) : super(key: key);

  @override
  State<InjuredPlayersScreen> createState() => _InjuredPlayersScreenState();
}

class _InjuredPlayersScreenState extends State<InjuredPlayersScreen> {
  List<dynamic> _injuredPlayers = [];
  bool _isLoading = true;
  String _error = '';
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    fetchInjuredPlayers();
  }

  Future<void> fetchInjuredPlayers() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Fetch all NFL teams
      final teamsResponse = await http.get(Uri.parse(
          'https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams?limit=32'
      ));

      if (teamsResponse.statusCode != 200) {
        throw Exception('Failed to load teams: ${teamsResponse.statusCode}');
      }

      final teamsData = json.decode(teamsResponse.body);
      final teams = teamsData['sports'][0]['leagues'][0]['teams'];

      // Fetch injuries for each team
      final List<dynamic> allInjuries = [];

      for (final team in teams) {
        final teamId = team['team']['id'];
        final injuriesUrl = Uri.parse(
            'https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams/$teamId/injuries'
        );

        final injuriesResponse = await http.get(injuriesUrl);
        if (injuriesResponse.statusCode == 200) {
          final injuriesData = json.decode(injuriesResponse.body);
          final injuries = injuriesData['athletes'] ?? [];

          for (final injury in injuries) {
            injury['team'] = team['team']; // Add team info to injury
            allInjuries.add(injury);
          }
        }
      }

      setState(() {
        _injuredPlayers = allInjuries;
        _isLoading = false;
        _hasData = allInjuries.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
        _hasData = false;
      });
    }
  }

  Widget buildInjuryCard(Map<String, dynamic> injury) {
    final player = injury;
    final team = injury['team'] ?? {};
    final position = player['position']?['abbreviation'] ?? 'N/A';
    final fullName = player['fullName'] ?? 'Unknown Player';
    final headshotUrl = player['headshot']?['href'] ?? '';
    final status = player['status'] ?? 'Unknown';
    final injuryType = player['injuries']?[0]?['type'] ?? 'Not specified';
    final injuryDesc = player['injuries']?[0]?['details'] ?? 'No description available';
    final injuryDate = player['injuries']?[0]?['date'] ?? 'Date not provided';

    // Determine status color
    Color statusColor = Colors.grey;
    if (status.toLowerCase().contains('out')) {
      statusColor = Colors.red;
    } else if (status.toLowerCase().contains('questionable') ||
        status.toLowerCase().contains('doubtful')) {
      statusColor = Colors.orange;
    } else if (status.toLowerCase().contains('probable')) {
      statusColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player headshot
                if (headshotUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: headshotUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),

                const SizedBox(width: 16),

                // Player info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        position,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team['displayName'] ?? 'Unknown Team',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Injury details
            const Divider(height: 1),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Injury Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    injuryType,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    injuryDate.toString().split("T").first,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              injuryDesc,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFL Injury Report'),
        backgroundColor: const Color(0xFF013369),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchInjuredPlayers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              _error,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchInjuredPlayers,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : !_hasData
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No current injuries reported',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchInjuredPlayers,
        child: ListView.builder(
          itemCount: _injuredPlayers.length,
          itemBuilder: (context, index) => buildInjuryCard(_injuredPlayers[index]),
        ),
      ),
    );
  }
}