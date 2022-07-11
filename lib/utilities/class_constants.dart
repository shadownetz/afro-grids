class AccessLevel{
  static const user = 'USER';
  static const provider = 'PROVIDER';
  static const admin = 'ADMIN';
}

class AuthType{
  static const email = 'EMAIL';
  static const phone = 'PHONE';
  static const google = 'GOOGLE';
  static const facebook = 'FACEBOOK';
}

class ServiceType{
  static const single = 'SINGLE';
  static const multiple = 'MULTIPLE';
}

class AccessStatus{
  static const pending = 'PENDING';
  static const approved = 'APPROVED';
  static const suspended = 'SUSPENDED';
  static const deactivated = 'DEACTIVATED';
}

class OrderStatus{
  static const pending = 'PENDING';
  static const approved = 'APPROVED';
  static const declined = 'DECLINED';
}

class MessageType{
  static const text = 'TEXT';
  static const image = 'IMAGE';
}

class Currency{
  static const ngn = 'NGN';
}