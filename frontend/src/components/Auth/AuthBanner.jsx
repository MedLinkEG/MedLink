import { Link } from "react-router";

function AuthBanner({ mainTxt, secTxt }) {
  return (
    <div className="head text-white bg-linear-[to_right,#02346b,#067f72] lg:w-[45%]">
      <div className="container py-[50px] flex flex-col gap-[30px] lg:h-full lg:flex lg:flex-col lg:justify-between">
        <h1 className="font-bold text-[24px]">
          <Link to="/">MedLink</Link>
        </h1>
        <div>
          <p className="font-bold text-[38px] leading-[1.5]">{mainTxt}</p>
          <p className="text-[17px] leading-[1.5]">{secTxt}</p>
        </div>
        <p className="text-[14px]">Buy only from license-verified sellers</p>
      </div>
    </div>
  );
}

export default AuthBanner;
