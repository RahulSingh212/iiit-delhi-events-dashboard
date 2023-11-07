import { fetchClubsInfoList } from "@/lib/firebase/clubsHandler";
import { useRouter } from "next/router";

type Props = {};

export default function AdminPage(props: Props) {
  const router = useRouter();
  return (
    <>
      <main className={`relative w-screen`}>
        <button
          onClick={() => {
            router.push({
              pathname: `/clubs`,
            });
          }}
          className={`realtive px-3 py-2 rounded-3xl bg-red-400 text-white`}
        >
          See all Clubs
        </button>
      </main>
    </>
  );
}
