# CarbonTrack Mobile Application — Implementation Plan

This document outlines the detailed roadmap for developing the Flutter mobile application in `mobile_app/`, reproducing the design, functionality, user flows, and calculation accuracy of the local `carbontrack` web platform.

---

## 1. Architecture & Design Principles

- **Framework**: Flutter (Channel Stable 3.47.0+, Dart 3.13.0+)
- **Folder Convention**: Feature-based architecture (`features/<feature_name>/screens`, `widgets`, `models`, `services`)
- **Backend Services**: Supabase Edge Function (`generate-insights`) + Supabase Database table (`emissions_submissions`)
- **Theme & Design**:
  - Primary: Emerald Green `#10B981` (Accents: `#064E3B`, `#F0FDF4`)
  - Secondary: Sky Blue `#3B82F6` (Accents: `#2980B9`, `#EFF6FF`)
  - Dark/Background: Slate `#0F172A` / Mint `#F8FAFC`
  - Typography: Google Fonts `Sora` (Headings) & `Outfit` (Body/Forms)
  - Responsive Mobile Adaptations: Replace wide multi-column HTML tables with touch-friendly ledger cards and bottom sheets.
- **Code Philosophy**: Clean, simple, readable Dart without convoluted overengineering. Small composable widgets, comprehensive input validation, offline-first fallback calculation engine.

---

## 2. Feature Implementation Sequence

### Phase 0: Project Foundation & Design System
- Setup `pubspec.yaml` with core dependencies (`google_fonts`, `supabase_flutter`, `fl_chart`, `pdf`, `printing`, `image_picker`, `file_picker`, `share_plus`, `path_provider`, `shared_preferences`, `intl`, `url_launcher`).
- Establish `AppColors`, `AppTypography`, `AppTheme` matching `carbontrack/styles.css`.
- Define calculation coefficients in `core/constants/emission_factors.dart`.
- Setup `PROJECT_PROGRESS.md`.

### Phase 1: Home & Landing Screen
- App shell with custom top navigation / drawer.
- Hero Banner with pulse indicators, eco-badges (ISO 14064-1, GHG Protocol, Scope 1·2·3, CO₂e Reporting).
- Standards Grid (4 accreditation cards).
- Understanding Emissions (3 core pillars).
- Interactive 4-step Methodology Timeline with dynamic details update.
- Platform capabilities (6 feature cards) & Governance overview.

### Phase 2: Net-Zero Transition Planner
- 5 mitigation initiatives checkboxes with CapEx, payback, and reduction percentages.
- Interactive 10-year trajectory forecast chart (BAU vs Decarbonization vs Net-Zero benchmark).
- Live KPI counter animations.

### Phase 3: Dashboard Analytics & Rolling Trends
- Scope 1, 2, and 3 summary cards with YoY indicators.
- Interactive emissions-by-scope donut chart.
- Rolling 12-month monthly emissions trend curve with touch tooltips.

### Phase 4: Authentication & ESG Audit Simulator
- Login form (Email & Password with validation, Remember Me, Google Sign-in simulation).
- Interactive ESG Audit Simulator modal with animated 5-step progress, benchmark ranking, and verification ledger display.

### Phase 5: Institution Details & Multi-File Attachments
- Form fields: Name, Address, Contact (+91 validation), Email, Campus Area, Built-up Area, Population, Students, Faculty, Lat/Lng coordinates, Elevation, Website, Google Maps link.
- Multi-file attachment system (Logo, College Photo, Layout Plan) with preview, delete, and thumbnail display.

### Phase 6: Scope 1 & 3 Vehicle Emissions Ledger
- Vehicle Type (Car, Bus, Van, Bike, Truck, Auto Rickshaw), Fuel Type (Petrol, Diesel, CNG, Electric), Ownership (Institute-owned vs Staff/Student/Other).
- Dynamic Scope 1 vs Scope 3 badge resolution.
- Daily, monthly, and annual emissions calculations.
- CSV and Excel (XLS) export to device storage.

### Phase 7: Scope 2 Electricity & Energy Consumption
- Energy Source selector (Purchased Grid, Coal, Natural Gas, Solar, Wind) with emission factors.
- Monthly consumption in kWh, monthly and annual emission calculations.
- Electricity bill photo/PDF attachment with preview and delete.

### Phase 8: Scope 1 Generators & LPG Dining Ledger
- Diesel Generator consumption ledger with standard emission factors.
- LPG Dining & Mess cylinder tracker with custom location fallback and monthly/annual calculations.
- Generator bill attachment.

### Phase 9: Scope 3 Paper Usage & Headcount Sync
- Dynamic two-way synchronization between institution student headcount and paper consumption.
- Student baseline consumption formula (`Students * 0.75 kg/yr`).
- Departmental administrative paper consumption ledger.

### Phase 10: Clean Offsets: Solar PV, Tree Sinks & Waste Recycling
- Solar rooftop generation and avoided grid emissions.
- 16 native tree species + extended tree database lookup and custom absorption rate.
- 10-material waste recycling & composting offset calculations.

### Phase 11: Final Tab, Net Carbon Footprint & Analytics
- Itemized breakdown cards.
- Net footprint formula: `(Paper + LPG + Electricity + Generator + Vehicles) - (Solar + Trees)`.
- Color-coded Net Footprint hero card (kgCO₂e and tCO₂e).
- Per-capita and spatial emission intensity metrics.
- Persistent docked summary widget.

### Phase 12: Supabase Cloud Sync & AI Insights Integration
- Submission to Supabase database table `emissions_submissions`.
- Edge Function `generate-insights` integration with Google Gemini 1.5 Flash.
- Transparent deterministic analytics engine fallback.

### Phase 13: Accredited Multi-Page PDF Report Generator
- ISO 14064-1 & GHG Protocol accredited format matching reference report.
- Dynamic pagination, Table of Contents, vector donut charts, hotspot bars, recommendations, and verification sign-off.
- In-app preview, printing, and PDF download via system share sheet.

### Phase 14: EcoBot Sustainability Assistant
- Floating Action Button with pulsing ring.
- Slide-out chat drawer with avatar, clear history, and minimize.
- 6 predefined question chips + natural language keyword search.
- Local conversation persistence.

### Phase 15: Final Testing & Release Verification
- Complete feature audit against website checklist.
- `flutter pub get`, `flutter analyze`, and `flutter test`.
- Debug APK build verification (`flutter build apk --debug`).
