import { auth, db } from "@/lib/firebase";
var cookie = require("cookie");
// import cookie from "cookie"; // server side cookie only https and available on the server side

import {
  createAdminUserAccount,
  createSubAdminUserAccount,
} from "@/lib/firebase/userHandler";

import {
  EMAIL_SIGNUP,
  EMAIL_LOGIN,
  GOOGLE_SIGNUP,
  GOOGLE_LOGIN,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
  EVENT_ADMIN_ACCESS_TOKEN,
  unixToDate,
  extractJWTValues,
  COOKIE_EXPIRATOIN_TIME,
  EVENT_USER_ADMIN,
  EVENTS_ADMIN_INFORMATION_COLLECTION_NAME,
  EVENT_USER_SUB_ADMIN,
  EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
} from "@/lib/helper";
import { doc, getDoc } from "firebase/firestore";

async function handler(req: any, res: any) {
  const data = req.body;
  const {
    authType,
    userAccessToken,
    userId,
    userEmail,
    userImageUrl,
    displayName,
    userType,
  } = data;

  try {
    if (userType === EVENT_USER_ADMIN) {
      const adminDoc = await getDoc(
        doc(db, EVENTS_ADMIN_INFORMATION_COLLECTION_NAME, userEmail)
      );
      if (!adminDoc.exists()) {
        res.status(422).json({
          userCredentials: null,
          error: null,
          message: "Email is not authorized to be an admin",
        });
        return;
      }
    } else if (userType === EVENT_USER_SUB_ADMIN) {
      const subAdminDoc = await getDoc(
        doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, userEmail)
      );
      if (!subAdminDoc.exists()) {
        res.status(422).json({
          userCredentials: null,
          error: null,
          message: "Email is not authorized to be a sub-admin",
        });
        return;
      }
    }

    if (authType === GOOGLE_SIGNUP) {
      if (userType === EVENT_USER_ADMIN) {
        const dbResponse = await createAdminUserAccount(
          userAccessToken,
          userId,
          userEmail,
          "",
          "google",
          displayName
        );
      } else {
        await createSubAdminUserAccount(
          userAccessToken,
          userId,
          userEmail,
          userImageUrl,
          "google",
          displayName
        );
      }
    }
    const response = await res.setHeader(
      "Set-Cookie",
      cookie.serialize(
        userType === EVENT_USER_ADMIN
          ? EVENT_ADMIN_ACCESS_TOKEN
          : EVENT_SUB_ADMIN_ACCESS_TOKEN,
        userAccessToken,
        {
          httpOnly: true,
          secure: process.env.NODE_ENV !== "development",
          maxAge: COOKIE_EXPIRATOIN_TIME,
          sameSite: "strict",
          path: "/",
        }
      )
    );
    res.status(201).json({
      userCredentials: response,
      error: null,
      message: "Unable to set auth cookie!",
    });
  } catch (error) {
    console.log("User-Google-Auth-Error");
    console.log(error);
    res.status(422).json({
      userCredentials: null,
      error,
      message: "Error occoured",
    });
  }
}

export default handler;
