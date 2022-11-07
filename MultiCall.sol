//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract TestMultiCall {
    //First function to call from multi call contract
    function func1() external view returns(uint, uint) {
        return (1, block.timestamp);
    }

    //Second function to call from multi call contract
    function func2() external view returns(uint, uint) {
        return (2, block.timestamp);
    }

    //get the abi data of function 1
    function getData1() external pure returns(bytes memory) {
        //return abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    //get the abi data of function 2
    function getData2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns(bytes[] memory)
    {
        require(targets.length == data.length, "target length is not equal to data length");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++){
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }

        return results;
    }
}

//Call two functions in the same time
//["0xd9145CCE52D386f254917e481eB44e9943F39138","0xd9145CCE52D386f254917e481eB44e9943F39138"]
//["0x74135154","0xb1ade4db"]
