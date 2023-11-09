import { useState } from "react";
import Image from "next/image";
import { TextContainer } from "./feildContainers/TextContainer";

type Props = {};

export const AddNewClub = (props: Props) => {
  const [clubName, setClubName] = useState<string>("");
  const [clubDescription, setClubDescription] = useState<string>("");
  const [eventImageUrl, setEventImageUrl] = useState<string>("");

  const submitClubHandler = async () => {
    
  }

  return (
    <>
      <div
        className={`relative w-full flex flex-col rounded-md mx-auto p-2 space-y-2 bg-gray-200 z-10`}
      >
        <TextContainer
          title={`Club Name`}
          placeholder={`Enter the name of the club`}
          value={clubName}
          setHandler={setClubName}
        />
        <TextContainer
          title={`Club Description`}
          placeholder={`Enter the description of the club`}
          value={clubDescription}
          setHandler={setClubDescription}
        />
        <div className={`relative w-full flex flex-row space-x-3`}>
          <Image
            alt={`image`}
            src={eventImageUrl === "" ? "/icons/gallery.svg" : ""}
            className={`mx-auto w-24 h-24`}
            width={10}
            height={10}
          />
          <TextContainer
            title={`Club Image Url`}
            placeholder={`Enter the image url of the club`}
            value={eventImageUrl}
            setHandler={setEventImageUrl}
          />
        </div>
      </div>
      <div className={`relative w-full flex justify-center my-5`}>
        <button
          onClick={submitClubHandler}
          className={`relative px-4 py-2 bg-red-400 hover:bg-red-500 font-semibold text-white mx-auto rounded-3xl`}
        >
          Add Club
        </button>
      </div>
      <div className={`h-16`}></div>
    </>
  );
};
