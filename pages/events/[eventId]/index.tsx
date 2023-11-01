import { fetchEventFullDetails } from "@/lib/firebase/eventsHandler";


type Props = {
  eventDetails: any;
};

export default function EventDetailsPage(props: Props) {
  return (
    <main className={`relative w-screen`}>
      <div className={`relative w-[95%] mx-auto mt-3`}>
        <span
          className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
        >
          {props.eventDetails.event_Name}
        </span>
      </div>
    </main>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const eventId = params?.eventId;
  const eventDetails = await fetchEventFullDetails(eventId);

  return {
    props: {
        eventDetails: eventDetails,
    },
  };
}
