String generateDefaultUsername(String email, String providedUsername) {
  return providedUsername.isEmpty ? email.split('@')[0] : providedUsername;
}
