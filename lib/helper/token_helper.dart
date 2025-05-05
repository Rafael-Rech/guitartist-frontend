import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcc/helper/lesson_helper.dart';
import 'package:tcc/helper/user_helper.dart';

class TokenHelper {
  static final TokenHelper _instance = TokenHelper.internal();
  factory TokenHelper() => _instance;
  TokenHelper.internal();
  Database? _db;

  static const String accessToken = "accessToken";
  static const String accessTokenTable = "accessTokenTable";

  static const String refreshTokenTable = "refreshTokenTable";
  static const String refreshToken = "refreshToken";

  static const String databaseName = "guitartistDb";

  Future<Database> get db async {
    _db ??= await initdb();
    return _db!;
  }

  Future<Database> initdb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "$databaseName.db");

    // await deleteDatabase(path);
    // print("Deletando database local");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $accessTokenTable($accessToken VARCHAR(512) PRIMARY KEY);");
      await db.execute(
          "CREATE TABLE $refreshTokenTable($refreshToken VARCHAR(512) PRIMARY KEY);");
      await db.execute("CREATE TABLE ${UserHelper.userTable}(${UserHelper.id} VARCHAR(512) PRIMARY KEY, ${UserHelper.appVersion} INTEGER, ${UserHelper.email} VARCHAR(64), ${UserHelper.name} VARCHAR(64), ${UserHelper.password} VARCHAR(64), ${UserHelper.time} VARCHAR(32), ${UserHelper.noteRepresentation} INTEGER, ${UserHelper.profilePicture} VARCHAR(1500000));");
      await db.execute("CREATE TABLE ${LessonHelper.lessonTable}(${LessonHelper.id} INTEGER PRIMARY KEY, ${LessonHelper.averagePrecision} INTEGER, ${LessonHelper.numberOfTries} INTEGER, ${LessonHelper.proficiency} INTEGER, ${LessonHelper.subject} INTEGER, ${LessonHelper.type} INTEGER, userId INTEGER REFERENCES ${UserHelper.userTable}(${UserHelper.id}) ON DELETE CASCADE);");
    });
  }

  Future<String> getToken() async {
    Database dbToken = await db;
    List<Map> listMap =
        await dbToken.rawQuery("SELECT * FROM $accessTokenTable");
    print("listMap: $listMap, ${listMap.runtimeType}");
    // if (listMap.isNotEmpty) {
    //   return .fromMap(maps.first);
    // }
    // return null;
    if (listMap.isNotEmpty && listMap[0].containsKey(accessToken)) {
      return listMap[0][accessToken];
    }
    return "";
  }

  Future<String> saveToken(String tokenString) async {
    Database dbToken = await db;
    await deleteToken();
    await dbToken.insert(accessTokenTable, {accessToken: tokenString});
    return tokenString;
  }

  // Future<String> updateToken(String tokenString) async {
  //   Database dbToken = await db;
  //   deleteToken();
  //   await dbToken.insert(tokenTable, {accessToken: tokenString});
  //   return tokenString;
  // }

  Future<void> deleteToken() async {
    Database dbToken = await db;
    await dbToken.delete(accessTokenTable);
  }
}
