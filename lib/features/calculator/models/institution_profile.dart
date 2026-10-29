/// Institutional Profile and Metadata Model
class InstitutionProfile {
  String name;
  String address;
  String contact;
  String email;
  double campusAreaAcres;
  double builtUpAreaSqm;
  int totalPopulation;
  int studentsCount;
  int facultyStaffCount;
  double latitude;
  double longitude;
  double elevation;
  String website;
  String googleMapsUrl;

  // File paths for attachments
  String? logoPath;
  String? logoFileName;
  String? collegePhotoPath;
  String? photoFileName;
  String? layoutPlanPath;
  String? layoutFileName;

  InstitutionProfile({
    this.name = 'Institute of Environmental Technology',
    this.address = 'Knowledge Campus, Science Park Road, Sector 4',
    this.contact = '+91 98765 43210',
    this.email = 'sustainability@iet-campus.edu',
    this.campusAreaAcres = 45.0,
    this.builtUpAreaSqm = 28900.0,
    this.totalPopulation = 3500,
    this.studentsCount = 3000,
    this.facultyStaffCount = 500,
    this.latitude = 18.5204,
    this.longitude = 73.8567,
    this.elevation = 560.0,
    this.website = 'https://iet-campus.edu',
    this.googleMapsUrl = 'https://maps.google.com/?q=18.5204,73.8567',
    this.logoPath,
    this.logoFileName,
    this.collegePhotoPath,
    this.photoFileName,
    this.layoutPlanPath,
    this.layoutFileName,
  });

  InstitutionProfile copyWith({
    String? name,
    String? address,
    String? contact,
    String? email,
    double? campusAreaAcres,
    double? builtUpAreaSqm,
    int? totalPopulation,
    int? studentsCount,
    int? facultyStaffCount,
    double? latitude,
    double? longitude,
    double? elevation,
    String? website,
    String? googleMapsUrl,
    String? logoPath,
    String? logoFileName,
    String? collegePhotoPath,
    String? photoFileName,
    String? layoutPlanPath,
    String? layoutFileName,
  }) {
    return InstitutionProfile(
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      campusAreaAcres: campusAreaAcres ?? this.campusAreaAcres,
      builtUpAreaSqm: builtUpAreaSqm ?? this.builtUpAreaSqm,
      totalPopulation: totalPopulation ?? this.totalPopulation,
      studentsCount: studentsCount ?? this.studentsCount,
      facultyStaffCount: facultyStaffCount ?? this.facultyStaffCount,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      elevation: elevation ?? this.elevation,
      website: website ?? this.website,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      logoPath: logoPath ?? this.logoPath,
      logoFileName: logoFileName ?? this.logoFileName,
      collegePhotoPath: collegePhotoPath ?? this.collegePhotoPath,
      photoFileName: photoFileName ?? this.photoFileName,
      layoutPlanPath: layoutPlanPath ?? this.layoutPlanPath,
      layoutFileName: layoutFileName ?? this.layoutFileName,
    );
  }
}
