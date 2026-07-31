enum FriendshipStatus { none, requestSent, requestReceived, friends, rejected, self }

extension FriendshipStatusX on FriendshipStatus {
  static FriendshipStatus fromApi(String value) {
    switch (value) {
      case 'requestSent':
        return FriendshipStatus.requestSent;
      case 'requestReceived':
        return FriendshipStatus.requestReceived;
      case 'friends':
        return FriendshipStatus.friends;
      case 'rejected':
        return FriendshipStatus.rejected;
      case 'self':
        return FriendshipStatus.self;
      default:
        return FriendshipStatus.none;
    }
  }
}