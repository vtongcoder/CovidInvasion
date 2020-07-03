class DisplayDataModel {
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

  //NOTE Only country model has these:
  String country;
  String flagUrl;

  DisplayDataModel({
    this.updatedAt = 0,
    this.cases = 0,
    this.deaths = 0,
    this.recovered = 0,
    this.todayCases = 0,
    this.todayDeaths = 0,
    this.active = 0,
    this.critical = 0,
    this.tests = 0,
    this.casesPerOneMillion = 0,
    this.deathsPerOneMillion = 0,
    this.testsPerOneMillion = 0,
    this.affectedCountries = 0,
    this.country = '',
    this.flagUrl = '',
  });
}
