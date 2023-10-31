import jwt_decode from "jwt-decode";

// User Type
export const EVENT_USER_ADMIN = "EVENT-ADMIN";
export const EVENT_USER_SUB_ADMIN = "EVENT-SUB-ADMIN";

// Collection Names
export const CLUBS_INFORMATION_COLLECTION_NAME = "CLUBS-DETAILS-INFORMATION";
export const EVENTS_INFORMATION_COLLECTION_NAME = "EVENTS-DETAILS-INFORMATION";
export const SUB_EVENTS_INFORMATION_COLLECTION_NAME = "SUB-EVENTS-DETAILS-INFORMATION";

// -----------------------------------------------------------------------------------------------------

// User Authentication Constants
export const EVENTS_ADMIN_INFORMATION_COLLECTION_NAME = "EVENTS-ADMIN-DETAILS-INFORMATION";
export const EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME = "EVENTS-SUB-ADMIN-DETAILS-INFORMATION";
export const EMAIL_SIGNUP = "email-sign-up";
export const EMAIL_LOGIN = "email-log-in";
export const GOOGLE_SIGNUP = "google-sign-up";
export const GOOGLE_LOGIN = "google-log-in";
export const EVENT_ADMIN_ACCESS_TOKEN = "event-admin-access-token";
export const EVENT_SUB_ADMIN_ACCESS_TOKEN = "event-sub-admin-access-token";
export const COOKIE_EXPIRATOIN_TIME = 30 * 24 * 60 * 60;
export const GET_EVENT_ADMIN_TOKEN_OBJECT = "get-event-admin-token-obj";
export const GET_EVENT_SUB_ADMIN_TOKEN_OBJECT = "get-event-sub-admin-token-obj";
export const EVENT_ADMIN_UPDATE_TYPE_NAME = "update-event-admin-name";
export const EVENT_SUB_ADMIN_UPDATE_TYPE_NAME = "update-event-sub-admin-name";

// -----------------------------------------------------------------------------------------------------

// Loading Modal Status
export const LOAD_MODAL_STATUS_LOADING = "LOADING";
export const LOAD_MODAL_STATUS_OFF = "OFF";
export const LOAD_MODAL_STATUS_SUCCESS = "SUCCESS";
export const LOAD_MODAL_STATUS_ERROR = "ERROR";

export async function getErrorMessage(errorValue: String) {
    if (errorValue === "auth/wrong-password") {
      return "Wrong combination of the credentials!";
    } else if (errorValue === "auth/email-already-in-use") {
      return "Email already is in use!";
    } else {
      return errorValue;
    }
  }

export const extractJWTValues = async (token: any) => {
  try {
    const decodedValue = await jwt_decode(token);
    return decodedValue;
  } catch (error) {
    return null;
  }
};

export const unixToDate = async (timeStamp: any) => {
  const dateObj = new Date(Number(timeStamp) * 1000);
  return dateObj;
};

