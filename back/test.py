import pyrebase

config = {
  "apiKey": "AIzaSyDYDsId2B8_J6G5Pr7qn7gN6RGbuZ-2_r4",
  "authDomain": "starthack-cedf4.firebaseapp.com",
  "databaseURL": "https://starthack-cedf4-default-rtdb.firebaseio.com",
  "projectId": "starthack-cedf4",
  "storageBucket": "starthack-cedf4.appspot.com",
  "messagingSenderId": "274912792343",
  "appId": "1:274912792343:web:41b7867a7f4f95f7a3b152",
  "measurementId": "G-LW7WLYJ3F4"
}

configlocal = {
  "apiKey": "AIzaSyDYDsId2B8_J6G5Pr7qn7gN6RGbuZ-2_r4",
  "authDomain": "starthack-cedf4.firebaseapp.com",
  "databaseURL": "http://starthack-cedf4-default-rtdb.localhost:9000",
  "projectId": "starthack-cedf4",
  "storageBucket": "starthack-cedf4.appspot.com",
  "messagingSenderId": "274912792343",
  "appId": "1:274912792343:web:41b7867a7f4f95f7a3b152",
  "measurementId": "G-LW7WLYJ3F4"
}

firebase = pyrebase.initialize_app(configlocal)

db = firebase.database()
# db.useEmulator("localhost", 9000);


import hashlib
import random
id_counter = 0

def dummy_id():
    global id_counter
    id_counter+=1
    m = hashlib.sha256(str(id_counter).encode())
    return m.hexdigest()

def dummy_project():
    return dummy_id(), {
        "level": 0,
        "votes": 5
    }


# data = {"name": "Mortimer 'Morty' Smith"}
# db.child("users").child("Morty").set(data)

projects = [dummy_project() for i in range(2)]

for id_, data in projects:

    db.child("projects").child(id_).set(data)



id_, payload = projects[0]
payload["votes"]=11
db.child("projects").child(id_).set(payload)