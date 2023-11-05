import { parse } from "cookie";
import { EVENT_SUB_ADMIN_ACCESS_TOKEN, extractJWTValues } from "@/lib/helper";
import { fetchSubAdminClubInfo } from "@/lib/firebase/subAdminHandler";
import { useRouter } from "next/router";

type Props = {
  clubsList: any[];
  eventsList: any[];
};

export default function SubAdminPage(props: Props) {
  const router = useRouter();

  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] mx-auto mt-3`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
          >
            Your Clubs
          </span>
        </div>
        <div
          className={`relative w-[95%] flex flex-col space-y-2 mx-auto my-5`}
        >
          {props.clubsList.map((club: any, index: number) => (
            <div
              onClick={() => {
                router.push({
                  pathname: `/clubs/${club.club_Id}`,
                });
              }}
              key={index}
              className={`relative flex flex-col space-y-1 px-3 py-1 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
            >
              <span>{club.club_Name}</span>
              <span>{club.club_Description}</span>
            </div>
          ))}
        </div>
        <div className={`relative w-[95%] mx-auto mt-3`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
          >
            Your Events
          </span>
        </div>
        <div
          className={`relative w-[95%] flex flex-col space-y-2 mx-auto my-5`}
        >
          {props.eventsList.map((event: any, index: number) => (
            <div
              onClick={() => {
                router.push({
                  pathname: `/events/${event.event_Id}`,
                });
              }}
              key={index}
              className={`relative flex flex-col space-y-1 px-3 py-1 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
            >
              <span>{event.event_Name}</span>
              <span>{event.event_Description}</span>
            </div>
          ))}
        </div>
      </main>
      <button
        className={`absolute bottom-3 right-3 px-3 py-2 rounded-3xl bg-red-400 hover:bg-red-500 text-white`}
        onClick={() => {
          router.push({
            pathname: `/a/addIndependentEvent`
          })
        }}
      >
        Add independent event
      </button>
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
