import { useRef, useState } from "react";
import { Link, useNavigate } from "react-router";
import clsx from "clsx";
import AuthBanner from "../components/Auth/AuthBanner";

function EmailStep({ setStep, setEmail, setError }) {
  const emailField = useRef(null);

  const handleSubmit = async (e) => {
    setError("");
    e.preventDefault();

    const email = emailField.current.value.trim();
    setEmail(email);

    // browser checks email format
    // further validations can be implemented here

    // Don't forget to check if the account already exists / or is it a backend thing?

    try {
      const res = await fetch("/api/auth/send-otp", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      if (!res.ok) {
        setError("Failed to send the email.");
        return;
      }

      setStep(2);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h3 className="font-bold text-[30px] leading-[1.2] text-[#10283f] ">
        What's your email?
      </h3>
      <p className="my-[20px] text-[#4a6178] leading-[1.5] text-[14px] ">
        We'll email you a 6-digit code to confirm it's really you.
      </p>

      <div className="flex flex-col">
        <span className="text-[14px] text-[#10283f] font-bold ">
          Email address
        </span>
        <input
          ref={emailField}
          type="email"
          name="email"
          id="email-field"
          placeholder="name@example.com"
          className="border-[#6B8299] border-[1px] w-full p-[10px] rounded-[10px] "
        />
      </div>

      <p className="my-[20px] text-[14px] leading-[1.5] text-[#4a6178]">
        Required. Use an email you can open now: you'll also use it to log in.
        Sellers never see it: chats stay inside MedLink.
      </p>

      <button
        type="submit"
        className="bg-[#02346b] text-white font-bold rounded-[14px] w-full py-[10px] cursor-pointer "
      >
        Send code
      </button>

      <p className="text-[#4a6178] text-[14px] mt-[20px] ">
        Already have an account{" "}
        <Link
          to="/login"
          className="text-[#02346b] underline hover:text-[#067a72] "
        >
          Log in
        </Link>
      </p>
    </form>
  );
}

function OTPStep({ email, setStep, setError }) {
  const OTPFields = useRef(null);

  const handleChangeEmail = () => {
    setError("");
    setStep(1);
  };

  const handleVerify = async () => {
    setError("");
    const otp = [...OTPFields.current.children]
      .map((child) => child.value)
      .reduce((acc, curr) => acc + curr, "");

    if (!/^\d{6}$/.test(otp)) {
      setError("Invalid OTP");
      return;
    }

    const res = await fetch("/api/auth/verify-otp", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, otp }),
    });

    if (!res.ok) {
      setError("Wrong or expired OTP");
      return;
    }

    setStep(3);
  };

  return (
    <div>
      <h3 className="font-bold text-[30px] leading-[1.2] text-[#10283f] ">
        Check your email
      </h3>
      <p className="my-[20px] text-[#4a6178] leading-[1.5] text-[14px] ">
        We sent a 6-digit code to {email}.{" "}
        <button
          className="underline bg-transparent border-none outline-none cursor-pointer"
          onClick={handleChangeEmail}
        >
          Change email
        </button>
      </p>

      <div className="flex gap-[15px]" ref={OTPFields}>
        {[1, 2, 3, 4, 5, 6].map((i) => (
          <input
            key={i}
            type="text"
            maxLength={1}
            inputMode="numeric"
            autoComplete="one-time-code"
            className="border-[#6B8299] border-[1px] py-[15px] pl-[22px] rounded-[10px] flex-1 min-w-0 "
          />
        ))}
      </div>

      <p className="my-[20px] text-[14px] leading-[1.5] text-[#4a6178]">
        Code expires in 10 minutes. Resend in 0:42
      </p>

      <button
        className="bg-[#02346b] text-white font-bold rounded-[14px] w-full py-[10px] cursor-pointer "
        onClick={handleVerify}
      >
        Verify
      </button>

      <p className="text-[#4a6178] text-[14px] mt-[20px] ">
        Can't find it? Check your spam or promotions folder. MedLink staff will
        never ask you for this code.
      </p>
    </div>
  );
}

function FinalStep({ email, setError }) {
  const fnameField = useRef(null);
  const phoneField = useRef(null);
  const passwordField = useRef(null);

  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    setError("");
    e.preventDefault();

    const fullname = fnameField.current.value.trim();
    const phone = phoneField.current.value.trim();
    const password = passwordField.current.value;

    // check mobile number
    // check password

    try {
      const res = await fetch("/api/auth/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, fullname, phone, password, role: "patient" }),
      });

      if (!res.ok) {
        setError("Error creating the account.");
        return;
      }

      navigate("/login");
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h3 className="font-bold text-[30px] leading-[1.2] text-[#10283f] ">
        Almost there
      </h3>

      <div className="flex flex-col">
        <span className="text-[14px] text-[#10283f] font-bold mt-[20px] ">
          Full name
        </span>
        <input
          required
          ref={fnameField}
          type="text"
          name="fname"
          id="fname-field"
          className="border-[#6B8299] border-[1px] w-full p-[10px] rounded-[10px] "
        />
      </div>
      <div className="flex flex-col">
        <span className="text-[14px] text-[#10283f] font-bold mt-[20px] ">
          Mobile number
        </span>
        <input
          ref={phoneField}
          type="text"
          name="phone"
          id="phone-field"
          placeholder="010 0000 0000"
          className="border-[#6B8299] border-[1px] w-full p-[10px] rounded-[10px] "
        />
        <span className="text-[#4a6178] text-[14px] leading-[1.5] mt-[5px]">
          Required. Egyptian numbers start with 010, 011, 012 or 015.
        </span>
      </div>
      <div className="flex flex-col">
        <span className="text-[14px] text-[#10283f] font-bold mt-[20px] ">
          Create a password
        </span>
        <input
          required
          ref={passwordField}
          type="password"
          name="password"
          id="password-field"
          minLength={8}
          className="border-[#6B8299] border-[1px] w-full p-[10px] rounded-[10px] "
        />
        <span className="text-[#4a6178] text-[14px] leading-[1.5] mt-[5px]">
          At least 8 characters, not a common password
        </span>
      </div>

      <div className="flex flex-col gap-[20px] my-[20px] ">
        <div className="flex gap-[10px] items-start ">
          <input type="checkbox" id="terms-cond" className="accent-[#02346b]" />
          <label
            htmlFor="terms-cond"
            className="text-[14px] text-[#10283f] leading-[1.5]"
          >
            I agree to the Terms of Service and Privacy Policy.
          </label>
        </div>
        <div className="flex gap-[10px] items-start ">
          <input
            type="checkbox"
            id="use-searches"
            className="accent-[#02346b]"
          />
          <label htmlFor="use-searches" className="text-[14px] text-[#10283f]">
            I consent to MedLink using my medicine searches to show availability
            and send alerts. I can withdraw this in Settings.
          </label>
        </div>
      </div>

      <button
        type="submit"
        className="bg-[#02346b] text-white font-bold rounded-[14px] w-full py-[10px] cursor-pointer "
      >
        Create account
      </button>
    </form>
  );
}

function Signup() {
  const [step, setStep] = useState(1);
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  const bannerText = {
    1: {
      main: "Find the medicine you need, close to you.",
      sec: "Create a free account in three short steps.",
    },
    2: {
      main: "Check your email.",
      sec: "Enter the code to keep your account secure.",
    },
    3: {
      main: "Almost there.",
      sec: "Tell us who you are and set a password.",
    },
  };

  return (
    <div className="lg:flex lg:min-h-screen ">
      <AuthBanner
        mainTxt={bannerText[step].main}
        secTxt={bannerText[step].sec}
      />

      <div className="content bg-[#f4f8fa] px-[50px] lg:flex-1 lg:flex lg:flex-col lg:justify-center ">
        <div className="box max-w-[400px] mx-auto py-[50px]">
          <div className="stage-bar flex gap-[5px] ">
            {[1, 2, 3].map((i) => (
              <span
                key={i}
                className={clsx(
                  "flex-1 h-[4px]  rounded-full transition-colors duration-300 ",
                  step >= i ? "bg-[#02346b]" : "bg-[#c9d6e0]",
                )}
              ></span>
            ))}
          </div>
          <p className="text-[14px] text-[#4a6178] my-[20px] ">
            Step {step} of 3
          </p>

          {step === 1 && (
            <EmailStep
              setEmail={setEmail}
              setStep={setStep}
              setError={setError}
            />
          )}
          {step === 2 && (
            <OTPStep email={email} setStep={setStep} setError={setError} />
          )}
          {step === 3 && <FinalStep email={email} setError={setError} />}

          {error && (
            <div className="bg-red-200 text-red-900 rounded-[20px] p-[20px] w-full mt-[20px] ">
              {error}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default Signup;
