import '../../../../core/custom_barrel.dart' show UserFailure;

class ValidatorSignup {
  static UserFailure? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return UserFailure("L'email est requis");
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return UserFailure("Email invalide");
    }
    return null;
  }

  static UserFailure? validatorUsername(String? value) {
    if (value == null || value.isEmpty) {
      return UserFailure("Un username est requis");
    }
    if (value.contains(' ')) {
      return UserFailure("Les espaces ne sont pas autorisés");
    }
    return null;
  }

  static UserFailure errorMP = UserFailure(
    "Le mot de passe doit contenir :\n"
    "- Au moins 8 caractères,\n"
    "- Au moins une majuscule,\n"
    "- Au moins une minuscule,\n"
    "- Au moins un chiffre,\n"
    "- Au moins un caractère spécial (!@#\$%^&*(),.?\":{}|<>).",
  );

  static UserFailure? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return UserFailure("Un mot de passe est requis");
    }
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );

    if (!regex.hasMatch(value)) return errorMP;

    return null;
  }

  static UserFailure? validatorConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (password != confirmPassword) {
      return UserFailure("mot de passe de confirmation incorrect");
    }
    return null;
  }
}
