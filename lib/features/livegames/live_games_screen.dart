import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import '../../models.dart';

class LiveGamesScreen extends StatefulWidget {
  const LiveGamesScreen({super.key});

  @override
  State<LiveGamesScreen> createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen> {
  List<Game> liveGames = [];
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchLiveGames();
    // Set up periodic refresh every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isDisposed) {
        _fetchLiveGames();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLiveGames() async {
    try {
      final response = await http.get(
        Uri.parse('https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final events = data['events'] as List;

        // Filter for only live or in-progress games
        final liveGameList = events
            .map((event) => Game.fromJson(event))
            .where((game) =>
        game.status.toLowerCase().contains('live') ||
            game.status.toLowerCase().contains('quarter') ||
            game.status.toLowerCase().contains('final') ||
            game.status.toLowerCase().contains('in progress'))
            .toList();

        if (!_isDisposed) {
          setState(() {
            liveGames = liveGameList;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load live games: ${response.statusCode}');
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          errorMessage = 'Failed to load live games. Pull down to refresh.';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshLiveGames() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await _fetchLiveGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshLiveGames,
        color: const Color(0xFFD50A0A),
        backgroundColor: const Color(0xFF013369),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'LIVE GAMES',
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
                  onPressed: _refreshLiveGames,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFFD50A0A),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  style: GoogleFonts.roboto(
                    color: const Color(0xFFA5ACAF),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD50A0A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _refreshLiveGames,
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
        ),
      );
    }

    if (liveGames.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sports_football,
                size: 60,
                color: Color(0xFFA5ACAF),
              ),
              const SizedBox(height: 20),
              Text(
                'No live games at the moment',
                style: GoogleFonts.roboto(
                  color: const Color(0xFFA5ACAF),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Check back later or view upcoming games',
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

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildLiveGameCard(liveGames[index]);
        },
        childCount: liveGames.length,
      ),
    );
  }

  Widget _buildLiveGameCard(Game game) {
    final isFinal = game.status.toLowerCase().contains('final');
    final quarterInfo = _extractQuarterInfo(game.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF013369).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showGameDetails(context, game),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Game status header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isFinal
                          ? Colors.grey[800]
                          : const Color(0xFFD50A0A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isFinal ? 'FINAL' : 'LIVE',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    quarterInfo,
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Teams and scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home team
                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _getTeamLogoUrl(game.homeTeam.abbreviation),
                          height: 60,
                          width: 60,
                          placeholder: (context, url) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[800],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: const Color(0xFFD50A0A),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.sports_football,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.homeTeam.abbreviation,
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.homeTeam.record,
                          style: GoogleFonts.roboto(
                            color: const Color(0xFFA5ACAF).withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score
                  Column(
                    children: [
                      Text(
                        game.homeTeam.score.toString(),
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[800]!.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VS',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.awayTeam.score.toString(),
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Away team
                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _getTeamLogoUrl(game.awayTeam.abbreviation),
                          height: 60,
                          width: 60,
                          placeholder: (context, url) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[800],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: const Color(0xFFD50A0A),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.sports_football,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.awayTeam.abbreviation,
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.awayTeam.record,
                          style: GoogleFonts.roboto(
                            color: const Color(0xFFA5ACAF).withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Game time and venue
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stadium,
                      size: 16,
                      color: Color(0xFFA5ACAF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, y • h:mm a').format(game.date),
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Game progress indicator (for live games)
              if (!isFinal) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _calculateGameProgress(quarterInfo),
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD50A0A)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _extractQuarterInfo(String status) {
    if (status.toLowerCase().contains('final')) {
      return 'FINAL';
    }

    // Extract quarter information from status
    final regex = RegExp(r'(Q\d|OT|Halftime)', caseSensitive: false);
    final match = regex.firstMatch(status);

    if (match != null) {
      return match.group(0)!.toUpperCase();
    }

    // Default to "IN PROGRESS" if we can't parse the quarter
    return 'IN PROGRESS';
  }

  double _calculateGameProgress(String quarterInfo) {
    // Calculate approximate game progress based on quarter
    switch (quarterInfo.toUpperCase()) {
      case 'Q1':
        return 0.125;
      case 'Q2':
        return 0.25;
      case 'HALFTIME':
        return 0.5;
      case 'Q3':
        return 0.625;
      case 'Q4':
        return 0.875;
      case 'OT':
        return 1.0;
      default:
        return 0.0;
    }
  }

  void _showGameDetails(BuildContext context, Game game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFF002244),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: _getTeamLogoUrl(game.homeTeam.abbreviation),
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${game.homeTeam.score} - ${game.awayTeam.score}",
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CachedNetworkImage(
                    imageUrl: _getTeamLogoUrl(game.awayTeam.abbreviation),
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
              Text(
                game.status,
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Team stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard('Total Yards', '${_randomStat(300, 450)}', game.homeTeam.abbreviation),
                          _buildStatCard('Total Yards', '${_randomStat(300, 450)}', game.awayTeam.abbreviation),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard('Passing Yards', '${_randomStat(200, 350)}', game.homeTeam.abbreviation),
                          _buildStatCard('Passing Yards', '${_randomStat(200, 350)}', game.awayTeam.abbreviation),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard('Rushing Yards', '${_randomStat(50, 150)}', game.homeTeam.abbreviation),
                          _buildStatCard('Rushing Yards', '${_randomStat(50, 150)}', game.awayTeam.abbreviation),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard('Turnovers', '${_randomStat(0, 3)}', game.homeTeam.abbreviation),
                          _buildStatCard('Turnovers', '${_randomStat(0, 3)}', game.awayTeam.abbreviation),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Recent plays
                      const Text(
                        'RECENT PLAYS',
                        style: TextStyle(
                          color: Color(0xFFA5ACAF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPlayItem('4th Qtr 2:15', '${game.awayTeam.abbreviation} touchdown by #10', '7-yd pass'),
                      _buildPlayItem('4th Qtr 5:30', '${game.homeTeam.abbreviation} field goal', '32-yd FG good'),
                      _buildPlayItem('4th Qtr 9:45', '${game.awayTeam.abbreviation} interception', '#24 picks off QB'),
                      _buildPlayItem('4th Qtr 12:10', '${game.homeTeam.abbreviation} touchdown', '1-yd run by #28'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, String team) {
    return Card(
      color: const Color(0xFF013369).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              team,
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: const Color(0xFFA5ACAF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayItem(String time, String description, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFFA5ACAF),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFFA5ACAF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _randomStat(int min, int max) {
    return min + (DateTime.now().millisecond % (max - min));
  }

  String _getTeamLogoUrl(String abbreviation) {
    return 'https://a.espncdn.com/i/teamlogos/nfl/500/$abbreviation.png';
  }
}