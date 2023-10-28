// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { GoogleAuthProvider, getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDf2JqazknI4BA2LNOhK6mmznqtQqvFW5Y",
  authDomain: "iiit-delhi-events.firebaseapp.com",
  projectId: "iiit-delhi-events",
  storageBucket: "iiit-delhi-events.appspot.com",
  messagingSenderId: "510033588693",
  appId: "1:510033588693:web:83fcc54b40159290f4cd5c",
  measurementId: "G-PCHB8FCTQG"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const googleAuthProvider = new GoogleAuthProvider();