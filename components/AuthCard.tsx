import { useState, useRef } from "react";
import { useRouter } from "next/router";
import Image from "next/image";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/20/solid";
import { googleAuthentication } from "@/lib/firebase/userHandler";
import {
  EMAIL_LOGIN,
  EMAIL_SIGNUP,
  EVENT_USER_ADMIN,
  EVENT_USER_SUB_ADMIN,
  getErrorMessage,
} from "@/lib/helper";

export const userEmailAuthApiHandler = async (
  authType: any,
  userEmail: any,
  userPassword: any,
  userType: string
) => {
  const response = await fetch("/api/auth/userEmailAuth", {
    method: "POST",
    body: JSON.stringify({ authType, userEmail, userPassword, userType }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = await response.json();
  return data;
};

type Props = {};

export const AuthCard = (props: Props) => {
  const router = useRouter();
  const emailInputRef = useRef<HTMLInputElement>(null);
  const passwordInputRef = useRef<HTMLInputElement>(null);
  const confirmPasswordInputRef = useRef<HTMLInputElement>(null);

  const [loadingModelVisible, setLoadingModel] = useState<boolean>(false);
  const [errorModelVisible, setErrorModel] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string>("");

  const [googleLogin, setGoogleLogin] = useState<boolean>(false);
  const [isLogin, setIsLogin] = useState<boolean>(true);
  const [isPasswordVisible, setPasswordVisible] = useState<boolean>(false);
  const [isConfirmPasswordVisible, setConfirmPasswordVisible] =
    useState<boolean>(false);
  const [userType, setUserType] = useState<string>("");

  const googleLoginHandler = async () => {
    if (userType === "") {
      alert("Please select the user type");
      return;
    }
    const userResponse = await googleAuthentication(userType);
    if (!userResponse.userCredentials && !userResponse.error) {
      setErrorMessage(String(userResponse.message));
      setErrorModel(true);
    } else if (userResponse.error) {
      const displayErrorMsg = await getErrorMessage(
        "Google authentication error!"
      );
      setErrorMessage(String(displayErrorMsg));
      setErrorModel(true);
    } else {
      setLoadingModel(true);
      if (userType === EVENT_USER_ADMIN) {
        router.replace("/h");
      } else {
        router.replace("/a");
      }
    }
  };

  const emailLoginHandler = async (event: any) => {
    event.preventDefault();
    if (userType === "") {
      alert("Please select the user type");
      return;
    }

    setLoadingModel(true);

    const enteredEmail = emailInputRef.current?.value;
    const enteredPassword = passwordInputRef.current?.value;
    const enteredConfirmPassword = confirmPasswordInputRef.current?.value;

    if (!isLogin && enteredPassword !== enteredConfirmPassword) {
      setLoadingModel(false);
      setErrorMessage("Password does not match!");
      setErrorModel(true);
      return;
    }

    try {
      const userResponse = await userEmailAuthApiHandler(
        isLogin ? EMAIL_LOGIN : EMAIL_SIGNUP,
        enteredEmail,
        enteredPassword,
        userType
      );
      if (userResponse.error) {
        setLoadingModel(false);
        setErrorModel(true);
        const displayErrorMsg = await getErrorMessage(userResponse.error.code);
        setErrorMessage(String(displayErrorMsg));
        alert(displayErrorMsg);
      } else if (!userResponse.userCredentials) {
        alert(userResponse.message);
      } else {
        setLoadingModel(true);
        if (userType === EVENT_USER_ADMIN) {
          router.replace("/h");
        } else {
          router.replace("/a");
        }
      }
    } catch (error: any) {
      setLoadingModel(false);
      setErrorModel(true);
      setErrorMessage("Authentication failed!");
    }
  };

  return (
    <div
      className={`relative w-[90%] sm:w-[95%] md:w-[60%] lg:w-[45%] xl:w-[37.5%] flex justify-between shadow-2xl rounded-2xl my-8 p-5 bg-gray-100 mx-auto`}
      data-testid="auth-card"
    >
      <div
        className={`relative flex flex-col w-full h-full items-center justify-center`}
      >
        <div className={`relative w-full mb-2`}>
          <h2
            className={`text-4xl font-semibold font-serif text-gray-600 text-center`}
          >
            {isLogin ? "Log-in" : "Sign-up"}
          </h2>
        </div>

        <div className={`relative w-full mb-2`}>
          <p className={`font-light text-md text-red-600 text-center`}>
            Please enter your credentails
          </p>
        </div>

        <div className={`relative flex w-full mb-6`}>
          <div className={`relative mx-auto`}>
            <label>Select User Type:</label>
            <select
              value={userType}
              onChange={(event) => {
                console.log(event.target.value);
                setUserType(event.target.value);
              }}
            >
              <option value={""}>Select User</option>
              <option value={EVENT_USER_ADMIN}>Admin</option>
              <option value={EVENT_USER_SUB_ADMIN}>Sub Admin</option>
            </select>
          </div>
        </div>
        <div
          className={`relative flex w-full align-middle items-center justify-center`}
        >
          <form
            onSubmit={emailLoginHandler}
            className={`flex flex-col w-full gap-4 align-middle items-center justify-center`}
            action=""
          >
            <input
              className={`p-3 rounded-xl border w-full lg:w-[80%] xl:[60%]`}
              type="text"
              name="email"
              placeholder="Email"
              ref={emailInputRef}
            />
            <div className={`relative w-full lg:w-[80%] xl:[60%]`}>
              <input
                className={`p-3 rounded-xl border w-full`}
                type={isPasswordVisible ? "text" : "password"}
                name="password"
                placeholder="Password"
                ref={passwordInputRef}
              />
              <div
                onClick={() => setPasswordVisible(!isPasswordVisible)}
                className={`absolute right-2 rounded-full bottom-1/4 cursor-pointer`}
              >
                {isPasswordVisible ? (
                  <EyeIcon className={`relative h-5 w-5 rounded-full`} />
                ) : (
                  <EyeSlashIcon className={`relative h-5 w-5 rounded-full`} />
                )}
              </div>
            </div>

            {!isLogin ? (
              <div className={`relative w-full lg:w-[80%] xl:[60%]`}>
                <input
                  className={`p-3 rounded-xl border w-full`}
                  type={isConfirmPasswordVisible ? "text" : "password"}
                  name="password"
                  placeholder="Confirm Password"
                  ref={confirmPasswordInputRef}
                />
                <button
                  onClick={() =>
                    setConfirmPasswordVisible(!isConfirmPasswordVisible)
                  }
                  className={`absolute right-2 rounded-full bottom-1/4 cursor-pointer`}
                >
                  {isConfirmPasswordVisible ? (
                    <EyeIcon className={`relative h-5 w-5 rounded-full`} />
                  ) : (
                    <EyeSlashIcon className={`relative h-5 w-5 rounded-full`} />
                  )}
                </button>
              </div>
            ) : (
              <div />
            )}
            <button
              className={`bg-red-600 py-3 w-[82.5%] md:w-[65%] lg:w-[55%] rounded-3xl items-center text-white font-semibold cursor-pointer shadow-md`}
            >
              {isLogin ? "Log in" : "Sign up"}
            </button>
          </form>
        </div>

        {/* <div
          className={`relative my-5 grid grid-cols-3 items-center align-middle w-full lg:w-[80%] xl:[60%] text-center`}
        >
          <hr className={`border-gray-400`} />
          <p className={`text-center`}>OR</p>
          <hr className={`border-gray-400`} />
        </div>

        <div
          onClick={googleLoginHandler}
          className="relative flex align-middle items-center justify-center bg-white p-3 w-[82.5%] md:w-[65%] lg:w-[55%] rounded-3xl font-semibold cursor-pointer shadow-md"
        >
          <Image
            src={`/icons/google-icon.svg`}
            alt="icon"
            width={25}
            height={25}
            className={`mr-2`}
          />
          <button className={`text-gray-500`}>
            {isLogin ? "Log-in" : "Sign-up"} with Google
          </button>
        </div> */}

        <div className={`relative w-full lg:w-[80%] xl:[60%] my-8`}>
          <hr className={`border-gray-400`} />
        </div>

        <div
          className={`relative flex w-full lg:w-[80%] xl:[60%] align-middle items-center justify-between`}
        >
          <div>
            <p className={`text-md text-gray-600`}>
              {isLogin ? "Create new account" : "Login to your account"}
            </p>
          </div>
          <button
            onClick={() => setIsLogin(!isLogin)}
            className={`py-1 px-5 rounded-full border-[1px] border-gray-300 bg-white cursor-pointer hover:shadow-md text-gray-500`}
          >
            {isLogin ? "Sign-up" : "Log-in"}
          </button>
        </div>
      </div>
    </div>
  );
};
