import { DashboardNavbar } from "../navbar/DashNavbar";

type Props = {
  children:
    | string
    | number
    | boolean
    | React.ReactElement<any, string | React.JSXElementConstructor<any>>
    | React.ReactFragment
    | React.ReactPortal
    | null
    | undefined;
};

export default function WebsiteLayout(props: Props) {
  return (
    <>
      <DashboardNavbar />
      {props.children}
    </>
  );
}
