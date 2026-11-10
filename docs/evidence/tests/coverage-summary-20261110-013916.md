<!-- Sinh bởi: dart run tool/coverage_summary.dart từ coverage-20261110-013916.lcov.info (flutter test --coverage trong quality-checks-20261110-013916.log). Số dòng hit/tổng là số thật từ lcov; % làm tròn 2 chữ số chỉ để đọc nhanh. lcov không liệt kê 11 file chỉ có interface/enum (không có dòng thực thi) và không gồm integration test. -->

| File | Dòng hit / tổng | % |
|---|---|---|
| lib/core/config/app_config.dart | 0 / 9 | 0.00% |
| lib/core/di/providers.dart | 34 / 58 | 58.62% |
| lib/data/datasources/local/app_database.dart | 8 / 62 | 12.90% |
| lib/data/datasources/local/app_database.g.dart | 515 / 1713 | 30.06% |
| lib/data/datasources/local/protocol_local_datasource.dart | 61 / 61 | 100.00% |
| lib/data/datasources/local/seed_loader.dart | 82 / 82 | 100.00% |
| lib/data/datasources/remote/supabase_remote_sync_source.dart | 0 / 33 | 0.00% |
| lib/data/models/remote_protocol_mapper.dart | 24 / 24 | 100.00% |
| lib/data/models/seed_parser.dart | 85 / 91 | 93.41% |
| lib/data/repositories/drift_emergency_repository.dart | 6 / 7 | 85.71% |
| lib/data/repositories/drift_protocol_repository.dart | 5 / 5 | 100.00% |
| lib/data/repositories/drift_protocol_sync_store.dart | 45 / 45 | 100.00% |
| lib/data/repositories/drift_sync_queue_repository.dart | 52 / 52 | 100.00% |
| lib/data/repositories/http_ai_router_repository.dart | 96 / 99 | 96.97% |
| lib/data/repositories/shared_prefs_settings_repository.dart | 13 / 13 | 100.00% |
| lib/data/services/connectivity_plus_service.dart | 0 / 8 | 0.00% |
| lib/data/services/flutter_tts_service.dart | 0 / 10 | 0.00% |
| lib/data/services/geolocator_location_service.dart | 1 / 22 | 4.55% |
| lib/data/services/url_launcher_dialer_service.dart | 1 / 3 | 33.33% |
| lib/data/services/url_launcher_sms_composer.dart | 4 / 6 | 66.67% |
| lib/domain/entities/ai_route.dart | 9 / 11 | 81.82% |
| lib/domain/entities/app_settings.dart | 6 / 6 | 100.00% |
| lib/domain/entities/cited_text.dart | 1 / 1 | 100.00% |
| lib/domain/entities/emergency_case.dart | 1 / 1 | 100.00% |
| lib/domain/entities/first_aid_protocol.dart | 2 / 2 | 100.00% |
| lib/domain/entities/protocol_step.dart | 1 / 1 | 100.00% |
| lib/domain/entities/sos_message.dart | 2 / 2 | 100.00% |
| lib/domain/entities/source_citation.dart | 3 / 3 | 100.00% |
| lib/domain/entities/sync_job.dart | 1 / 1 | 100.00% |
| lib/domain/entities/triage_node.dart | 2 / 2 | 100.00% |
| lib/domain/services/location_service.dart | 3 / 3 | 100.00% |
| lib/domain/services/remote_sync_source.dart | 4 / 6 | 66.67% |
| lib/domain/usecases/advance_triage.dart | 5 / 5 | 100.00% |
| lib/domain/usecases/detect_emergency_keywords.dart | 23 / 24 | 95.83% |
| lib/domain/usecases/enqueue_sos_log.dart | 9 / 9 | 100.00% |
| lib/domain/usecases/get_current_location_for_sos.dart | 3 / 3 | 100.00% |
| lib/domain/usecases/get_offline_protocols.dart | 2 / 2 | 100.00% |
| lib/domain/usecases/get_protocol_by_code.dart | 3 / 3 | 100.00% |
| lib/domain/usecases/prepare_sos_message.dart | 20 / 20 | 100.00% |
| lib/domain/usecases/process_sync_queue.dart | 25 / 25 | 100.00% |
| lib/domain/usecases/route_situation.dart | 78 / 81 | 96.30% |
| lib/domain/usecases/run_sync.dart | 13 / 13 | 100.00% |
| lib/domain/usecases/search_protocols.dart | 20 / 20 | 100.00% |
| lib/domain/usecases/start_emergency_flow.dart | 6 / 6 | 100.00% |
| lib/domain/usecases/sync_protocols.dart | 20 / 20 | 100.00% |
| lib/domain/utils/version_compare.dart | 10 / 10 | 100.00% |
| lib/main.dart | 21 / 38 | 55.26% |
| lib/presentation/providers/protocol_providers.dart | 11 / 13 | 84.62% |
| lib/presentation/providers/settings_provider.dart | 19 / 20 | 95.00% |
| lib/presentation/router/app_router.dart | 19 / 20 | 95.00% |
| lib/presentation/screens/describe_situation_screen.dart | 205 / 206 | 99.51% |
| lib/presentation/screens/home_screen.dart | 31 / 34 | 91.18% |
| lib/presentation/screens/protocol_detail_screen.dart | 108 / 109 | 99.08% |
| lib/presentation/screens/protocol_list_screen.dart | 32 / 35 | 91.43% |
| lib/presentation/screens/settings_screen.dart | 27 / 27 | 100.00% |
| lib/presentation/screens/sos_screen.dart | 115 / 119 | 96.64% |
| lib/presentation/screens/triage_screen.dart | 55 / 58 | 94.83% |
| lib/presentation/theme/app_text_scaler.dart | 11 / 13 | 84.62% |
| lib/presentation/theme/app_theme.dart | 6 / 7 | 85.71% |
| lib/presentation/widgets/call_115_button.dart | 12 / 13 | 92.31% |
| lib/presentation/widgets/clinical_warning_banner.dart | 15 / 15 | 100.00% |
| lib/presentation/widgets/network_chip.dart | 7 / 7 | 100.00% |
| lib/presentation/widgets/sos_button.dart | 12 / 12 | 100.00% |

| Lớp | Dòng hit / tổng | % |
|---|---|---|
| core | 34 / 67 | 50.75% |
| data | 998 / 2336 | 42.72% |
| domain | 272 / 280 | 97.14% |
| khác | 21 / 38 | 55.26% |
| presentation | 685 / 708 | 96.75% |

TỔNG: 2010 / 3429 dòng (58.62%), 63 file trong lcov.info
TỔNG KHÔNG TÍNH *.g.dart: 1495 / 1716 dòng (87.12%), 62 file
