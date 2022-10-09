
export default function Quests() {
    return (
        <div>
            <div className="grid gap-10 grid-rows-4 text-center max-w-xl mx-auto">
                
                <a href="/Youth">
                    <div className="py-3 px-5 border hover:border-[#FEA520] rounded-3xl bg-[#FEA520] hover:bg-transparent cursor-pointer">Youth</div>
                </a>
                <a href="/Biker">
                    <div className="py-3 px-5 border hover:border-[#ABE777] rounded-3xl bg-[#ABE777] hover:bg-transparent cursor-pointer">Biker</div>
                </a>
                <a href="/Scholar">
                    <div className="py-3 px-5 border hover:border-[#162988] rounded-3xl bg-[#162988] hover:bg-transparent text-white hover:text-black cursor-pointer">Scholar</div>
                </a>
                <a href="/Tourist">
                    <div className="py-3 px-5 border hover:border-[#F1EF7E] rounded-3xl bg-[#F1EF7E] hover:bg-transparent cursor-pointer ">Tourist</div>
                </a>
            </div>
        </div>
    )
}