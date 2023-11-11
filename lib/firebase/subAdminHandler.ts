import { doc, getDoc, updateDoc } from "firebase/firestore";
import { db } from ".";
import { EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME } from "../helper";
import { fetchClubInfo } from "./clubsHandler";
import { fetchEventInfo } from "./eventsHandler";
import { fetchLoggedInUserInfo } from "./userHandler";

export const updateSubAdminInfo = async (keyVal: string, value: any) => {
  try {
    const userAccessTokenObject = await fetchLoggedInUserInfo(false);
    const userEmailId = userAccessTokenObject.userCredentials.payload.email;
    const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

    const userDoc = doc(
      db,
      EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
      userEmailId
    );
    const userInfo = await getDoc(userDoc);
    const res = await updateDoc(userDoc, {
      [keyVal]: value,
    });

    return {
      status: true,
      message: `${keyVal} updated successfully.`,
      val: "",
    };
  } catch (error: any) {
    console.log(error.message);
    return {
      status: false,
      message: `Something went wrong. Please try again.`,
      val: "",
    };
  }
};

export const fetchSubAdminInfo = async (keyVal: string) => {
  try {
    const userAccessTokenObject = await fetchLoggedInUserInfo(false);
    const userEmailId = userAccessTokenObject.userCredentials.payload.email;
    const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

    const userDoc = doc(
      db,
      EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
      userEmailId
    );
    const userInfo = await getDoc(userDoc);
    const value = userInfo.data()?.[keyVal];

    return {
      status: true,
      message: `${keyVal} fetched successfully.`,
      val: value,
    };
  } catch (error: any) {
    console.log(error.message);
    return {
      status: false,
      message: `Something went wrong. Please try again.`,
      val: "",
    };
  }
};

export const fetchSubAdminClubInfo = async (
  userAccessTokenObject: any
): Promise<any> => {
  if (userAccessTokenObject === null) return [];
  const userEmailId = userAccessTokenObject.payload.email;

  const userDoc = await getDoc(
    doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, userEmailId)
  );
  let clubIdsList: any[] = userDoc.data()?.subAdmin_Clubs_List;
  let eventIdsList: any[] = userDoc.data()?.subAdmin_Events_List;

  let clubsList: any[] = [];
  for (let clubId of clubIdsList) {
    let obj = await fetchClubInfo(clubId);
    if (obj === null) continue;
    clubsList.push(obj);
  }

  let eventsList: any[] = [];
  for (let eventId of eventIdsList) {
    let obj = await fetchEventInfo(eventId);
    if (obj === null) continue;
    eventsList.push(obj);
  }

  return {
    clubsList,
    eventsList,
  };
};
