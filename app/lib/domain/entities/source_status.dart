/// Trạng thái nguồn y khoa (thống nhất toàn dự án, xem CLAUDE.md §6).
enum SourceVerification { verified, unverified }

enum ClinicalReview { reviewed, notClinicallyReviewed }

enum ReusePermission { permitted, permissionPending, unknown }
