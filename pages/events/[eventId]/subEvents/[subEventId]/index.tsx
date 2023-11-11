import { parse } from "cookie";
import {
  deleteSubEvent,
  fetchSubEventInfo,
} from "@/lib/firebase/subEventsHandler";
import { EVENT_ADMIN_ACCESS_TOKEN } from "@/lib/helper";
import Image from "next/image";
import { useRouter } from "next/router";
import { SubEventInformation } from "@/lib/classModals/eventInformation";

type Props = {
  isAdmin: boolean;
  subEventDetails: SubEventInformation;
};

export default function SubEventPage(props: Props) {
  const router = useRouter();
  const deleteSubEventHandler = async () => {
    const response: any = await deleteSubEvent(
      router.query.eventId + "",
      props.subEventDetails.subEvent_Name,
      router.query.subEventId + ""
    );

    alert(response.message);
    if (response.status) {
      router.replace({
        pathname: `/events/${router.query.eventId}`,
      });
    }
  };

  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] mx-auto mt-3`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl font-semibold`}
          >
            {props.subEventDetails.subEvent_Name}
          </span>
        </div>
      </main>
      {!props.isAdmin && (
        <button
          className={`absolute bottom-3 right-3 font-semibold px-4 py-2 rounded-3xl bg-red-400 text-white`}
          onClick={deleteSubEventHandler}
        >
          Delete sub event
        </button>
      )}
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const eventId = params?.eventId;
  const subEventId = params?.subEventId;
  const subEventDetails = await fetchSubEventInfo(eventId, subEventId);

  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_ADMIN_ACCESS_TOKEN];
  let isAdmin = false;
  if (userAccessToken) isAdmin = true;

  return {
    props: {
      isAdmin: isAdmin,
      subEventDetails: subEventDetails,
    },
  };
}
