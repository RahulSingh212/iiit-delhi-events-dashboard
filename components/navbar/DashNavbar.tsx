import Image from "next/image";
import Link from "next/link";

export const DashboardNavbar = () => {
  return (
    <div
      className={`sticky top-0 w-full flex justify-between px-2 py-1 rounded-b-md bg-gray-500 z-30`}
    >
      <Link href={`/`} className={`relative my-auto`}>
        <Image
          alt="profile"
          src={`/images/iiitd-logo.jpeg`}
          className={`w-40 h-12`}
          width={5}
          height={5}
        />
      </Link>
      <Link
        href={`/profile`}
        className={`relative flex my-auto space-x-4 align-middle items-center px-3 rounded-lg bg-gray-400 `}
      >
        <span className={`text-semibold my-auto text-white text-2xl`}>Profile</span>
        <Image
          alt="profile"
          src={`/images/profile.svg`}
          className={`w-16 h-16 p-[1px] rounded-full`}
          width={5}
          height={5}
        />
      </Link>
    </div>
  );
};
