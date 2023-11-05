import { useState } from "react";

type Props = {};

export const NewClub = (props: Props) => {
  const [clubName, setClubName] = useState<string>("");
  return (
    <div
      className={`relative w-full flex flex-col space-y-2 rounded-md mx-auto p-2 bg-gray-200`}
    >
      <TextContainer
        title={`Club Name`}
        placeholder={`Enter the name of the club`}
        value={clubName}
        setHandler={setClubName}
      />
    </div>
  );
};

const TextContainer = (props: any) => {
  return (
    <div className={`relative w-full flex flex-col`}>
      <h4 className={`relative w-full`}>{props.title}</h4>
      <input
        className="rounded-sm p-1 bg-blue-50"
        placeholder={props.placeholder}
        value={props.value}
        onChange={(e) => {
          props.setHandler(String(e.target.value));
        }}
      />
    </div>
  );
};
