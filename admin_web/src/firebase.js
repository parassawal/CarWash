import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// Extracted from google-services.json
const firebaseConfig = {
    apiKey: "AIzaSyCwKStjgK_kMq2U49ElZ-hzAGrf5VIHpoI",
    authDomain: "carwash-374e8.firebaseapp.com",
    projectId: "carwash-374e8",
    storageBucket: "carwash-374e8.firebasestorage.app",
    messagingSenderId: "527356236873",
    appId: "1:527356236873:web:9b23f378450690d8e59b98" // Using the generic app ID prefix mapped to web
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
