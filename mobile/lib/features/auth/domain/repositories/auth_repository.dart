abstract interface class AuthRepository {
  Future<bool> hasSession();


  Future<void> logOut();
}