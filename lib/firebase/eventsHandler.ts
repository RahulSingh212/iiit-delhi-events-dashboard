import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDoc,
  updateDoc,
} from "firebase/firestore";
import { db } from ".";
import {
  CLUBS_INFORMATION_COLLECTION_NAME,
  EVENTS_INFORMATION_COLLECTION_NAME,
  EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
  SUB_EVENTS_INFORMATION_COLLECTION_NAME,
} from "../helper";
import { EventInformation } from "../classModals/eventInformation";
import { fetchLoggedInUserInfo } from "./userHandler";
import { updateClubInfo } from "./clubsHandler";
import { fetchSubAdminInfo, updateSubAdminInfo } from "./subAdminHandler";

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
    event_Start_Date: String(eventInfo.data()?.event_Start_Date),
    event_End_Date: String(eventInfo.data()?.event_End_Date),
    event_Start_Time: String(eventInfo.data()?.event_Start_Time),
    event_End_Time: String(eventInfo.data()?.event_End_Time),
    event_Authorized_Users_List: eventInfo.data()?.event_Authorized_Users_List,
  };

  return eventObj;
};

export const fetchEventInfo = async (eventId: string) => {
  const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, eventId);
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

export const createNewIndependentEvent = async (
  eventInfo: EventInformation,
  isAdmin: boolean = false
) => {
  const userAccessTokenObject = await fetchLoggedInUserInfo(isAdmin);
  const userEmailId = userAccessTokenObject.userCredentials.payload.email;
  const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

  try {
    const event = await addDoc(
      collection(db, EVENTS_INFORMATION_COLLECTION_NAME),
      {
        event_Id: "",
        event_Address: eventInfo.event_Address,
        event_Authorized_Users_List: eventInfo.event_Authorized_Users_List,
        event_Club_Id: eventInfo.event_Club_Id,
        event_Club_Name: eventInfo.event_Club_Name,
        event_Created_At: new Date(),
        event_Created_By: userUniqueId,
        event_Created_Email: userEmailId,
        event_Name: eventInfo.event_Name,
        event_Discussion_List: [],
        event_Description: eventInfo.event_Description,
        event_Start_Date: eventInfo.event_Start_Date,
        event_End_Date: eventInfo.event_End_Date,
        event_Start_Time: eventInfo.event_Start_Time,
        event_End_Time: eventInfo.event_End_Time,
        event_Location_Url: eventInfo.event_Location_Url,
        event_Logo_Url: eventInfo.event_Logo_Url,
      }
    );

    const docRef = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, event.id);
    const response = await updateDoc(docRef, {
      event_Id: event.id,
    });

    const userDoc = doc(
      db,
      EVENTS_SUB_ADMIN_INFORMATION_COLLECTION_NAME,
      userEmailId
    );
    const userInfo = await getDoc(userDoc);
    let eventsList: any[] = userInfo.data()?.subAdmin_Events_List;
    eventsList.push(event.id);
    await updateDoc(userDoc, {
      subAdmin_Events_List: eventsList,
    });

    return {
      status: true,
      message: "New event added successfully.",
      val: event.id,
    };
  } catch (error: any) {
    return {
      status: false,
      message: "Something went wrong. Please try again.",
      val: error.message,
    };
  }
};

export const createNewEventForClub = async (eventInfo: EventInformation) => {
  if (eventInfo.event_Club_Id === "") {
    return {
      status: false,
      message: "Club id is not available.",
      val: "",
    };
  }

  const club = doc(
    db,
    CLUBS_INFORMATION_COLLECTION_NAME,
    eventInfo.event_Club_Id
  );
  if (!(await getDoc(club)).exists()) {
    return {
      status: false,
      message: "Club id is not available.",
      val: "",
    };
  }
  const userAccessTokenObject = await fetchLoggedInUserInfo();
  const userEmailId = userAccessTokenObject.userCredentials.payload.email;
  const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;

  try {
    const event = await addDoc(
      collection(db, EVENTS_INFORMATION_COLLECTION_NAME),
      {
        event_Id: "",
        event_Address: eventInfo.event_Address,
        event_Authorized_Users_List: eventInfo.event_Authorized_Users_List,
        event_Club_Id: eventInfo.event_Club_Id,
        event_Club_Name: eventInfo.event_Club_Name,
        event_Created_At: new Date(),
        event_Created_By: userUniqueId,
        event_Created_Email: userEmailId,
        event_Name: eventInfo.event_Name,
        event_Discussion_List: [],
        event_Description: eventInfo.event_Description,
        event_Start_Date: eventInfo.event_Start_Date,
        event_End_Date: eventInfo.event_End_Date,
        event_Start_Time: eventInfo.event_Start_Time,
        event_End_Time: eventInfo.event_End_Time,
        event_Location_Url: eventInfo.event_Location_Url,
        event_Logo_Url: eventInfo.event_Logo_Url,
      }
    );

    const docRef = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, event.id);
    const response = await updateDoc(docRef, {
      event_Id: event.id,
    });
    const clubDoc = await getDoc(club);

    let club_Events_List = clubDoc.data()?.club_Events_List;
    club_Events_List.push(event.id);

    await updateDoc(club, {
      club_Events_List: club_Events_List,
    });

    return {
      status: true,
      message: "New event added successfully.",
      val: event.id,
    };
  } catch (error: any) {
    return {
      status: false,
      message: "Something went wrong. Please try again.",
      val: error.message,
    };
  }
};

export const deleteEvent = async (eventName: string, eventId: string) => {
  const userAccessTokenObject = await fetchLoggedInUserInfo(false);
  const userEmailId = userAccessTokenObject.userCredentials.payload.email;
  const userUniqueId = userAccessTokenObject.userCredentials.payload.user_id;
  try {
    const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, eventId);
    const eventInfo = await getDoc(eventDoc);
    if (!eventInfo.exists()) {
      return {
        status: false,
        message: `Event-id does not exist. Please try again.`,
        val: "",
      };
    } else {
      const clubId = eventInfo.data()?.event_Club_Id;
      if (clubId !== "") {
        const clubDoc = doc(db, CLUBS_INFORMATION_COLLECTION_NAME, clubId);
        const clubInfo = await getDoc(clubDoc);
        if (clubInfo.exists()) {
          let club_Events_List = clubInfo.data()?.club_Events_List;
          let nList: any[] = [];
          for (let i = 0; i < club_Events_List.length; i++) {
            if (String(club_Events_List[i]) !== String(eventId)) {
              nList.push(club_Events_List[i]);
            }
          }

          const res = await updateClubInfo(
            clubId,
            "club_Events_List",
            nList
          );
        }
      }

      const listRes: any = await fetchSubAdminInfo("subAdmin_Events_List");
      if (listRes.status) {
        let nList = listRes.val;
        let finalList: any[] = [];
        for (let i = 0; i < nList.length; i++) {
          let eId = nList[i];
          if (eId !== eventId) {
            finalList.push(eId);
          }
        }
        const updateRes = await updateSubAdminInfo(
          "subAdmin_Events_List",
          finalList
        );
      }

      const response = await deleteDoc(eventDoc);
      return {
        status: true,
        message: `${eventName} deleted successfully.`,
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

export const updateEventInfo = async (
  eventId: string,
  keyVal: string,
  value: any
) => {
  try {
    const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, eventId);
    const eventInfo = await getDoc(eventDoc);
    if (!eventInfo.exists()) {
      return {
        status: false,
        message: `Event-id does not exist. Please try again.`,
        val: "",
      };
    } else {
      const response = await updateDoc(eventDoc, {
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
