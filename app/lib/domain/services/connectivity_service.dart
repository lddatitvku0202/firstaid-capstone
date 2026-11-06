/// Chỉ phản ánh thiết bị có kết nối mạng hay không, KHÔNG đảm bảo có Internet.
abstract interface class ConnectivityService {
  Future<bool> isConnected();
  Stream<bool> get onChanged;
}
