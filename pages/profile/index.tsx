import { userLogoutHandler } from "@/lib/firebase/userHandler";
import Image from "next/image";
import { useRouter } from "next/router";

export default function ProfilePage() {
  const router = useRouter();
  return (  
    <main className={`relative w-screen`}>
      <div className={`relative w-full flex justify-center`}>
        <button
          onClick={userLogoutHandler.bind(null, router)}
          className={`relative mx-auto px-4 py-2 rounded-md bg-black text-white font-semibold`}
        >
          Logout
        </button>
      </div>
    </main>
  );
}
