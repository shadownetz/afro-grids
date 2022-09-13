class AccessLevel{
  static const user = 'USER';
  static const provider = 'PROVIDER';
  static const admin = 'ADMIN';
  static const superAdmin = 'SUPER_ADMIN';
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
  static const accepted = "ACCEPTED";
}

class DeliveryStatus{
  static const completed = 'COMPLETED';
  static const cancelled = 'CANCELLED';
  static const delayed = "DELAYED";
  static const processing = "PROCESSING";
  static const delivering = "DELIVERING";
  static const delivered = "DELIVERED";
}

class ChatType{
  static const text = 'TEXT';
  static const image = 'IMAGE';
  static const serviceRef = "SREF";
}

class Currency{
  static const ngn = 'NGN';
}

class SubscriptionContext {
  static const membership = "MEMBERSHIP";
}

class SubscriptionStatus{
  static const pending = 'PENDING';
  static const approved = 'APPROVED';
  static const declined = 'DECLINED';
}