class Tcases {
  var cases;
  var todayCases;
  var deaths;
  var todayDeaths;

  Tcases({this.cases, this.todayCases, this.deaths, this.todayDeaths});

  factory Tcases.fromJson(final json) => Tcases(
      cases: json["cases"],
      deaths: json["deaths"],
      todayCases: json["todayCases"]);
}
