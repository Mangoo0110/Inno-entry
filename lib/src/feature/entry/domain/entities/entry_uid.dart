
/// Reason this exist:
/// ### Less file modification, if we later migrate to different data type(int -> string) for uId
class EntryUid {
  final int uId;

  EntryUid({required this.uId});
}