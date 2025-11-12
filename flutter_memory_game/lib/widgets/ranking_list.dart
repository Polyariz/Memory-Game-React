import 'package:flutter/material.dart';
import '../models/ranking_item.dart';
import '../services/supabase_service.dart';

/// Список рейтинга (аналог Ranking.jsx)
class RankingList extends StatefulWidget {
  const RankingList({super.key});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  List<RankingItem> _ranking = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  Future<void> _loadRanking() async {
    setState(() {
      _isLoading = true;
    });

    final ranking = await SupabaseService.getRanking();

    setState(() {
      _ranking = ranking;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF7FBFFF),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(maxHeight: 185),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7FBFFF),
              ),
            )
          : _ranking.isEmpty
              ? const Center(
                  child: Text(
                    'Рейтинг пуст',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.separated(
                  itemCount: _ranking.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFF7FBFFF),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = _ranking[index];
                    return RankingItemWidget(
                      position: index + 1,
                      name: item.name,
                      score: item.score,
                    );
                  },
                ),
    );
  }
}

/// Элемент рейтинга (аналог Item.jsx)
class RankingItemWidget extends StatelessWidget {
  final int position;
  final String name;
  final int score;

  const RankingItemWidget({
    super.key,
    required this.position,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$position:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            '$score Pts',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
