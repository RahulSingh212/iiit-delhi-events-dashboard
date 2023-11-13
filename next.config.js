/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  css: ["styles/global.css"],
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "**",
      },
    ],
    unoptimized: true,
    loader: "default",
    dangerouslyAllowSVG: true,
  },
};

module.exports = nextConfig;
