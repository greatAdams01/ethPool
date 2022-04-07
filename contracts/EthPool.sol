// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

// 604800

contract EthPool is Ownable{
    struct Reward {
        uint256 timestamp;
        uint256 totalAmount;
    }

    Reward[] public rewards;

    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public depositDate;
    address[] public stakers;

    uint256 weekDays = 604800;

    event DepositMade(address sender, uint256 amount, uint256 timestamp);

    function deposit() payable public {
        require(msg.value > 0, "Pls add funds");
        // Check if staker exist
        bool userExist = checkIfUserExist();
        if(userExist) {
            stakedAmount[msg.sender] += msg.value;
            depositDate[msg.sender] = block.timestamp;
            emit DepositMade(msg.sender, msg.value, block.timestamp);
            return;
        }

        stakedAmount[msg.sender] = msg.value;
        depositDate[msg.sender] = block.timestamp;
        stakers.push(msg.sender);
        emit DepositMade(msg.sender, msg.value, block.timestamp);
    }

    function checkIfUserExist() public view returns(bool) {
        for (
            uint256 stakerIndex = 0;
            stakerIndex < stakers.length;
            stakerIndex++
        ) {
            if (stakers[stakerIndex] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    function addReward() payable public onlyOwner{
        require(msg.value > 0, "Pls add funds");
        Reward memory reward = Reward(block.timestamp, address(this).balance);
        rewards.push(reward);
        emit DepositMade(msg.sender, msg.value, block.timestamp);
    }

    function calculatePecentage() public view returns(uint256) {
        // uint timeOfDeposit  = depositDate[msg.sender];
        // require(block.timestamp >= timeOfDeposit + weekDays);

        uint256 amountInPool = checkAmountInPool();
        uint256 userAmount = stakedAmount[msg.sender];
        uint256 percentage = (userAmount * 100) / amountInPool;
        return percentage;
    }

    function checkAmountInPool() public view returns(uint256) {
        uint256 balance = address(this).balance;
        return balance;
    }

    function withdraw() payable public {
        uint256 percentage = calculatePecentage();
        uint256 _timeStamp = depositDate[msg.sender];
        uint256 amountPool = getReward(_timeStamp);
        uint256 stakerAmount = percentage % amountPool;
        console.log(stakerAmount);
        // payable(address(this)).transfer(msg.sender, stakerAmount);
        (bool success, ) = payable(msg.sender).call{value: stakerAmount}("");
        require(success, "Failed to send Ether");
    }

    function getReward(uint256 _timeStamp) public view returns(uint256 _amount) {
        uint256 amount;
        for(uint256 _rewardIndex=0; _rewardIndex < rewards.length; _rewardIndex++) {
          Reward memory reward = rewards[_rewardIndex];
          if(_timeStamp <= reward.timestamp) {
              amount = reward.totalAmount;
              return _amount;
          }
        }
        return amount;
    }

    // function withdraws() payable onlyOwner public {
    //     payable(msg.sender).transfer(address(this).balance);
    //     for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
    //         address funder = funders[funderIndex];
    //         stakedAmount[funder] = 0;
    //         console.log(funderIndex);
    //     }
    //     funders = new address[](0);
    // }
}

// for (
//             uint256 _rewardIndex = 0; _rewardIndex < stakers.length; _rewardIndex++) {
//             uint256 amount;
//             Reward memory reward = rewards[_rewardIndex];
//             if(_timeStamp <= reward.timestamp) {
//                 amount = reward.totalAmount;
//                 return _amount;
//             }
//             return amount;
//         }