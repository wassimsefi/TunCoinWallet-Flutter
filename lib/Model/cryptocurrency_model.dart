// To parse this JSON data, do
//
//     final cryptocurrencyModel = cryptocurrencyModelFromJson(jsonString);

import 'dart:convert';

CryptocurrencyModel cryptocurrencyModelFromJson(String str) =>
    CryptocurrencyModel.fromJson(json.decode(str));

String cryptocurrencyModelToJson(CryptocurrencyModel data) =>
    json.encode(data.toJson());

class CryptocurrencyModel {
  CryptocurrencyModel({
    this.values,
  });

  List<Value> values;

  factory CryptocurrencyModel.fromJson(Map<String, dynamic> json) =>
      CryptocurrencyModel(
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.id,
    this.currency,
    this.symbol,
    this.name,
    this.logoUrl,
    this.status,
    this.price,
    this.priceDate,
    this.priceTimestamp,
    this.circulatingSupply,
    this.maxSupply,
    this.marketCap,
    this.numExchanges,
    this.numPairs,
    this.numPairsUnmapped,
    this.firstCandle,
    this.firstTrade,
    this.firstOrderBook,
    this.rank,
    this.rankDelta,
    this.high,
    this.highTimestamp,
    this.the1D,
    this.the30D,
  });

  String id;
  String currency;
  String symbol;
  String name;
  String logoUrl;
  String status;
  String price;
  DateTime priceDate;
  DateTime priceTimestamp;
  String circulatingSupply;
  String maxSupply;
  String marketCap;
  String numExchanges;
  String numPairs;
  String numPairsUnmapped;
  DateTime firstCandle;
  DateTime firstTrade;
  DateTime firstOrderBook;
  String rank;
  String rankDelta;
  String high;
  DateTime highTimestamp;
  The1D the1D;
  The1D the30D;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
        currency: json["currency"],
        symbol: json["symbol"],
        name: json["name"],
        logoUrl: json["logo_url"],
        status: json["status"],
        price: json["price"],
        priceDate: DateTime.parse(json["price_date"]),
        priceTimestamp: DateTime.parse(json["price_timestamp"]),
        circulatingSupply: json["circulating_supply"],
        maxSupply: json["max_supply"] == null ? null : json["max_supply"],
        marketCap: json["market_cap"],
        numExchanges: json["num_exchanges"],
        numPairs: json["num_pairs"],
        numPairsUnmapped: json["num_pairs_unmapped"],
        firstCandle: DateTime.parse(json["first_candle"]),
        firstTrade: DateTime.parse(json["first_trade"]),
        firstOrderBook: DateTime.parse(json["first_order_book"]),
        rank: json["rank"],
        rankDelta: json["rank_delta"],
        high: json["high"],
        highTimestamp: DateTime.parse(json["high_timestamp"]),
        the1D: The1D.fromJson(json["1d"]),
        the30D: The1D.fromJson(json["30d"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency": currency,
        "symbol": symbol,
        "name": name,
        "logo_url": logoUrl,
        "status": status,
        "price": price,
        "price_date": priceDate.toIso8601String(),
        "price_timestamp": priceTimestamp.toIso8601String(),
        "circulating_supply": circulatingSupply,
        "max_supply": maxSupply == null ? null : maxSupply,
        "market_cap": marketCap,
        "num_exchanges": numExchanges,
        "num_pairs": numPairs,
        "num_pairs_unmapped": numPairsUnmapped,
        "first_candle": firstCandle.toIso8601String(),
        "first_trade": firstTrade.toIso8601String(),
        "first_order_book": firstOrderBook.toIso8601String(),
        "rank": rank,
        "rank_delta": rankDelta,
        "high": high,
        "high_timestamp": highTimestamp.toIso8601String(),
        "1d": the1D.toJson(),
        "30d": the30D.toJson(),
      };
}

class The1D {
  The1D({
    this.volume,
    this.priceChange,
    this.priceChangePct,
    this.volumeChange,
    this.volumeChangePct,
    this.marketCapChange,
    this.marketCapChangePct,
  });

  String volume;
  String priceChange;
  String priceChangePct;
  String volumeChange;
  String volumeChangePct;
  String marketCapChange;
  String marketCapChangePct;

  factory The1D.fromJson(Map<String, dynamic> json) => The1D(
        volume: json["volume"],
        priceChange: json["price_change"],
        priceChangePct: json["price_change_pct"],
        volumeChange: json["volume_change"],
        volumeChangePct: json["volume_change_pct"],
        marketCapChange: json["market_cap_change"],
        marketCapChangePct: json["market_cap_change_pct"],
      );

  Map<String, dynamic> toJson() => {
        "volume": volume,
        "price_change": priceChange,
        "price_change_pct": priceChangePct,
        "volume_change": volumeChange,
        "volume_change_pct": volumeChangePct,
        "market_cap_change": marketCapChange,
        "market_cap_change_pct": marketCapChangePct,
      };
}
