class WalletConnectionObj {
  bool? _connected;
  List<String>? _accounts;
  int? _chainId;
  String? _bridge;
  String? _key;
  String? _clientId;
  ClientMeta? _clientMeta;
  String? _peerId;
  PeerMeta? _peerMeta;
  int? _handshakeId;
  String? _handshakeTopic;

  WalletConnectionObj(
      {bool? connected,
        List<String>? accounts,
        int? chainId,
        String? bridge,
        String? key,
        String? clientId,
        ClientMeta? clientMeta,
        String? peerId,
        PeerMeta? peerMeta,
        int? handshakeId,
        String? handshakeTopic}) {
    if (connected != null) {
      this._connected = connected;
    }
    if (accounts != null) {
      this._accounts = accounts;
    }
    if (chainId != null) {
      this._chainId = chainId;
    }
    if (bridge != null) {
      this._bridge = bridge;
    }
    if (key != null) {
      this._key = key;
    }
    if (clientId != null) {
      this._clientId = clientId;
    }
    if (clientMeta != null) {
      this._clientMeta = clientMeta;
    }
    if (peerId != null) {
      this._peerId = peerId;
    }
    if (peerMeta != null) {
      this._peerMeta = peerMeta;
    }
    if (handshakeId != null) {
      this._handshakeId = handshakeId;
    }
    if (handshakeTopic != null) {
      this._handshakeTopic = handshakeTopic;
    }
  }

  bool? get connected => _connected;
  set connected(bool? connected) => _connected = connected;
  List<String>? get accounts => _accounts;
  set accounts(List<String>? accounts) => _accounts = accounts;
  int? get chainId => _chainId;
  set chainId(int? chainId) => _chainId = chainId;
  String? get bridge => _bridge;
  set bridge(String? bridge) => _bridge = bridge;
  String? get key => _key;
  set key(String? key) => _key = key;
  String? get clientId => _clientId;
  set clientId(String? clientId) => _clientId = clientId;
  ClientMeta? get clientMeta => _clientMeta;
  set clientMeta(ClientMeta? clientMeta) => _clientMeta = clientMeta;
  String? get peerId => _peerId;
  set peerId(String? peerId) => _peerId = peerId;
  PeerMeta? get peerMeta => _peerMeta;
  set peerMeta(PeerMeta? peerMeta) => _peerMeta = peerMeta;
  int? get handshakeId => _handshakeId;
  set handshakeId(int? handshakeId) => _handshakeId = handshakeId;
  String? get handshakeTopic => _handshakeTopic;
  set handshakeTopic(String? handshakeTopic) =>
      _handshakeTopic = handshakeTopic;

  WalletConnectionObj.fromJson(Map<String, dynamic> json) {
    _connected = json['connected'];
    _accounts = json['accounts'].cast<String>();
    _chainId = json['chainId'];
    _bridge = json['bridge'];
    _key = json['key'];
    _clientId = json['clientId'];
    _clientMeta = json['clientMeta'] != null
        ? new ClientMeta.fromJson(json['clientMeta'])
        : null;
    _peerId = json['peerId'];
    _peerMeta = json['peerMeta'] != null
        ? new PeerMeta.fromJson(json['peerMeta'])
        : null;
    _handshakeId = json['handshakeId'];
    _handshakeTopic = json['handshakeTopic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connected'] = this._connected;
    data['accounts'] = this._accounts;
    data['chainId'] = this._chainId;
    data['bridge'] = this._bridge;
    data['key'] = this._key;
    data['clientId'] = this._clientId;
    if (this._clientMeta != null) {
      data['clientMeta'] = this._clientMeta!.toJson();
    }
    data['peerId'] = this._peerId;
    if (this._peerMeta != null) {
      data['peerMeta'] = this._peerMeta!.toJson();
    }
    data['handshakeId'] = this._handshakeId;
    data['handshakeTopic'] = this._handshakeTopic;
    return data;
  }
}

class ClientMeta {
  String? _description;
  String? _url;
  List<String>? _icons;
  String? _name;

  ClientMeta(
      {String? description, String? url, List<String>? icons, String? name}) {
    if (description != null) {
      this._description = description;
    }
    if (url != null) {
      this._url = url;
    }
    if (icons != null) {
      this._icons = icons;
    }
    if (name != null) {
      this._name = name;
    }
  }

  String? get description => _description;
  set description(String? description) => _description = description;
  String? get url => _url;
  set url(String? url) => _url = url;
  List<String>? get icons => _icons;
  set icons(List<String>? icons) => _icons = icons;
  String? get name => _name;
  set name(String? name) => _name = name;

  ClientMeta.fromJson(Map<String, dynamic> json) {
    _description = json['description'];
    _url = json['url'];
    _icons = json['icons'].cast<String>();
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this._description;
    data['url'] = this._url;
    data['icons'] = this._icons;
    data['name'] = this._name;
    return data;
  }
}

class PeerMeta {
  String? _description;
  String? _url;
  List<String>? _icons;
  String? _name;
  bool? _ssl;

  PeerMeta(
      {String? description,
        String? url,
        List<String>? icons,
        String? name,
        bool? ssl}) {
    if (description != null) {
      this._description = description;
    }
    if (url != null) {
      this._url = url;
    }
    if (icons != null) {
      this._icons = icons;
    }
    if (name != null) {
      this._name = name;
    }
    if (ssl != null) {
      this._ssl = ssl;
    }
  }

  String? get description => _description;
  set description(String? description) => _description = description;
  String? get url => _url;
  set url(String? url) => _url = url;
  List<String>? get icons => _icons;
  set icons(List<String>? icons) => _icons = icons;
  String? get name => _name;
  set name(String? name) => _name = name;
  bool? get ssl => _ssl;
  set ssl(bool? ssl) => _ssl = ssl;

  PeerMeta.fromJson(Map<String, dynamic> json) {
    _description = json['description'];
    _url = json['url'];
    _icons = json['icons'].cast<String>();
    _name = json['name'];
    _ssl = json['ssl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this._description;
    data['url'] = this._url;
    data['icons'] = this._icons;
    data['name'] = this._name;
    data['ssl'] = this._ssl;
    return data;
  }
}
