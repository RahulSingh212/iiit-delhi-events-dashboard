import { EventInformation } from "@/lib/classModals/eventInformation";
import { qrEventStatus } from "@/lib/firebase/eventsHandler";
import Image from "next/image";

type Props = {
  eventInfo: EventInformation;
  userInfo: any;
  status: boolean;
};

export default function EventRegistration(props: Props) {
  return (
    <main className={`relative w-screen`}>
      {props.eventInfo && props.userInfo && (
        <div className={`relative flex flex-col w-[95%] mx-auto my-4`}>
          <div
            className={`relative flex flex-col space-y-4 px-2 py-2 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
          >
            <div
              className={`relative flex space-x-2 align-middle items-center`}
            >
              <Image
                alt="img"
                src={`/images/event.svg`}
                className={`w-12 h-12 p-[1px] rounded-md`}
                width={5}
                height={5}
              />
              <span className={`relative w-full font-bold text-2xl font-serif`}>
                {props.eventInfo.event_Name}
              </span>
            </div>
            <div
              className={`relative flex flex-col space-y-1 p-2 bg-white rounded-md shadow-md`}
            >
              <span className={`relative w-full font-semibold text-xl`}>
                About{" "}
              </span>
              <span className={`font-mono`}>
                {props.eventInfo.event_Description}
              </span>
            </div>
          </div>

          <div className={`relative w-full my-4 h-[1px] bg-black`} />

          <div className={`relative w-full flex flex-col space-y-2`}>
            <div className={`relative w-full flex flex-row space-x-3`}>
              <span className={`relative font-semibold text-lg`}>Name:</span>
              <span
                className={`relative font-semibold text-xl font-serif text-gray-500`}
              >
                {props.userInfo.displayName}
              </span>
            </div>
            <div className={`relative w-full flex flex-row space-x-3`}>
              <span className={`relative font-semibold text-lg`}>Email:</span>
              <span
                className={`relative font-semibold text-xl font-serif text-gray-500`}
              >
                {props.userInfo.email}
              </span>
            </div>
            <div className={`relative w-full flex flex-row space-x-3`}>
              <span className={`relative font-semibold text-lg`}>
                Registration Status:
              </span>
              <span
                className={`relative font-semibold text-xl font-serif text-gray-500`}
              >
                {`${
                  props.status
                    ? "User is registered for the event."
                    : "User is not registered for the event."
                }`}
              </span>
            </div>
          </div>
        </div>
      )}
      {(!props.eventInfo || !props.userInfo) && (
        <div
          className={`relative w-full h-screen flex justify-center align-middle items-center`}
        >
          <span className={`text-2xl font-mono text-gray-400`}>
            Invalid Ticket
          </span>
        </div>
      )}
    </main>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = await context;
  const eventId = query.uid.split("-")[0];
  const userId = query.uid.split("-")[1];

  const { eventInfo, userInfo, status } = await qrEventStatus(eventId, userId);

  return {
    props: {
      eventInfo: eventInfo,
      userInfo: userInfo,
      status: status,
    },
  };
}
