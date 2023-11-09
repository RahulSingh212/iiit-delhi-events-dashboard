import { AddNewClub } from "@/components/AddNewClub";
import { fetchClubsInfoList } from "@/lib/firebase/clubsHandler";
import { useRouter } from "next/router";

type Props = {};

export default function ClubsListPage(props: Props) {
  const router = useRouter();
  return (
    <>
      <main className={`relative w-screen`}>
        <div className={`relative w-full text-2xl text-center mt-2 mb-5`}>
          Add New Club
        </div>

        <div className={`relative w-[90%] mx-auto`}>
          <AddNewClub />
        </div>
      </main>
    </>
  );
}
