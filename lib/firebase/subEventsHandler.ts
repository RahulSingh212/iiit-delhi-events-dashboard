import {
  doc,
  getDoc,
  getDocs,
  collection,
  updateDoc,
  deleteDoc,
  addDoc,
} from "firebase/firestore";
import {
  EVENTS_INFORMATION_COLLECTION_NAME,
  SUB_EVENTS_INFORMATION_COLLECTION_NAME,
} from "../helper";
import { db } from ".";
import { SubEventInformation } from "../classModals/eventInformation";
import { fetchLoggedInUserInfo } from "./userHandler";

export const createNewSubEvent = async (
  subEventInfo: SubEventInformation,
  isAdmin: boolean = false
) => {
  const eId = subEventInfo.subEvent_Event_Id;
  const userAccessTokenObject = await fetchLoggedInUserInfo(isAdmin);
  const userEmailId = userAccessTokenObject.userCredentials.payload.email;
  const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

  try {
    const subEvent = await addDoc(
      collection(
        db,
        EVENTS_INFORMATION_COLLECTION_NAME,
        eId,
        SUB_EVENTS_INFORMATION_COLLECTION_NAME
      ),
      {
        subEvent_Id: subEventInfo.subEvent_Id,
        subEvent_Club_Id: subEventInfo.subEvent_Club_Id,
        subEvent_Event_Id: subEventInfo.subEvent_Event_Id,
        subEvent_Name: subEventInfo.subEvent_Name,
        subEvent_Description: subEventInfo.subEvent_Description,
        subEvent_Address: subEventInfo.subEvent_Address,
        subEvent_Location_Url: subEventInfo.subEvent_Location_Url,
        subEvent_Logo_Url: subEventInfo.subEvent_Logo_Url,
        subEvent_Start_Date: subEventInfo.subEvent_Start_Date,
        subEvent_End_Date: subEventInfo.subEvent_End_Date,
        subEvent_Start_Time: subEventInfo.subEvent_Start_Time,
        subEvent_End_Time: subEventInfo.subEvent_End_Time,
        subEvent_Created_At: new Date(),
        subEvent_Created_Email: userEmailId,
        subEvent_Created_Id: userUniqueId,
      }
    );

    const docRef = doc(
      db,
      EVENTS_INFORMATION_COLLECTION_NAME,
      eId,
      SUB_EVENTS_INFORMATION_COLLECTION_NAME,
      subEvent.id
    );
    
    const response = await updateDoc(docRef, {
      subEvent_Id: subEvent.id,
    });

    return {
      status: true,
      message: "New sub - event added successfully.",
      val: subEvent.id,
    };
  } catch (error: any) {
    return {
      status: false,
      message: "Something went wrong. Please try again.",
      val: error.message,
    };
  }
};

export const deleteSubEvent = async (
  eventId: string,
  subEventName: string,
  subEventId: string
) => {
  try {
    const subEventDoc = doc(
      db,
      EVENTS_INFORMATION_COLLECTION_NAME,
      eventId,
      SUB_EVENTS_INFORMATION_COLLECTION_NAME,
      subEventId
    );
    const subEventInfo = await getDoc(subEventDoc);
    if (!subEventInfo.exists()) {
      return {
        status: false,
        message: `Event-id does not exist. Please try again.`,
        val: "",
      };
    } else {
      const response = await deleteDoc(subEventDoc);
      return {
        status: true,
        message: `${subEventName} deleted successfully.`,
        val: "",
      };
    }
  } catch (erro: any) {
    return {
      status: false,
      message: "Something went wrong. Please try again.",
      val: "",
    };
  }
};

export const updateSubEventInfo = async (
  eventId: string,
  subEventId: string,
  keyVal: string,
  value: any
) => {
  try {
    const subEventDoc = doc(
      db,
      EVENTS_INFORMATION_COLLECTION_NAME,
      eventId,
      SUB_EVENTS_INFORMATION_COLLECTION_NAME,
      subEventId
    );
    const subEventInfo = await getDoc(subEventDoc);
    if (!subEventInfo.exists()) {
      return {
        status: false,
        message: `Event-id does not exist. Please try again.`,
        val: "",
      };
    } else {
      const response = await updateDoc(subEventDoc, {
        [keyVal]: value,
      });
      return {
        status: true,
        message: `${keyVal} updated successfully.`,
        val: "",
      };
    }
  } catch (erro: any) {
    return {
      status: false,
      message: "Something went wrong. Please try again.",
      val: "",
    };
  }
};
