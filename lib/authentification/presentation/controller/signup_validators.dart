class ValidatorSignup {
  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) return "L'email est requis";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Email invalide";
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return "Ce champ est requis";
    if (value.contains(' ')) return "Les espaces ne sont pas autorisés";
    return null;
  }

  String errorMP =
      "Le mot de passe doit contenir :\n"
      "- Au moins 8 caractères,\n"
      "- Au moins une majuscule,\n"
      "- Au moins une minuscule,\n"
      "- Au moins un chiffre,\n"
      "- Au moins un caractère spécial (!@#\$%^&*(),.?\":{}|<>).";

  String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) return "Un mot de passe est requis";
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );

    if (!regex.hasMatch(value)) return errorMP;

    return null;
  }

  String? validatorConfirmPassword(String? password, String confirmPassword) {
    if (password != confirmPassword) {
      return "mot de passe de confirmation incorrect";
    }
    return null;
  }
}
