class GlobalInfo {
  int updatedAt;
  int cases;
  int deaths;
  int recovered;
  int todayCases;
  int todayDeaths;
  int active;
  int critical;
  int tests;
  int casesPerOneMillion;
  int deathsPerOneMillion;
  int testsPerOneMillion;

  //NOTE only global model has this:
  int affectedCountries;

  GlobalInfo({
    this.updatedAt,
    this.cases,
    this.deaths,
    this.recovered,
    this.todayCases,
    this.todayDeaths,
    this.active,
    this.critical,
    this.tests,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.testsPerOneMillion,
    this.affectedCountries,
  });

  GlobalInfo.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated'];
    cases = json['cases'];
    deaths = json['deaths'];
    recovered = json['recovered'];
    todayCases = json['todayCases'];
    todayDeaths = json['todayDeaths'];
    active = json['active'];
    critical = json['critical'];
    tests = json['tests'];

    final _casesPerOneMillion = json['casesPerOneMillion'];
    final _deathsPerOneMillion = json['deathsPerOneMillion'];
    final _testsPerOneMillion = json['testsPerOneMillion'];
    casesPerOneMillion = _casesPerOneMillion.toInt();
    deathsPerOneMillion = _deathsPerOneMillion.toInt();
    testsPerOneMillion = _testsPerOneMillion.toInt();

    affectedCountries = json['affectedCountries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cases'] = this.cases;
    data['deaths'] = this.deaths;
    data['recovered'] = this.recovered;
    return data;
  }
}
