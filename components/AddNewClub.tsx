import { useState } from "react";
import Image from "next/image";
import { TextContainer } from "./feildContainers/TextContainer";
import { ClubInformation } from "@/lib/classModals/clubInformation";
import { createNewIndependentClubHandler } from "@/lib/firebase/clubsHandler";
import { useRouter } from "next/router";

type Props = {};

export const AddNewClub = (props: Props) => {
  const router = useRouter();
  const [clubName, setClubName] = useState<string>("");
  const [clubDescription, setClubDescription] = useState<string>("");
  const [clubImageUrl, setClubImageUrl] = useState<string>("");
  const [adminEmail, setAdminEmail] = useState<string>("");

  const submitClubHandler = async () => {

    let clubInfo = new ClubInformation();
    clubInfo.club_Name = clubName;
    clubInfo.club_Description = clubDescription;
    clubInfo.club_Logo_Url = clubImageUrl;

    const response: any = await createNewIndependentClubHandler(
      clubInfo,
      adminEmail
    );

    if (response.status) {
      alert(response.message);
      router.replace({
        pathname: `/clubs`,
      });
    }
    else {
      alert(response.message);
    }
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
        <TextContainer
          title={`Club Admin Email`}
          placeholder={`Enter the email-id of admin of the club`}
          value={adminEmail}
          setHandler={setAdminEmail}
        />
        <div className={`relative w-full flex flex-row space-x-3`}>
          <Image
            alt={`image`}
            src={clubImageUrl === "" ? "/icons/gallery.svg" : ""}
            className={`mx-auto w-24 h-24`}
            width={10}
            height={10}
          />
          <TextContainer
            title={`Club Image Url`}
            placeholder={`Enter the image url of the club`}
            value={clubImageUrl}
            setHandler={setClubImageUrl}
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
