import { parse } from "cookie";
import { EVENT_SUB_ADMIN_ACCESS_TOKEN, extractJWTValues } from "@/lib/helper";
import { fetchSubAdminClubInfo } from "@/lib/firebase/subAdminHandler";
import { useRouter } from "next/router";
import { EventInfoTile } from "@/components/EventInfoTile";
import { ClubInfoTile } from "@/components/ClubInfoTile";

type Props = {
  clubsList: any[];
  eventsList: any[];
};

export default function SubAdminPage(props: Props) {
  const router = useRouter();

  return (
    <>
      <main className={`relative w-screen`}>
        <div
          className={`relative w-[95%] flex flex-col mx-auto shadow-md p-3 rouned-lg bg-yellow-50`}
        >
          <div className={`relative flex justify-between w-full mx-auto`}>
            <span
              className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
            >
              Your Clubs
            </span>
          </div>
          <div
            className={`relative w-full flex flex-col space-y-2 mx-auto my-3`}
          >
            {props.clubsList.map((club: any, index: number) => (
              <ClubInfoTile
                key={index}
                clubInfo={club}
                routerUrlObj={{
                  pathname: `/clubs/${club.club_Id}`,
                  query: {
                    clubName: `${club.club_Name}`,
                  },
                }}
              />
            ))}
          </div>
        </div>

        <div className={`relative w-[95%] h-[1px] my-6 bg-black mx-auto`} />

        <div
          className={`relative w-[95%] flex flex-col mx-auto mt-3 shadow-md p-3 rouned-lg bg-yellow-50`}
        >
          <div className={`relative flex justify-between w-full mx-auto mt-3`}>
            <span
              className={`relative px-1 py-3 text-semibold font-mono text-2xl`}
            >
              Your Events
            </span>
            <button
              className={`relative px-3 py-1 rounded-3xl bg-red-400 hover:bg-red-500 text-white`}
              onClick={() => {
                router.push({
                  pathname: `/a/addIndependentEvent`,
                });
              }}
            >
              Add event
            </button>
          </div>
          {props.eventsList.length > 0 && (
            <div
              className={`relative w-full flex flex-col space-y-2 mx-auto my-3`}
            >
              {props.eventsList.map((event: any, index: number) => (
                <EventInfoTile
                  key={index}
                  eventInfo={event}
                  routerUrlObj={{
                    pathname: `/events/${event.event_Id}`,
                    query: {
                      eventName: `${event.event_Name}`,
                    },
                  }}
                />
              ))}
            </div>
          )}
          {props.eventsList.length === 0 && (
            <div
              className={`relative w-full flex text-center text-xl flex-col h-20 justify-center align-middle items-center space-y-2 mx-auto my-3`}
            >
              List is empty
            </div>
          )}
        </div>
        <div className={`relative w-full h-16`} />
      </main>
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { req, res } = context;
  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_SUB_ADMIN_ACCESS_TOKEN];
  const userAccessTokenObject = await extractJWTValues(userAccessToken);
  const clubsInfo = await fetchSubAdminClubInfo(userAccessTokenObject);
  let clubsList = clubsInfo.clubsList;
  let eventsList = clubsInfo.eventsList;
  return {
    props: {
      clubsList: clubsList,
      eventsList: eventsList,
    },
  };
}
