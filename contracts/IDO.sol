// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/utils/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/access/Ownable.sol';

contract IDO is Ownable {
    using SafeMath for uint256;

    ERC20 public fromToken;
    ERC20 public toToken;       // Token being sold
    uint256 public rate;        // How many toToken a buyer gets per fromToken
    address public wallet;      // Where funds are collected
    
    uint256 public investorCap = 250000000000000000000;    
    uint256 public openingTime;
    uint256 public closingTime;

    mapping(address => bool) public whitelist;
    mapping(address => uint256) public contributions;
    uint256 public totalRaised;

    modifier onlyWhileOpen {
        // solium-disable-next-line security/no-block-members
        require(block.timestamp >= openingTime && block.timestamp <= closingTime);
        _;
    }

    modifier isWhitelisted(address _beneficiary) {
        require(whitelist[_beneficiary]);
        _;
    }

    function addToWhitelist(address _beneficiary) external onlyOwner {
        whitelist[_beneficiary] = true;
    }

    function addManyToWhitelist(address[] calldata _beneficiaries) external onlyOwner {
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            whitelist[_beneficiaries[i]] = true;
        }
    }

    function removeFromWhitelist(address _beneficiary) external onlyOwner {
        whitelist[_beneficiary] = false;
    }

    constructor(
        uint256 _rate, 
        address _wallet, 
        address _fromToken, 
        address _toToken,
        uint256 _openingTime,
        uint256 _closingTime
    ) {
        require(_rate > 0);
        require(_wallet != address(0));
        require(_fromToken != address(0));
        require(_toToken != address(0));
        require(_openingTime >= block.timestamp);
        require(_openingTime < _closingTime);

        rate = _rate;
        wallet = _wallet;
        fromToken = ERC20(_fromToken);
        toToken = ERC20(_toToken);
        openingTime = _openingTime;
        closingTime = _closingTime;
    }

    function buyTokens(uint256 _fromAmount) public onlyWhileOpen isWhitelisted(msg.sender) {
        // Check and update funding cap
        uint256 _existingContribution = contributions[msg.sender];
        uint256 _newContribution = _existingContribution.add(_fromAmount);
        require(_newContribution <= investorCap);
        contributions[msg.sender] = _newContribution;

        // Forward token to fund wallet
        require(fromToken.transferFrom(msg.sender, wallet, _fromAmount));
        totalRaised = totalRaised.add(_fromAmount);
        
        // Send token to user
        uint256 _toAmount = _fromAmount.mul(rate);
        require(toToken.transfer(msg.sender, _toAmount));
    }

    function getUserContribution(address _beneficiary) public view returns (uint256) {
        return contributions[_beneficiary];
    }
}