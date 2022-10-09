import React from "react";


/**
 * web3 props can be passed from '../App.jsx' into your local view component for use
 * @param {*} yourLocalBalance balance on current network
 * @param {*} readContracts contracts from current chain already pre-loaded using ethers contract module. More here https://docs.ethers.io/v5/api/contract/contract/
 * @returns react component
 **/
export default function Home({ yourLocalBalance, readContracts }) {
  // you can also use hooks locally in your component of choice
  // in this case, let's keep track of 'purpose' variable from our contract
  

  return (
    <div className="grid gap-10 text-center">
      <a href="/Quests">
        <div class="py-3 px-5 border border-black rounded-3xl hover:bg-black cursor-pointer hover:text-white">Quest</div>
      </a>
      <a href="/Governance">
        <div class="py-3 px-5 border border-black rounded-3xl hover:bg-black cursor-pointer hover:text-white">Governance</div>
      </a>  
      <div class="py-3 px-5 border bg-gray-100 rounded-3xl cursor-not-allowed">New Place</div>
      <div class="py-3 px-5 border bg-gray-100 rounded-3xl cursor-not-allowed">Add to Quest</div>
    </div>
  )
}
