class HistoryData {
  Map<String, dynamic> cases;
  Map<String, dynamic> recovered;
  Map<String, dynamic> deaths;

  HistoryData(
    this.cases,
    this.recovered,
    this.deaths,
  );

  HistoryData.fromJson(Map<String, dynamic> json) {
    cases = json['cases'];
    deaths = json['deaths'];
    recovered = json['recovered'];
  }
}
