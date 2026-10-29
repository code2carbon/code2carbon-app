# CarbonTrack Mobile Application — Project Progress Tracker

This file tracks the status, test results, known issues, and remaining work for every feature in the `mobile_app/` Flutter application.

**Status Legend:**
- ⏳ `Pending`: Not started yet
- 🏗️ `In Progress`: Implementation in progress
- 🔍 `Under Verification`: Implementation done, undergoing tests/analysis
- ✅ `Completed & Approved`: Implementation and verification complete and approved

---

## Feature Progress Table

| Feature ID | Feature Name | Status | Files Changed | Tests Performed | Known Issues |
|---|---|---|---|---|---|
| **Phase 0** | Project Setup & Design System | ✅ Completed & Verified | `pubspec.yaml`, `IMPLEMENTATION_PLAN.md`, `PROJECT_PROGRESS.md`, `lib/app/theme/*`, `lib/core/constants/*`, `lib/shared/models/*`, `lib/main.dart`, `test/widget_test.dart` | `flutter pub get`, `flutter analyze` (0 issues), `flutter test` (2/2 tests passed) | None |
| **Phase 1** | Home & Landing Screen | ✅ Completed & Verified | `lib/app/main_navigation_shell.dart`, `lib/features/home/screens/home_screen.dart`, `lib/features/home/widgets/*`, `lib/shared/widgets/custom_app_bar.dart`, `lib/app/app.dart` | `flutter analyze` (0 issues), `flutter test` (2/2 tests passed) | None |
| **Phase 2** | Net-Zero Decarbonization Planner | ✅ Completed & Verified | `lib/features/planner/models/*`, `lib/features/planner/screens/*`, `lib/features/planner/widgets/*`, `lib/app/main_navigation_shell.dart` | `flutter analyze` (0 issues), `flutter test` (2/2 tests passed) | None |
| **Phase 3** | Dashboard Analytics & Trends | ✅ Completed & Verified | `lib/features/dashboard/models/*`, `lib/features/dashboard/widgets/*`, `lib/features/dashboard/screens/*`, `lib/app/main_navigation_shell.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (3/3 tests passed) | None |
| **Phase 4** | Authentication & ESG Audit Simulator | ✅ Completed & Verified | `lib/features/auth/services/*`, `lib/features/auth/widgets/*`, `lib/features/dashboard/screens/dashboard_screen.dart`, `lib/app/main_navigation_shell.dart` | `flutter analyze` (0 issues), `flutter test` (3/3 tests passed) | None |
| **Phase 5** | Institution Profile & Multi-File Attachments | ✅ Completed & Verified | `lib/features/calculator/models/institution_profile.dart`, `lib/features/calculator/widgets/institution_profile_card.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (4/4 tests passed) | None |
| **Phase 6** | Scope 1 & 3 Vehicle Emissions Ledger | ✅ Completed & Verified | `lib/features/calculator/models/ledger_models.dart`, `lib/features/calculator/widgets/vehicle_ledger_widget.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (5/5 tests passed) | None |
| **Phase 7** | Scope 2 Electricity & Energy Ledger | ✅ Completed & Verified | `lib/features/calculator/models/ledger_models.dart`, `lib/features/calculator/widgets/energy_ledger_widget.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (6/6 tests passed) | None |
| **Phase 8** | Scope 1 Generators & LPG Dining Ledger | ✅ Completed & Verified | `lib/features/calculator/widgets/generator_ledger_widget.dart`, `lib/features/calculator/widgets/lpg_ledger_widget.dart`, `lib/features/calculator/services/calculator_engine.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (7/7 tests passed) | None |
| **Phase 9** | Scope 3 Paper & Headcount Dynamic Sync | ✅ Completed & Verified | `lib/features/calculator/widgets/paper_ledger_widget.dart`, `lib/features/calculator/models/ledger_models.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (8/8 tests passed) | None |
| **Phase 10** | Clean Offsets: Solar PV, Trees & Waste | ✅ Completed & Verified | `lib/features/calculator/widgets/solar_offset_widget.dart`, `lib/features/calculator/widgets/tree_offset_widget.dart`, `lib/features/calculator/widgets/waste_offset_widget.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (9/9 tests passed) | None |
| **Phase 11** | Final Tab, Net Footprint & Analytics | ✅ Completed & Verified | `lib/features/calculator/widgets/final_summary_tab.dart`, `lib/features/calculator/widgets/docked_summary_bar.dart`, `lib/features/calculator/screens/calculator_screen.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (10/10 tests passed) | None |
| **Phase 12** | Cloud Sync & Supabase Edge Function AI | ✅ Completed & Verified | `lib/features/calculator/widgets/final_summary_tab.dart` (Supabase sync simulation + Gemini AI insights integrated into Final Tab) | `flutter analyze` (0 issues), `flutter test` (10/10 tests passed) | Supabase write is simulated; real write requires valid credentials in Supabase project |
| **Phase 13** | Accredited Multi-Page PDF Report Generator | ✅ Completed & Verified | `lib/features/reports/services/pdf_report_generator.dart`, `lib/features/reports/screens/pdf_preview_screen.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (11/11 tests passed) | None |
| **Phase 14** | EcoBot Sustainability Assistant | ✅ Completed & Verified | `lib/features/chatbot/widgets/ecobot_chat_drawer.dart`, `lib/shared/widgets/custom_app_bar.dart`, `lib/app/main_navigation_shell.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (15/15 tests passed) | None |
| **Phase 15** | Website-to-Flutter Deep Audit & Parity Verification | ✅ Completed & Verified | `lib/features/calculator/services/calculator_engine.dart`, `lib/features/dashboard/widgets/esg_audit_simulator_sheet.dart`, `lib/features/dashboard/screens/dashboard_screen.dart`, `lib/app/main_navigation_shell.dart`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (13/13 passed) | None |
| **Phase 16** | Interactive Branded Splash Screen | ✅ Completed & Verified | `lib/features/splash/screens/splash_screen.dart`, `lib/app/app.dart`, `pubspec.yaml`, `test/widget_test.dart` | `flutter analyze` (0 issues), `flutter test` (15/15 passed) | None |

---

## Log of Completed Changes & Verification Runs

### Run 1 — Phase 0: Project Initialization
- Initialized clean Flutter application in `mobile_app/` (`code2carbon`).
- Created `IMPLEMENTATION_PLAN.md` and `PROJECT_PROGRESS.md`.
- Added production dependencies: `google_fonts`, `supabase_flutter`, `fl_chart`, `file_picker`, `image_picker`, `share_plus`, `path_provider`, `pdf`, `printing`, `shared_preferences`, `intl`, `url_launcher`.

### Run 2 — Phase 8–14: All Calculator & Output Features Verified
- Reviewed and verified all ledger widgets: `generator_ledger_widget.dart`, `lpg_ledger_widget.dart`, `paper_ledger_widget.dart`, `solar_offset_widget.dart`, `tree_offset_widget.dart`, `waste_offset_widget.dart`, `final_summary_tab.dart`, `docked_summary_bar.dart`.
- Reviewed `pdf_report_generator.dart`, `pdf_preview_screen.dart`, `ecobot_chat_drawer.dart`.
- Added comprehensive unit tests for Phases 9–14 to `test/widget_test.dart`.
- `flutter analyze` → ✅ 0 issues
- `flutter test` → ✅ 12/12 tests passed

### Run 3 — Deep Website-to-Flutter Source Audit & Parity Corrections
- **Audit Findings & Fixes**:
  1. **ESG Audit Simulator**: Extracted into a dedicated reusable widget `EsgAuditSimulatorSheet` matching website `carbontrack/script.js` (lines 446–489). Integrated sector peer benchmarks (Tech Office 35.0t, University 120.0t, Manufacturing 450.0t, Retail 25.0t), dynamic variance calculations, and 5 sequential verification steps.
  2. **Navigation Flow**: Wired `EsgAuditSimulatorSheet` directly into the Main App Drawer so clicking "ESG Audit Simulator" immediately launches the verification modal instead of a placeholder snackbar.
  3. **Comprehensive CSV Ledger Export**: Expanded `generateCsvReport()` in `calculator_engine.dart` to export all 8 emission and offset tables (Vehicles, Energy, Generators, LPG, Paper & Headcount baseline, Solar PV, Native Trees, Waste Recycling) plus Per-Capita and Spatial Intensity metrics.
  4. **Verification**: Added Phase 15 automated test in `test/widget_test.dart`.
  5. **Code Quality**: `flutter analyze` → ✅ **0 issues found**; `flutter test` → ✅ **13/13 tests passed**.

