// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/security/ReentrancyGuard.sol";
import "@openzeppelin/utils/Strings.sol";
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/utils/cryptography/MerkleProof.sol";
import "../adding/verifier.sol";

contract Lottery2 is Ownable, ReentrancyGuard, Verifier {
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint[] randomWords;
    }

    struct CryptoLotteryState {
        address lotteryOwner;
        bytes32 merkkleRoot;
        uint drawerAmount;
        address tokenAddress;
        uint amount;
        uint finalWinnerNumber; // final winner number
    }

    struct NftLotteryState {
        bytes32 merkkleRoot;
        address tokenAddress;
        uint tokenId;
        uint finalWinnerNumber; // final winner number
    }

    mapping(uint => CryptoLotteryState) public cryptoLotteryStates; // game ID => game info
    uint public cryptoLotteryCount = 0;
    mapping(uint => uint) public requestIdToGameId; // request ID => game ID
    mapping(uint => uint) public gameIdToRequestId; // game ID => request ID
    mapping(uint => RequestStatus) public s_requests;

    // IERC20 private immutable receiveToken;

    // can customize request id
    uint64 public constant TRANSFER_REQUEST_ID = 1;

    constructor() {}

    /***************************/
    /****  Admin Functions  ****/
    /***************************/

    function listLottery(address tokenAddress, uint amount) external {
        cryptoLotteryCount++;
        cryptoLotteryStates[cryptoLotteryCount] = CryptoLotteryState(
            msg.sender,
            bytes32(0),
            0,
            tokenAddress,
            amount,
            0
        );
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    }

    function closeLotteryAndCallChainlinkCoordinator(
        uint lotteryId,
        uint amount,
        uint randomSeed
    ) external {
        // uint requestId = requestRandomWords(1);
        // requestIdToGameId[requestId] = lotteryId;
        // gameIdToRequestId[lotteryId] = requestId;
        cryptoLotteryStates[lotteryId].drawerAmount = amount;
        cryptoLotteryStates[lotteryId].finalWinnerNumber = randomSeed % count;
    }

    function settingMerkleTreeRoot(
        uint lotteryId,
        bytes32 merkleRoot
    ) external {
        require(
            msg.sender == cryptoLotteryStates[lotteryId].lotteryOwner,
            "Only owner can set merkle root"
        );
        cryptoLotteryStates[lotteryId].merkkleRoot = merkleRoot;
    }

    /****************************/
    /****  Drawer Functions  ****/
    /****************************/

    // function verify(
    //     uint lotteryId,
    //     address drawer,
    //     uint drawerId,
    //     bytes32[] calldata proof
    // ) public view returns (bool) {
    //     // Verify the Merkle proof
    //     bytes32 lotteryHash = cryptoLotteryStates[lotteryId].merkkleRoot;
    //     bytes32 userLeaf = keccak256(abi.encode(drawer, drawerId));
    //     bool isValid = MerkleProof.verify(proof, lotteryHash, userLeaf);

    //     // Return the result
    //     return isValid;
    // }

    function redeemLotteryPrize(
        uint lotteryId,
        address drawer,
        uint drawerId,
        uint[] memory input,
        Proof memory proof
    ) external nonReentrant {
        require(verify(input, proof) == 0, "Invalid proof");
        require(
            cryptoLotteryStates[lotteryId].finalWinnerNumber == drawerId,
            "You are not the winner"
        );
        uint amount = cryptoLotteryStates[lotteryId].amount;
        address tokenAddress = cryptoLotteryStates[lotteryId].tokenAddress;
        IERC20(tokenAddress).transfer(drawer, amount);
    }

    function redeemLotteryPrize2(
        uint lotteryId,
        address drawer,
        uint drawerId,
        uint[] memory input,
        Proof memory proof
    ) external nonReentrant {
        uint amount = cryptoLotteryStates[lotteryId].amount;
        address tokenAddress = cryptoLotteryStates[lotteryId].tokenAddress;
        IERC20(tokenAddress).transfer(drawer, amount);
    }

    // function verifyList(
    //     uint lotteryId,
    //     address drawer,
    //     bytes32[] memory proof
    // ) external returns (bool) {
    //     bytes32 lotteryHash = cryptoLotteryStates[lotteryId].merkkleRoot;
    //     bytes32 user = keccak256(abi.encodePacked(drawer));
    //     bytes32 computedHash = user;

    //     for (uint256 i = 0; i < proof.length; i++) {
    //         bytes32 proofElement = proof[i];

    //         if (computedHash <= proofElement) {
    //             computedHash = keccak256(
    //                 abi.encodePacked(computedHash, proofElement)
    //             );
    //         } else {
    //             computedHash = keccak256(
    //                 abi.encodePacked(proofElement, computedHash)
    //             );
    //         }
    //     }
    //     return computedHash == lotteryHash;
    // }

    /****************************/
    /***  Internal Functions  ***/
    /****************************/

    // function requestRandomWords(
    //     uint8 numWords
    // ) internal returns (uint requestId) {
    //     requestId = COORDINATOR.requestRandomWords(
    //         keyHash,
    //         s_subscriptionId,
    //         requestConfirmations,
    //         callbackGasLimit,
    //         numWords
    //     );
    //     s_requests[requestId] = RequestStatus({
    //         randomWords: new uint[](0),
    //         exists: true,
    //         fulfilled: false
    //     });
    //     requestIds.push(requestId);
    //     lastRequestId = requestId;
    //     return requestId;
    // }

    // function fulfillRandomWords(
    //     uint _requestId,
    //     uint[] memory _randomWords
    // ) internal {
    //     require(s_requests[_requestId].exists, "request not found");
    //     s_requests[_requestId].fulfilled = true;
    //     s_requests[_requestId].randomWords = _randomWords;
    //     uint count = cryptoLotteryStates[requestIdToGameId[_requestId]]
    //         .drawerAmount;
    //     cryptoLotteryStates[requestIdToGameId[_requestId]].finalWinnerNumber =
    //         _randomWords[0] %
    //         count;
    // }

    /**************************/
    /***  Status Functions  ***/
    /**************************/

    // function getRequestStatus(
    //     uint _requestId
    // ) external view returns (bool fulfilled, uint[] memory randomWords) {
    //     require(s_requests[_requestId].exists, "Request not found");
    //     RequestStatus memory request = s_requests[_requestId];
    //     return (request.fulfilled, request.randomWords);
    // }

    // function getGameFinalWinnerAddress (uint gameId) external view returns (address) {
    //     GameState memory gameState = idToGameState[gameId];
    //     require(s_requests[gameIdToRequestId[gameId]].exists, "Request not found");
    //     require(
    //         gameState.status == Status.DrawFinalNumber,
    //         "Final number not draw yet"
    //     );
    //     return gameState.playerList[gameState.finalWinningNumber];
    // }

    // function getGamePlayerList (uint gameId) external view returns (address[] memory) {
    //     return idToGameState[gameId].playerList;
    // }

    function getBlocktime() external view returns (uint) {
        return block.timestamp;
    }

    /***************************/
    /***  Utility Functions  ***/
    /***************************/

    // function getReceiveToken() external onlyOwner {
    //     uint balanceOfReceiveToken = receiveToken.balanceOf(address(this));
    //     receiveToken.transferFrom(
    //         address(this),
    //         msg.sender,
    //         balanceOfReceiveToken
    //     );
    // }

    // function rawFulfillRandomWords(
    //     uint256 requestId,
    //     uint256[] memory randomWords
    // ) external {
    //     if (msg.sender != vrfCoordinator) {
    //         revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
    //     }
    //     fulfillRandomWords(requestId, randomWords);
    // }
}
