import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsArticle> newsArticles = [];
  bool isLoading = true;
  String errorMessage = '';
  NewsArticle? selectedArticle;

  @override
  void initState() {
    super.initState();
    _fetchNFLNews();
  }

  Future<void> _fetchNFLNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://site.api.espn.com/apis/site/v2/sports/football/nfl/news'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .where((article) => article['headline'] != null)
            .map((article) => NewsArticle.fromJson(article))
            .toList();

        setState(() {
          newsArticles = articles;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load news. Pull down to refresh.';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshNews() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      selectedArticle = null;
    });
    await _fetchNFLNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshNews,
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
          child: selectedArticle == null
              ? _buildNewsContent()
              : _buildNewsDetailScreen(),
        ),
      ),
    );
  }

  Widget _buildNewsContent() {
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
                onPressed: _refreshNews,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (newsArticles.isEmpty) {
      return const Center(
        child: Text(
          'No news articles available',
          style: TextStyle(
            color: Color(0xFFA5ACAF),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        return _buildNewsCard(newsArticles[index]);
      },
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF013369).withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedArticle = article;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD50A0A),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description ?? '',
                style: const TextStyle(
                  color: Color(0xFFA5ACAF),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.source ?? 'ESPN',
                    style: TextStyle(
                      color: const Color(0xFFA5ACAF).withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, y • h:mm a').format(article.publishedAt),
                    style: TextStyle(
                      color: const Color(0xFFA5ACAF).withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsDetailScreen() {
    return Column(
      children: [
        AppBar(
          backgroundColor: const Color(0xFF013369),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setState(() {
                selectedArticle = null;
              });
            },
          ),
          title: const Text(
            'NEWS DETAILS',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Header
                _buildArticleHeader(selectedArticle!),
                const SizedBox(height: 16),

                // Featured Image
                if (selectedArticle!.imageUrl != null)
                  _buildArticleImage(selectedArticle!.imageUrl!),
                const SizedBox(height: 24),

                // Article Content
                Text(
                  selectedArticle!.description ?? 'No content available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Related News Section
                const SizedBox(height: 32),
                const Text(
                  'RELATED NEWS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRelatedNewsSection(selectedArticle!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleHeader(NewsArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              article.source ?? 'ESPN',
              style: TextStyle(
                color: const Color(0xFFA5ACAF).withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('MMM d, y • h:mm a').format(article.publishedAt),
              style: TextStyle(
                color: const Color(0xFFA5ACAF).withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          color: Colors.grey[800],
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD50A0A),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[800],
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedNewsSection(NewsArticle currentArticle) {
    final relatedArticles = newsArticles
        .where((article) => article.title != currentArticle.title)
        .take(3)
        .toList();

    if (relatedArticles.isEmpty) {
      return const Text(
        'No related articles available',
        style: TextStyle(
          color: Color(0xFFA5ACAF),
          fontSize: 16,
        ),
      );
    }

    return Column(
      children: relatedArticles.map((article) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          color: const Color(0xFF013369).withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                selectedArticle = article;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: article.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD50A0A),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.article,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d, y').format(article.publishedAt),
                          style: TextStyle(
                            color: const Color(0xFFA5ACAF).withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }
}