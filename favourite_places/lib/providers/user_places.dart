import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favourite_places/models/place.dart';

Future<Database> getDatabase() async {
  // Get the default path for database
  final dbPath = await sql.getDatabasesPath();

  // Opening the database
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)",
      );
    },
    version: 1,
  );

  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query("user_places");
    final places = data.map(
      (item) => Place(
        id: item['id'] as String,
        title: item['title'] as String,
        image: File(item['image'] as String),
        location: PlaceLocation(
            latitude: item['lat'] as double,
            longitude: item['lng'] as double,
            address: item['address'] as String),
      ),
    ).toList();

    state = places;
  }

  void removePlace(Place place) async {
    final db = await getDatabase();
    final response = await db.delete("user_places", where: 'id = ?', whereArgs: [place.id]);

    state = state.where((el)=> el.id != place.id ).toList();

    print(response);
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    // gives the path of the directory where we can store user-generated data
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // generate a name for the image
    final imageName = path.basename(image.path);

    // Copying the image into the appDir
    final copiedImage = await image.copy('${appDir.path}/$imageName');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    // Storing All the data on the local device
    final db = await getDatabase();
    db.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "lat": newPlace.location.latitude,
      "lng": newPlace.location.longitude,
      "address": newPlace.location.address
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
