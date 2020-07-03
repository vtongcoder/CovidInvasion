class Country {
  int updatedAt;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  int casesPerOneMillion;
  int deathsPerOneMillion;
  int tests;
  int testsPerOneMillion;

  //NOTE Only country model has these:
  String country;
  String flagUrl;

  Country({
    this.updatedAt,
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.active,
    this.critical,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.tests,
    this.testsPerOneMillion,
    this.country,
    this.flagUrl,
  });

  Country.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated'];
    cases = json['cases'];
    todayCases = json['todayCases'];
    deaths = json['deaths'];
    todayDeaths = json['todayDeaths'];
    recovered = json['recovered'];
    active = json['active'];
    critical = json['critical'];
    tests = json['tests'];

    final _casesPerOneMillion = json['casesPerOneMillion'];
    final _deathsPerOneMillion = json['deathsPerOneMillion'];
    final _testsPerOneMillion = json['testsPerOneMillion'];
    casesPerOneMillion = _casesPerOneMillion.toInt();
    deathsPerOneMillion = _deathsPerOneMillion.toInt();
    testsPerOneMillion = _testsPerOneMillion.toInt();

    country = json['country'];
    flagUrl = json['countryInfo']['flag'];
  }

  Country.fromJsonGetNameAndFlag(Map<String, dynamic> json) {
    country = json['country'];
    flagUrl = json['countryInfo']['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['recovered'] = this.recovered;
    data['active'] = this.active;
    data['critical'] = this.critical;
    data['casesPerOneMillion'] = this.casesPerOneMillion;
    data['deathsPerOneMillion'] = this.deathsPerOneMillion;
    data['totalTests'] = this.tests;
    data['testsPerOneMillion'] = this.testsPerOneMillion;
    return data;
  }
}
