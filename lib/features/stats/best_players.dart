import 'package:flutter/material.dart';

class NFLTopPlayersScreen extends StatefulWidget {
  const NFLTopPlayersScreen({super.key});

  @override
  State<NFLTopPlayersScreen> createState() => _NFLTopPlayersScreenState();
}

class _NFLTopPlayersScreenState extends State<NFLTopPlayersScreen> {
  // Track which year's players are currently visible
  int? selectedYear;

  // Player data for each year
  final Map<int, List<Player>> playersByYear = {
    2023: [
      Player(
        rank: 1,
        name: 'Patrick Mahomes',
        position: 'QB – Kansas City Chiefs',
        stats: [
          '5,250 passing yards (league leader)',
          '41 passing TDs (league leader)',
        ],
        accolades: [
          'Voted #1 overall in NFL Top 100',
          'Super Bowl champion & MVP',
        ],
      ),
      Player(
        rank: 2,
        name: 'Justin Jefferson',
        position: 'WR – Minnesota Vikings',
        stats: [
          '128 receptions (league leader)',
          '1,809 receiving yards (league leader)',
          '8 receiving touchdowns',
        ],
        accolades: [
          'Offensive Player of the Year',
          'First-Team All-Pro',
          'Ranked #2 in NFL Top 100',
        ],
      ),
      Player(
        rank: 3,
        name: 'Jalen Hurts',
        position: 'QB – Philadelphia Eagles',
        stats: [
          '3,701 passing yards',
          '22 passing TDs',
          '760 rushing yards',
          '13 rushing TDs',
        ],
        accolades: ['2nd-Team All-Pro honors', 'Ranked #3 in NFL Top 100'],
      ),
      Player(
        rank: 4,
        name: 'Nick Bosa',
        position: 'DE – San Francisco 49ers',
        stats: [
          '41 solo tackles',
          '18.5 sacks (league leader)',
        ],
        accolades: [
          'NFL Defensive Player of the Year',
          'First-Team All-Pro',
          'Ranked #4 in NFL Top 100',
        ],
      ),
      Player(
        rank: 5,
        name: 'Travis Kelce',
        position: 'TE – Kansas City Chiefs',
        stats: [
          'Consistently among top TEs in receptions, yards, and TDs',
        ],
        accolades: [
          'Super Bowl champion',
          'Ranked #5 in NFL Top 100',
        ],
      ),
    ],
    2022: [
      Player(
        rank: 1,
        name: 'Tom Brady',
        position: 'QB – Tampa Bay Buccaneers',
        stats: [
          '485 completions',
          '5,316 passing yards',
          '43 passing touchdowns',
        ],
        accolades: [
          'Led Bucs to NFC Championship Game',
          'Ranked #1 on NFL Top 100',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Donald',
        position: 'DT – Los Angeles Rams',
        stats: [
          '10+ sacks',
          'High tackle-for-loss counts',
        ],
        accolades: [
          'Elite defensive force',
          'Ranked #2 in NFL Top 100',
        ],
      ),
      Player(
        rank: 3,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,430 passing yards',
          '37 passing TDs (league leader)',
          '63% completion percentage',
        ],
        accolades: ['Ranked #3 in NFL Top 100'],
      ),
      Player(
        rank: 4,
        name: 'Cooper Kupp',
        position: 'WR – Los Angeles Rams',
        stats: [
          '75 receptions',
          '812 receiving yards',
          '6 receiving touchdowns',
        ],
        accolades: ['Ranked #4 in NFL Top 100'],
      ),
      Player(
        rank: 5,
        name: 'Jonathan Taylor',
        position: 'RB – Indianapolis Colts',
        stats: [
          '1,811 rushing yards',
          '18 rushing TDs',
          '40 receptions',
          '360 receiving yards',
          '2 receiving TDs',
        ],
        accolades: ['Ranked #5 in NFL Top 100'],
      ),
    ],
    2021: [
      Player(
        rank: 1,
        name: 'Tom Brady',
        position: 'QB – Tampa Bay Buccaneers',
        stats: [
          '5,316 passing yards (league leader)',
          '43 TDs (league leader)',
          'NFL single-season completions record (485)',
        ],
        accolades: [
          'Oldest player (44) to lead in passing yards and TDs',
          'Voted #1 on NFL Top 100',
        ],
      ),
      Player(
        rank: 2,
        name: 'T.J. Watt',
        position: 'OLB – Pittsburgh Steelers',
        stats: [
          '22.5 sacks (tied single-season record)',
          'Led league in QB pressures and tackles for loss',
        ],
        accolades: ['AP Defensive Player of the Year'],
      ),
      Player(
        rank: 3,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,115 passing yards',
          '37 TDs, just 4 INTs',
          '111.9 passer rating',
        ],
        accolades: ['AP MVP in 2021'],
      ),
      Player(
        rank: 4,
        name: 'Patrick Mahomes',
        position: 'QB – Kansas City Chiefs',
        stats: [
          '4,839 passing yards',
          '37 TDs',
          '98.4 passer rating',
        ],
        accolades: ['Held high placement in NFL Top 100 rankings'],
      ),
      Player(
        rank: 5,
        name: 'Justin Jefferson',
        position: 'WR – Minnesota Vikings',
        stats: [
          '1,616 receiving yards (second-most in NFL)',
        ],
        accolades: [
          'Pro Bowl & Second-team All-Pro',
          'First receiver since Randy Moss with 1,600+ yards in first two seasons',
        ],
      ),
    ],
    2020: [
      Player(
        rank: 1,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,299 passing yards',
          '48 passing TDs (most in the league)',
          'Only 5 INTs',
          '70.7% completion rate, 121.5 passer rating',
        ],
        accolades: ['NFL MVP (2020)'],
      ),
      Player(
        rank: 2,
        name: 'Patrick Mahomes',
        position: 'QB – Kansas City Chiefs',
        stats: [
          '4,740 passing yards',
          '38 touchdowns, 6 interceptions',
          'Guided the Chiefs to a 14–1 record',
        ],
        accolades: [],
      ),
      Player(
        rank: 3,
        name: 'Aaron Donald',
        position: 'DT – Los Angeles Rams',
        stats: [
          '13.5 sacks',
          '45 pressures',
          '4 forced fumbles',
        ],
        accolades: [
          'AP Defensive Player of the Year',
          'First-Team All-Pro',
        ],
      ),
      Player(
        rank: 4,
        name: 'Derrick Henry',
        position: 'RB – Tennessee Titans',
        stats: [
          '2,027 rushing yards',
          '17 rushing TDs',
        ],
        accolades: [
          '2,000-yard club member',
          'AP Offensive Player of the Year',
        ],
      ),
      Player(
        rank: 5,
        name: 'Travis Kelce',
        position: 'TE – Kansas City Chiefs',
        stats: [
          '105 receptions',
          '1,416 receiving yards',
          '11 TDs',
        ],
        accolades: [
          'NFL tight end single-season receiving yards record',
          'First-Team All-Pro',
        ],
      ),
    ],
    2019: [
      Player(
        rank: 1,
        name: 'Lamar Jackson',
        position: 'QB – Baltimore Ravens',
        stats: [
          '3,127 passing yards, 36 TDs, 6 INTs',
          '113.3 passer rating',
          '1,206 rushing yards, 7 TDs',
        ],
        accolades: [
          'Broke QB rushing record',
          'Unanimously voted AP MVP',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Donald',
        position: 'DT – Los Angeles Rams',
        stats: [
          '13.5 sacks',
          '45 pressures',
          '4 forced fumbles',
        ],
        accolades: [
          'AP Defensive Player of the Year',
          'First-Team All-Pro',
        ],
      ),
      Player(
        rank: 3,
        name: 'Patrick Mahomes',
        position: 'QB – Kansas City Chiefs',
        stats: [
          '5,097 passing yards',
          '50 TDs (league leader)',
        ],
        accolades: ['Ranked top 2 on NFL Top 100'],
      ),
      Player(
        rank: 4,
        name: 'Michael Thomas',
        position: 'WR – New Orleans Saints',
        stats: [
          '149 receptions (NFL record)',
          '1,725 receiving yards',
          '9 TDs',
        ],
        accolades: [
          'AP Offensive Player of the Year',
          'First-Team All-Pro',
        ],
      ),
      Player(
        rank: 5,
        name: 'Christian McCaffrey',
        position: 'RB – Carolina Panthers',
        stats: [
          '2,392 scrimmage yards (1,387 rush + 1,005 rec)',
          '116 receptions',
          '15 rushing TDs',
        ],
        accolades: [
          'One of only three 1,000/1,000 seasons ever',
          'First-Team All-Pro',
        ],
      ),
    ],
    2018: [
      Player(
        rank: 1,
        name: 'Patrick Mahomes',
        position: 'QB – Kansas City Chiefs',
        stats: [
          '50 passing TDs (led NFL)',
          '5,097 passing yards (2nd in league)',
          '113.8 passer rating',
        ],
        accolades: [
          'Named AP MVP and Offensive Player of the Year',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Donald',
        position: 'DT – Los Angeles Rams',
        stats: [
          '20.5 sacks (NFL leader)',
          '59 total tackles, 41 QB hits, 4 forced fumbles',
        ],
        accolades: [
          'Awarded AP Defensive Player of the Year',
        ],
      ),
      Player(
        rank: 3,
        name: 'Drew Brees',
        position: 'QB – New Orleans Saints',
        stats: [
          '74.4% completion percentage (NFL leader)',
          '3,992 passing yards, 32 TDs, 115.7 passer rating',
        ],
        accolades: [
          'Set NFL single-season record for completion percentage',
        ],
      ),
      Player(
        rank: 4,
        name: 'Todd Gurley',
        position: 'RB – Los Angeles Rams',
        stats: [
          '1,251 rushing yards, 17 rushing TDs',
          '59 receptions, 4 receiving TDs',
        ],
        accolades: [
          'Rated among top 5 by peers in 2018 NFL Top 100',
        ],
      ),
      Player(
        rank: 5,
        name: 'Alvin Kamara',
        position: 'RB – New Orleans Saints',
        stats: [
          '1,098 rushing yards, 7 rushing TDs',
          '107 receptions, 867 receiving yards, 6 receiving TDs',
        ],
        accolades: [
          'Led NFL in dual-threat use; over 1,000 rush + 1,000 receiving yards',
        ],
      ),
    ],
    2017: [
      Player(
        rank: 1,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '4,577 passing yards (led the NFL)',
          '32 touchdowns',
          'Strong performance at age 40',
        ],
        accolades: [
          'Ranked #1 on NFL Peer Ballot Top 100',
        ],
      ),
      Player(
        rank: 2,
        name: 'Von Miller',
        position: 'OLB – Denver Broncos',
        stats: [
          'Consistently elite pass rusher stats',
        ],
        accolades: [
          'Ranked #2 on NFL Top 100',
          'Perennial All-Pro pick (Pro Bowl & First-Team All-Pro)',
        ],
      ),
      Player(
        rank: 3,
        name: 'Julio Jones',
        position: 'WR – Atlanta Falcons',
        stats: [
          'Averaged over 1,400 yards for the 4th straight season',
        ],
        accolades: [
          'Ranked #3 in NFL Top 100',
        ],
      ),
      Player(
        rank: 4,
        name: 'Antonio Brown',
        position: 'WR – Pittsburgh Steelers',
        stats: [
          'Over 100 receptions for the 5th straight season',
        ],
        accolades: [
          'Ranked #4 in NFL Top 100',
        ],
      ),
      Player(
        rank: 5,
        name: 'Khalil Mack',
        position: 'DE – Oakland Raiders',
        stats: [
          'Elite defensive play stats',
        ],
        accolades: [
          'Ranked #5 in NFL Top 100',
          'AP Defensive Player of the Year candidate',
        ],
      ),
    ],
    2016: [
      Player(
        rank: 1,
        name: 'Matt Ryan',
        position: 'QB – Atlanta Falcons',
        stats: [
          '4,944 passing yards, 38 passing TDs, 7 INTs',
          '117.1 passer rating',
        ],
        accolades: [
          'AP MVP 2016',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,428 passing yards, 40 TDs, 7 INTs',
          '65.7% completion rate, 104.2 passer rating',
          '369 rushing yards, 4 rushing TDs',
        ],
        accolades: [],
      ),
      Player(
        rank: 3,
        name: 'Cam Newton',
        position: 'QB – Carolina Panthers',
        stats: [
          'Significant passing and rushing contributions',
        ],
        accolades: [
          'Ranked #1 in NFL Top 100 (peer-voted)',
        ],
      ),
      Player(
        rank: 4,
        name: 'J.J. Watt',
        position: 'DE – Houston Texans',
        stats: [
          'Led Texans defense after returning from injury',
        ],
        accolades: [
          'Ranked #3 in Top 100 players',
        ],
      ),
      Player(
        rank: 5,
        name: 'Antonio Brown',
        position: 'WR – Pittsburgh Steelers',
        stats: [
          'Among league leaders in receptions and receiving yards',
        ],
        accolades: [
          'Ranked #4 in peer-voted NFL Top 100',
        ],
      ),
    ],
    2015: [
      Player(
        rank: 1,
        name: 'J.J. Watt',
        position: 'DE – Houston Texans',
        stats: [
          '76 tackles, 17.5 sacks (NFL lead), 3 forced fumbles',
        ],
        accolades: [
          'Voted #1 overall on NFL Top 100 2015',
          'Earned his third AP Defensive Player of the Year',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,428 passing yards, ~40 TDs, ~7 INTs, ~104 passer rating',
        ],
        accolades: [
          'Ranked #2 on Top 100 2015',
        ],
      ),
      Player(
        rank: 3,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '~4,770 yards, high completion rate, 36+ TDs',
        ],
        accolades: [
          'Ranked #3 in NFL Top 100',
        ],
      ),
      Player(
        rank: 4,
        name: 'DeMarco Murray',
        position: 'RB – Dallas Cowboys / Philadelphia Eagles',
        stats: [
          '1,845 rushing yards, 13 TDs',
        ],
        accolades: [
          'Ranked #4 in NFL Top 100',
        ],
      ),
      Player(
        rank: 5,
        name: 'Peyton Manning',
        position: 'QB – Denver Broncos',
        stats: [
          '~3,705 yards, 9 TDs in his final season',
        ],
        accolades: [
          'Ranked #5 in NFL Top 100',
        ],
      ),
    ],
    2014: [
      Player(
        rank: 1,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,381 passing yards, 38 passing TDs (league leader)',
        ],
        accolades: [
          'Awarded AP MVP for the 2014 season',
        ],
      ),
      Player(
        rank: 2,
        name: 'DeMarco Murray',
        position: 'RB – Dallas Cowboys',
        stats: [
          '1,845 rushing yards, 13 rushing TDs (league leader)',
          '57 receptions for 416 yards',
        ],
        accolades: [
          'Received AP Offensive Player of the Year',
        ],
      ),
      Player(
        rank: 3,
        name: 'Antonio Brown',
        position: 'WR – Pittsburgh Steelers',
        stats: [
          '1,698 receiving yards (league leader)',
        ],
        accolades: [],
      ),
      Player(
        rank: 4,
        name: 'J.J. Watt',
        position: 'DE – Houston Texans',
        stats: [
          '20.5 sacks (in 2014 context)',
        ],
        accolades: [
          'Voted #1 overall in NFL Top 100 players list',
        ],
      ),
      Player(
        rank: 5,
        name: 'Drew Brees',
        position: 'QB – New Orleans Saints',
        stats: [
          '4,952 passing yards (highest in the league)',
        ],
        accolades: [],
      ),
    ],
    2013: [
      Player(
        rank: 1,
        name: 'Adrian Peterson',
        position: 'RB – Minnesota Vikings',
        stats: [
          '2,097 rushing yards and 12 TDs',
          'Averaged 131.1 yds/game',
        ],
        accolades: [
          "#1 on NFL Network's Top 100 Players of 2013",
          'Earned First-Team All-Pro honors',
        ],
      ),
      Player(
        rank: 2,
        name: 'Peyton Manning',
        position: 'QB – Denver Broncos',
        stats: [
          '4,659 passing yards, 37 TDs, and 11 INTs',
          '68.6% completion rate',
        ],
        accolades: [
          'Ranked #2 on Top 100 list',
          'Led Broncos to 13–3 and first-team All-Pro',
        ],
      ),
      Player(
        rank: 3,
        name: 'Calvin Johnson',
        position: 'WR – Detroit Lions',
        stats: [
          '122 passes for 1,964 yards (NFL single-season record at the time)',
          'Averaged 16.1 yds/catch',
        ],
        accolades: [
          'Ranked #3 on Top 100',
          'Voted First-Team All-Pro',
        ],
      ),
      Player(
        rank: 4,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '4,806 yards, 50 TDs (first QB ever with 50 in a season), 8 INTs',
          '117.2 passer rating',
        ],
        accolades: [
          'Ranked #4 on Top 100 list',
        ],
      ),
      Player(
        rank: 5,
        name: 'J.J. Watt',
        position: 'DE – Houston Texans',
        stats: [
          '20.5 sacks (league leader)',
        ],
        accolades: [
          'Ranked #5 on Top 100',
          'Earned First-Team All-Pro honors',
        ],
      ),
    ],
    2012: [
      Player(
        rank: 1,
        name: 'Adrian Peterson',
        position: 'RB – Minnesota Vikings',
        stats: [
          '2,097 rushing yards, 12 rushing TDs',
          '6.0 yards per carry',
        ],
        accolades: [
          'AP NFL MVP & Offensive Player of the Year (2012)',
        ],
      ),
      Player(
        rank: 2,
        name: 'Peyton Manning',
        position: 'QB – Denver Broncos',
        stats: [
          '4,659 passing yards, 37 passing TDs, 11 INTs',
          '68.6% completion, 105.8 passer rating',
        ],
        accolades: [
          'Delivered a comeback season post-injury',
        ],
      ),
      Player(
        rank: 3,
        name: 'Calvin Johnson',
        position: 'WR – Detroit Lions',
        stats: [
          '122 receptions, 1,964 receiving yards (NFL leader)',
          'Averaged 16.1 yds/catch',
        ],
        accolades: [
          'Set Lions franchise records',
          'Voted NFL Top 100 (#3)',
        ],
      ),
      Player(
        rank: 4,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '4,827 passing yards, 34 TDs, 8 INTs',
          '98.7 passer rating',
        ],
        accolades: [
          'Led Patriots to a 12–4 record',
        ],
      ),
      Player(
        rank: 5,
        name: 'J.J. Watt',
        position: 'DE – Houston Texans',
        stats: [
          '69 solo tackles, 20.5 sacks, 4 forced fumbles',
        ],
        accolades: [
          'Earned AP Defensive Player of the Year',
          'Voted Top 100 (#5)',
        ],
      ),
    ],
    2011: [
      Player(
        rank: 1,
        name: 'Drew Brees',
        position: 'QB – New Orleans Saints',
        stats: [
          '5,476 passing yards (led NFL)',
          '46 touchdowns',
          '71.2% completion rate, 110.6 passer rating',
        ],
        accolades: [
          'Awarded AP Offensive Player of the Year',
        ],
      ),
      Player(
        rank: 2,
        name: 'Aaron Rodgers',
        position: 'QB – Green Bay Packers',
        stats: [
          '4,643 yards, 45 touchdowns, only 6 interceptions',
          '122.5 passer rating (NFL single-season record)',
        ],
        accolades: [
          'Won AP MVP for the 2011 season',
        ],
      ),
      Player(
        rank: 3,
        name: 'Maurice Jones-Drew',
        position: 'RB – Jacksonville Jaguars',
        stats: [
          '1,606 rushing yards (#1 in NFL)',
          '1,980 scrimmage yards',
        ],
        accolades: [],
      ),
      Player(
        rank: 4,
        name: 'Calvin Johnson',
        position: 'WR – Detroit Lions',
        stats: [
          '1,681 receiving yards (led the league)',
        ],
        accolades: [],
      ),
      Player(
        rank: 5,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '5,235 yards and 39 TDs',
          '105.6 passer rating',
        ],
        accolades: [],
      ),
    ],
    2010: [
      Player(
        rank: 1,
        name: 'Tom Brady',
        position: 'QB – New England Patriots',
        stats: [
          '3,900 passing yards, 36 TDs, 4 INTs',
          '65.9% completion rate, 111.0 passer rating',
        ],
        accolades: [
          'AP NFL MVP & Offensive Player of the Year',
        ],
      ),
      Player(
        rank: 2,
        name: 'Arian Foster',
        position: 'RB – Houston Texans',
        stats: [
          '1,616 rushing yards (led NFL)',
        ],
        accolades: [
          'First-team AP All-Pro (2010)',
        ],
      ),
      Player(
        rank: 3,
        name: 'Maurice Jones-Drew',
        position: 'RB – Jacksonville Jaguars',
        stats: [
          '1,324 rushing yards',
        ],
        accolades: [
          'AP All-Pro First-Team',
        ],
      ),
      Player(
        rank: 4,
        name: 'DeMarcus Ware',
        position: 'OLB – Dallas Cowboys',
        stats: [
          '15.5 sacks (led NFL)',
        ],
        accolades: [
          'Pro Bowler and elite pass rusher',
        ],
      ),
      Player(
        rank: 5,
        name: 'Roddy White',
        position: 'WR – Atlanta Falcons',
        stats: [
          '115 receptions (led NFL)',
        ],
        accolades: [
          'AP All-Pro First-Team receiver',
        ],
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Year selection buttons - now centered and more professional
            Center(
              child: Column(
                children: [
                  // Title above the buttons
                  const Text(
                    'SELECT A SEASON',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // First row (2023-2016)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016]
                          .map((year) => _buildYearButton(year))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Second row (2015-2010)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [2015, 2014, 2013, 2012, 2011, 2010]
                          .map((year) => _buildYearButton(year))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Display selected year's players
            if (selectedYear != null) ...[
              Text(
                'TOP 5 PLAYERS - $selectedYear SEASON',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              ...playersByYear[selectedYear]!.map((player) => _buildPlayerCard(player)).toList(),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'SELECT A YEAR TO VIEW TOP PLAYERS\n2024 TOP PLAYERS ARE YET TO BE ANNOUNCED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFA5ACAF),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildYearButton(int year) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedYear == year
            ? const Color(0xFFD50A0A) // NFL red for selected
            : const Color(0xFF013369), // NFL blue
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selectedYear == year ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 3,
      ),
      onPressed: () {
        setState(() {
          selectedYear = selectedYear == year ? null : year;
        });
      },
      child: Text(
        year.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlayerCard(Player player) {
    Color rankColor;
    String rankSymbol;

    switch (player.rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Gold
        rankSymbol = '🥇';
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0); // Silver
        rankSymbol = '🥈';
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankSymbol = '🥉';
        break;
      case 4:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankSymbol = '4';
        break;
      case 5:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankSymbol = '5';
        break;
      default:
        rankColor = Colors.white;
        rankSymbol = '${player.rank}.';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$rankSymbol ',
                  style: const TextStyle(fontSize: 24),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                        ),
                      ),
                      Text(
                        player.position,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA5ACAF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF013369), thickness: 1),
            const SizedBox(height: 8),
            const Text(
              'STATS:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            ...player.stats.map((stat) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                '• $stat',
                style: const TextStyle(
                  color: Color(0xFFA5ACAF),
                ),
              ),
            )).toList(),
            if (player.accolades.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'ACCOLADES:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              ...player.accolades.map((accolade) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  '• $accolade',
                  style: const TextStyle(
                    color: Color(0xFFA5ACAF),
                  ),
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

class Player {
  final int rank;
  final String name;
  final String position;
  final List<String> stats;
  final List<String> accolades;

  Player({
    required this.rank,
    required this.name,
    required this.position,
    required this.stats,
    required this.accolades,
  });
}