class C {
  static const baseUrl = 'http://coa.attr.in/coa-app/public/api/v1';

  //APIs
  static const loginOtp = '/members/otp/generation';
  static const loginWithOtp = '/members/otp/authentication';
  static const dashboard = '/members/dashboard';
  static const updateProfilePhoto = '/members/update/profile-photo';
  static const shareDetails = '/members/share/details';
  static const familyMembers = '/members/familymembers';
  static const unlinkShare = '/members/unlink/share';
  static const searchShare = '/members/search/unlinked';
  static const linkShare = '/members/link/share';
  static const relations = '/relations';
  static const sliders = '/members/sliders';

  //Other

  static const bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
}
