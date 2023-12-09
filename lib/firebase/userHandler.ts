import { GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import {
  EVENTS_ADMIN_INFORMATION_COLLECTION_NAME,
  EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
  EVENT_ADMIN_ACCESS_TOKEN,
  EVENT_ADMIN_UPDATE_TYPE_NAME,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
  EVENT_SUB_ADMIN_UPDATE_TYPE_NAME,
  EVENT_USER_ADMIN,
  EVENT_USER_SUB_ADMIN,
  GET_EVENT_SUB_ADMIN_TOKEN_OBJECT,
  GOOGLE_LOGIN,
  GOOGLE_SIGNUP,
  extractJWTValues,
} from "../helper";
import { auth, googleAuthProvider } from "./index";

import {
  DocumentData,
  collection,
  doc,
  getDoc,
  getDocs,
  getFirestore,
  orderBy,
  query,
  setDoc,
  updateDoc,
} from "firebase/firestore";
import { db } from ".";

export const fetchLoggedInUserInfo = async (
  isAdmin: boolean = false
): Promise<any> => {
  const response = await fetch("/api/auth/fetchCookieDetails", {
    method: "POST",
    body: JSON.stringify({
      accessTokenType: isAdmin
        ? EVENT_ADMIN_ACCESS_TOKEN
        : EVENT_SUB_ADMIN_ACCESS_TOKEN,
    }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await response.json();
  return data;
};

export const userLogoutHandler = async (router: any) => {
  const response = await fetch("/api/auth/userLogout", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  });
  const data = await response.json();
  if (data.status) {
    router.push({
      pathname: "/login",
    });
  }
};

export const googleAuthentication = async (userType: string) => {
  try {
    const googleResponse = await signInWithPopup(auth, googleAuthProvider);
    const credential = GoogleAuthProvider.credentialFromResult(googleResponse);
    if (!credential) {
      return {
        userCredentials: null,
        error: null,
        message: "Google account not selected!",
      };
    }
    const user = googleResponse.user;
    const userEmail = user.email;

    const userAccessToken = await googleResponse.user.getIdToken();
    const userId = user.uid;
    const userImageUrl = user.photoURL;
    const displayName = user.displayName;

    let authType = "";
    const docRef = doc(
      db,
      EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
      userId
    );
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
      authType = GOOGLE_LOGIN;
    } else {
      authType = GOOGLE_SIGNUP;
    }

    const response = await fetch("/api/auth/userGoogleAuth", {
      method: "POST",
      body: JSON.stringify({
        authType,
        userAccessToken,
        userId,
        userEmail,
        userImageUrl,
        displayName,
        userType,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    });

    const data = await response.json();
    return {
      userCredentials: user,
      error: null,
      message: "",
    };
  } catch (error) {
    console.log("User-Handler-Error");
    return {
      userCredentials: null,
      error,
      message: "Error occoured",
    };
  }
};

export const updateProfileDetailsHandler = async (
  headerValue1: string,
  textValue1: string,
  headerValue2: string,
  textValue2: string,
  headerValue3: string,
  textValue3: string
) => {
  const response = await fetch("/api/userProfile/updateUserDetails", {
    method: "POST",
    body: JSON.stringify({
      // updateType: ADMIN_UPDATE_TYPE_NAME,
      updateType: EVENT_SUB_ADMIN_UPDATE_TYPE_NAME,
      headerValue1: headerValue1,
      textValue1: textValue1,
      headerValue2: headerValue2,
      textValue2: textValue2,
      headerValue3: headerValue3,
      textValue3: textValue3,
    }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await response.json();
  // console.log(data);
  return data;
};

export const createSubAdminUserAccount = async (
  accessToken: string,
  userId: string,
  userEmailId: string,
  userImageUrl = "",
  authType = "email",
  displayName = ""
) => {
  const response = await setDoc(
    doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, userEmailId),
    {
      subAdmin_Id: userId,
      subAdmin_Authorization: true,
      EVENT_SUB_ADMIN_ACCESS_TOKEN: accessToken,
      subAdmin_Auth_Type: authType,
      subAdmin_Display_Name: displayName,
      subAdmin_First_Name: "",
      subAdmin_Middle_Name: "",
      subAdmin_Last_Name: "",
      subAdmin_Gender: "",
      subAdmin_Image_Url: userImageUrl,
      subAdmin_Mobile_Number: "",
      subAdmin_Alternate_Mobile_Number: "",
      subAdmin_Email_Id: userEmailId,
      subAdmin_Events_List: [],
      subAdmin_Clubs_List: [],
    }
  );
};

export const createAdminUserAccount = async (
  accessToken: string,
  userId: string,
  userEmailId: string,
  userImageUrl = "",
  authType = "email",
  displayName = ""
) => {
  const response = await setDoc(
    doc(db, EVENTS_ADMIN_INFORMATION_COLLECTION_NAME, userEmailId),
    {
      admin_Id: userId,
      admin_Authorization: true,
      EVENT_ADMIN_ACCESS_TOKEN: accessToken,
      admin_Auth_Type: authType,
      admin_Display_Name: displayName,
      admin_First_Name: "",
      admin_Middle_Name: "",
      admin_Last_Name: "",
      admin_Gender: "",
      admin_Image_Url: userImageUrl,
      admin_Mobile_Number: "",
      admin_Alternate_Mobile_Number: "",
      admin_Email_Id: userEmailId,
    }
  );
};

export const getUserProfileDetails = async (userAccessTokenObject: any) => {
  if (userAccessTokenObject === null) return null;
  const docRef = doc(
    db,
    EVENT_SUB_ADMIN_UPDATE_TYPE_NAME,
    userAccessTokenObject.user_id
  );
  const docSnap = await getDoc(docRef);
  return docSnap.data();
};

export const fetchApplicationUserInfo = async (userId: string) => {
  const userDoc = doc(db, "USER-DETAILS-INFORMATION", userId);
  const userInfo = await getDoc(userDoc);
  return userInfo.data();
};
