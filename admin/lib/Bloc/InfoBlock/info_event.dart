abstract class InfoEvent {}

class GetTermsAndConditionsData implements InfoEvent {}

class GetAboutUsData implements InfoEvent {}

class GetContactUsData implements InfoEvent {}

class InfoEditEvent implements InfoEvent {}

class InitInfoUploadEvent implements InfoEvent {}

class UploadTermsAndConditionsEvent implements InfoEvent {
  List termsAndConditions;
  UploadTermsAndConditionsEvent({required this.termsAndConditions});
}

class UploadAboutUsEvent implements InfoEvent {
  List aboutUs;
  UploadAboutUsEvent({required this.aboutUs});
}

class UploadContactUsEvent implements InfoEvent {
  List contactUs;
  UploadContactUsEvent({required this.contactUs});
}
