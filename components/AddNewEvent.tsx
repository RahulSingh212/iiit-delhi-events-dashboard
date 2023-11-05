import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/router";
import { EventInformation } from "@/lib/classModals/eventInformation";
import {
  createNewEventForClub,
  createNewIndependentEvent,
} from "@/lib/firebase/eventsHandler";
import { TextContainer } from "./feildContainers/TextContainer";
import { DateBox } from "./feildContainers/DateBox";
import TimePicker from "react-time-picker";
import "react-time-picker/dist/TimePicker.css";
import "react-clock/dist/Clock.css";
import { EVENT_CLUB, EVENT_INDEPENDENT } from "@/lib/helper";

type Props = {
  eventType: string;
};

export const AddNewEvent = (props: Props) => {
  const router = useRouter();
  const [clubId, setClubId] = useState<string>(String(router.query.clubId));
  const [eventName, setEventName] = useState<string>("");
  const [eventDescription, setEventDescription] = useState<string>("");
  const [eventLocation, setEventLocation] = useState<string>("");
  const [eventMapUrl, setEventMapUrl] = useState<string>("");
  const [eventStartDate, setEventStartDate] = useState<Date>(new Date());
  const [eventEndDate, setEventEndDate] = useState<Date>(new Date());
  const [eventStartTime, setEventStartTime] = useState<any>("00:00");
  const [eventEndTime, setEventEndTime] = useState<any>("00:00");
  const [eventImageUrl, setEventImageUrl] = useState<string>("");

  const [showStartCalendar, setShowStartCalendar] = useState<boolean>(false);
  const [showEndCalendar, setShowEndCalendar] = useState<boolean>(false);

  const addClubEventHandler = async () => {
    let eventInfo = new EventInformation();
    eventInfo.event_Club_Id = router.query.clubId + "";
    eventInfo.event_Name = eventName;
    eventInfo.event_Description = eventDescription;
    eventInfo.event_Address = eventLocation;
    eventInfo.event_Location_Url = eventMapUrl;
    eventInfo.event_Start_Date = eventStartDate;
    eventInfo.event_End_Date = eventEndDate;
    eventInfo.event_Start_Time = eventStartTime;
    eventInfo.event_End_Time = eventEndTime;
    eventInfo.event_Logo_Url = eventImageUrl;
    eventInfo.event_Created_By = "PAn72rdmxUQxmjjyrnrs6TEFLDb2";

    const response: any = await createNewEventForClub(eventInfo);
    alert(response.message);
    if (response.status) {
      router.replace({
        pathname: `/clubs/${router.query.clubId}`,
      });
    }
  };

  const addIndEventHandler = async () => {
    let eventInfo = new EventInformation();
    eventInfo.event_Club_Id = router.query.clubId + "";
    eventInfo.event_Name = eventName;
    eventInfo.event_Description = eventDescription;
    eventInfo.event_Address = eventLocation;
    eventInfo.event_Location_Url = eventMapUrl;
    eventInfo.event_Start_Date = eventStartDate;
    eventInfo.event_End_Date = eventEndDate;
    eventInfo.event_Start_Time = eventStartTime;
    eventInfo.event_End_Time = eventEndTime;
    eventInfo.event_Logo_Url = eventImageUrl;
    eventInfo.event_Created_By = "PAn72rdmxUQxmjjyrnrs6TEFLDb2";

    const response: any = await createNewIndependentEvent(eventInfo);
    alert(response.message);
    if (response.status) {
      router.replace({
        pathname: `/events/${response.val}`,
      });
    }
  };

  const submitEventHandler = async () => {
    if (props.eventType === EVENT_CLUB) {
      await addClubEventHandler();
    } else if (props.eventType === EVENT_INDEPENDENT) {
        addIndEventHandler();
    } else {
    }
  };

  return (
    <>
      <div
        className={`relative w-full flex flex-col rounded-md mx-auto p-2 space-y-2 bg-gray-200 z-10`}
      >
        <TextContainer
          title={`Event Name`}
          placeholder={`Enter the name of the event`}
          value={eventName}
          setHandler={setEventName}
        />
        <TextContainer
          title={`Event Desciption`}
          placeholder={`Enter the description of the event`}
          value={eventDescription}
          setHandler={setEventDescription}
        />
        <TextContainer
          title={`Event Location Details`}
          placeholder={`Enter the location of the event`}
          value={eventLocation}
          setHandler={setEventLocation}
        />
        <TextContainer
          title={`Event Map Url`}
          placeholder={`Enter the map url of the event`}
          value={eventMapUrl}
          setHandler={setEventMapUrl}
        />

        <div className={`relative w-full flex space-x-2 md:space-x-4 py-2`}>
          <DateBox
            title={"Start Date"}
            date={eventStartDate}
            setDate={setEventStartDate}
            showCalendar={showStartCalendar}
            setShowCalendar={setShowStartCalendar}
          />
          <DateBox
            title={"End Date"}
            date={eventEndDate}
            setDate={setEventEndDate}
            showCalendar={showEndCalendar}
            setShowCalendar={setShowEndCalendar}
          />
        </div>

        <div className={`relative w-full flex space-x-2 md:space-x-4 z-20`}>
          <TimePicker value={eventStartTime} onChange={setEventStartTime} />
          <TimePicker value={eventEndTime} onChange={setEventEndTime} />
        </div>

        <TextContainer
          title={`Event Ending Time`}
          placeholder={`Enter the ending time of the event`}
          value={eventEndTime}
          setHandler={setEventEndTime}
        />

        <div className={`relative w-full flex flex-row space-x-3`}>
          <Image
            alt={`image`}
            src={eventImageUrl === "" ? "/icons/gallery.svg" : ""}
            className={`mx-auto w-24 h-24`}
            width={10}
            height={10}
          />
          <TextContainer
            title={`Event Image Url`}
            placeholder={`Enter the image url of the event`}
            value={eventImageUrl}
            setHandler={setEventImageUrl}
          />
        </div>
      </div>
      <div className={`relative w-full flex justify-center my-5`}>
        <button
          onClick={submitEventHandler}
          className={`relative px-4 py-2 bg-red-400 hover:bg-red-500 font-semibold text-white mx-auto rounded-3xl`}
        >
          Add Event
        </button>
      </div>
      <div className={`h-16`}></div>
    </>
  );
};
