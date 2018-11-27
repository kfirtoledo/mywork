pragma solidity ^0.4.24;
//import { increaseTimeTo, duration } from './helpers/increaseTime';
//import latestTime from './helpers/latestTime';
//import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";
import "./usingOraclize.sol";

contract Lastpay is usingOraclize{

      struct winner_t {
          address addr;
      }
      // Store last paying addrees to contract
      winner_t public winner;

      uint256 public closingTime = 60;

      bytes32 private LastQueryId;

      event LogInfo(string description);

      event payEvent (address _pay_addr);

      event timesUp (address _winner_addr);

      event votedEvent (
          uint indexed _candidateId
      );

      // ...
      // Constructor
      constructor() public {
      }

      function payLastAddr ()  public returns (bool) {
          winner.addr.transfer(address(this).balance);
          emit timesUp(msg.sender);
          return true;
      }

      function payFound() payable public returns(bool success) {
        winner.addr = msg.sender;

        if (oraclize_getPrice("URL") > address(this).balance) {
          emit LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
          return false;
        }
        else {
              emit LogInfo("Oraclize query was sent, standing by for the answer..");
              emit payEvent(msg.sender);
              LastQueryId = oraclize_query(closingTime, "URL", "");
              return true;
        }
      }
      function __callback(bytes32 id, string result, bytes proof) public {
          //require(msg.sender == oraclize_cbAddress(), "here 1");
          if (id == LastQueryId) {
              payLastAddr();
          }
       }


}
