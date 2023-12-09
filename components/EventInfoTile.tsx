import Image from "next/image";
import { EventInformation } from "@/lib/classModals/eventInformation";
import { useRouter } from "next/router";

type Props = {
  eventInfo: EventInformation;
  routerUrlObj: any;
};

export const EventInfoTile = (props: Props) => {
  const router = useRouter();

  return (
    <div
      onClick={() => {
        router.push(props.routerUrlObj);
      }}
      className={`relative flex flex-col space-y-4 px-2 py-2 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
    >
      <div className={`relative flex space-x-2 align-middle items-center`}>
        <Image
          alt="img"
          src={`/images/event.svg`}
          className={`w-12 h-12 p-[1px] rounded-md`}
          width={5}
          height={5}
        />
        <span className={`relative w-full font-bold text-2xl font-serif`}>
          {props.eventInfo.event_Name}
        </span>
      </div>
      <div
        className={`relative flex flex-col space-y-1 p-2 bg-white rounded-md shadow-md`}
      >
        <span className={`relative w-full font-semibold text-xl`}>About </span>
        <span className={`font-mono`}>{props.eventInfo.event_Description}</span>
      </div>
    </div>
  );
};
