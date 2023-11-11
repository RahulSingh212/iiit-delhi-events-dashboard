import { auth, db } from "@/lib/firebase";
import {
  CLUBS_INFORMATION_COLLECTION_NAME,
  EVENTS_INFORMATION_COLLECTION_NAME,
} from "@/lib/helper";
var cookie = require("cookie");

import { doc, getDoc, updateDoc } from "firebase/firestore";

async function handler(req: any, res: any) {
  const data = req.body;
  const { eventId, keyVal, value } = data;

  try {
    const eventDoc = doc(db, EVENTS_INFORMATION_COLLECTION_NAME, eventId);
    const eventInfo = await getDoc(eventDoc);
    if (!eventInfo.exists()) {
      res.status(200).json({
        status: false,
        message: `Event-id does not exist. Please try again.`,
        value: "",
      });
    } else {
      const response = await updateDoc(eventDoc, {
        [keyVal]: value,
      });
      res.status(200).json({
        status: true,
        message: `${keyVal} updated successfully.`,
        value: "",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(422).json({
      value: null,
      error,
      message: "Error occoured",
    });
  }

  // res.status(201).json({ message: queryOutput });
  return;
}

export default handler;
