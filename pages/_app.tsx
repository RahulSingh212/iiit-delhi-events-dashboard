import "@/styles/globals.css";
import type { AppProps } from "next/app";
import WebsiteLayout from "@/components/layout/WebsiteLayout";

import Router, { useRouter } from "next/router";
import ProgressBar from "@badrap/bar-of-progress";

const progress = new ProgressBar({
  size: 4,
  color: "#FE595E",
  className: "z-100",
  delay: 100,
});

Router.events.on("routeChangeStart", progress.start);
Router.events.on("routeChangeComplete", progress.finish);
Router.events.on("routeChangeError", progress.finish);

export default function App({ Component, pageProps }: AppProps) {
  const router = useRouter();

  if (router.pathname.startsWith("/login")) {
    return <Component {...pageProps} />;
  }

  return (
    <WebsiteLayout>
      <Component {...pageProps} />
    </WebsiteLayout>
  );
}
