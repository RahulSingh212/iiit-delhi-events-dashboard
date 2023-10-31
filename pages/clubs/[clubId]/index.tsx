import { fetchClubFullDetails } from "@/lib/firebase/clubsHandler";

type Props = {
  clubDetails: any;
};

export default function ClubDetailsPage(props: Props) {
  return <main className={``}>{props.clubDetails.club_Name}</main>;
}

export async function getServerSideProps(context: any) {
  const { params, query, req, res } = context;
  const clubId = params?.clubId;
  const clubDetails = await fetchClubFullDetails(clubId);

  return {
    props: {
      clubDetails: clubDetails,
    },
  };
}
