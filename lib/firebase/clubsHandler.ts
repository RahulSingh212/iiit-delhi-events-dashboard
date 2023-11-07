import { collection, doc, getDoc, getDocs } from "firebase/firestore";
import { db } from ".";
import { CLUBS_INFORMATION_COLLECTION_NAME } from "../helper";
import { fetchEventInfo } from "./eventsHandler";

export const fetchClubFullDetails = async (clubId: string) => {
  const clubDoc = doc(db, CLUBS_INFORMATION_COLLECTION_NAME, clubId);
  const clubInfo = await getDoc(clubDoc);

  if (!clubInfo.exists()) return null;

  let eventsList: any[] = [];
  for (let eventId of clubInfo.data()?.club_Events_List) {
    let obj = await fetchEventInfo(eventId);
    if (!obj) continue;
    eventsList.push(obj);
  }
  const clubObj = {
    club_Id: clubInfo.id,
    club_Name: clubInfo.data()?.club_Name,
    club_Description: clubInfo.data()?.club_Description,
    club_Logo_Url: clubInfo.data()?.club_Logo_Url,
    club_Events_List: eventsList,
  };

  return clubObj;
};

export const fetchClubInfo = async (clubId: string) => {
  const clubDoc = doc(db, CLUBS_INFORMATION_COLLECTION_NAME, clubId);
  const clubInfo = await getDoc(clubDoc);

  if (!clubInfo.exists()) return null;
  const clubObj = {
    club_Id: clubInfo.id,
    club_Name: clubInfo.data()?.club_Name,
    club_Description: clubInfo.data()?.club_Description,
    club_Logo_Url: clubInfo.data()?.club_Logo_Url,
  };

  return clubObj;
};

export const fetchClubsInfoList = async (): Promise<any[]> => {
  const clubsCol = await getDocs(
    collection(db, CLUBS_INFORMATION_COLLECTION_NAME)
  );

  let list: any[] = [];
  for (let club of clubsCol.docs) {
    let obj = await fetchClubInfo(club.id);
    list.push(obj);
  }

  return list;
};

export const createNewClubHandler = async (clubDetails: any) => {};
