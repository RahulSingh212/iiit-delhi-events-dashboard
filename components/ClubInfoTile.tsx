import Image from "next/image";
import { useRouter } from "next/router";
import { ClubInformation } from "@/lib/classModals/clubInformation";

type Props = {
  clubInfo: ClubInformation;
  routerUrlObj: any;
};

export const ClubInfoTile = (props: Props) => {
  const router = useRouter();

  return (
    <div
      onClick={() => {
        router.push(props.routerUrlObj);
      }}
      className={`relative flex flex-col space-y-3 px-2 py-2 rounded-md bg-gray-200 cursor-pointer hover:bg-gray-300`}
    >
      <div
        className={`relative w-full flex space-x-3 align-middle items-center`}
      >
        <Image
          alt="profile"
          src={props.clubInfo.club_Logo_Url}
          className={`w-16 h-16 rounded-full my-auto `}
          height={10}
          width={10}
        />
        <span className={`font-serif text-2xl font-semibold`}>
          {props.clubInfo.club_Name}
        </span>
      </div>
      <div
        className={`relative flex flex-col space-y-1 p-2 bg-white rounded-md shadow-md`}
      >
        <span className={`relative w-full font-semibold text-xl`}>About </span>
        <span className={`font-mono`}>{props.clubInfo.club_Description}</span>
      </div>
    </div>
  );
};
