import { AddNewEvent } from "@/components/AddNewEvent";
import { SUB_EVENT } from "@/lib/helper";

type Props = {};

export default function NewSubEventPage(props: Props) {
  return (
    <main className={`w-screen`}>
      <div className={`relative w-full text-2xl text-center mt-2 mb-5`}>
        Add New Independent Event
      </div>
      <div className={`relative w-[90%] mx-auto`}>
        <AddNewEvent eventType={SUB_EVENT} />
      </div>
    </main>
  );
}
