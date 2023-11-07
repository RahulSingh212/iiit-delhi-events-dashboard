import { auth, db } from "@/lib/firebase";
var cookie = require("cookie");
// import cookie from "cookie"; // server side cookie only https and available on the server side

import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
} from "@firebase/auth";
import {
  createAdminUserAccount,
  createSubAdminUserAccount,
} from "@/lib/firebase/userHandler";
import {
  EMAIL_SIGNUP,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
  EVENT_ADMIN_ACCESS_TOKEN,
  COOKIE_EXPIRATOIN_TIME,
  EVENT_USER_ADMIN,
  EVENT_USER_SUB_ADMIN,
  EVENTS_ADMIN_INFORMATION_COLLECTION_NAME,
  EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
} from "@/lib/helper";
import { doc, getDoc } from "firebase/firestore";

async function handler(req: any, res: any) {
  // req.body.token
  // const serverResponse = NextResponse.next();
  const data = req.body;

  const { authType, userEmail, userPassword, userType } = data;

  if (
    !userEmail ||
    !userEmail.includes("@") ||
    !userEmail.includes(".") ||
    !userPassword ||
    userPassword.trim().length < 7 ||
    userPassword.includes(" ")
  ) {
    res.status(422).json({
      userCredentials: null,
      error: null,
      message: "Invalid input - password must be at least 7 characters",
    });
    return;
  }

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

    if (authType === EMAIL_SIGNUP) {
      const response = await createUserWithEmailAndPassword(
        auth,
        userEmail,
        userPassword
      );

      const userAccessToken = await response.user.getIdToken();
      const userId = response.user.uid;
      const displayName = userEmail.split("@")[0];

      if (userType === EVENT_USER_ADMIN) {
        const dbResponse = await createAdminUserAccount(
          userAccessToken,
          userId,
          userEmail,
          "",
          "email",
          displayName
        );
      } else {
        const dbResponse = await createSubAdminUserAccount(
          userAccessToken,
          userId,
          userEmail,
          "",
          "email",
          displayName
        );
      }

      res.setHeader(
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
        message: "email verification completed successfully.",
      });
    }
    // else if (authType === EMAIL_LOGIN) {
    else {
      const response = await signInWithEmailAndPassword(
        auth,
        userEmail,
        userPassword
      );

      const userAccessToken = await response.user.getIdToken();
      res.setHeader(
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
        message: "email verification completed successfully.",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(422).json({
      userCredentials: null,
      error,
      message: "Error occoured",
    });
  }

  // res.status(201).json({ message: queryOutput });
  return;
}

export default handler;
