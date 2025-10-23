class UserSession {
  // Fields must be non-nullable or explicitly marked as nullable (?)
  // I've assumed they are nullable unless otherwise constrained.
  final String? user_table;
  final int? role_id;

  // 1. Added semicolon (;) at the end of the constructor
  UserSession({
    this.user_table,
    this.role_id,
  }); // <--- FIX 1: Semicolon added

factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      // Ensure keys match what you save in toJson()
      user_table: json['user_table'] as String?,
      role_id: json['role_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user_session = <String, dynamic>{};
    user_session["user_table"] = user_table;
    user_session["role_id"] = role_id;


    return user_session; // <--- FIX 2: Added return statement
  }
}