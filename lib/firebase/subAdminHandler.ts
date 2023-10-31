import { doc, getDoc } from "firebase/firestore";
import { db } from ".";
import { EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME } from "../helper";
import { fetchClubInfo } from "./clubsHandler";

export const fetchSubAdminClubInfoList = async (
  userAccessTokenObject: any
): Promise<any[]> => {
  if (userAccessTokenObject === null) return [];
  const userEmailId = userAccessTokenObject.payload.email;

  const userDoc = await getDoc(
    doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, userEmailId)
  );
  let clubIdsList: any[] = userDoc.data()?.subAdmin_Events_List;

  let clubsList: any[] = [];
  for (let clubId of clubIdsList) {
    let obj = await fetchClubInfo(clubId);
    clubsList.push(obj);
  }

  return clubsList;
};
