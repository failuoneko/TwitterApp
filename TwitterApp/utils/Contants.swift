//
//  Contants.swift
//  TwitterApp
//
//  Created by L on 2021/10/5.
//

import Firebase

let DATABASE_REF = Database.database().reference()
let REF_USERS = DATABASE_REF.child("users")
let REF_TWEETS = DATABASE_REF.child("tweets")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")


//let FIRESTORE_COLLECTION_MESSAGES = Firestore.firestore().collection("message")
//let FIRESTORE_COLLECTION_USERS = Firestore.firestore().collection("users")
