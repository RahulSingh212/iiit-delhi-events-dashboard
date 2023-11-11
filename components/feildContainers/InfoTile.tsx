import { UPDATE_CLUB, UPDATE_EVENT } from "@/lib/helper";
import { useRouter } from "next/router";
import React from "react";

type Props = {
  handlerType: string;
  firebaseHeaderName: string;
  headerText: string;
  tileText: string;
  descriptionText: string;
  placeHolderText: string;
  inputType: string;
};

export const updateClubDetailsHandler = async (
  clubId: string,
  header: string,
  value: string
) => {
  const response = await fetch("/api/club/updateClubInfo", {
    method: "POST",
    body: JSON.stringify({
      clubId: clubId,
      keyVal: header,
      value: value,
    }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await response.json();
  // console.log(data);
  return data;
};

export const updateEventDetailsHandler = async (
  eventId: string,
  header: string,
  value: string
) => {
  const response = await fetch("/api/event/updateEventInfo", {
    method: "POST",
    body: JSON.stringify({
      eventId: eventId,
      keyVal: header,
      value: value,
    }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await response.json();
  // console.log(data);
  return data;
};

export default function InfoTile(props: Props) {
  const router = useRouter();
  const [editBtn, setEditBtn] = React.useState<boolean>(false);
  const [inputValue, setInputValue] = React.useState<string>(props.tileText);

  const saveTextHandler = async () => {
    if (props.handlerType === UPDATE_CLUB) {
      const responseData = await updateClubDetailsHandler(
        router.query.clubId + "",
        props.firebaseHeaderName,
        inputValue
      );
    } else if (props.handlerType === UPDATE_EVENT) {
      const responseData = await updateEventDetailsHandler(
        router.query.eventId + "",
        props.firebaseHeaderName,
        inputValue
      );
    }
    setEditBtn(false);
  };

  return (
    <>
      <div
        className={`relative flex flex-col w-full rounded-2xl py-5 px-4 bg-slate-100 hover:bg-slate-200`}
      >
        <div
          className={`realtive flex flex-row justify-between mb-1 align-middle `}
        >
          <div
            className={`relative flex justify-center align-middle items-center text-left text-xl font-sans`}
          >
            {props.headerText}
          </div>
          <div
            onClick={() => {
              if (editBtn) {
                setInputValue(props.tileText);
              }
              setEditBtn(!editBtn);
            }}
            className={`relative flex items-center p-1 rounded-3xl bg-slate-400 ${
              editBtn ? `px-3` : "px-5"
            } py-1 text-white cursor-pointer text-sm font-medium`}
          >
            {editBtn ? "Cancel" : inputValue.length === 0 ? "Add" : "Edit"}
          </div>
        </div>
        {!editBtn && (
          <div className={`text-lg text-gray-500`}>
            {inputValue.length === 0 ? "✹ Not provided ✹" : inputValue}
          </div>
        )}
        {editBtn && (
          <div className={`relative flex flex-col w-full`}>
            <div className={`relative flex text-md text-gray-500 font-light`}>
              {props.descriptionText}
            </div>
            <div className={`relative flex my-6`}>
              <input
                className={`py-4 px-3 rounded-lg border border-gray-400 text-lg w-full md:w-[80%] xl:[60%]`}
                type={props.inputType}
                name="email"
                placeholder={props.placeHolderText}
                value={inputValue}
                onChange={(val) => {
                  setInputValue(val.target.value);
                }}
              />
            </div>
            <div
              onClick={saveTextHandler}
              className={`relative flex w-fit py-2 px-7 rounded-lg bg-black text-white font-medium text-lg cursor-pointer`}
            >
              Save
            </div>
          </div>
        )}
      </div>
    </>
  );
}
