class Vpn {

  late final String hostname;
  late final String ip;
  late final int score;
  late final String ping;
  late final int speed;
  late final String countryLong;
  late final String countryShort;
  late final int numVpnSessions;
  late final String openVPNConfigDataBase64;

  Vpn({
    required this.hostname,
    required this.ip,
    required this.score,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.openVPNConfigDataBase64,
  });

  Vpn.fromJson(Map<String, dynamic> json){
    hostname = json['HostName'] ?? '';
    ip = json['IP'] ?? '';
    score = json['Score'] ?? 0;
    ping = json['Ping'].toString();
    speed = json['Speed'] ?? 0;
    countryLong = json['CountryLong'] ?? '';
    countryShort = json['CountryShort'] ?? '';
    numVpnSessions = json['NumVpnSessions'] ?? 0;
    openVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['HostName'] = hostname;
    _data['IP'] = ip;
    _data['Score'] = score;
    _data['Ping'] = ping;
    _data['Speed'] = speed;
    _data['CountryLong'] = countryLong;
    _data['CountryShort'] = countryShort;
    _data['NumVpnSessions'] = numVpnSessions;

    _data['OpenVPN_ConfigData_Base64'] = openVPNConfigDataBase64;
    return _data;
  }
}