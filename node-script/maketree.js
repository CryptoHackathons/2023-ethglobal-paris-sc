// Import the required libraries
const { MerkleTree } = require("merkletreejs");
const sha3 = require("js-sha3");
const keccak256 = sha3.keccak256;
const abi = require("ethereumjs-abi");
const Web3 = require("web3").default;
const web3 = new Web3();

// Create an array of data to be included in the Merkle Tree
const datas = [
  "0x1dB47D1a06Df36f963af1b086B012bb278071372",
  "0x7054D076C898472cbFEB31a6fE72c135c86C6609",
  "0x85EdA6610C66cCd307f230621DdA24Fd3bE20245",
  "0xF16Aa7E201651e7eAd5fDd010a5a14589E220826",
];

const leafNode = datas.map((x, index) =>
  web3.utils.keccak256(
    web3.eth.abi.encodeParameters(["address", "uint256"], [x, index])
  )
);

console.log(leafNode);
const merkleTreeTest = new MerkleTree(leafNode, keccak256, { sortPairs: true });

// Get the Merkle Root
const merkleRoot = merkleTreeTest.getRoot().toString("hex");

console.log(merkleTreeTest.toString());
console.log("Merkle Root:", merkleRoot);

function testKeccak(_input) {
  const hash = web3.utils.keccak256(
    web3.eth.abi.encodeParameters(["address", "uint256"], [_input, 103])
  );
  console.log(hash);
}

testKeccak("0x1dB47D1a06Df36f963af1b086B012bb278071372");

const proof = merkleTreeTest.getProof(leafNode[2]);

console.log(JSON.stringify(proof.toString("hex")));
console.log(
  JSON.stringify(
    proof.map((el) => ({ ...el, data: "0x" + el.data.toString("hex") })),
    null,
    2
  )
);
