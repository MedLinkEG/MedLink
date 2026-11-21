function HomeCard({title, type, note}) {
  return (
    <div className="rounded-[20px] border-[1px] border-[#c9d6e0] bg-white p-[16px] flex flex-col gap-[12px] items-start">
      <div className="rounded-[14px] w-full bg-[#e3eef5] h-[120px]"></div>
      <span className="text-[18px] font-bold text-[#10283f]">{title}</span>
      <span className="text-[14px] text-[#4a6178]">{type}</span>
      <span className="font-bold text-[13px] bg-[#e3f4f1] text-[#066359] rounded-full py-[4px] px-[10px] ">{note}</span>
    </div>
  )
}

export default HomeCard;