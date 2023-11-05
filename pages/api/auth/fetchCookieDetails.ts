const cookie = require("cookie");

import {
  extractJWTValues,
  EVENT_ADMIN_ACCESS_TOKEN,
  EVENT_SUB_ADMIN_ACCESS_TOKEN,
} from "@/lib/helper";

async function handler(req: any, res: any) {
  const receivedData = req.body;
  const { accessTokenType } = receivedData;
  try {
    const cookies = cookie.parse(req.headers.cookie || "");
    const userAccessToken = cookies[accessTokenType];
    const userAccessTokenObject = await extractJWTValues(userAccessToken);

    res.status(201).json({
      userCredentials: userAccessTokenObject,
      error: null,
      message: "Logged In user access token value fetched successfull!",
    });
  } catch (error) {
    res.status(422).json({
      userCredentials: null,
      error,
      message: "Error occoured",
    });
  }
}

export default handler;
