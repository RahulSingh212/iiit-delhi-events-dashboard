import { format } from "date-fns";
import Image from "next/image";
import Calendar from "react-calendar";

type Props = {
  title: string;
  date: Date;
  setDate: Function;
  showCalendar: boolean;
  setShowCalendar: Function;
};

export const DateBox = (props: Props) => {
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
        <span className={`relative my-auto`}>
          {`${format(props.date, "dd/MM/yyyy")}`}
        </span>
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
            <Calendar
              className={`w-72 h-44 bg-white align-middle`}
              minDate={new Date()}
              // maxDate={props.maxDateValue}
              value={props.date}
              onChange={(newDate: any) => {
                props.setDate(newDate);
                props.setShowCalendar(false);
              }}
            />
          </div>
        </div>
      )}
    </div>
  );
};
