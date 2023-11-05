import { AddNewClubEvent } from "@/components/AddNewClubEvent";

type Props = {};

export default function NewClubEventPage(props: Props) {
  return (
    <main className={`w-screen`}>
      <div className={`relative w-full text-2xl text-center mt-2 mb-5`}>
        Add New Event for the Club
      </div>
      <div className={`relative w-[90%] mx-auto`}>
        <AddNewClubEvent />
      </div>
    </main>
  );
}
