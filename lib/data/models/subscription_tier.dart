enum SubscriptionTier { free, silver, golden }

extension SubscriptionTierX on SubscriptionTier {
  String get label {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.silver:
        return 'Silver';
      case SubscriptionTier.golden:
        return 'Golden';
    }
  }

  String get price {
    switch (this) {
      case SubscriptionTier.free:
        return '₹0 / month';
      case SubscriptionTier.silver:
        return '₹699 / month';
      case SubscriptionTier.golden:
        return '₹1,999 / month';
    }
  }

  int get monthlyImages {
    switch (this) {
      case SubscriptionTier.free:
        return 30;
      case SubscriptionTier.silver:
        return 100;
      case SubscriptionTier.golden:
        return 300;
    }
  }

  int get monthlyVideos {
    switch (this) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.silver:
        return 30;
      case SubscriptionTier.golden:
        return 90;
    }
  }

  int get dailyTexts {
    switch (this) {
      case SubscriptionTier.free:
        return 5;
      case SubscriptionTier.silver:
        return -1; // unlimited
      case SubscriptionTier.golden:
        return -1;
    }
  }
}
