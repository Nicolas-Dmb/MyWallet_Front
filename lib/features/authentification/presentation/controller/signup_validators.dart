import '../../../../core/custom_barrel.dart' show UserException;

class ValidatorSignup {
  static UserException? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return UserException("L'email est requis");
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return UserException("Email invalide");
    }
    return null;
  }

  static UserException? validatorUsername(String? value) {
    if (value == null || value.isEmpty) {
      return UserException("Un username est requis");
    }
    if (value.contains(' ')) {
      return UserException("Les espaces ne sont pas autorisés");
    }
    return null;
  }

  static UserException errorMP = UserException(
    "Le mot de passe doit contenir :\n"
    "- Au moins 8 caractères,\n"
    "- Au moins une majuscule,\n"
    "- Au moins une minuscule,\n"
    "- Au moins un chiffre,\n"
    "- Au moins un caractère spécial (!@#\$%^&*(),.?\":{}|<>).",
  );

  static UserException? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return UserException("Un mot de passe est requis");
    }
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );

    if (!regex.hasMatch(value)) return errorMP;

    return null;
  }

  static UserException? validatorConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (password != confirmPassword) {
      return UserException("mot de passe de confirmation incorrect");
    }
    return null;
  }
}
