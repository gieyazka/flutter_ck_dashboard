import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // แสดง stack trace กี่ชั้น
    errorMethodCount: 5, // แสดง stack trace เมื่อ error
    lineLength: 80, // ความยาวบรรทัดก่อน wrap
    colors: true, // เปิดสีใน console
  ),
);

void logInfo(String msg) => logger.i(msg);
void logDebug(String msg) => logger.d(msg);
void logTrace(String msg) => logger.t(msg);
void logWarning(String msg) => logger.w(msg);
void logError(String msg, [dynamic err, StackTrace? st]) =>
    logger.e(msg, error: err, stackTrace: st);
