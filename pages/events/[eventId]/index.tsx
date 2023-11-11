import { parse } from "cookie";
import {
  deleteEvent,
  fetchEventFullDetails,
} from "@/lib/firebase/eventsHandler";
import moment from "moment";
import { format } from "date-fns";
import { EVENT_ADMIN_ACCESS_TOKEN, UPDATE_EVENT } from "@/lib/helper";
import { useRouter } from "next/router";
import { getSubEventsList } from "@/lib/firebase/subEventsHandler";
import InfoTile from "@/components/feildContainers/InfoTile";
import { EventInformation } from "@/lib/classModals/eventInformation";

type Props = {
  isAdmin: boolean;
  eventDetails: EventInformation;
  subEventsList: any[];
};

export default function EventDetailsPage(props: Props) {
  const router = useRouter();
  const deleteEventHandler = async () => {
    const response: any = await deleteEvent(
      props.eventDetails.event_Name,
      props.eventDetails.event_Id
    );
    alert(response.message);
    if (response.status) {
      if (props.isAdmin) {
        router.replace({
          pathname: `/events/${router.query.eventId}`,
        });
      } else {
        router.replace({
          pathname: `/a`,
        });
      }
    }
  };

  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] mx-auto mt-5 space-y-2`}>
          <span
            className={`relative w-full text-center flex text-3xl font-serif justify-center mb-4`}
          >
            Event Details
          </span>
          <InfoTile
            isEditable={!props.isAdmin}
            handlerType={UPDATE_EVENT}
            firebaseHeaderName={"event_Name"}
            headerText={"Event Name"}
            tileText={props.eventDetails.event_Name}
            placeHolderText={"Event Name"}
            descriptionText={"Enter the name of the event"}
            inputType={"text"}
          />
          <InfoTile
            isEditable={!props.isAdmin}
            handlerType={UPDATE_EVENT}
            firebaseHeaderName={"event_Description"}
            headerText={"Event Description"}
            tileText={props.eventDetails.event_Description}
            placeHolderText={"Event Description"}
            descriptionText={"Enter the description of the event"}
            inputType={"text"}
          />
          <InfoTile
            isEditable={!props.isAdmin}
            handlerType={UPDATE_EVENT}
            firebaseHeaderName={"event_Location_Url"}
            headerText={"Event Location URL"}
            tileText={props.eventDetails.event_Location_Url}
            placeHolderText={"Event location url"}
            descriptionText={"Enter the location url of the event"}
            inputType={"text"}
          />
          <InfoTile
            isEditable={!props.isAdmin}
            handlerType={UPDATE_EVENT}
            firebaseHeaderName={"event_Logo_Url"}
            headerText={"Event Logo URL"}
            tileText={props.eventDetails.event_Logo_Url}
            placeHolderText={"Event logo url"}
            descriptionText={"Enter the logo url of the event"}
            inputType={"text"}
          />
        </div>
        <div className={`relative  w-[95%] mx-auto flex flex-col mb-2 mt-5`}>
          <span className={`relative w-full text-xl font-medium mb-2`}>
            Sub events:
          </span>
          <div className={`relative w-full flex flex-col space-y-2`}>
            {props.subEventsList.map((subEvent: any, index: number) => (
              <div
                onClick={() => {
                  router.push({
                    pathname: `/events/${router.query.eventId}/subEvents/${subEvent.subEvent_Id}`,
                  });
                }}
                key={index}
                className={`relative flex flex-col space-y-1 px-3 py-1 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
              >
                <span>{subEvent.subEvent_Name}</span>
                <span>{subEvent.subEvent_Description}</span>
              </div>
            ))}
          </div>
        </div>
      </main>
      {!props.isAdmin && (
        <button
          className={`absolute bottom-3 right-3 font-semibold px-4 py-2 rounded-3xl bg-red-400 text-white`}
          onClick={() => {
            router.push({
              pathname: `/events/${router.query.eventId}/addSubEvent`,
            });
          }}
        >
          Add sub event
        </button>
      )}
      <button
        className={`absolute bottom-3 left-3 font-semibold px-4 py-2 rounded-3xl bg-red-400 text-white`}
        onClick={deleteEventHandler}
      >
        Delete event
      </button>
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const eventId = params?.eventId;
  const eventDetails = await fetchEventFullDetails(eventId);
  const subEventsList = await getSubEventsList(eventId);

  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_ADMIN_ACCESS_TOKEN];
  let isAdmin = false;
  if (userAccessToken) isAdmin = true;

  return {
    props: {
      isAdmin: isAdmin,
      eventDetails: eventDetails,
      subEventsList: subEventsList,
    },
  };
}
