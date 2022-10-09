import mime from "mime/lite";
import { NFTStorage, File } from "nft.storage";
require("dotenv").config();


const IPFS = require("ipfs-mini");
const ipfs = new IPFS({ host: "ipfs.infura.io", port: 5001, protocol: "https" });

const captureFile = event => {
    console.log("capturing file...");
    const file = event.target.files[0]; // access to the file
    const reader = new FileReader();
    reader.readAsArrayBuffer(file); // read the file as an ArrayBuffer so that it can be uplaode to ipfs
    reader.onloadend = async () => {
      const buffer = Buffer(reader.result);
      setBuffer(buffer);
      const image = new File([buffer], file.name, {
        contentType: mime.getType(file.name),
      });
      setUploadedImage(image);
      console.log(image);
    };
  };

  const registerPlace = async () => {
    const client = new NFTStorage({ token: process.env.REACT_APP_NFT_STORAGE_TOKEN });
    const placeId = await contractInstance.methods.placeId().call();

    const imageURL = await client.store({
      name: "image",
      description: "image uploaded on punk cities",
      image: uploadedImage,
    });

    const metadata = {
      version: "1.0.0",
      tokenID: placeId,
      metadata_id: uuidv4(),
      content: "Content",
      name: name,
      description: "This is a place description",
      uploadedImage: imageURL.url,
      image: image,
      imageMimeType: "image/png",
      image3D: Image3D,
      address: streetAddress,
      tag: tag,
      attributes: [
        {
          trait_type: "city",
          value:(city),
        },
        {
          trait_type: "place_type",
          value: formatPlaceType(placeType),
        },
        {
          trait_type: "quest_type",
          value: formatQuestType(questType),
        },
      ],
      appId: "punkcities",
    };

    const metadataString = JSON.stringify(metadata);
    const cid = await ipfs.add(metadataString);
    const url = `ipfs://${cid}`;

    let placeInput = convertPlaceType(placeType);
    let questInput = convertQuestType(questType);

    try {
      const transactionParams = {
        from: address,
        to: contractAddressLocal,
        data: contractInstance.methods.registerPlace(placeInput, questInput, url).encodeABI(),
      };
      await web3.eth.sendTransaction(transactionParams);
    } catch (err) {
      console.log(err);
    }

    //tx(writeContracts.PunkCity.registerPlace(placeInput, questInput, url));
  };



export default function Youth() {
    return (
        <div className="">
            <div className="grid gap-5 text-center items-center">
                <div className="grid grid-cols-12 border rounded-3xl p-5 items-center">
                    <div className=" grid gap-5 grid-rows-2 items-center col-span-3 border-r rounded-full">
                        <input type="file" className="rounded-3xl cursor-pointer text-lg py-3" onChange={captureFile}/>
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