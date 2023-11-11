import { parse } from "cookie";
import {
  deleteEvent,
  fetchEventFullDetails,
} from "@/lib/firebase/eventsHandler";
import { EVENT_ADMIN_ACCESS_TOKEN } from "@/lib/helper";
import { useRouter } from "next/router";

type Props = {
  isAdmin: boolean;
  eventDetails: any;
};

export default function EventDetailsPage(props: Props) {
  const router = useRouter();
  const deleteEventHandler = async () => {
    const response: any = await deleteEvent(
      props.eventDetails.event_Name,
      props.eventDetails.event_Id
    );
    if (response.status) {
      alert(response.message);
      if (props.isAdmin) {
        router.replace({
          pathname: `/events`,
        });
      } else {
        router.replace({
          pathname: `/a`,
        });
      }
    } else {
      alert(response.message);
    }
  };
  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] mx-auto mt-3`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
          >
            {props.eventDetails.event_Name}
          </span>
        </div>
      </main>
      {!props.isAdmin && (
        <button
          className={`absolute bottom-3 right-3 font-semibold px-4 py-2 rounded-3xl bg-red-400 text-white`}
          onClick={deleteEventHandler}
        >
          Delete event
        </button>
      )}
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const eventId = params?.eventId;
  const eventDetails = await fetchEventFullDetails(eventId);
  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_ADMIN_ACCESS_TOKEN];

  let isAdmin = false;
  if (userAccessToken) isAdmin = true;

  return {
    props: {
      isAdmin: isAdmin,
      eventDetails: eventDetails,
    },
  };
}
