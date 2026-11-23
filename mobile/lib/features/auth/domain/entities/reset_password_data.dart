class ResetPasswordData {
  const ResetPasswordData({
    required this.resetToken,
    required this.newPassword,
  });

  final String resetToken;
  final String newPassword;
}