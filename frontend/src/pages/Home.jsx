import { Link } from "react-router";
import { homeCards } from "../data/homeCards";
import HomeCard from "../components/Home/HomeCard";

function Home() {
  return (
    <>
      <header className="h-[70px] bg-[#f4f8fa]">
        <div className="container h-full flex justify-between items-center">
          <h1 className="font-bold text-[24px] text-[#02346b]">
            <Link to="/">MedLink</Link>
          </h1>
          <nav className="flex gap-[15px] ">
            <Link
              to="/login"
              className="font-bold px-[20px] py-[10px] border-[1px] border-[#02346b] text-[#02346b] rounded-[12px]"
            >
              Log in
            </Link>
            <Link
              to="/signup"
              className="font-bold px-[20px] py-[10px] border-[1px] border-[#02346b] bg-[#02346b] text-white rounded-[12px]"
            >
              Create account
            </Link>
          </nav>
        </div>
      </header>

      <main className="bg-[#f4f8fa]">
        <div className="container pb-[56px]">
          <div className="card bg-linear-[to_right,#02346b,#067f72] text-white p-[56px] rounded-[28px]">
            <div className="content max-w-[720px]">
              <p className="font-extrabold text-[46px] leading-[1.15]">
                Find medicines and medical devices near you, even when they're
                hard to find.
              </p>
              <p className="text-[18px] leading-[1.5] my-[20px] ">
                See which nearby sellers have each item, and get alerted when a
                missing item is back.
              </p>
              <form className="flex gap-[12px]">
                <input
                  type="text"
                  name="search-query"
                  placeholder="Search a medicine or device"
                  className="flex-1 bg-white rounded-[14px] text-[#02346b] px-[20px] py-[10px] min-w-0"
                />
                <button
                  type="submit"
                  className="font-bold px-[20px] py-[10px] rounded-[14px] bg-white text-[#02346b] cursor-pointer"
                >
                  Search
                </button>
              </form>
            </div>
          </div>

          <section className="mt-[48px]">
            <h2 className="font-bold text-[28px] text-[#10283f] mb-[20px]">
              Browse what people look for
            </h2>
            <div className="cards pb-[50px] grid gap-[12px] grid-cols-[repeat(auto-fill,minmax(250px,1fr))]">
              {homeCards.map((homeCard) => (
                <HomeCard
                  key={homeCard.id}
                  title={homeCard.title}
                  type={homeCard.type}
                  note={homeCard.note}
                />
              ))}
            </div>
          </section>

          <div className="bg-white flex justify-between items-center py-[32px] px-[40px] rounded-[28px] border-[2px] border-[#02346b]">
            <p className="text-[#10283f] text-[24px] font-extrabold">Ready to find your item?</p>
            <Link
              to="/signup"
              className="font-bold px-[20px] py-[10px] border-[1px] border-[#02346b] bg-[#02346b] text-white rounded-[12px]"
            >
              Create account
            </Link>
          </div>
        </div>
      </main>
    </>
  );
}

export default Home;
