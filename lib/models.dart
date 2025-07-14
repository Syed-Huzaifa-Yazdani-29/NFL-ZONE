class Game {
  final String id;
  final DateTime date;
  final String status;
  final Team homeTeam;
  final Team awayTeam;

  Game({
    required this.id,
    required this.date,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final competitions = json['competitions'] as List;
    final competition = competitions.isNotEmpty ? competitions[0] : {};
    final competitors = competition['competitors'] as List;

    final homeTeamJson = competitors.firstWhere(
          (c) => c['homeAway'] == 'home',
      orElse: () => {},
    );

    final awayTeamJson = competitors.firstWhere(
          (c) => c['homeAway'] == 'away',
      orElse: () => {},
    );

    return Game(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      status: competition['status']['type']['name'] ?? 'Scheduled',
      homeTeam: Team.fromJson(homeTeamJson['team'], homeTeamJson['score']),
      awayTeam: Team.fromJson(awayTeamJson['team'], awayTeamJson['score']),
    );
  }
}

class Team {
  final String id;
  final String name;
  final String abbreviation;
  final String displayName;
  final String record;
  final int score;
  final String logoUrl;

  Team({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.displayName,
    required this.record,
    required this.score,
    required this.logoUrl,
  });

  factory Team.fromJson(Map<String, dynamic> teamJson, dynamic scoreJson) {
    if (teamJson.isEmpty) {
      return Team(
        id: '',
        name: 'TBD',
        abbreviation: 'TBD',
        displayName: 'To Be Determined',
        record: '0-0',
        score: 0,
        logoUrl: 'https://a.espncdn.com/i/teamlogos/nfl/500/default.png',
      );
    }

    return Team(
      id: teamJson['id'] ?? '',
      name: teamJson['name'] ?? 'Unknown',
      abbreviation: teamJson['abbreviation'] ?? '',
      displayName: teamJson['displayName'] ?? teamJson['name'] ?? 'Unknown',
      record: teamJson['record']?[0]?['summary'] ?? '0-0',
      score: int.tryParse(scoreJson?.toString() ?? '0') ?? 0,
      logoUrl: teamJson['logos']?[0]?['href'] ??
          'https://a.espncdn.com/i/teamlogos/nfl/500/${teamJson['abbreviation']?.toLowerCase() ?? 'default'}.png',
    );
  }
}

class NewsArticle {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? source;
  final DateTime publishedAt;
  final String? url;

  NewsArticle({
    required this.title,
    this.description,
    this.imageUrl,
    this.source,
    required this.publishedAt,
    this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['headline'] ?? 'No title',
      description: json['description'],
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : null,
      source: json['source'] ?? 'ESPN',
      publishedAt: DateTime.parse(json['published'] ?? DateTime.now().toString()),
      url: (json['links'] != null &&
          json['links']['web'] != null &&
          json['links']['web']['href'] != null)
          ? json['links']['web']['href']
          : null,
    );
  }
}

class PlayerStats {
  final String name;
  final String position;
  final String imageUrl;
  final String number;
  final String stats;
  final String type;

  PlayerStats({
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.number,
    required this.stats,
    required this.type,
  });
}