import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../res/color.dart';

typedef SearchFilter<T> = List<String?> Function(T t);
typedef ResultBuilder<T> = Widget Function(T t);

class SearchPage<T> extends SearchDelegate<T?> {
  final bool showItemsOnEmpty;
  final Widget suggestion;
  final Widget failure;
  final ResultBuilder<T> builder;
  final SearchFilter<T> filter;
  final String? searchLabel;
  final List<T> items;
  final bool itemStartsWith;
  final bool itemEndsWith;
  final void Function(String)? onQueryUpdate;
  final TextStyle? searchStyle;

  SearchPage({
    this.suggestion = const SizedBox(),
    this.failure = const SizedBox(),
    required this.builder,
    required this.filter,
    required this.items,
    this.showItemsOnEmpty = false,
    this.searchLabel,
    this.itemStartsWith = false,
    this.itemEndsWith = false,
    this.onQueryUpdate,
    this.searchStyle,
  }) : super(
          searchFieldLabel: searchLabel,
          searchFieldStyle: searchStyle,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.copyWith(
            titleLarge: TextStyle(
              color: mainTextColor.resolve(context),
              fontSize: 20,
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: mainTextColor.resolve(context),
          fontSize: 20,
        ),
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        border: InputBorder.none,
      ),
      appBarTheme: AppBarTheme(color: NeumorphicTheme.baseColor(context)),
      primaryColor: NeumorphicTheme.baseColor(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: query.isNotEmpty ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        child: IconButton(
          icon: Icon(Icons.clear, color: mainTextColor.resolve(context)),
          onPressed: () => query = '',
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: mainTextColor.resolve(context)),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryUpdate?.call(query);

    final cleanQuery = query.toLowerCase().trim();

    final List<T> result = items
        .where(
          (item) =>
              filter(item).map((value) => value?.toLowerCase().trim()).any(
            (value) {
              if (itemStartsWith == true && itemEndsWith == true) {
                return value == cleanQuery;
              } else if (itemStartsWith == true) {
                return value?.startsWith(cleanQuery) == true;
              } else if (itemEndsWith == true) {
                return value?.endsWith(cleanQuery) == true;
              } else {
                return value?.contains(cleanQuery) == true;
              }
            },
          ),
        )
        .toList();

    return Theme(
      data: Theme.of(context),
      child: cleanQuery.isEmpty && !showItemsOnEmpty
          ? suggestion
          : result.isEmpty
              ? failure
              : ListView(children: result.map(builder).toList()),
    );
  }
}
