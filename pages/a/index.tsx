import { parse } from "cookie";
import { EVENT_SUB_ADMIN_ACCESS_TOKEN, extractJWTValues } from "@/lib/helper";
import { fetchSubAdminClubInfoList } from "@/lib/firebase/subAdminHandler";
import { useRouter } from "next/router";

type Props = {
  clubsList: any[];
};

export default function SubAdminPage(props: Props) {
  const router = useRouter();

  return (
    <main className={`relative w-screen`}>
      <div className={`relative w-[95%] mx-auto mt-3`}>
        <span
          className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
        >
          Available Clubs
        </span>
      </div>
      <div className={`relative w-[95%] flex flex-col space-y-2 mx-auto my-5`}>
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
          Your Independent Events
        </span>
      </div>
    </main>
  );
}

export async function getServerSideProps(context: any) {
  const { req, res } = context;
  const cookies = parse(req.headers.cookie || "");
  const userAccessToken = cookies[EVENT_SUB_ADMIN_ACCESS_TOKEN];
  const userAccessTokenObject = await extractJWTValues(userAccessToken);
  const clubsList = await fetchSubAdminClubInfoList(userAccessTokenObject);
  return {
    props: {
      clubsList: clubsList,
    },
  };
}
