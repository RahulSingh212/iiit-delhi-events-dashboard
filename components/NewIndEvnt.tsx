import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/router";
import { EventInformation } from "@/lib/classModals/eventInformation";
import { createNewEventForClub, createNewIndependentEvent } from "@/lib/firebase/eventsHandler";

type Props = {};

export const AddNewIndependentEvent = (props: Props) => {
  const router = useRouter();
  const [clubId, setClubId] = useState<string>(String(router.query.clubId));
  const [eventName, setEventName] = useState<string>("");
  const [eventDescription, setEventDescription] = useState<string>("");
  const [eventLocation, setEventLocation] = useState<string>("");
  const [eventMapUrl, setEventMapUrl] = useState<string>("");
  const [eventStartDate, setEventStartDate] = useState<string>("");
  const [eventEndDate, setEventEndDate] = useState<string>("");
  const [eventStartTime, setEventStartTime] = useState<string>("");
  const [eventEndTime, setEventEndTime] = useState<string>("");
  const [eventImageUrl, setEventImageUrl] = useState<string>("");

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
        <TextContainer
          title={`Event Starting Date`}
          placeholder={`Enter the start date of the event`}
          value={eventStartDate}
          setHandler={setEventStartDate}
        />
        <TextContainer
          title={`Event Ending Date`}
          placeholder={`Enter the end date of the event`}
          value={eventEndDate}
          setHandler={setEventEndDate}
        />
        <TextContainer
          title={`Event Starting Time`}
          placeholder={`Enter the starting time of the event`}
          value={eventStartTime}
          setHandler={setEventStartTime}
        />
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
          onClick={addIndEventHandler}
          className={`relative px-4 py-2 bg-red-400 hover:bg-red-500 font-semibold text-white mx-auto rounded-3xl`}
        >
          Add Event
        </button>
      </div>
      <div className={`h-16`}></div>
    </>
  );
};

const TextContainer = (props: any) => {
  return (
    <div
      className={`relative w-full flex flex-col space-y-1 py-2 px-1 bg-yellow-50 z-20 my-2`}
    >
      <h4 className={`relative w-full`}>{props.title}</h4>
      <input
        className="rounded-sm p-1 bg-blue-50"
        placeholder={props.placeholder}
        value={props.value}
        onChange={(e) => {
          props.setHandler(String(e.target.value));
        }}
      />
    </div>
  );
};
