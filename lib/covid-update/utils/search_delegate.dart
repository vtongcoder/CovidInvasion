import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends SearchDelegate {
  final List<Map<String, String>> countriesListWithNameAndFlag;

  Search({
    this.countriesListWithNameAndFlag,
    
  }):super(searchFieldLabel: 'Input country name' );
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  String _searchResult = '';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        // Navigator.pop(context, _searchResult) ;
        close(context, _searchResult);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('Search result: $query');
    // final searchResult = Provider.of<SearchResult>(context);
    // query = searchResult.searchResult;

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print('Suggesstion: $query');
    // final searchResult = Provider.of<SearchResult>(context);
    // query = searchResult.searchResult;

    final suggestionList = query.isEmpty
        ? countriesListWithNameAndFlag
        : countriesListWithNameAndFlag
            .where(
                (country) => country['country'].toLowerCase().startsWith(query))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return SearchItem(suggestion: suggestionList[index]);
      },
    );
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key key,
    @required this.suggestion,
  }) : super(key: key);

  final Map<String, String> suggestion;

  @override
  Widget build(BuildContext context) {
    String _searchResult = '';

    return GestureDetector(
      onTap: () {
        _searchResult = suggestion['country'];        
        Navigator.pop(context, _searchResult);
        
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                child: suggestion['country'] == 'Global'
                    ? SvgPicture.asset(
                        'assets/icons/global.svg',
                      )
                    : Image.network(suggestion['flag']),
              ),
              SizedBox(
                width: 30,
              ),
              Text(suggestion['country']),
            ],
          ),
        ),
      ),
    );
  }
}

// class SearchResult with ChangeNotifier {
//   String _searchResult = '';

//   String get searchResult => _searchResult;

//   void updateSearchResult(String rNewResult) {
//     _searchResult = rNewResult;
    
//     notifyListeners();
//     print('Send notif search result');
//   }
// }
