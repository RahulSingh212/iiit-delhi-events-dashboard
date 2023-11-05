import { AddNewIndependentEvent } from "@/components/NewIndEvnt";

type Props = {
    
};

export default function NewClubEventPage(props: Props) {
  return (
    <main className={`w-screen`}>
      <div className={`relative w-full text-2xl text-center mt-2 mb-5`}>
        Add New Independent Event
      </div>
      <div className={`relative w-[90%] mx-auto`}>
        <AddNewIndependentEvent />
      </div>
    </main>
  );
}
