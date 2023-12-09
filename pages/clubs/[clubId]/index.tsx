import { parse } from "cookie";
import { fetchClubFullDetails } from "@/lib/firebase/clubsHandler";
import {
  UPDATE_CLUB,
  EVENT_ADMIN_ACCESS_TOKEN,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
} from "@/lib/helper";
import { useRouter } from "next/router";
import InfoTile from "@/components/feildContainers/InfoTile";
import { ClubInformation } from "@/lib/classModals/clubInformation";
import { EventInfoTile } from "@/components/EventInfoTile";

type Props = {
  clubDetails: ClubInformation;
  isAdmin: boolean;
};

export default function ClubDetailsPage(props: Props) {
  const router = useRouter();
  return (
    <>
      <main className={`relative w-screen`}>
        <div
          className={`relative w-[95%] flex flex-col mx-auto mt-5 space-y-2`}
        >
          <span
            className={`relative w-full text-center flex text-3xl font-serif justify-center mb-4`}
          >
            Club Details
          </span>
          <InfoTile
            isEditable={props.isAdmin}
            handlerType={UPDATE_CLUB}
            firebaseHeaderName={"club_Name"}
            headerText={"Club Name"}
            tileText={props.clubDetails.club_Name}
            placeHolderText={"Club Name"}
            descriptionText={"Enter the name of the club"}
            inputType={"text"}
          />
          <InfoTile
            isEditable={props.isAdmin}
            handlerType={UPDATE_CLUB}
            firebaseHeaderName={"club_Description"}
            headerText={"Club Description"}
            tileText={props.clubDetails.club_Description}
            placeHolderText={"Club Name"}
            descriptionText={"Enter the name of the club"}
            inputType={"text"}
          />
        </div>

        <div className={`relative w-[95%] h-[1px] my-6 bg-black mx-auto`} />

        <div
          className={`relative w-[95%] flex flex-col mx-auto mt-3 shadow-md p-3 rouned-lg bg-yellow-50`}
        >
          <div className={`relative flex justify-between w-full mx-auto mt-3`}>
            <span
              className={`relative px-1 py-3 text-semibold font-mono text-2xl`}
            >
              All Events of the Club
            </span>
            {!props.isAdmin && (
              <button
                className={`relative px-3 py-1 rounded-3xl bg-red-400 hover:bg-red-500 text-white`}
                onClick={() => {
                  router.push({
                    pathname: `/clubs/${router.query.clubId}/newClubEvent`,
                    query: {
                      clubName: `${props.clubDetails.club_Name}`,
                    },
                  });
                }}
              >
                Add New Event
              </button>
            )}
          </div>
          {props.clubDetails.club_Events_List.length > 0 && (
            <div
              className={`relative w-full flex flex-col space-y-2 mx-auto my-3`}
            >
              {props.clubDetails.club_Events_List.map(
                (event: any, index: number) => (
                  <EventInfoTile
                    key={index}
                    eventInfo={event}
                    routerUrlObj={{
                      pathname: `/events/${event.event_Id}`,
                      query: {
                        clubName: `${props.clubDetails.club_Name}`,
                      },
                    }}
                  />
                )
              )}
            </div>
          )}
          {props.clubDetails.club_Events_List.length === 0 && (
            <div
              className={`relative w-full flex text-center text-xl flex-col h-20 justify-center align-middle items-center space-y-2 mx-auto my-3`}
            >
              List is empty
            </div>
          )}
        </div>

        <div className={`relative w-full h-12`} />
      </main>
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
