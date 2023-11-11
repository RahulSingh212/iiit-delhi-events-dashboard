import {
  addDoc,
  collection,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
} from "firebase/firestore";
import { db } from ".";
import {
  CLUBS_INFORMATION_COLLECTION_NAME,
  EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
} from "../helper";
import { fetchEventInfo } from "./eventsHandler";
import { fetchLoggedInUserInfo } from "./userHandler";
import { ClubInformation } from "../classModals/clubInformation";

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

export const createNewIndependentClubHandler = async (
  clubDetails: ClubInformation,
  adminEmail: string
): Promise<any> => {
  // const userAccessTokenObject = await fetchLoggedInUserInfo(false);
  // const userEmailId = userAccessTokenObject.userCredentials.payload.email;
  // const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

  try {
    const club = await addDoc(
      collection(db, CLUBS_INFORMATION_COLLECTION_NAME),
      {
        club_Id: "",
        club_Created_At: new Date(),
        club_Created_By: "userUniqueId",
        club_Created_Email: "userEmailId",
        club_Authorized_Users: {
          [adminEmail]: true,
        },
        club_Events_List: [],
        club_Name: clubDetails.club_Name,
        club_Description: clubDetails.club_Description,
        club_Logo_Url: clubDetails.club_Logo_Url,
      }
    );

    const docRef = doc(db, CLUBS_INFORMATION_COLLECTION_NAME, club.id);
    const response = await updateDoc(docRef, {
      club_Id: club.id,
    });

    const adminDoc = await getDoc(
      doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, adminEmail)
    );

    if (adminDoc.exists()) {
      const response = await updateDoc(
        doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, adminEmail),
        {
          subAdmin_Clubs_List: [
            ...adminDoc.data()?.subAdmin_Clubs_List,
            club.id,
          ],
        }
      );
    } else {
      const response = await setDoc(
        doc(db, EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME, adminEmail),
        {
          subAdmin_Id: "",
          subAdmin_Authorization: false,
          EVENT_SUB_ADMIN_ACCESS_TOKEN: "",
          subAdmin_Auth_Type: "email",
          subAdmin_Display_Name: adminEmail.split("@")[0],
          subAdmin_First_Name: "",
          subAdmin_Middle_Name: "",
          subAdmin_Last_Name: "",
          subAdmin_Gender: "",
          subAdmin_Image_Url: "",
          subAdmin_Mobile_Number: "",
          subAdmin_Alternate_Mobile_Number: "",
          subAdmin_Email_Id: adminEmail,
          subAdmin_Events_List: [],
          subAdmin_Clubs_List: [club.id],
        }
      );
    }

    return {
      status: true,
      message: "New club added successfully.",
      val: club.id,
    };
  } catch (erro: any) {
    return {
      status: true,
      message: "Something went wrong. Please try again.",
      val: "",
    };
  }
};

export const updateClubInfo = async (
  clubId: string,
  keyVal: string,
  value: any
) => {
  try {
    const clubDoc = doc(db, CLUBS_INFORMATION_COLLECTION_NAME, clubId);
    const clubInfo = await getDoc(clubDoc);
    if (!clubInfo.exists()) {
      return {
        status: false,
        message: `Club-id does not exist. Please try again.`,
        val: "",
      };
    } else {
      const response = await updateDoc(clubDoc, {
        [keyVal]: value,
      });
      return {
        status: true,
        message: `${keyVal} updated successfully.`,
        val: "",
      };
    }
  } catch (error: any) {
    return {
      status: false,
      message: `Something went wrong. Please try again.`,
      val: "",
    };
  }
};
