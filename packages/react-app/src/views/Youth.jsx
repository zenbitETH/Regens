export default function Youth() {
    return (
        <div className="">
            <div className="grid gap-5 text-center items-center">
                <div className="grid grid-cols-12 border rounded-3xl p-5 items-center">
                    <div className=" grid gap-5 grid-rows-2 items-center col-span-3 border-r rounded-full">
                        <input type="file" className="rounded-3xl cursor-pointer text-lg py-3"/>
                        <div className="bg-orange-300 rounded-3xl cursor-pointer text-lg py-3">Mint Place NFT</div>
                    </div>
                    <div className="ml-5 col-span-9 grid gap-5 text-center">
                        <div className=" grid grid-cols-12 ">
                            <div className="col-span-9 text-left ">
                                <div className="text-3xl font-bold">Name</div>
                                <div className="text-xl">Place type</div>
                            </div>
                            <div className="col-span-3">URL</div>
                        </div>
                        <div className="text-justify  text-lg">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in felis eget velit scelerisque mattis. Donec purus ex, rhoncus ac ultricies euismod, efficitur quis erat. Donec scelerisque mi vitae mauris volutpat, ac molestie leo blandit. Praesent auctor sem in felis suscipit iaculis. Vivamus eleifend sem non sem porttitor convallis. Nam et sem lacus. Duis maximus odio vel ultrices blandit.</div>
                    </div>
                </div>
            </div>
        </div>
    )
}