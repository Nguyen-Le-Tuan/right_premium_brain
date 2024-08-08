import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static String uid = "";
  static String deckid = "";

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference deckCollection =
      FirebaseFirestore.instance.collection('decks');

  final CollectionReference cardCollection =
      FirebaseFirestore.instance.collection('cards');

  DatabaseService() {
    final User? user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
    print(uid);
  }

  // DatabaseService(this.uid);

  Future addUserData(String uid) async {
    DatabaseService.uid = uid;

    return await userCollection.add({
      "uid": uid,
      "avgScore": [
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
      ]
    });
  }

  Future getUid(String uid) async {
    DatabaseService.uid = uid;
    print(DatabaseService.uid);
  }

  Future addCard(String deckId, String front, String back) async {
    return await cardCollection.add({
      "deckid": deckId,
      "front": front,
      "back": back,
      "score": 2,
    });
  }

  Future addDeck(String deckname, String desc, String tag) async {
    final docRef = await deckCollection
        .add({"uid": uid, "deckname": deckname, "desc": desc, "tag": tag});

    deckid = docRef.id;
    return deckid;
  }

  Future<void> deleteAccount() async {
    try {
      String? docRef;
      String? deckRef;

      // Get the user document reference
      QuerySnapshot userSnapshot = await userCollection.where("uid", isEqualTo: uid).get();
      if (userSnapshot.docs.isNotEmpty) {
        docRef = userSnapshot.docs.first.id;
      }

      // Get the deck document references and delete associated cards
      QuerySnapshot deckSnapshot = await deckCollection.where("uid", isEqualTo: uid).get();
      for (var deckDoc in deckSnapshot.docs) {
        deckRef = deckDoc.id;

        // Delete all cards associated with the deck
        QuerySnapshot cardSnapshot = await cardCollection.where("deckid", isEqualTo: deckRef).get();
        for (var cardDoc in cardSnapshot.docs) {
          await cardCollection.doc(cardDoc.id).delete();
        }

        // Delete the deck
        await deckCollection.doc(deckRef).delete();
      }

      // Delete the user document
      if (docRef != null) {
        await userCollection.doc(docRef).delete();
      }

      print("deleted");
    } catch (error) {
      print(error);
    }
  }


  Future deleteDeck(String deckid) async {
    String deckRef;
    await deckCollection.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if (doc.id == deckid) {
              deckRef = doc.id;

              cardCollection
                  .where("deckid", isEqualTo: deckRef)
                  .get()
                  .then((QuerySnapshot querySnapshot) => {
                        querySnapshot.docs.forEach((doc) {
                          cardCollection.doc(doc.id).delete();
                        })
                      });

              deckCollection.doc(deckRef).delete();
            }
          })
        });
    return;
  }

  //deck list from snapshot
  // List<Deck> _deckListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Deck(
  //       deckname: doc.data()['deckname'] ?? '',
  //       desc: doc.data()['desc'] ?? '',
  //       tag: doc.data()['tag'] ?? '',
  //       deckid: doc.id ?? '',
  //     );
  //   }).toList();
  // }

  // Stream<List<Deck>> get decks {
  //   return deckCollection
  //       .where("uid", isEqualTo: uid)
  //       .snapshots()
  //       .map(_deckListFromSnapshot);
  // }

  Future<List<Map<String, dynamic>>> getCardDetails(String deckid) async  {
    List<Map<String, dynamic>> allCards = [];
    await cardCollection
        .where("deckid", isEqualTo: deckid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          Map<String, dynamic> card = {
            "front": data['front'],
            "back": data['back'],
            "score": data['score'],
            "cardId": doc.id,
          };
          allCards.add(card);
        }
      }
    });

    return allCards;
  }


  Future<List<Map<String, dynamic>>> getDecks() async {
    List<Map<String, dynamic>> allDecks = [];
    await deckCollection
        .where("uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          Map<String, String> deck = {
            "deckname": data['deckname'] ?? '',
            "desc": data['desc'] ?? '',
            "tag": data['tag'] ?? '',
            "deckid": doc.id
          };
          allDecks.add(deck);
        }
      }
    });
    return allDecks;
  }


  Future<Map<String, dynamic>?> getDeckDetails(String deckid) async {
    Map<String, dynamic>? deckDetails;

    await deckCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.id == deckid) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            deckDetails = {
              "deckname": data['deckname'] ?? '',
              "desc": data['desc'] ?? '',
              "tag": data['tag'] ?? '',
              "deckid": doc.id
            };
          }
        }
      }
    });

    return deckDetails;
  }


  Future<String> editDeck(
      String deckname, String desc, String tag, String docid) async {
    await deckCollection
        .doc(docid)
        .update({"uid": uid, "deckname": deckname, "desc": desc, "tag": tag})
        .then((value) {})
        .catchError((onError) {
          print(onError);
          return "error";
        });
    return "Successful";
  }

  Future<String> editCard(
      String front, String back, String docid, String deckid) async {
    await cardCollection
        .doc(docid)
        .update({"front": front, "back": back, "deckid": deckid})
        .then((value) {})
        .catchError((onError) {
          print(onError);
          return "error";
        });
    return "Successful";
  }

  Future<String> updateScore(String cardId, score) async {
    await cardCollection
        .doc(cardId)
        .update({"score": score})
        .then((value) {})
        .catchError((onError) {
          print(onError);
        });
    return "Successsful";
  }

  Future<String> deleteOneCard(String cardId) async {
    await cardCollection
        .doc(cardId)
        .delete()
        .then((value) {})
        .catchError((onError) {
      print(onError);
      return "error";
    });
    return "Successful";
  }

  Future<List> getTotalCount() async {
    String deckRef;
    List count = [0, 0];

    await deckCollection
        .where("uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                deckRef = doc.id;
                count[0] += 1; // total deck

                await cardCollection
                    .where("deckid", isEqualTo: deckRef)
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((doc) {
                            count[1] += 1; // total cards
                          })
                        });
              })
            });

    return count;
  }
  Future<List<int>> getLevelCount() async {
    List<int> count = [0, 0, 0, 0];
    List<String> deckList = [];

    try {
      QuerySnapshot deckSnapshot = await deckCollection
          .where("uid", isEqualTo: uid)
          .get();

      for (var doc in deckSnapshot.docs) {
        deckList.add(doc.id);
      }

      for (String deckId in deckList) {
        QuerySnapshot cardSnapshot = await cardCollection
            .where("deckid", isEqualTo: deckId)
            .get();

        for (var doc in cardSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            int score = data['score'] ?? 0;
            if (score == 4) {
              count[0] += 1; // easy
            } else if (score == 3) {
              count[1] += 1; // moderate
            } else if (score == 2) {
              count[2] += 1; // hard
            } else {
              count[3] += 1; // insane
            }
          }
        }
      }
    } catch (error) {
      print(error);
    }

    return count;
  }


  Future<List<dynamic>?> getAvgScore() async {
    List<dynamic>? avg;
    try {
      QuerySnapshot querySnapshot = await userCollection
          .where("uid", isEqualTo: uid)
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          print(data["avgScore"]);
          avg = data["avgScore"] as List<dynamic>?;
        }
      }
    } catch (onError) {
      print(onError);
    }
    return avg;
  }


  void addAverageScore() async {
    double avg = 0;
    int sum = 0;
    int counter = 0;

    List<String> deckList = [];

    try {
      QuerySnapshot deckSnapshot = await deckCollection.where("uid", isEqualTo: uid).get();
      for (var doc in deckSnapshot.docs) {
        deckList.add(doc.id);
      }

      for (String deckId in deckList) {
        QuerySnapshot cardSnapshot = await cardCollection.where("deckid", isEqualTo: deckId).get();
        for (var doc in cardSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('score')) {
            sum += data['score'] as int;
            counter += 1;
          }
        }
      }

      if (counter > 0) {
        avg = sum / counter;
      } else {
        avg = 0; // handle the case where counter is zero to avoid division by zero
      }
      print(avg);

      String? docRef;
      List<dynamic>? avgscore;

      QuerySnapshot userSnapshot = await userCollection.where("uid", isEqualTo: uid).get();
      for (var doc in userSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('avgScore')) {
          docRef = doc.id;
          avgscore = List.from(data['avgScore']);
          if (avgscore.isNotEmpty) {
            avgscore.removeAt(0);
          }
          avgscore.add(avg);
          print(avgscore);
        }
      }

      if (docRef != null && avgscore != null) {
        await userCollection.doc(docRef).update({"avgScore": avgscore});
      } else {
        print("No document reference or average score found");
      }
    } catch (error) {
      print(error);
    }
  }


  Future<String> resetDeck(String deckid) async {
    await cardCollection
        .where("deckid", isEqualTo: deckid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.id);
        await cardCollection
            .doc(doc.id)
            .update({"score": 2}).then((value) => {});
      });
    });
    return "Successful";
  }

  Future<String> resetStats() async {
    List deckList = [];

    await deckCollection
        .where("uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        deckList.add(doc.id);
      });
    }).catchError((error) => {print(error)});

    print(deckList);

    for (int i = 0; i < deckList.length; i++) {
      await cardCollection
          .where("deckid", isEqualTo: deckList[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          print(doc.id);
          await cardCollection
              .doc(doc.id)
              .update({"score": 2}).then((value) => {});
        });
      });
    }
    return "Successful";
  }
}
