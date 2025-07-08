class DigitSummary {
  final DigitQuota digitQuota;
  final List<Accumulate> topAccumulate;
  final List<Accumulate> bottomAccumulate;
  final List<Accumulate> notBuyAccumulate;
  final List<Accumulate> fullQuota;
  final DashboardSummary dashboardSummary;

  const DigitSummary({
    required this.digitQuota,
    required this.topAccumulate,
    required this.bottomAccumulate,
    required this.notBuyAccumulate,
    required this.fullQuota,
    required this.dashboardSummary,
  }); 

  factory DigitSummary.fromJson(Map<String, dynamic> json) {
    return DigitSummary(
      digitQuota: DigitQuota.fromJson(json['digitQuota']),
      topAccumulate: (json['topAccumulate'] as List)
          .map((item) => Accumulate.fromJson(item))
          .toList(),
      bottomAccumulate: (json['bottomAccumulate'] as List)
          .map((item) => Accumulate.fromJson(item))
          .toList(),
      notBuyAccumulate: (json['notBuyAccumulate'] as List)
          .map((item) => Accumulate.fromJson(item))
          .toList(),
      fullQuota: (json['fullQuota'] as List)
          .map((item) => Accumulate.fromJson(item))
          .toList(),
      dashboardSummary: json['dashboardSummary'] != null
          ? DashboardSummary.fromJson(json['dashboardSummary'])
          : DashboardSummary(
              id: '',
              lotteryDateId: '',
              revenue: 0,
              type: 0,
              bankWinCost: 0,
              lotteryTsCost: 0,
              pointCost: 0,
              quota: 0,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'digit_quota': digitQuota.toJson(),
      'top_accumulate': topAccumulate.map((item) => item.toJson()).toList(),
      'bottom_accumulate': bottomAccumulate
          .map((item) => item.toJson())
          .toList(),
      'not_buy_accumulate': notBuyAccumulate
          .map((item) => item.toJson())
          .toList(),
      'full_quota': fullQuota.map((item) => item.toJson()).toList(),
      'dashboard_summary': dashboardSummary.toJson(),
    };
  }
}

class DigitQuota {
  final int amount;
  final int type;
  final String id; // corresponds to $id

  const DigitQuota({
    required this.amount,
    required this.type,
    required this.id,
  });

  factory DigitQuota.fromJson(Map<String, dynamic> json) {
    return DigitQuota(
      amount: (json['amount'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      id: json[r'$id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'type': type, r'$id': id};
  }
}

class Accumulate {
  final String lottery;
  final int amount;
  final int quotaAmount;
  final int lotteryType;
  final String id; // corresponds to $id

  const Accumulate({
    required this.lottery,
    required this.amount,
    required this.quotaAmount,
    required this.lotteryType,
    required this.id,
  });

  factory Accumulate.fromJson(Map<String, dynamic> json) {
    return Accumulate(
      lottery: json['lottery'] as String,
      amount: (json['amount'] as num).toInt(),
      quotaAmount: (json['quotaAmount'] as num).toInt(),
      lotteryType: (json['lotteryType'] as num).toInt(),
      id: json[r'$id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lottery': lottery,
      'amount': amount,
      'quotaAmount': quotaAmount,
      'lotteryType': lotteryType,
      r'$id': id,
    };
  }
}

class DashboardSummary {
  final String id; // corresponds to $id
  final String lotteryDateId;
  final int revenue;
  final int type;
  final int bankWinCost;
  final int lotteryTsCost;
  final int pointCost;
  final int quota;

  const DashboardSummary({
    required this.id,
    required this.lotteryDateId,
    required this.revenue,
    required this.type,
    required this.bankWinCost,
    required this.lotteryTsCost,
    required this.pointCost,
    required this.quota,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      id: json[r'$id'] as String,
      lotteryDateId: json['lottery_date_id'] as String,
      revenue: (json['revenue'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      bankWinCost: (json['bank_win_cost'] as num).toInt(),
      lotteryTsCost: (json['lottery_transaction_cost'] as num).toInt(),
      pointCost: (json['point_cost'] as num).toInt(),
      quota: (json['quota'] as num).toInt(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      r'$id': id,
      'lottery_date_id': lotteryDateId,
      'revenue': revenue,
      'type': type,
      'bank_win_cost': bankWinCost,
      'lottery_transaction_cost': lotteryTsCost,
      'point_cost': pointCost,
      'quota': quota,
    };
  }
}
