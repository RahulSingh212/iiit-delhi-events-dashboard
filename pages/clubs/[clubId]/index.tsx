import { parse } from "cookie";
import { fetchClubFullDetails } from "@/lib/firebase/clubsHandler";
import {
  EVENT_ADMIN_ACCESS_TOKEN,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
} from "@/lib/helper";
import { useRouter } from "next/router";

type Props = {
  clubDetails: any;
  isAdmin: boolean;
};

export default function ClubDetailsPage(props: Props) {
  const router = useRouter();
  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] flex flex-col mx-auto mt-2`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
          >
            {props.clubDetails.club_Name}
          </span>
        </div>
        <div className={`relative w-[95%] flex flex-col mx-auto my-2`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-lg mb-2`}
          >
            All Events of the Club
          </span>
          <div className={`relative w-full flex flex-col`}>
            {props.clubDetails.club_Events_List.map(
              (eventInfo: any, index: number) => (
                <div
                  key={index}
                  className={`relative w-full flex flex-col px-1 py-2 rounded-md bg-gray-500 hover:bg-gray-400 cursor-pointer mb-2`}
                  onClick={() => {
                    router.push({
                      pathname: `/events/${eventInfo.event_Id}`,
                    });
                  }}
                >
                  <div className={`relative w-full flex space-x-1`}>
                    <span className={`relative text-white`}>Name: </span>
                    <span className={`relative w-full`}>
                      {eventInfo.event_Name}
                    </span>
                  </div>
                  <div className={`relative w-full flex space-x-1`}>
                    <span className={`relative text-white`}>Description: </span>
                    <span className={`relative w-full`}>
                      {eventInfo.event_Description}
                    </span>
                  </div>
                </div>
              )
            )}
          </div>
        </div>
      </main>
      {!props.isAdmin && (
        <button
          className={`absolute bottom-3 right-5 rounded-3xl px-4 py-2 bg-red-400 hover:bg-red-500 cursor-pointer`}
          onClick={() => {
            router.push({
              pathname: `/clubs/${router.query.clubId}/newClubEvent`,
            });
          }}
        >
          Add New Event
        </button>
      )}
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const clubId = params?.clubId;
  const clubDetails = await fetchClubFullDetails(clubId);
  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_ADMIN_ACCESS_TOKEN];

  let isAdmin = false;
  if (userAccessToken) isAdmin = true;

  return {
    props: {
      clubDetails: clubDetails,
      isAdmin: isAdmin,
    },
  };
}
