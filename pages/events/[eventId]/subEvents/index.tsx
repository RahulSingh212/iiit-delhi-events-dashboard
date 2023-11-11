import Image from "next/image";
import { useRouter } from "next/router";

export default function AllSubEventsPage() {
  const router = useRouter();
  return (
    <main className={`relative w-screen`}>
      <span className={`relative p-3 text-lg bg-gray-500`}>All SubEvents</span>
    </main>
  );
}
