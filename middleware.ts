import { NextRequest, NextResponse } from "next/server";
import Router from "next/router";
import {
  EVENT_ADMIN_ACCESS_TOKEN,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
} from "./lib/helper";

export function middleware(req: NextRequest, res: NextResponse) {
  const response = NextResponse.next();
  const userAccessTokenAdmin = req.cookies.get(EVENT_ADMIN_ACCESS_TOKEN);
  const userAccessTokenSubAdmin = req.cookies.get(EVENT_SUB_ADMIN_ACCESS_TOKEN);

  if (
    !userAccessTokenAdmin &&
    !userAccessTokenSubAdmin &&
    req.nextUrl.pathname !== "/login"
  ) {
    return NextResponse.redirect(new URL("/login", req.url));
  }
  if (userAccessTokenAdmin) {
    if (
      !req.nextUrl.pathname.startsWith("/h") &&
      !req.nextUrl.pathname.startsWith("/clubs")
    ) {
      return NextResponse.redirect(new URL("/h", req.url));
    }
  }
  if (userAccessTokenSubAdmin) {
    if (
      !req.nextUrl.pathname.startsWith("/a") &&
      !req.nextUrl.pathname.startsWith("/profile") &&
      (req.nextUrl.pathname.startsWith("/clubs")
        ? (req.nextUrl.pathname.match(/\//g) || []).length < 2
        : true) &&
      (req.nextUrl.pathname.startsWith("/events")
        ? (req.nextUrl.pathname.match(/\//g) || []).length < 2
        : true)
    ) {
      return NextResponse.redirect(new URL("/a", req.url));
    }
  }

  return response;
}

export const config = {
  matcher: ["/", "/login", "/a", "/h", "/events", "/clubs", "/profile"],
};
