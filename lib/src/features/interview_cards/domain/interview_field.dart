enum InterviewField {
  softwareEngineering,
  productManagement,
}

extension InterviewFieldX on InterviewField {
  String get label {
    switch (this) {
      case InterviewField.softwareEngineering:
        return 'Software Engineering';
      case InterviewField.productManagement:
        return 'Product Management';
    }
  }
}
