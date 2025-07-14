class SummaryDashboard {
  final int sumRevenue;
  final List<SummaryData> dashboardSummary;

  SummaryDashboard({required this.sumRevenue, required this.dashboardSummary});
  factory SummaryDashboard.fromJson(Map<String, dynamic> json) {
    final summaryList = (json['dashboardSummary'] as List<dynamic>)
        .map((e) => SummaryData.fromJson(e as Map<String, dynamic>))
        .toList();

    return SummaryDashboard(
      sumRevenue: (json['sumRevenue'] as num).toInt(),
      dashboardSummary: summaryList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sumRevenue': sumRevenue,
      'dashboardSummary': dashboardSummary
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class SummaryData {
  final String lotteryDateId;
  final double bankTransactionCost;
  final double revenue;
  final int type;
  final double bankWinCost;
  final double lotteryTransactionCost;
  final double specialReward;
  final double promotionCost;
  final double pointCost;
  final double quota;
  final String id;
  final double maxQuota;

  SummaryData({
    required this.lotteryDateId,
    required this.bankTransactionCost,
    required this.revenue,
    required this.type,
    required this.bankWinCost,
    required this.lotteryTransactionCost,
    required this.specialReward,
    required this.promotionCost,
    required this.pointCost,
    required this.quota,
    required this.id,
    required this.maxQuota,
  });
  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      lotteryDateId: json["lottery_date_id"],
      bankTransactionCost: (json['bank_transaction_cost'] as num).toDouble(),
      revenue: (json["revenue"] as num).toDouble(),
      type: json["type"],
      bankWinCost: (json["bank_win_cost"] as num).toDouble(),
      lotteryTransactionCost: (json["lottery_transaction_cost"] as num).toDouble(),
      specialReward: (json["special_reward"] as num).toDouble(),
      promotionCost: (json["promotion_cost"] as num).toDouble(),
      pointCost: (json["point_cost"] as num).toDouble(),
      quota: (json["quota"] as num).toDouble(),
      id: json[r'$id'] as String,
      maxQuota: (json["maxQuota"] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "lottery_date_id": lotteryDateId,
      "bank_transaction_cost": bankTransactionCost,
      "revenue": revenue,
      "type": type,
      "bank_win_cost": bankWinCost,
      "lottery_transaction_cost": lotteryTransactionCost,
      "special_reward": specialReward,
      "promotion_cost": promotionCost,
      "point_cost": pointCost,
      "quota": quota,
      r"$id": id,
      "maxQuota": maxQuota,
    };
  }
}
