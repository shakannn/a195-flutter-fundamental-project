import 'package:dicoding_news_app/common/bundle_data.dart';
import 'package:dicoding_news_app/provider/news_provider.dart';
import 'package:dicoding_news_app/ui/article_detail_page.dart';
import 'package:dicoding_news_app/widgets/card_article.dart';
import 'package:dicoding_news_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleListPage extends StatelessWidget {
  Widget _buildList(NewsProvider state) {
    if (state.state == ResultState.Loading) {
      return Center(child: CircularProgressIndicator());
    } else if (state.state == ResultState.HasData) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.result.articles.length,
        itemBuilder: (context, index) {
          var article = state.result.articles[index];
          return CardArticle(
            image: article.urlToImage,
            title: article.title,
            author: article.author,
            onPressed: () => Navigator.pushNamed(
              context,
              ArticleDetailPage.routeName,
              arguments: BundleData(article.source, article),
            ),
          );
        },
      );
    } else if (state.state == ResultState.NoData) {
      return Center(child: Text(state.message));
    } else if (state.state == ResultState.Error) {
      return Center(child: Text(state.message));
    } else {
      return Center(child: Text(''));
    }
  }

  Widget _buildAndroid(BuildContext context) {
    final state = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: _buildList(state),
    );
  }

  Widget _buildIos(BuildContext context) {
    final state = Provider.of<NewsProvider>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('News App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
