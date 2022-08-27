class PaymentResponseModel {
  PaymentResponseModel({
    this.id,
    this.txRef,
    this.flwRef,
    this.deviceFingerprint,
    this.amount,
    this.currency,
    this.chargedAmount,
    this.appFee,
    this.merchantFee,
    this.processorResponse,
    this.authModel,
    this.ip,
    this.narration,
    this.status,
    this.paymentType,
    this.createdAt,
    this.accountId,
    this.card,
    this.meta,
    this.amountSettled,
    this.customer,});

  PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    txRef = json['tx_ref'];
    flwRef = json['flw_ref'];
    deviceFingerprint = json['device_fingerprint'];
    amount = json['amount'];
    currency = json['currency'];
    chargedAmount = json['charged_amount'];
    appFee = json['app_fee'];
    merchantFee = json['merchant_fee'];
    processorResponse = json['processor_response'];
    authModel = json['auth_model'];
    ip = json['ip'];
    narration = json['narration'];
    status = json['status'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    accountId = json['account_id'];
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    amountSettled = json['amount_settled'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  @override
  String toString() {
    return 'PaymentResponseModel{id: $id, txRef: $txRef, flwRef: $flwRef, deviceFingerprint: $deviceFingerprint, amount: $amount, currency: $currency, chargedAmount: $chargedAmount, appFee: $appFee, merchantFee: $merchantFee, processorResponse: $processorResponse, authModel: $authModel, ip: $ip, narration: $narration, status: $status, paymentType: $paymentType, createdAt: $createdAt, accountId: $accountId, card: $card, meta: $meta, amountSettled: $amountSettled, customer: $customer}';
  }

  int? id;
  String? txRef;
  String? flwRef;
  String? deviceFingerprint;
  num? amount;
  String? currency;
  num? chargedAmount;
  num? appFee;
  num? merchantFee;
  String? processorResponse;
  String? authModel;
  String? ip;
  String? narration;
  String? status;
  String? paymentType;
  String? createdAt;
  int? accountId;
  Card? card;
  Meta? meta;
  num? amountSettled;
  Customer? customer;
  PaymentResponseModel copyWith({  int? id,
    String? txRef,
    String? flwRef,
    String? deviceFingerprint,
    num? amount,
    String? currency,
    num? chargedAmount,
    num? appFee,
    num? merchantFee,
    String? processorResponse,
    String? authModel,
    String? ip,
    String? narration,
    String? status,
    String? paymentType,
    String? createdAt,
    int? accountId,
    Card? card,
    Meta? meta,
    num? amountSettled,
    Customer? customer,
  }) => PaymentResponseModel(  id: id ?? this.id,
    txRef: txRef ?? this.txRef,
    flwRef: flwRef ?? this.flwRef,
    deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    chargedAmount: chargedAmount ?? this.chargedAmount,
    appFee: appFee ?? this.appFee,
    merchantFee: merchantFee ?? this.merchantFee,
    processorResponse: processorResponse ?? this.processorResponse,
    authModel: authModel ?? this.authModel,
    ip: ip ?? this.ip,
    narration: narration ?? this.narration,
    status: status ?? this.status,
    paymentType: paymentType ?? this.paymentType,
    createdAt: createdAt ?? this.createdAt,
    accountId: accountId ?? this.accountId,
    card: card ?? this.card,
    meta: meta ?? this.meta,
    amountSettled: amountSettled ?? this.amountSettled,
    customer: customer ?? this.customer,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['tx_ref'] = txRef;
    map['flw_ref'] = flwRef;
    map['device_fingerprint'] = deviceFingerprint;
    map['amount'] = amount;
    map['currency'] = currency;
    map['charged_amount'] = chargedAmount;
    map['app_fee'] = appFee;
    map['merchant_fee'] = merchantFee;
    map['processor_response'] = processorResponse;
    map['auth_model'] = authModel;
    map['ip'] = ip;
    map['narration'] = narration;
    map['status'] = status;
    map['payment_type'] = paymentType;
    map['created_at'] = createdAt;
    map['account_id'] = accountId;
    if (card != null) {
      map['card'] = card?.toJson();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    map['amount_settled'] = amountSettled;
    if (customer != null) {
      map['customer'] = customer?.toJson();
    }
    return map;
  }

}

/// id : 1584738
/// name : "John Doe"
/// phone_number : "09065123456"
/// email : "john@gmail.com"
/// created_at : "2022-04-11T11:35:38.000Z"

class Customer {
  Customer({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.createdAt,});

  Customer.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    createdAt = json['created_at'];
  }
  int? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? createdAt;
  Customer copyWith({  int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? createdAt,
  }) => Customer(  id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone_number'] = phoneNumber;
    map['email'] = email;
    map['created_at'] = createdAt;
    return map;
  }

}

/// __CheckoutInitAddress : "https://ravemodal-dev.herokuapp.com/v3/hosted/pay"

class Meta {
  Meta({
    this.checkoutInitAddress,});

  Meta.fromJson(dynamic json) {
    checkoutInitAddress = json['__CheckoutInitAddress'];
  }
  String? checkoutInitAddress;
  Meta copyWith({  String? checkoutInitAddress,
  }) => Meta(  checkoutInitAddress: checkoutInitAddress ?? this.checkoutInitAddress,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['__CheckoutInitAddress'] = checkoutInitAddress;
    return map;
  }

}

/// first_6digits : "553188"
/// last_4digits : "2950"
/// issuer : " CREDIT"
/// country : "NIGERIA NG"
/// type : "MASTERCARD"
/// token : "flw-t1nf-6fc7778dc67bdc77b9ed6ecdefb7f6a8-k3n"
/// expiry : "09/32"

class Card {
  Card({
    this.first6digits,
    this.last4digits,
    this.issuer,
    this.country,
    this.type,
    this.token,
    this.expiry,});

  Card.fromJson(dynamic json) {
    first6digits = json['first_6digits'];
    last4digits = json['last_4digits'];
    issuer = json['issuer'];
    country = json['country'];
    type = json['type'];
    token = json['token'];
    expiry = json['expiry'];
  }
  String? first6digits;
  String? last4digits;
  String? issuer;
  String? country;
  String? type;
  String? token;
  String? expiry;
  Card copyWith({  String? first6digits,
    String? last4digits,
    String? issuer,
    String? country,
    String? type,
    String? token,
    String? expiry,
  }) => Card(  first6digits: first6digits ?? this.first6digits,
    last4digits: last4digits ?? this.last4digits,
    issuer: issuer ?? this.issuer,
    country: country ?? this.country,
    type: type ?? this.type,
    token: token ?? this.token,
    expiry: expiry ?? this.expiry,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_6digits'] = first6digits;
    map['last_4digits'] = last4digits;
    map['issuer'] = issuer;
    map['country'] = country;
    map['type'] = type;
    map['token'] = token;
    map['expiry'] = expiry;
    return map;
  }

}