import { fetchClubsInfoList } from "@/lib/firebase/clubsHandler";
import { useRouter } from "next/router";

type Props = {
  clubsList: any[];
};

export default function ClubsListPage(props: Props) {
  const router = useRouter();
  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-[95%] mx-auto mt-3`}>
          <span
            className={`relative w-full px-1 py-3 text-semibold font-mono text-2xl`}
          >
            All Clubs
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
      </main>
    </>
  );
}

export async function getServerSideProps(context: any) {
  const { req, res } = context;
  const clubsInfoList = await fetchClubsInfoList();
  return {
    props: {
      clubsList: clubsInfoList,
    },
  };
}
