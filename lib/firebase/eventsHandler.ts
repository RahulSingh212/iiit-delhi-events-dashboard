import { doc, getDoc } from "firebase/firestore";
import { db } from ".";
import { EVENTS_INFORMATION_COLLECTION_NAME } from "../helper";

export const fetchEventFullDetails = async (eventId: string) => {
  const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, eventId);
  const eventInfo = await getDoc(eventDoc);

  if (!eventInfo.exists()) return null;

  const eventObj = {
    event_Id: eventInfo.id,
    event_Name: eventInfo.data()?.event_Name,
    event_Description: eventInfo.data()?.event_Description,
    event_Logo_Url: eventInfo.data()?.event_Logo_Url,
    event_Address: eventInfo.data()?.event_Address,
    event_Location_Url: eventInfo.data()?.event_Location_Url,
    event_Start_Date: eventInfo.data()?.event_Start_Date,
    event_End_Date: eventInfo.data()?.event_End_Date,
    event_Start_Time: eventInfo.data()?.event_Start_Time,
    event_End_Time: eventInfo.data()?.event_End_Time,
    event_Authorized_Users_List: eventInfo.data()?.event_Authorized_Users_List,
  };

  return eventObj;
};

export const fetchEventInfo = async (clubId: string) => {
  const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, clubId);
  const eventInfo = await getDoc(eventDoc);

  if (!eventInfo.exists()) return null;
  const eventObj = {
    event_Id: eventInfo.id,
    event_Name: eventInfo.data()?.event_Name,
    event_Description: eventInfo.data()?.event_Description,
    event_Logo_Url: eventInfo.data()?.event_Logo_Url,
  };

  return eventObj;
};

export const createNewClubHandler = async (
    clubDetails: any
) => {

}