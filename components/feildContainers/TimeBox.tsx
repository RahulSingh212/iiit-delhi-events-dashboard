import { format } from "date-fns";
import Image from "next/image";
import Calendar from "react-calendar";
import TimePicker from "react-time-picker";

type Props = {
  title: string;
  time: any;
  setTime: Function;
  showCalendar: boolean;
  setShowCalendar: Function;
};

export const TimeBox = (props: Props) => {
  return (
    <div className={`relative flex flex-col`}>
      <span
        className={`absolute bg-white -mt-[6px] ml-3 z-10 font-serif text-xs`}
      >
        {props.title}
      </span>
      <div
        className={`relative flex space-x-2 md:space-x-5 px-2 py-2 my-auto rounded-md border-[1.5px] border-gray-400 hover:border-gray-500`}
      >
        <span className={`relative my-auto`}>{`${props.time}`}</span>
        <Image
          onClick={() => {
            props.setShowCalendar(!props.showCalendar);
          }}
          alt="calendar"
          className={`relative w-8 h-8 cursor-pointer my-auto items-center p-[5px] rounded-md hover:bg-gray-200`}
          src={`/icons/calendar.svg`}
          width={10}
          height={10}
        />
      </div>
      {props.showCalendar && (
        <div
          className={`absolute mx-auto p-1 rounded-md top-14 bg-white left-0 z-50`}
        >
          <div className={`relative w-full h-full bg-white`}>
            <TimePicker value={props.time} onChange={(e: any) => {
                console.log(e);
                // props.setTime();
            }} />
          </div>
        </div>
      )}
    </div>
  );
};
